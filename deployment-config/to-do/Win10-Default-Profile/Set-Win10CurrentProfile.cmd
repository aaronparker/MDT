@ECHO OFF
REM -----------------------------------------------------------------------------
REM  Script configures the Default User Profile in a Windows 10 image
REM  Should also be suitable for Windows Server 2016 RDSH deployments
REM -----------------------------------------------------------------------------

REM Remove PC beeps
REG ADD "HKCU\Control Panel\Sound" /v Beep /t REG_SZ /d NO /f
REG ADD "HKCU\Control Panel\Sound" /v ExtendedSounds /t REG_SZ /d NO /f

REM Set NET USE drive commands to be non-persistent
REG ADD "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Network\Persistent Connections" /v SaveConnections /d "no" /t REG_SZ /f

REM Windows Explorer
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SeparateProcess /t REG_DWORD /d 1 /f

REM Personalization Settings
REM Remove transparency and colour to Navy Blue
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableBlurBehind /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v ColorPrevalence /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v AccentColor /t REG_DWORD /d "4289815296" /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v ColorizationAfterglow /t REG_DWORD /d "3288359857" /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v ColorizationColor /t REG_DWORD /d "3288359857" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v AccentColor  /t REG_DWORD /d "4289992518" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v AccentPalette  /t REG_BINARY /d "86CAFF005FB2F2001E91EA000063B10000427500002D4F000020380000CC6A00" /f

REM Taskbar Settings
REG ADD "HKCU\Software\Microsoft\TabletTip\1.7" /v TipbandDesiredVisibility /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\PenWorkspace" /v PenWorkspaceButtonDesiredVisibility /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarGlomLevel /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v MMTaskbarGlomLevel /t REG_DWORD /d 1 /f

REM Start menu settings
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f

REM Disable advertising
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f

REM Internet Explorer - local Intranet zone defaults intranet location
REM	REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\domain.local" /v * /t REG_DWORD /d 1 /f

REM Internet Explorer - local Intranet zone defaults for Azure AD SSO
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftazuread-sso.com\autologon" /v http /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\nsatc.net\aadg.windows.net" /v http /t REG_DWORD /d 1 /f

REM Internet Explorer - local Trusted Sites zone defaults for Office 365
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftonline.com" /v http /t REG_DWORD /d 2 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\sharepoint.com" /v http /t REG_DWORD /d 2 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\outlook.com" /v http /t REG_DWORD /d 2 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\lync.com" /v http /t REG_DWORD /d 2 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\office365.com" /v http /t REG_DWORD /d 2 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\office.com" /v http /t REG_DWORD /d 2 /f

REM Windows Media Player
REG ADD "HKCU\Software\Microsoft\MediaPlayer\Setup\UserOptions" /v DesktopShortcut /d No /t REG_SZ /f
REG ADD "HKCU\Software\Microsoft\MediaPlayer\Setup\UserOptions" /v QuickLaunchShortcut /d 0 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v AcceptedPrivacyStatement /d 1 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v FirstRun /d 0 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v DisableMRU /d 1 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v AutoCopyCD /d 0 /t REG_DWORD /f
