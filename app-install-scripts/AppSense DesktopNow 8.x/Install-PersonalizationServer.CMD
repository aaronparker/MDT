@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Enable additional IIS features
powershell Set-ExecutionPolicy -ExecutionPolicy Unrestricted
powershell -NonInteractive .\Enable-IISUpdateforAMS.ps1
powershell Set-ExecutionPolicy -ExecutionPolicy Restricted

REM Install AppSense servers and consoles
START /WAIT MSIEXEC /I EnvironmentManagerConsole64.msi ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\AppSenseEnvironmentManagerConsole.log
START /WAIT MSIEXEC /I EnvironmentManagerDocumentation64.msi ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\AppSenseEnvironmentManagerDoc.log
START /WAIT MSIEXEC /I PersonalizationServer64.msi ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\AppSensePersonalizationServer.log
START /WAIT MSIEXEC /I ConfigurationAssistant64.msi ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\AppSenseConfigurationAssistant.log
START /WAIT MSIEXEC /I EnvironmentManagerTools64.msi ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\AppSenseEnvironmentManagerTools.log
START /WAIT MSIEXEC /I EMBrowserInterface64.msi ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\AppSenseEMBrowserInterface.log
