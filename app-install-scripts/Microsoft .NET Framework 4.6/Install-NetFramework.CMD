@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM http://www.microsoft.com/en-us/download/details.aspx?id=48137

START /WAIT NDP46-KB3045557-x86-x64-AllOS-ENU.exe /passive /norestart /log %LOGDIR%\NDP46-KB3045557-x86-x64-AllOS-ENU.htm
REM	IF EXIST %SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\ngen.exe START /WAIT /D %SystemRoot%\Microsoft.NET\Framework64\v4.0.30319 ngen executequeueditems
REM	IF EXIST %SystemRoot%\Microsoft.NET\Framework\v4.0.30319\ngen.exe START /WAIT /D %SystemRoot%\Microsoft.NET\Framework\v4.0.30319 ngen executequeueditems

