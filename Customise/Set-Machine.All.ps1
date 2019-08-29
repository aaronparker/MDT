#   Windows 10 Set-Customisations.ps1

# Registry Commands
$RegCommands =
'add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes" /v "MS Shell Dlg" /d "Tahoma" /t REG_SZ /f',
'add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes" /v "MS Shell Dlg 2" /d "Tahoma" /t REG_SZ /f'

# Process Registry Commands
ForEach ($Command in $RegCommands) {
    Write-Host "reg $Command"
    Start-Process reg -ArgumentList $Command -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
}
