<#
    .Synopsis
        Configures Windows from settings provided in an external XML file.

    .DESCRIPTION
        This script configures Windows from settings provided in an external XML file, including setting the default user profile, system customisations etc.

    .NOTES   
        Name: Set-Customisations.ps1
        Author: Aaron Parker
        Version: 2.0
        DateUpdated: 2017-04-26

    .LINK
        http://stealthpuppy.com

    .PARAMETER XmlTemplate
        The XML that contains the registry values to set in the profile.

    .PARAMETER Log
        Path to a log file to record changes to the system.

    .PARAMETER SkipSystem
        Skip system customisations specified in the XML file.

    .EXAMPLE
        .\Set-Customisations.ps1 -XmlTemplate ".\Customisations.xml" -Log "$env:SystemRoot\Temp\Set-Customisations.log"

        Description:
        Specifies the path to the XMl file containing the registry values to set and file actions and records to a log file at $env:SystemRoot\Temp\Set-Customisations.log.
#>

[CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = "Low")]
PARAM (
    [Parameter(Mandatory=$True, HelpMessage="The path to the XML document describing the OS customisations.")]
    # [ValidateScript({Test-Path $_ -PathType 'Container'})]
    [string]$XmlTemplate,

    [Parameter(Mandatory=$False, HelpMessage="The path to a log file.")]
    [string]$Log = "$env:SystemRoot\Temp\Set-Customisations.log",

    [Parameter(Mandatory=$False, HelpMessage="Skip customisations specified for the system in the XML file.")]
    [bool]$SkipSystem = $False
)

