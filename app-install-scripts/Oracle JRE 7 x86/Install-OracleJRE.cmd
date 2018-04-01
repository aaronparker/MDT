@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM http://java.com/en/download/manual.jsp

SET JRE=1.7.0_55
START /WAIT jre-7u55-windows-i586.exe /s ADDLOCAL=jrecore IEXPLORER=1 MOZILLA=1 REBOOT=Suppress /L %LOGDIR%\OracleJava7.log

REM Configure on x86 systems
IF "%PROCESSOR_ARCHITECTURE%"=="x86" (
REG.EXE ADD "HKLM\SOFTWARE\JavaSoft\Java Plug-in\%JRE%" /v HideSystemTrayIcon /t REG_DWORD /d 1 /f
REG.EXE ADD "HKLM\SOFTWARE\JavaSoft\Java Update\Policy" /v EnableJavaUpdate /t REG_DWORD /d 0 /f
REG.EXE ADD "HKLM\SOFTWARE\JavaSoft\Java Update\Policy" /v EnableAutoUpdateCheck /t REG_DWORD /d 0 /f
REG.EXE ADD "HKLM\SOFTWARE\JavaSoft\Java Update\Policy" /v NotifyDownload /t REG_DWORD /d 0 /f
REG.EXE ADD "HKLM\SOFTWARE\JavaSoft\Java Update\Policy" /v NotifyInstall /t REG_DWORD /d 0 /f
REG.EXE DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v SunJavaUpdateSched /f
)

REM Configure on x64 systems
IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" ( (
%SYSTEMROOT%\SysWOW64\REG.EXE ADD "HKLM\SOFTWARE\JavaSoft\Java Plug-in\%JRE%" /v HideSystemTrayIcon /t REG_DWORD /d 1 /f
%SYSTEMROOT%\SysWOW64\REG.EXE ADD "HKLM\SOFTWARE\JavaSoft\Java Update\Policy" /v EnableJavaUpdate /t REG_DWORD /d 0 /f
%SYSTEMROOT%\SysWOW64\REG.EXE ADD "HKLM\SOFTWARE\JavaSoft\Java Update\Policy" /v EnableAutoUpdateCheck /t REG_DWORD /d 0 /f
%SYSTEMROOT%\SysWOW64\REG.EXE ADD "HKLM\SOFTWARE\JavaSoft\Java Update\Policy" /v NotifyDownload /t REG_DWORD /d 0 /f
%SYSTEMROOT%\SysWOW64\REG.EXE ADD "HKLM\SOFTWARE\JavaSoft\Java Update\Policy" /v NotifyInstall /t REG_DWORD /d 0 /f
%SYSTEMROOT%\SysWOW64\REG.EXE DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v SunJavaUpdateSched /f
)
