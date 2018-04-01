@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

START /WAIT vjredist64.exe /q:a /c:"install.exe /q /l %LOGDIR%\vjredist.log"
