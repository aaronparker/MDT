@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM http://support.citrix.com/proddocs/topic/dws-storefront-12/dws-install-command.html

powershell -nologo -executionpolicy unrestricted -noninteractive -file %SOURCE%\Enable-StorefrontIIS.ps1
PUSHD x64\StoreFront
START /WAIT CitrixStoreFront-x64.exe -silent
POPD
