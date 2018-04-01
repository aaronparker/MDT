@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP
IF NOT EXIST %LOGDIR% MD %LOGDIR%

REM Resources
REM http://support.citrix.com/proddocs/topic/provisioning-7/pvs-target-image-prepare.html#pvs-target-device-software-install

PUSHD %SOURCE%\Device
START /WAIT PVS_Device.exe /S /v/qn" ALLUSERS=TRUE REBOOT=SUPPRESS /l* %LOGDIR%\CitrixPVSDeviceTarget.log"
POPD
