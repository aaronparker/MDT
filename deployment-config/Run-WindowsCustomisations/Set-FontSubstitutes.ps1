Function Set-FontSubstitutes {
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
            PS C:\> Set-Fonts
            
            Substitutes fonts by changing the 'MS Shell Dlg' and 'MS Shell Dlg 2' values to Tahoma.
            
        .EXAMPLE
            PS C:\> Set-Fonts -Values 'MS Shell Dlg', 'MS Shell Dlg 2', 'Microsoft Sans Serif' -Font 'Segoe UI'
            
            Substitutes fonts by changing the 'MS Shell Dlg', 'MS Shell Dlg 2' and 'Microsoft Sans Serif' values to 'Segoe UI'.
 
        .NOTES
 	        NAME: Set-Fonts.ps1
	        VERSION: 1.1
	        AUTHOR: Aaron Parker
	        LASTEDIT: March 15, 2016
 
        .LINK
            http://stealthpuppy.com
    #>
    [CmdletBinding(SupportsShouldProcess = $False, ConfirmImpact = "Low", DefaultParameterSetName = "Font")]
    PARAM (
        [Parameter(Mandatory=$False, Position=0, HelpMessage="Specify a list of Registry values to change in the FontSubstitutes key.")]
        [array]$Values = ("MS Shell Dlg", "MS Shell Dlg 2"),

        [Parameter(Mandatory=$False, Position=1, HelpMessage="Specify an alternative font to set the FontSubstitutes values to.")]
        [string]$Font = "Tahoma"
    )

    BEGIN {
        
        # Set variables
        [array]$Status = @()
        [string]$KeyPath = 'Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes'
        
        # Get script elevation status
        [bool]$Elevated = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    }

    PROCESS {

        If ($PSCmdlet.ShouldProcess("Setting $Values to $Font.")) {

            If ( $Elevated ) {
                
                # Get values from the FontSubstitutes key
                $Key = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes'
                
                ForEach ( $Value in $Values ) {
                
                    If (-not ($Key.$Value -eq $Font)) {
                        
                        # Set target value to $Font
                        $WriteFont = New-ItemProperty -Path $KeyPath -Name $Value -Value $Font -Force
                        $obj = New-Object psobject -Property @{
                            Value = $Value
                            Font = $WriteFont.$Value
                            Status = $True
                        }
                        $Status += $obj
                    } Else {
                        
                        # Value already set to $Font
                        $obj = New-Object psobject -Property @{
                            Value = $Value
                            Font = $Key.$Value
                            Status = $True
                        }
                        $Status += $obj
                    }
                }  
            } Else {
                
                # Script not elevated
                $Status = $False
                $Status += "Script not elevated."
            }
        }
    }
    
    END {
        Return $Status
    }
}