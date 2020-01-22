#   Windows 10 Set-Customisations.ps1

# Registry Commands
$RegCommands =
'add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" /v DisableEdgeDesktopShortcutCreation /t REG_DWORD /d 1 /f'

# Process Registry Commands
ForEach ($Command in $RegCommands) {
    Write-Host "reg $Command"
    Start-Process reg -ArgumentList $Command -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
}

# Configure Windows features
$features = "Printing-XPSServices-Features", "SMB1Protocol", "WorkFolders-Client"
Disable-WindowsOptionalFeature -FeatureName $features -Online -NoRestart
