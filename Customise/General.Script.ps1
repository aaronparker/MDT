# Remove sample files if they exist
$Paths = "$env:PUBLIC\Music\Sample Music", "$env:PUBLIC\Pictures\Sample Pictures", `
    "$env:PUBLIC\Videos\Sample Videos", "$env:PUBLIC\Recorded TV\Sample Media"
ForEach ($Path in $Paths) {
    # Write-Host "$Path exists."
    If (Test-Path $Path) { Remove-Item $Path -Recurse -Force }
}

# Remove the C:\Logs folder
$Path = "$env:SystemDrive\Logs"
If (Test-Path $Path) { Remove-Item $Path -Recurse -Force }

# Remove permissions to admin tools for standard users
$Paths = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Server Manager.lnk", `
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools"
ForEach ($Path in $Paths) {
    # icacls $Path /inheritance:d
    # icacls $Path /grant "Administrators":F /T
    # icacls $Path /inheritance:d /remove "Everyone" /T
    # icacls $Path /inheritance:d /remove "Users" /T
}

# Configure services
Set-Service Audiosrv -StartupType Automatic
Set-Service WSearch -StartupType Automatic

 # EnableSmartScreen
 Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableSmartScreen" -Type DWORD -Value 2
 