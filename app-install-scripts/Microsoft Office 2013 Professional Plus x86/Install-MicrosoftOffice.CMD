@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM http://stealthpuppy.com/office-2013-customization/

PUSHD %SOURCE%
START /WAIT SETUP.EXE /ADMINFILE UnattendSilent.MSP
