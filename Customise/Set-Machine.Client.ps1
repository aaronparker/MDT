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
$features = "Printing-XPSServices-Features", "SMB1Protocol", "WorkFolders-Client", "FaxServicesClientPackage", "WindowsMediaPlayer"
Disable-WindowsOptionalFeature -FeatureName $features -Online -NoRestart -ErrorAction SilentlyContinue

$Capabilities = $("App.Support.QuickAssist~~~~0.0.1.0", "MathRecognizer~~~~0.0.1.0", "Media.WindowsMediaPlayer~~~~0.0.12.0", "XPS.Viewer~~~~0.0.1.0")
ForEach ($Capability in $Capabilities) {
    Remove-WindowsCapability -Online -Name $Capability -ErrorAction SilentlyContinue
}

Get-WindowsPackage -Online -PackageName "Microsoft-Windows-MediaPlayer-Package*" | `
    ForEach-Object { Remove-WindowsPackage -PackageName $_.PackageName -Online -ErrorAction SilentlyContinue }
