@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP
IF NOT EXIST %LOGDIR% MD %LOGDIR%

REM Resources
REM http://support.citrix.com/proddocs/topic/provisioning-7/pvs-install-task3-install.html
REM http://support.citrix.com/proddocs/topic/provisioning-7/pvs-install-task3-install-console.html

PUSHD %SOURCE%\Server
START /WAIT PVS_Server_x64.exe /S /v/qn" ALLUSERS=TRUE REBOOT=SUPPRESS /l* %LOGDIR%\CitrixPVSServer.log"
PUSHD %SOURCE%\Console
START /WAIT PVS_Console_x64.exe /S /v/qn" ALLUSERS=TRUE REBOOT=SUPPRESS /l* %LOGDIR%\CitrixPVSConsole.log"
