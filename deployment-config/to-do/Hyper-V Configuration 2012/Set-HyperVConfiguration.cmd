@ECHO OFF
COPY Set-HyperVConfiguration.ps1 %TEMP%
POWERSHELL.EXE -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Unrestricted -File %TEMP%\Set-HyperVConfiguration.ps1
DEL /Q %TEMP%\Set-HyperVConfiguration.ps1
