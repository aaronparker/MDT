@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

START /WAIT MSIEXEC /I sqlncli.MSI IACCEPTSQLNCLILICENSETERMS=YES ADDLOCAL=ALL ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\SQLServer2008R2NativeClientx64.log
EXIT %ERRORLEVEL%
