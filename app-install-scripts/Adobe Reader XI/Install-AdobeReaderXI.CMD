@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM ftp://ftp.adobe.com/pub/adobe/reader/win/11.x/
REM http://stealthpuppy.com/adobe-reader-xi-deployment/

SET MST="%SOURCE%\CustomReaderXI.mst"
SET PATCH="%SOURCE%\AdbeRdrUpd11010.msp"

REM Install Reader with latest patch
START /WAIT MSIEXEC /I "%SOURCE%\AcroRead.msi" TRANSFORMS=%MST% PATCH=%PATCH% ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\AdobeReaderXI.log

REM Disable the Reader update service
sc config AdobeARMservice start= disabled
