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

    .PARAMETER Update
        The folder containing the updates to import into the MDT deployment share.

    .PARAMETER Path
        Specify the path to the MDT deployment share.

    .PARAMETER Folder
        A folder path to import into under the Packages folder in MDT.

    .PARAMETER Clean
        Before importing the latest updates into the target path, remove any existing update package.

    .EXAMPLE
         .\Get-LatestUpdate.ps1 -Download -Path C:\Updates | .\Import-LatestUpdate.ps1 -Path \\server\reference -Folder 'Windows 10'
        
        Import the latest update gathered from Get-LatestUpdate.ps1 into the deployment share \\server\reference under 'Packages\Windows 10'.

    .EXAMPLE
         .\Import-LatestUpdate.ps1 -Update C:\Updates -Path \\server\reference -Clean -Verbose
        
        Import the latest update stored in C:\Updates into the deployment share \\server\reference. Remove all existing packages first. Show verbose output.

    .EXAMPLE
         .\Import-LatestUpdate.ps1 -Update C:\Updates -Path \\server\reference -Folder 'Windows 10'
        
        Import the latest update stored in C:\Updates into the deployment share \\server\reference under 'Packages\Windows 10'.
#>
[CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Low', DefaultParameterSetName='Base')]
Param (
    [Parameter(ParameterSetName='Base', Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Specify the path to the MSU to import.")]
    $Update,

    [Parameter(ParameterSetName='Base', Mandatory=$True, HelpMessage="Specify an MDT deployment share to apply the update to.")]
    [ValidateScript({ If (Test-Path $_ -PathType 'Container') { $True } Else { Throw "Cannot find path $_" } })]
    [string]$Path,

    [Parameter(ParameterSetName='Base', Mandatory=$False, HelpMessage="A sub-folder in the MDT Packages folder.")]
    [string]$Folder,

    [Parameter(ParameterSetName='Base', Mandatory=$False, HelpMessage="Remove the updates from the target MDT deployment share before importing the new updates.")]
    [switch]$Clean
)
BEGIN {
    # Functions -------------------------
    # Validate Update parameter which could be a string or a PSCustomObject passed from Get-LatestUpdate.ps1
    Function Test-UpdateParameter {
        Param (
            [Parameter(Mandatory=$True, Position=0, ValueFromPipelineByPropertyName=$True)]
            $Path
        )
        [String]$UpdatePath = $Path
        If ($Path -is [PSCustomObject]) {
            [String]$UpdatePath = $Path.Path
        } 
        # Test the path to ensure it exists
        If (!(Test-Path -Path $UpdatePath -PathType 'Container' -ErrorAction SilentlyContinue )) {
            [bool]$UpdatePath = $False
        }
        Return $UpdatePath
    }

    # If we can find the MDT PowerShell module, import it. Requires MDT console to be installed
    Function Import-MdtModule {
        $mdtModule = "$((Get-ItemProperty "HKLM:SOFTWARE\Microsoft\Deployment 4").Install_Dir)bin\MicrosoftDeploymentToolkit.psd1"
        If (Test-Path -Path $mdtModule) {
            Try {            
                Import-Module -Name $mdtModule -ErrorAction SilentlyContinue
                Return $True
            }
            Catch {
                Throw "Could not load MDT PowerShell Module. Please make sure that the MDT console is installed correctly."
            }
        } Else {
            Throw "Cannot find the MDT PowerShell module. Is the MDT console installed?"
        }
    }

    # Create the MDT PSDrive
    Function New-MdtPSDrive {
        Param (
            [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$True)]
            [String]$Drive,

            [Parameter(Mandatory=$True, Position=1, ValueFromPipeline=$True)]
            [string]$Path
        )
        If (Test-Path "$($Drive):") {
            Write-Verbose "Found existing MDT drive $Drive."
            Remove-PSDrive -Name $Drive -Force
        }
        Try {
            $Drive = New-PSDrive -Name $Drive -PSProvider MDTProvider -Root $Path -ErrorAction SilentlyContinue
            Return $Drive
        }
        Catch {
            Write-Error $Error
            Return $False
        }
    }

    # Function to create a folder in the MDT Packages node
    Function New-MdtPackagesFolder {
        Param (
            [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$True)]
            [PSDrive]$Drive,

            [Parameter(Mandatory=$True, Position=1, ValueFromPipeline=$True)]
            [String]$Path
        )
        $Dest = "$($Drive.Name):\Packages\$Path"
        If (!(Test-Path -Path $Dest -Type 'Container')) {
            Write-Verbose "Creating folder $Path in Packages."
            New-Item -Path "$($Drive.Name):\Packages" -Enable "True" -Name $Path `
            -Comments "Created by 'Import-LatestUpdates.ps1" `
            -ItemType "Folder" -ErrorAction SilentlyContinue
        }
        If (Test-Path -Path $Dest -Type 'Container') { 
            Return $Dest
        } Else {
            Return $False
        }
    }
    # End Functions -------------------------


    # Import the MDT PS module and create a drive to the MDT deployment share
    If (Import-MdtModule) {
        $Drive = New-MdtPSDrive -Drive "DS001" -Path $Path
    } Else {
        Throw "Unable to map drive to the MDT deployment share."
    }
}

PROCESS {

    # If $Folder is specified, use a sub-folder of MDT Share\Packages
    If ($PSBoundParameters.ContainsKey('Folder')) {
        $Dest = New-MdtPackagesFolder -Drive $Drive -Path $Folder
    } Else {
        # If no path specified, we'll import directly into the Packages folder
        $Dest = "$($Drive.Name):\Packages"
    }

    # If we could create the path successfully, or import directly into \Packges, continue
    If ($Dest -ne $False) {

        # If -Clean is specified, enumerate existing packages from the target destination and remove before importing
        If ($Clean) {
            Write-Verbose "Removing existing update packages."
            Push-Location $Dest
            # Get Package items from the target folder, and remove them
            # If they appear in other folders we won't remove copies
            Get-ChildItem | Where-Object { $_.Name -like "Package*" } | ForEach-Object { Remove-Item $_.Name }
            Pop-Location
        }

        # Validate the provided local path and import the update package
        $UpdatePath = Test-UpdateParameter $Update
        If ($UpdatePath -ne $False) {
            Import-MdtPackage -Path $Dest -SourcePath $UpdatePath
        } Else {
            Write-Error "Validation failed on the provided path $Update"
        }
    }
}

END {
}