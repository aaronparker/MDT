@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

START /WAIT vcredist_x86-RTM.exe /Q
START /WAIT vcredist_x86-SP1.exe /Q
START /WAIT vcredist_x86-ATL.exe /Q
START /WAIT vcredist_x86-MFC.EXE /Q
IF EXIST %SystemDrive%\msdia80.dll DEL /Q %SystemDrive%\msdia80.dll

REM Multiple versions might be required to support various applications
REM	http://www.microsoft.com/en-us/download/details.aspx?id=3387
REM	http://www.microsoft.com/en-us/download/details.aspx?id=5638
REM	http://www.microsoft.com/en-us/download/details.aspx?id=14431
REM	http://www.microsoft.com/en-us/download/details.aspx?id=26347
