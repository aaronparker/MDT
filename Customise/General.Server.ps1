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
