@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM	START /WAIT vcredist_x86-SP1.exe /CEIPconsent /norestart /passive /log %LOGDIR%\VisualC2010x86-SP1.htm
START /WAIT vcredist_x86-MFC.exe /CEIPconsent /norestart /passive /log %LOGDIR%\VisualC2010x86-MFC.htm

REM Multiple versions might be required to support various applications
REM	http://www.microsoft.com/en-us/download/details.aspx?id=8328
REM	http://www.microsoft.com/en-us/download/details.aspx?id=26999
