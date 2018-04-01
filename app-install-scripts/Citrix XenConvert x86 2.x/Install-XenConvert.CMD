@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM http://www.citrix.com/downloads/xenserver/tools/conversion.html

START /WAIT XenConvert_Install.exe /S /v"ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\CitrixXenConvert2.log"
