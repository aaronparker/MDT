@ECHO OFF
powershell Set-ExecutionPolicy -ExecutionPolicy Unrestricted
powershell -NonInteractive .\Enable-BasicIIS.ps1
powershell Set-ExecutionPolicy -ExecutionPolicy Restricted
exit 0