@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM START /WAIT vc_redist.x86.RTM.exe /norestart /passive /log %LOGDIR%\VisualC2015x86-RTM.htm
REM START /WAIT vc_redist.x86.U1.exe /norestart /passive /log %LOGDIR%\VisualC2015x86-U1.htm
START /WAIT vc_redist.x86.U2.exe /norestart /passive /log %LOGDIR%\VisualC2015x86-U2.htm

REM Multiple versions might be required to support various applications
REM	http://www.microsoft.com/en-us/download/details.aspx?id=48145
REM https://www.microsoft.com/en-au/download/details.aspx?id=49984
REM https://www.microsoft.com/en-au/download/details.aspx?id=51682