@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM http://support.citrix.com/article/CTX135817
REM https://taas.citrix.com/hdx/download/

START /WAIT MSIEXEC /I "%SOURCE%\hdx-monitor.msi" ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\CitrixHDXMonitor.log
IF EXIST "%PUBLIC%\Desktop\Citrix HDX Monitor 3.2 (msi).lnk" DEL /Q "%PUBLIC%\Desktop\Citrix HDX Monitor 3.2 (msi).lnk"