BEGIN {
    # Variables
    $build = [Environment]::OSVersion.Version
    $hkcu = "Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER"
    $loadPath = "HKLM\DefaultUser"
    $default = "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\DefaultUser"
    $hklm = "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE"

    # Get script elevation status
    [bool]$Elevated = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

PROCESS {
    
    Function Write-Log {
        param (
        [string]$Path,
        [string]$Entry)

        Write-Log -Path $logPath -Entry "$Entry" | Out-File -FilePath $Path -Append
        Return $?
    }

    # Read the specifed XML document
    $xmlDocument = ( Select-Xml -Path $XmlTemplate -XPath / ).Node

    # Select settings from the document for the current OS
    $customisations = $xmlDocument.SelectNodes("/Customisations/TargetOS") | Where-Object { ($build -ge $_.Min) -and ($build -le $_.Max) }

    # Testing
    # ForEach ( $setting in $customisations.SelectNodes("DefaultUser/Registry/*[@Path]") ) {
    #     Write-Host "$default\$($setting.Path)"
    #     ForEach ( $value in $setting.SelectNodes("Values/*[@Name]") ) {
    #         Write-Host "Value: $($value.Name); Data: $($value.InnerText)"
    #     }
    # }

    # Run customisation actions
    If ($customisations -ne $Null) {

        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>> Default Profile
        # Load the default profile hive
        If ($pscmdlet.ShouldProcess("$loadPath $env:SystemDrive\Users\Default\NTUSER.DAT", "Loading registry hive")) {
            REG LOAD $loadPath "$env:SystemDrive\Users\Default\NTUSER.DAT"
        }

        # Set defaut profile
        # Loop through each setting in the XML structure to set the registry value
        ForEach ( $setting in $customisations.SelectNodes("DefaultUser/Registry/*[@Path]") ) {
            
            # If the registry path doesn't exist, create it before setting the value
            If (!(Test-Path("$default\$($setting.Path)"))) {
                If ($pscmdlet.ShouldProcess("$default\$($setting.Path)", "Create key")) {
                    New-Item -Path "$default\$($setting.Path)" -Force
                }
            }

            # Set specified registry values specified in the XML
            ForEach ( $value in $setting.SelectNodes("Values/*[@Name]") ) {
                If ($pscmdlet.ShouldProcess("$($value.Name) in $default\$($setting.Path)", "Create value")) {

                    # Convert values to an integer where required (fix with an xsd?)
                    If ($value.Data.Type -eq "Int") {  
                        $val = $value.InnerText.ToInt32($Null)
                    } Else {
                        $val = $value.InnerText
                    }

                    # Add or set the registry value
                    New-ItemProperty -Path "$default\$($setting.Path)" -Name $($value.Name) -Value $val -Force
                }
            }
        }

        If ($pscmdlet.ShouldProcess("$loadPath $env:SystemDrive\Users\Default\NTUSER.DAT", "Unloading registry hive")) {
            # Unload the default profile hive
            Start-Sleep -Seconds 30
            REG UNLOAD $loadPath
            [gc]::collect()
        }

        # File operations
        ForEach ( $setting in $customisations.SelectNodes("DefaultUser/Files/File") ) {
            
            # Add or set the registry value
            # New-ItemProperty -Path "$Hive\$($setting.Path)" -Name $($setting.Name) -Value $Value -Force

            $Root = (Get-ChildItem -Path Env: | Where { $_.Name -eq $setting.Target.Root }).Value
            $File = "$Root\$($setting.Target.InnerText)"

                # File operations
                Switch ($setting.Action) {
                    Delete {
                        If ($pscmdlet.ShouldProcess($File, "Delete")) {
                            If (Test-Path $File) {
                                Remove-Item -Path $File -Force
                            }
                        }
                    }

                    Copy {
                        If ($pscmdlet.ShouldProcess($File, "Copy")) {
                            If (Test-Path $File) {
                                Copy-Item -Path $File -Destination $setting.Dest.InnerText -Force
                            }
                        }
                    }

                    Move {
                        If ($pscmdlet.ShouldProcess($File, "Move")) {
                            If (Test-Path $File) {
                                Move-Item -Path $File -Destination $setting.Dest.InnerText -Force
                            }
                        }
                    }

                    Default {
                        If ($pscmdlet.ShouldProcess($File, "Unknown")) {
                           
                        }
                    }
                }
        }


        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>> System
        # If SkipSystem is specified on the command line this section will not be processed
        If (!($SkipSystem)) {
            ForEach ( $setting in $customisations.SelectNodes("System/Registry/Files/*[@Path]" )) {
                
                # If the registry path doesn't exist, create it before setting the value
                If ($pscmdlet.ShouldProcess("$hklm\$($setting.Path)", "Create key")) {
                    If (!(Test-Path("$hklm\$($setting.Path)"))) { New-Item -Path "$hklm\$($setting.Path)" -Force }
                }
                # Convert values to an integer where required (fix with an xsd?)
                If ($setting.Type -eq "Int") {  
                    $Value = $setting.Data.ToInt32($Null)
                } Else {
                    $Value = $setting.Data
                }

                If ($pscmdlet.ShouldProcess("$($setting.Name)", "Create value")) {
                    # Add or set the registry value
                    New-ItemProperty -Path "$hklm\$($setting.Path)" -Name $($setting.Name) -Value $Value -Force
                }
            }

            # File operations
            ForEach ( $setting in $customisations.SelectNodes("System/Files/File") ) {
                
                # Add or set the registry value
                # New-ItemProperty -Path "$Hive\$($setting.Path)" -Name $($setting.Name) -Value $Value -Force

                $Root = (Get-ChildItem -Path Env: | Where { $_.Name -eq $setting.Target.Root }).Value
                $File = "$Root\$($setting.Target.InnerText)"

                    # File operations
                    Switch ($setting.Action) {
                        Delete {
                            If ($pscmdlet.ShouldProcess($File, "Delete")) {
                                If (Test-Path $File) {
                                    Remove-Item -Path $File -Force
                                }
                            }
                        }

                        Copy {
                            If ($pscmdlet.ShouldProcess($File, "Copy")) {
                                If (Test-Path $File) {
                                    Copy-Item -Path $File -Destination $setting.Dest.InnerText -Force
                                }
                            }
                        }

                        Move {
                            If ($pscmdlet.ShouldProcess($File, "Move")) {
                                If (Test-Path $File) {
                                    Move-Item -Path $File -Destination $setting.Dest.InnerText -Force
                                }
                            }
                        }

                        Default {
                            If ($pscmdlet.ShouldProcess($File, "Unknown")) {
                            
                            }
                        }
                    }
            }
        }
    } Else {
        # Throw an exception because the current OS didn't match between the specified Min and Max build values
        Throw "Customisations for this OS not found in $xmlTemplate. Exiting."
    }
}