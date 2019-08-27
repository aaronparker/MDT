#Requires -RunAsAdministrator
<#
    .SYNOPSIS
    Changes the default UI fonts in Windows.
 
    .DESCRIPTION
    Changes the default UI fonts in Windows (under FontSubstitutes) by changing the 'MS Shell Dlg', MS Shell Dlg 2' values to Tahoma.
    Additional values under the FontSubstitutes key can be specified and/or a different font can also be specified.

    .PARAMETER Values
    Specify a list of Registry values to change the font to.

    .PARAMETER Font
    Specify an alternative font to set, otherwise 'Tahoma' is used.
  
    .EXAMPLE
    PS C:\> .\Set-FontSubstitutes.ps1
            
    Substitutes fonts by changing the 'MS Shell Dlg' and 'MS Shell Dlg 2' values to Tahoma.
            
    .EXAMPLE
    PS C:\> .\Set-FontSubstitutes.ps1 -Values 'MS Shell Dlg', 'MS Shell Dlg 2', 'Microsoft Sans Serif' -Font 'Segoe UI'
            
    Substitutes fonts by changing the 'MS Shell Dlg', 'MS Shell Dlg 2' and 'Microsoft Sans Serif' values to 'Segoe UI'.
 
    .NOTES
    NAME: Set-FontSubstitutes.ps1
    AUTHOR: Aaron Parker
 
    .LINK
    http://stealthpuppy.com
#>
[CmdletBinding(SupportsShouldProcess = $False)]
Param (
    [Parameter(Mandatory = $False, Position = 0, HelpMessage = "Specify a list of Registry values to change in the FontSubstitutes key.")]
    [System.String[]] $Values = @("MS Shell Dlg", "MS Shell Dlg 2"),

    [Parameter(Mandatory = $False, Position = 1, HelpMessage = "Specify an alternative font to set the FontSubstitutes values to.")]
    [System.String] $Font = "Tahoma"
)

#region Functions
Function Set-RegistryValue {
    <#
        .SYNOPSIS
            Creates a registry value in a target key. Creates the target key if it does not exist.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        [System.String] $Key,

        [Parameter(Mandatory = $True)]
        [System.String] $Value,

        [Parameter(Mandatory = $True)]
        $Data,

        [Parameter(Mandatory = $False)]
        [ValidateSet('Binary', 'ExpandString', 'String', 'Dword', 'MultiString', 'QWord')]
        [System.String] $Type = "String"
    )

    try {
        If (Test-Path -Path $Key -ErrorAction SilentlyContinue) {
            Write-Verbose "Path exists: $Key"
        }
        Else {
            Write-Verbose -Message "Does not exist: $Key."

            $folders = $Key -split "\\"
            $parent = $folders[0]
            Write-Verbose -Message "Parent is: $parent."

            ForEach ($folder in ($folders | Where-Object { $_ -notlike "*:" })) {
                New-Item -Path $parent -Name $folder -ErrorAction SilentlyContinue | Out-Null
                $parent = "$parent\$folder"
                If (Test-Path -Path $parent -ErrorAction SilentlyContinue) {
                    Write-Verbose -Message "Created $parent."
                }
            }
            Test-Path -Path $Key -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Error "Failed to create key $Key."
        Break
    }
    finally {
        Write-Verbose -Message "Setting $Value in $Key."
        New-ItemProperty -Path $Key -Name $Value -Value $Data -PropertyType $Type -Force -ErrorAction SilentlyContinue | Out-Null
    }

    $val = Get-Item -Path $Key
    If ($val.Property -contains $Value) {
        Write-Verbose "Write value success: $Value"
        Write-Output $True
    }
    Else {
        Write-Verbose "Write value failed."
        Write-Output $False
    }
}
#endregion
                
# Get values from the FontSubstitutes key
$Key = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes'

ForEach ($Value in $Values) {
    Set-RegistryValue -Key $Key -Value $Value -Data $Font
}
