@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Recommended Hotfixes for XenApp 6.0 and Later on Windows Server 2008 R2 
REM http://support.citrix.com/article/CTX129229

REM Install all of the hotfixes from the current folder
REM This might require changing the file names to ensure patches are installed in order (e.g. rename XA650W2K8R2X64R01.msp to 1_XA650W2K8R2X64R01.msp)
FOR %%p IN (*.msp) DO START /WAIT MSIEXEC /P "%%p" ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* "%LOGDIR%\%%p.log"
FOR %%p IN (*.msi) DO START /WAIT MSIEXEC /I "%%p" ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* "%LOGDIR%\%%p.log"


REM === Add specific hotfix configuration changes here ===

REM Hotfix Rollup Pack 2 for Citrix XenApp 6.5 for Microsoft Windows Server 2008 R2 
REM http://support.citrix.com/article/CTX136248

REM	REG ADD HKLM\SOFTWARE\Citrix\Policies /v SFTA /d 1 /t REG_DWORD /f
REM	REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Citrix\wfshell\TWI /v PublishedAppCommandLineFlag /d 2 /t REG_DWORD /f
REM	IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" REG ADD "HKLM\SOFTWARE\Wow6432Node\Citrix\CtxHook\AppInit_Dlls\Multiple Monitor Hook" /v "DevEnv.exe" /d 0x00100000 /f
REM	IF "%PROCESSOR_ARCHITECTURE%"=="x86" REG ADD "HKLM\SOFTWARE\Citrix\CtxHook\AppInit_Dlls\Multiple Monitor Hook" /v "DevEnv.exe" /d 0x00100000 /f
REM	IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" REG ADD "HKLM\SOFTWARE\Wow6432Node\Citrix\CtxHook\AppInit_Dlls\Zero Latency" /v IgnoreMarlettFont /d 1 /t REG_DWORD /f
REM	IF "%PROCESSOR_ARCHITECTURE%"=="x86" REG ADD "HKLM\SOFTWARE\Citrix\CtxHook\AppInit_Dlls\Zero Latency" /v IgnoreMarlettFont /d 1 /t REG_DWORD /f
REM	REG ADD "HKLM\SYSTEM\currentcontrolset\control\terminal server\wds\icawd" /v DisconnectTimeoutRetry /d 50 /t REG_DWORD /f
REM	REG ADD HKLM\SOFTWARE\Wow6432Node\Citrix\CtxPnP /v PnpRefreshClassExclusion /d "IEFrame" /t REG_SZ /f
REM	REG ADD HKLM\SOFTWARE\Wow6432Node\Citrix\Install /v CacheLocation /d [network location] /t REG_SZ /f
REM	REG ADD HKLM\SOFTWARE\Citrix\SmartCard /v SSEEETimeout /d 120 /t REG_DWORD /f
REM	REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Citrix\wfshell\TWI /v LogoffCheckerStartupDelayInSeconds /d 120 /t REG_DWORD /f
REM	REG ADD HKLM\SOFTWARE\Citrix\SmartCard /v EnableCtxCleanup /d 1 /t REG_DWORD /f
REM	REG ADD HKLM\SOFTWARE\Citrix /v AllowLongUserName /d 1 /t REG_DWORD /f
REM	IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" REG ADD HKLM\SOFTWARE\Wow6432Node\Citrix\Speedscreenmultimedia /v Disabledexecutables /d [list of exe's] /d REG_MULTI_SZ /f
REM	IF "%PROCESSOR_ARCHITECTURE%"=="x86" REG ADD HKLM\SOFTWARE\Citrix\Speedscreenmultimedia /v Disabledexecutables /d [list of exe's] /d REG_MULTI_SZ /f
REM	REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Citrix\wfshell\TWI /v ApplicationLaunchWaitTimeoutMS /d 10000 /t REG_DWORD /f
REM	REG ADD HKLM\SYSTEM\CurrentControlSet\services\picadm\Parameters /v EnableSophosAVSupport /d 1 /t REG_DWORD /f
REM	REG ADD HKLM\SOFTWARE\Wow6432Node\Citrix\WFShell /v LockOnReconnect /d 0 /t REG_DWORD /f
REM	REG ADD HKLM\SYSTEM\CurrentControlSet\services\picadm\Parameters /v EnableReadonlyAccess /d 0 /t REG_DWORD /f
REM	REG ADD HKLM\SYSTEM\CurrentControlSet\services\picadm\Parameters /v EnableCcReadCache /d 1 /t REG_DWORD /f
REM	REG ADD HKLM\SYSTEM\CurrentControlSet\services\picadm\Parameters /v EnableCcWriteCache /d 1 /t REG_DWORD /f
REM	REG ADD HKLM\SYSTEM\CurrentControlSet\services\picadm\Parameters /v SetMaxIOSize /d 1 /t REG_DWORD /f
REM	REG ADD HKLM\SOFTWARE\Citrix\SmartCard /v TransactionTimeoutEnable /d 1 /t REG_DWORD /f
REM	REG ADD HKLM\SOFTWARE\Citrix\SmartCard /v TransactionTimeoutValue /d 40 /t REG_DWORD /f
REM	REG ADD HKLM\SOFTWARE\Citrix\SmartCard /v SendRecvTimeout /d 30 /t REG_DWORD /f
REM	REG ADD HKLM\SOFTWARE\Citrix\SmartCard /v SupLowIntegrityProc /d 1 /t REG_DWORD /f
REM	REG ADD HKLM\Software\Wow6432Node\Citrix\WFShell /v SessionReconnectMinTimeInMilliSeconds /d 20000 /t REG_DWORD /f
REM	REG ADD HKLM\SOFTWARE\Wow6432Node\Policies\Citrix /v ReconnectSame /d 1 /t REG_DWORD /f
REM	REG ADD HKLM\SOFTWARE\Citrix\Reconnect /v DisableGPCalculation /d 1 /t REG_DWORD /f
REM	REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\icawd" /v EnableKeepAliveOnBR /d 1 /t REG_DWORD /f
REM	REG ADD HKLM\System\CurrentControlSet\Control\Citrix\wfshell\TWI /v SeamlessFlags /d 0x00800000 /t REG_DWORD /f
REM	REG ADD HKLM\System\CurrentControlSet\Control\Citrix\wfshell\TWI /v SeamlessFlags /d 0x00400000 /t REG_DWORD /f

