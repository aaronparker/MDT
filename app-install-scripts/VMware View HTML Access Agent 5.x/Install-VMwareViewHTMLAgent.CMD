@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

START /WAIT VMware-Horizon-View-HTML-Access_x64-1.1.0-1213173.exe /s /v"/qn REBOOT=ReallySuppress /l* %LOGDIR%\VMwareViewHTMLAccessAgent5.log"
