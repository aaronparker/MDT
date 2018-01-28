@ECHO OFF
REM -----------------------------------------------------------------------------
REM  Customise Windows Server 2008 R2 RDS during the deployment phase
REM -----------------------------------------------------------------------------

REM Disable Windows Defender
sc config windefend start= disabled
NET STOP WINDEFEND

REM Improve UI consistency
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes" /v "MS Shell Dlg" /d Tahoma /t REG_SZ /f

REM IE fixes: Mapped drives marked as Internet zone
REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_RESPECT_ZONEMAP_FOR_MAPPED_DRIVES_KB929798" /v * /d 1 /t REG_DWORD /f

REM IE fixes: Disable default favourites, links and feeds
REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_BRANDING_DISABLE_DEFAULT_FEEDS_KB941938" /v * /d 1 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_BRANDING_DISABLE_DEFAULT_FAVORITES_KB941938" /v * /d 1 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_BRANDING_DISABLE_DEFAULT_QUICKLINKS_KB941938" /v * /d 1 /t REG_DWORD /f

REM IE fixes: file type icon changes fixing the defaults
REG ADD HKCR\InternetShortcut\DefaultIcon /t REG_SZ /ve /d "%SystemRoot%\System32\url.dll,0" /f

REM Prevent Windows Media Player first-run dialog
REG ADD HKLM\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer /v GroupPrivacyAcceptance /d 1 /t REG_DWORD /f

REM Remove Briefcase from New menu
REG DELETE HKCR\Briefcase /f

REM Clean up Windows locations
IF EXIST "%PUBLIC%\Music\Sample Music" RD /Q /S "%PUBLIC%\Music\Sample Music"
IF EXIST "%PUBLIC%\Pictures\Sample Pictures" RD /Q /S "%PUBLIC%\Pictures\Sample Pictures"
IF EXIST "%PUBLIC%\Videos\Sample Videos" RD /Q /S "%PUBLIC%\Videos\Sample Videos"
IF EXIST "%PUBLIC%\Recorded TV\Sample Media" RD /Q /S "%PUBLIC%\Recorded TV\Sample Media"

REM Remove default start navigtation click sound
IF EXIST "%SystemRoot%\Media\Windows Navigation Start.wav" (
TAKEOWN /f "%SystemRoot%\Media\Windows Navigation Start.wav" /a
CACLS "%SystemRoot%\Media\Windows Navigation Start.wav" /E /G Administrators:F
DEL /Q "%SystemRoot%\Media\Windows Navigation Start.wav"
)

REM Wallpaper, Themes, User Account Pictures
TAKEOWN /F "%SystemRoot%\Web\Wallpaper\Windows\img0.jpg" /A
CACLS "%SystemRoot%\Web\Wallpaper\Windows\img0.jpg" /E /G Administrators:F
XCOPY .\Wallpaper %SystemRoot%\Web\Wallpaper /E /Y
XCOPY .\Themes %SystemRoot%\Resources\Themes /Y
TAKEOWN /F "C:\ProgramData\Microsoft\User Account Pictures\user.bmp" /A
TAKEOWN /F "C:\ProgramData\Microsoft\User Account Pictures\guest.bmp" /A
XCOPY .\AccountPictures "%ProgramData%\Microsoft\User Account Pictures" /Y

REM Set default theme, works with system customisations script
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes /v InstallTheme /d "%SystemRoot%\resources\themes\Aero\Aero.msstyles" /t REG_SZ /f
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes /v InstallVisualStyle /d "%ResourceDir%\themes\Aero\Aero.msstyles" /t REG_SZ /f

REM Enable Themes, Audio services
sc config themes start= auto
sc config audiosrv start= auto
NET START THEMES
NET START AUDIOSRV

REM Enable Remote Desktop Firewall exception
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes
