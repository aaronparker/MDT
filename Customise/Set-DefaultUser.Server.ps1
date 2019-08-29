#   Windows Server 2016/2019

# Configure the default Start menu
If (!(Test-Path("$env:SystemDrive\Users\Default\AppData\Local\Microsoft\Windows"))) { New-Item -Value "$env:SystemDrive\Users\Default\AppData\Local\Microsoft\Windows" -ItemType Directory }
Import-StartLayout -LayoutPath .\WindowsServerStartMenuLayout.xml -MountPath "$($env:SystemDrive)\"
