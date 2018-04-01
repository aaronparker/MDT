@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM http://support.citrix.com/proddocs/topic/xenapp65-admin/hd-opengl-gpu-sharing.html

REM Install all of the hotfixes from the current folder
FOR %%p IN (*.msp) DO START /WAIT MSIEXEC /P "%%p" ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* "%LOGDIR%\%%p.log"

