@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

START /WAIT vcredist_x64-RTM.exe /Q
START /WAIT vcredist_x64-SP1.exe /Q
START /WAIT vcredist_x64-ATL.exe /Q
START /WAIT vcredist_x64-MFC.EXE /Q
IF EXIST %SystemDrive%\msdia80.dll DEL /Q %SystemDrive%\msdia80.dll

REM Multiple versions might be required to support various applications
REM	http://www.microsoft.com/en-us/download/details.aspx?id=21254
REM	http://www.microsoft.com/en-us/download/details.aspx?id=18471
REM	http://www.microsoft.com/en-us/download/details.aspx?id=14431
REM	http://www.microsoft.com/en-us/download/details.aspx?id=26347
