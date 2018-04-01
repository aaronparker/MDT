@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

START /WAIT msiexec /i profilemgt4.1.2_x86.msi /quiet /norestart /l* %LOGDIR%\CitrixProfileManagementX86.log
