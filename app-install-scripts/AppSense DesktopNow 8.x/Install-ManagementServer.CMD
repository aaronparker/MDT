@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Enable additional IIS features
powershell Set-ExecutionPolicy -ExecutionPolicy Unrestricted
powershell .\Enable-IISUpdateforAMS.ps1
powershell Set-ExecutionPolicy -ExecutionPolicy Restricted

REM Install AppSense servers and consoles
START /WAIT vcredist2010_SP1_x64.exe /PASSIVE /NORESTART
START /WAIT MSIEXEC /I ManagementConsole64.msi ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\AppSenseManagementConsole.log
START /WAIT MSIEXEC /I ManagementCenterDocumentation64.msi ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\AppSenseManagementCenterDoc.log
START /WAIT MSIEXEC /I ManagementServer64.msi ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\AppSenseManagementServer.log


