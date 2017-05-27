<#
    .SYNOPSIS
        Imports the latest Windows update into MDT.

    .DESCRIPTION
        This script will import the latest Cumulative updates for Windows 10 and Windows Server 2016 gathered by Get-LatestUpdate.ps1 into an MDT deployment share.

    .NOTES
        Name: Import-LatestUpdates.ps1
        Author: Aaron Parker
        Twitter: @stealthpuppy

    .LINK
        http://stealthpuppy.com

    .PARAMETER Path
        Specify the path to the MDT deployment share.

    .PARAMETER Update
        Imports the specific update into the MDT share, which can be passed from Get-LatestUpdate.ps1.

    .EXAMPLE
        Import the latest update gathered from Get-LatestUpdate.ps1 into the deployment share \\server\reference.

        .\Get-LatestUpdate | .\Import-LatestUpdate.ps1 -Path \\server\reference
#>
[CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Low', DefaultParameterSetName='Base')]
Param (
    [Parameter(ParameterSetName='Base', Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Specify the path to the MSU to import.")]
    [ValidateScript({ If (Test-Path $_ -PathType 'Container') { $True } Else { Throw "Cannot find path $_" } })]
    [string]$Update,

    [Parameter(ParameterSetName='Base', Mandatory=$True, HelpMessage="Specify an MDT deployment share to apply the update to.")]
    [string]$Path,

    [Parameter(ParameterSetName='Base', Mandatory=$False, HelpMessage="A sub-folder in the MDT Packages folder.")]
    [string]$Folder,

    [Parameter(ParameterSetName='Base', Mandatory=$False, HelpMessage="Remove the updates from the target MDT deployment share before importing the new updates.")]
    [switch]$Clean
)
BEGIN {
    # If we can find the MDT PowerShell module, import it. Requires MDT console to be installed
    $mdtModule = "$((Get-ItemProperty "HKLM:SOFTWARE\Microsoft\Deployment 4").Install_Dir)bin\MicrosoftDeploymentToolkit.psd1"
    If (Test-Path -Path $mdtModule) {
        Try {            
        Import-Module -Name $mdtModule
        }
        Catch {
            Throw "Could not load MDT PowerShell Module. Please make sure that the MDT console is installed correctly."
        }
    } Else {
        Throw "Cannot find the MDT PowerShell module. Is the MDT console installed?"
    }

    # Create the MDT PSDrive
    $mdtDrive = "DS001"
    If (Test-Path "$($mdtDrive):") {
        Write-Verbose "Found existing MDT drive $mdtDrive. Removing."
        Remove-PSDrive -Name $mdtDrive -Force
    }
    Try {
        $Drive = New-PSDrive -Name $mdtDrive -PSProvider MDTProvider -Root $Path
    }
    Catch {
        Throw "Could not create a new MDT drive. Aborting."
    }
}

PROCESS {

    # If $Path is specified, use a sub-folder of MDT Share\Packages
    If ($PSBoundParameters.ContainsKey('Folder')) {
        $Dest = "$($Drive.Name):\Packages\$Folder"
        If (!(Test-Path -Path $Dest -Type 'Container')) {
            Try {
                New-Item -Path "$($Drive.Name):\Packages" -Enable "True" -Name $Folder -Comments "" -ItemType "Folder" -Verbose
            }
            Catch {
                Throw "Could not create path $Dest in the MDT deployment share. Aborting."
            }
        }
    } Else {
        # If no path specified, we'll import directly into the Packages folder
        $Dest = "$($Drive.Name):\Packages"
    }

    If ($Clean) {
        Push-Location $Dest
        Get-ChildItem | Where-Object { $_.Name -like "Package*" } | ForEach-Object { Remove-Item $_.Name -Verbose }
    }

    Import-MdtPackage -Path $Dest -SourcePath $Update -Verbose
}

END {
}