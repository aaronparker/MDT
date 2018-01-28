@ECHO OFF
REM -----------------------------------------------------------------------------
REM  Customise Windows 8 during the deployment phase
REM -----------------------------------------------------------------------------

REM =========================================================
REM  Changes to Windows
REM --------------------------------------------------------

REM Improve UI consistency - replace 'Microsoft San Serif' with 'Tahoma'
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes" /v "MS Shell Dlg" /d Tahoma /t REG_SZ /f

REM IE fixes: Mapped drives marked as Internet zone
REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_RESPECT_ZONEMAP_FOR_MAPPED_DRIVES_KB929798" /v * /d 1 /t REG_DWORD /f

REM Enable SmartScreen for improved security
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /d "RequireAdmin" /t REG_SZ /f

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

REM Enable Remote Desktop Firewall exception
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes

