@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM	START /WAIT vcredist_x64-SP1.exe /CEIPconsent /norestart /passive /log %LOGDIR%\VisualC2010x64-SP1.htm
START /WAIT vcredist_x64-MFC.exe /CEIPconsent /norestart /passive /log %LOGDIR%\VisualC2010x64-MFC.htm

REM Multiple versions might be required to support various applications
REM	http://www.microsoft.com/en-us/download/details.aspx?id=13523
REM	http://www.microsoft.com/en-us/download/details.aspx?id=26999
