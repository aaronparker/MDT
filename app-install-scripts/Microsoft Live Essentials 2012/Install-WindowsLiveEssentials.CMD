@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM http://g.live.com/1rewlive5-all/en/wlsetup-all.exe

REM no toolbar ceip configuration
REM /NOTOOLBARCEIP

REM no search configuration
REM /NOSEARCH

REM no homepage configuration
REM /NOHOMEPAGE

REM messenger only configuration
REM /MESSENGERONLY

REM no CEIP configuration
REM /NOCEIP

REM no MU configuration
REM /NOMU

REM non-strict dependency configuration
REM /NOSTRICT

REM no launch configuration
REM /NOLAUNCH


START /WAIT wlsetup-all.exe /AppSelect:PhotoGallery,MovieMaker /NOTOOLBARCEIP /NOSEARCH /NOHOMEPAGE /NOCEIP /NOSTRICT /NOLAUNCH /SILENT
