Function Get-AppxPackageFromStart {
<#
        .SYNOPSIS
            Returns the AppX package that correlates to the application display name on the Start menu.
 
        .DESCRIPTION
            Returns the AppX package object that correlates to the application display name on the Start menu.
            Returns null if the name specified is not found or the shortcut points to a non-AppX app.

        .PARAMETER Name
            Specify a shortcut display name to return the AppX package for.
  
        .EXAMPLE
            PS C:\> Get-AppxPackageFromStart -Name "Twitter"

            Returns the AppX package for the shortcut 'Twitter'.

        .NOTES
 	        NAME: Get-AppxPackageFromStart.ps1
	        VERSION: 1.1
	        AUTHOR: Aaron Parker
	        LASTEDIT: March 29, 2016
 
        .LINK
            http://stealthpuppy.com
    #>
    [CmdletBinding(SupportsShouldProcess = $False, ConfirmImpact = "None", DefaultParameterSetName = "Name")]
    PARAM (
        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$True, HelpMessage="Specify a Start menu shortcut name.")]
        [string[]]$Name
    )
    
    BEGIN {

        $Packages = @()
    }

    PROCESS {

        ForEach ( $Pkg in $Name ) {

            $StartPkg = Get-StartApps -Name $Pkg

            # If package is not Null and AppID contains !, assume that it is an AppX package
            If ( ( -not ($StartPkg -eq $Null )) -and $StartPkg.AppID.Contains("!") ) {

                # Return an AppX package object by comparing the Start menu package AppId to the PackageFamilyName up to the ! character
                $Packages += Get-AppxPackage | Where-Object { ($StartPkg.AppID -split "!")[0] -contains $_.PackageFamilyName }
            }
        }
    }

    END {

        Return $Packages
    }
}