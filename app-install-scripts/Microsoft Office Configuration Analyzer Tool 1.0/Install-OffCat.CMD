@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM http://www.microsoft.com/en-us/download/details.aspx?id=36852

START /WAIT MSIEXEC /I OffCAT.msi ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\MicrosoftOffCAT1.log
