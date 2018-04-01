@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Multiple versions might be required to support various applications
REM	http://www.microsoft.com/en-us/download/details.aspx?id=30679

REM	START /WAIT vcredist_x86.exe /norestart /passive /log %LOGDIR%\VisualC2012x86-RTM.htm
START /WAIT vcredist_x86_Update4.exe /norestart /passive /log %LOGDIR%\VisualC2012x86-U4.htm


