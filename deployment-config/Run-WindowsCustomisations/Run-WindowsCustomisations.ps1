<#
    .SYNOPSIS
    Configuration changes to a default install of Windows during provisioning.
  
    .NOTES
    NAME: Run-WindowsCustomisations.ps1
    AUTHOR: Aaron Parker, Insentra
    LASTEDIT: June 28, 2017
 
    .LINK
    http://www.insentra.com.au
#>

# Remove sample files if they exist
$Paths = "$env:PUBLIC\Music\Sample Music", "$env:PUBLIC\Pictures\Sample Pictures", "$env:PUBLIC\Videos\Sample Videos", "$env:PUBLIC\Recorded TV\Sample Media"
ForEach ( $Path in $Paths ) {
    # Write-Host "$Path exists."
    If ( Test-Path $Path ) { Remove-Item $Path -Recurse -Force }
}

# Remove the C:\Logs folder
$Path = "$env:SystemDrive\Logs"
If ( Test-Path $Path ) { Remove-Item $Path -Recurse -Force }

# If Windows 10, remove in-box Universal Apps and other apps
If ([Environment]::OSVersion.Version -ge (New-Object 'Version' 10,0)) {
    . .\Remove-DefaultAppxApps.ps1
    Remove-DefaultAppxApps -Confirm:$False

    # If Windows 10, remove the Contact Support /  Get Help app
    $Build = ([Environment]::OSVersion.Version).Build
    dism /online /remove-package /PackageName:"Microsoft-Windows-ContactSupport-Package~31bf3856ad364e35~amd64~~10.0.$Build.0"
    dism /online /remove-package /PackageName:"Microsoft-Windows-QuickAssist-Package~31bf3856ad364e35~amd64~~10.0.$Build.0"
}

# Set FontSubstitutes. Default font replacement is 'Microsoft Sans Serif' for 'Tahoma'
.\Set-FontSubstitutes.ps1 -Values "MS Shell Dlg", "MS Shell Dlg 2" -Font "Tahoma"

# Run Disk Cleanup tool. The tool will run interactively in the current session
. .\Set-CleanMgrSettings.ps1
Start-Process -FilePath $env:SystemRoot\system32\Cleanmgr.exe -ArgumentList "/sagerun:100" -Wait

# Default profile customisations (and current profile for CopyProfile in unattend.xml)
. .\Set-DefaultProfile.ps1
