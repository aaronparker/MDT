@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

START /WAIT MSIEXEC /I ClientCommunicationsAgent32.MSI ALLUSERS=TRUE REBOOT=SUPPRESS WEB_SITE=http://appsense1.demolab.test /QB- /l* %LOGDIR%\AppSenseCommunicationsAgentx86.log
