Function Remove-AppxApps {
    <#
        .SYNOPSIS
            Removes a specified list of AppX packages from the current system.
 
        .DESCRIPTION
            Removes a specified list of AppX packages from the current user account and the local system
            to prevent new installs of in-built apps when new users log onto the system. Return True or 
            False to flag whether the system requires a reboot as a result of removing the packages.

        .PARAMETER Operation
            Specify the AppX removal operation - either Blacklist or Whitelist. 

        .PARAMETER Blacklist
            Specify an array of AppX packages to 'blacklist' or remove from the current Windows instance,
            all other apps will remain installed. The script will use the blacklist by default.
  
        .PARAMETER Whitelist
            Specify an array of AppX packages to 'whitelist' or keep in the current Windows instance.
            All apps except this list will be removed from the current Windows instance.

        .EXAMPLE
            PS C:\> Remove-AppxApps -Operation Blacklist
            
            Remove the default list of Blacklisted AppX packages stored in the function.
 
        .EXAMPLE
            PS C:\> Remove-AppxApps -Operation Whitelist
            
            Remove the default list of Whitelisted AppX packages stored in the function.

         .EXAMPLE
            PS C:\> Remove-AppxApps -Operation Blacklist -Blacklist "Microsoft.3DBuilder_8wekyb3d8bbwe", "Microsoft.XboxApp_8wekyb3d8bbwe"
            
            Remove a specific set of AppX packages a specified in the -Blacklist argument.
 
         .EXAMPLE
            PS C:\> Remove-AppxApps -Operation Whitelist -Whitelist "Microsoft.BingNews_8wekyb3d8bbwe", "Microsoft.BingWeather_8wekyb3d8bbwe"
            
            Remove AppX packages from the system except those specified in the -Whitelist argument.

        .NOTES
 	        NAME: Remove-AppxApps.ps1
	        VERSION: 2.0
	        AUTHOR: Aaron Parker
	        TWITTER: @stealthpuppy
 
        .LINK
            http://stealthpuppy.com
    #>
    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = "High", DefaultParameterSetName = "Blacklist")]
    PARAM (
        [Parameter(Mandatory=$true, ParameterSetName = "Blacklist", HelpMessage="Specify whether the operation is a blacklist or whitelist.")]
        [Parameter(Mandatory=$true, ParameterSetName = "Whitelist", HelpMessage="Specify whether the operation is a blacklist or whitelist.")]
        [ValidateSet('Blacklist','Whitelist')]
        $Operation,

        [Parameter(Mandatory=$false, ParameterSetName = "Blacklist", HelpMessage="Specify an AppX package or packages to remove.")]
        [array]$Blacklist = ( "Microsoft.3DBuilder_8wekyb3d8bbwe", `
                        "Microsoft.BingFinance_8wekyb3d8bbwe", `
                        "Microsoft.BingSports_8wekyb3d8bbwe", `
                        "Microsoft.ConnectivityStore_8wekyb3d8bbwe", `
                        "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe", `
                        "Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe", `
                        "Microsoft.SkypeApp_kzf8qxf38zg5c", `
                        "Microsoft.WindowsPhone_8wekyb3d8bbwe", `
                        "Microsoft.XboxApp_8wekyb3d8bbwe", `
                        "Microsoft.ZuneMusic_8wekyb3d8bbwe", `
                        "Microsoft.ZuneVideo_8wekyb3d8bbwe", `
                        "Microsoft.OneConnect_8wekyb3d8bbwe", `
                        "king.com.CandyCrushSodaSaga_kgqvnymyfvs32", `
                        "Microsoft.PPIProjection_cw5n1h2txyewy", `
                        "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe", `
                        "Microsoft.Windows.SecureAssessmentBrowser_cw5n1h2txyewy" ),
        
        [Parameter(Mandatory=$false, ParameterSetName = "Whitelist", HelpMessage="Specify an AppX package or packages to keep, removing all others.")]
        [array]$Whitelist = ( "Microsoft.BingNews_8wekyb3d8bbwe", `
                         "Microsoft.BingWeather_8wekyb3d8bbwe", `
                         "Microsoft.Office.OneNote_8wekyb3d8bbwe", `
                         "Microsoft.People_8wekyb3d8bbwe", `
                         "Microsoft.Windows.Photos_8wekyb3d8bbwe", `
                         "Microsoft.WindowsAlarms_8wekyb3d8bbwe", `
                         "Microsoft.WindowsCalculator_8wekyb3d8bbwe", `
                         "Microsoft.WindowsCamera_8wekyb3d8bbwe", `
                         "microsoft.windowscommunicationsapps_8wekyb3d8bbwe", `
                         "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe", `
	                     "Microsoft.WindowsStore_8wekyb3d8bbwe", `
                         "Microsoft.MicrosoftEdge_8wekyb3d8bbwe", `
                         "Microsoft.Windows.Cortana_cw5n1h2txyewy", `
                         "Microsoft.Windows.FeatureOnDemand.InsiderHub_cw5n1h2txyewy", `
                         "Microsoft.WindowsFeedback_cw5n1h2txyewy", `
                         "Microsoft.WindowsMaps_8wekyb3d8bbwe", `
                         "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe", `
                         "Microsoft.GetHelp_8wekyb3d8bbwe", `
                         "Microsoft.Getstarted_8wekyb3d8bbwe", `
                         "Microsoft.StorePurchaseApp_8wekyb3d8bbwe", `
                         "Microsoft.Wallet_8wekyb3d8bbwe" )
    )

    BEGIN {
        # The flag to be returned by the function
        [bool]$Result = $False

        # A set of apps that we'll never try to remove
        [array]$ProtectList = ( "Microsoft.WindowsStore_8wekyb3d8bbwe", `
                         "Microsoft.MicrosoftEdge_8wekyb3d8bbwe", `
                         "Microsoft.Windows.Cortana_cw5n1h2txyewy", `
                         "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe", `
                         "Microsoft.StorePurchaseApp_8wekyb3d8bbwe", `
                         "Microsoft.Wallet_8wekyb3d8bbwe" )
    }
    
    PROCESS {

        Switch ($Operation) {

            "Blacklist" {
                # Filter list if it contains apps from the $ProtectList
                $Apps = Compare-Object -ReferenceObject $ProtectList -DifferenceObject $Blacklist -PassThru
            }

            "Whitelist" {
                # Get packages from the current system and filter out the whitelisted apps
                $AllPackages = @()
                $Packages = Get-AppxProvisionedPackage -Online | Select-Object DisplayName
                ForEach ( $Package in $Packages) {
                    $AllPackages += Get-AppxPackage -AllUsers -Name $Package.DisplayName | Select-Object PackageFamilyName
                }
                $Apps = Compare-Object -ReferenceObject $AllPackages.PackageFamilyName -DifferenceObject $Whitelist -PassThru | Where-Object { $_.SideIndicator -eq "<=" }

                # Ensure the list does not contain a system app
                $SystemApps = Get-AppxPackage -AllUsers | Where-Object { $_.InstallLocation -like "$env:SystemRoot\SystemApps*" -or $_.IsFramework -eq $True } | Select-Object PackageFamilyName
                $Apps = Compare-Object -ReferenceObject $Apps -DifferenceObject $SystemApps.PackageFamilyName -PassThru | Where-Object { $_.SideIndicator -eq "<=" }

                # Ensure the list does not contain an app from the $ProtectList
                $Apps = Compare-Object -ReferenceObject $Apps -DifferenceObject $ProtectList -PassThru | Where-Object { $_.SideIndicator -eq "<=" }
            }
        }

        # Remove the apps; Walk through each package in the array
        ForEach ( $App in $Apps ) {
                
            # Get the AppX package object by passing the string to the left of the underscore
            # to Get-AppxPackage and passing the resulting package object to Remove-AppxPackage
            If ($PSCmdlet.ShouldProcess("Removing AppX package: $App.")) {
                Get-AppxPackage -AllUsers -Name (($App -split "_")[0]) | Remove-AppxPackage -Verbose
            }
            
            # Remove the provisioned package as well, completely from the system
            $Package = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq (($App -split "_")[0])
            If ( $Package ) {

                If ($PSCmdlet.ShouldProcess("Removing AppX provisioned package: $App.")) {
                    $Action = Remove-AppxProvisionedPackage -Online -PackageName $Package.PackageName -Verbose
                    If ( $Action.RestartNeeded -eq $True ) { $Result = $True }
                }
            }
        }
    }
    
    END {
        # Return $Result
    }
}