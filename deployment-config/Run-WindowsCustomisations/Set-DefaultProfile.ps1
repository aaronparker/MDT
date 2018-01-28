 <#
    .SYNOPSIS
        Script configures the Default User Profile in a Windows 10 image
 
    .DESCRIPTION
        Script configures the Default User Profile in a Windows 10 image.
        Should also be suitable for Windows Server 2016 RDSH deployments.
        Edits the profile of the current user and the default profile.
 
    .LINK
        http://stealthpuppy.com
#>

Function Set-DefaultProfile {
    Param ([String]$KeyPath = "Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER")

    # Remove PC beeps
    New-ItemProperty -Path "$KeyPath\Control Panel\Sound" -Name "Beep" -Value "No" -Force
    New-ItemProperty -Path "$KeyPath\Control Panel\Sound" -Name "ExtendedSounds" -Value "No" -Force

    # Set NET USE drive commands to be non-persistent
    New-Item -Path "$KeyPath\Software\Microsoft\Windows NT\CurrentVersion\Network"
    New-Item -Path "$KeyPath\Software\Microsoft\Windows NT\CurrentVersion\Network\Persistent Connections"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows NT\CurrentVersion\Network\Persistent Connections" -Name "SaveConnections" -Value "No" -Force

    # Windows Explorer
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "SeparateProcess" -Value 1 -Force

    # Personalization Settings
    # Remove transparency and colour to Navy Blue
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableBlurBehind" -Value 0 -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\DWM" -Name "ColorPrevalence" -Value 1 -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\DWM" -Name "AccentColor" -Value 4289815296 -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\DWM" -Name "ColorizationAfterglow" -Value 3288359857 -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\DWM" -Name "ColorizationColor" -Value 3288359857 -Force
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "AccentColor" -Value 4289992518 -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "AccentPalette" -Value 86CAFF005FB2F2001E91EA000063B10000427500002D4F000020380000CC6A00 -Force

    # Taskbar Settings
    New-Item -Path "$KeyPath\Software\Microsoft\TabletTip"
    New-Item -Path "$KeyPath\Software\Microsoft\TabletTip\1.7"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\TabletTip\1.7" -Name "TipbandDesiredVisibility" -Value 0 -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\PenWorkspace" -Name "PenWorkspaceButtonDesiredVisibility" -Value 0 -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value 1 -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarGlomLevel" -Value 1 -Force

    # Start menu settings
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0 -Force

    # Disable advertising
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Force

    # Internet Explorer - local Intranet zone defaults intranet location
    # New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\domain.local" -Name * -Value 1 -Force

    # Internet Explorer - local Intranet zone defaults for Azure AD SSO
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap"
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains"
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftazuread-sso.com"
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftazuread-sso.com\autologon"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftazuread-sso.com\autologon" -Name "http" -Value 1 -Force
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\nsatc.net"
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\nsatc.net\aadg.windows.net"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\nsatc.net\aadg.windows.net" -Name "http" -Value 1 -Force

    # Internet Explorer - local Trusted Sites zone defaults for Office 365
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftonline.com"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftonline.com" -Name "http" -Value 2 -Force
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\sharepoint.com"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\sharepoint.com" -Name "http" -Value 2 -Force
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\outlook.com"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\outlook.com" -Name "http" -Value 2 -Force
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\lync.com"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\lync.com" -Name "http" -Value 2 -Force
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\office365.com"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\office365.com" -Name "http" -Value 2 -Force
    New-Item -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\office.com"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\office.com" -Name "http" -Value 2 -Force

    # Windows Media Player
    New-Item -Path "$KeyPath\Software\Microsoft\MediaPlayer"
    New-Item -Path "$KeyPath\Software\Microsoft\MediaPlayer\Setup"
    New-Item -Path "$KeyPath\Software\Microsoft\MediaPlayer\Setup\UserOptions"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\MediaPlayer\Setup\UserOptions" -Name "DesktopShortcut" -Value "No" -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\MediaPlayer\Setup\UserOptions" -Name "QuickLaunchShortcut" -Value 0 -Force
    New-Item -Path "$KeyPath\Software\Microsoft\MediaPlayer\Preferences"
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\MediaPlayer\Preferences" -Name "AcceptedPrivacyStatement" -Value 1 -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\MediaPlayer\Preferences" -Name "FirstRun" -Value 0 -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\MediaPlayer\Preferences" -Name "DisableMRU" -Value 1 -Force
    New-ItemProperty -Path "$KeyPath\Software\Microsoft\MediaPlayer\Preferences" -Name "AutoCopyCD" -Value 0 -Force
}

# Set default in the current profile for use with CopyProfile in unattend.xml
Set-DefaultProfile -KeyPath "Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER"

# Set defaults in the default profile
# Load the default profile hive
$LoadPath = "HKLM\Default"
REG LOAD $LoadPath "$env:SystemDrive\Users\Default\NTUSER.DAT"

# Set defaut profile
Set-DefaultProfile -KeyPath "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\Default"

# Unload the default profile hive
Start-Sleep -Seconds 30
REG UNLOAD $LoadPath
[gc]::collect()

# Configure the default Start menu
If (!(Test-Path("$env:SystemDrive\Users\Default\AppData\Local\Microsoft\Windows"))) { New-Item -Name "$env:SystemDrive\Users\Default\AppData\Local\Microsoft\Windows" -ItemType Directory }
If (((Get-WmiObject Win32_OperatingSystem).Caption) -Like "Microsoft Windows Server 2016*") {
    Import-StartLayout -LayoutPath .\Win2016CustomStartMenuLayout.xml -MountPath "$env:SystemDrive\"
}
If (((Get-WmiObject Win32_OperatingSystem).Caption) -Like "Microsoft Windows 10*") {
    Import-StartLayout -LayoutPath .\Win10CustomStartMenuLayout.xml -MountPath "$env:SystemDrive\"
}
