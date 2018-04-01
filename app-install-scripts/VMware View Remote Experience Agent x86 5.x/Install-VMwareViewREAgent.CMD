@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

START /WAIT VMware-Horizon-View-5.2-Remote-Experience-Agent-2.0-1211192.exe /s /v"/qn REBOOT=ReallySuppress ADDLOCAL=Core,HTMLAccess,UnityTouch,FlashURLRedirection,RTAV /l* %LOGDIR%\VMwareViewREAgent5.log"

