@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

FOR /f "delims=" %%D in ('dir "%SOURCE%\" /a:d /b') DO PUSHD "%%~fD" & Install-VisualCRedist.CMD & POPD
