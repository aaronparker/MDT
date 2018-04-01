@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Multiple versions might be required to support various applications
REM	http://www.microsoft.com/en-us/download/details.aspx?id=15336
REM	http://www.microsoft.com/en-us/download/details.aspx?id=16771
REM	http://www.microsoft.com/en-us/download/details.aspx?id=10430
REM	http://www.microsoft.com/en-us/download/details.aspx?id=2092
REM	http://www.microsoft.com/en-us/download/details.aspx?id=11895
REM	http://www.microsoft.com/en-us/download/details.aspx?id=26368

START /WAIT vcredist_x64-RTM.exe /q /l %LOGDIR%\VisualC2008x64-RTM.log
START /WAIT vcredist_x64-FP.exe /q /l %LOGDIR%\VisualC2008x64-FP.log
START /WAIT vcredist_x64-ATL.exe /q /l %LOGDIR%\VisualC2008x64-ATL.log
START /WAIT vcredist_x64-SP1.exe /q /l %LOGDIR%\VisualC2008x64-SP1.log
START /WAIT vcredist_x64-SP1-ATL.exe /q /l %LOGDIR%\VisualC2008x64-SP1-ATL.log
START /WAIT vcredist_x64-MFC.EXE /q /l %LOGDIR%\VisualC2008x64-MFC.log

REM Cleanup - VC 2008 RTM installer
IF EXIST %SystemDrive%\eula.1028.txt DEL /Q %SystemDrive%\eula.1028.txt
IF EXIST %SystemDrive%\eula.1031.txt DEL /Q %SystemDrive%\eula.1031.txt
IF EXIST %SystemDrive%\eula.1033.txt DEL /Q %SystemDrive%\eula.1033.txt
IF EXIST %SystemDrive%\eula.1036.txt DEL /Q %SystemDrive%\eula.1036.txt
IF EXIST %SystemDrive%\eula.1040.txt DEL /Q %SystemDrive%\eula.1040.txt
IF EXIST %SystemDrive%\eula.1041.txt DEL /Q %SystemDrive%\eula.1041.txt
IF EXIST %SystemDrive%\eula.1042.txt DEL /Q %SystemDrive%\eula.1042.txt
IF EXIST %SystemDrive%\eula.1049.txt DEL /Q %SystemDrive%\eula.1049.txt
IF EXIST %SystemDrive%\eula.2052.txt DEL /Q %SystemDrive%\eula.2052.txt
IF EXIST %SystemDrive%\eula.3082.txt DEL /Q %SystemDrive%\eula.3082.txt
IF EXIST %SystemDrive%\globdata.ini DEL /Q %SystemDrive%\globdata.ini
IF EXIST %SystemDrive%\install.exe DEL /Q %SystemDrive%\install.exe
IF EXIST %SystemDrive%\install.ini DEL /Q %SystemDrive%\install.ini
IF EXIST %SystemDrive%\install.res.1028.dll DEL /Q %SystemDrive%\install.res.1028.dll
IF EXIST %SystemDrive%\install.res.1031.dll DEL /Q %SystemDrive%\install.res.1031.dll
IF EXIST %SystemDrive%\install.res.1033.dll DEL /Q %SystemDrive%\install.res.1033.dll
IF EXIST %SystemDrive%\install.res.1036.dll DEL /Q %SystemDrive%\install.res.1036.dll
IF EXIST %SystemDrive%\install.res.1040.dll DEL /Q %SystemDrive%\install.res.1040.dll
IF EXIST %SystemDrive%\install.res.1041.dll DEL /Q %SystemDrive%\install.res.1041.dll
IF EXIST %SystemDrive%\install.res.1042.dll DEL /Q %SystemDrive%\install.res.1042.dll
IF EXIST %SystemDrive%\install.res.1049.dll DEL /Q %SystemDrive%\install.res.1049.dll
IF EXIST %SystemDrive%\install.res.2052.dll DEL /Q %SystemDrive%\install.res.2052.dll
IF EXIST %SystemDrive%\install.res.3082.dll DEL /Q %SystemDrive%\install.res.3082.dll
IF EXIST %SystemDrive%\vcredist.bmp DEL /Q %SystemDrive%\vcredist.bmp
IF EXIST %SystemDrive%\VC_RED.cab DEL /Q %SystemDrive%\VC_RED.cab
IF EXIST %SystemDrive%\VC_RED.MSI DEL /Q %SystemDrive%\VC_RED.MSI