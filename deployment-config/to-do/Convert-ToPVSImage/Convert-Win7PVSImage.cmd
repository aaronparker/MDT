@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REG ADD HKLM\SYSTEM\CurrentControlSet\Services\BNNS\Parameters /v EnableOffload /d 0 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters /v DisableTaskOffload /d 1 /t REG_DWORD /f

REM	REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\5.0\Cache\Content" /v CacheLimit /d 1024 /t REG_DWORD /f
REM	REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Content" /v CacheLimit /d 1024 /t REG_DWORD /f
REM	REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRecycleFiles /d 1 /t REG_DWORD /f
REM	REG ADD "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Internet Settings\5.0\Cache\Content" /v CacheLimit /d 1024 /t REG_DWORD /f
REM	REG ADD "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Content" /v CacheLimit /d 1024 /t REG_DWORD /f

REG ADD HKLM\Software\Citrix\ProvisioningServices /v DeviceOptimizerRun /d 1 /t REG_DWORD /f
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\NetCache /v Enabled /d 0 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /d 1 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v ScheduledInstallDay /d 0 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v ScheduledInstallTime /d 3 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\wuauserv /v Start /d 4 /t REG_DWORD /f
REG ADD HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction /v Enable /d "N" /t REG_SZ /f
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OptimalLayout /v EnableAutoLayout /d 0 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\FileSystem /v NtfsDisableLastAccessUpdate /d 1 /t REG_DWORD /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HibernateEnabled /d 0 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\CrashControl /v CrashDumpEnabled /d 0 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\CrashControl /v LogEvent /d 0 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\CrashControl /v SendAlert /d 0 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\cisvc /v Start /d 4 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Application /v MaxSize /d 65536 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Security /v MaxSize /d 65536 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\System /v MaxSize /d 65536 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Paths" /v Paths /d 4 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Paths\path1" /v CacheLimit /d 256 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Paths\path2" /v CacheLimit /d 256 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Paths\path3" /v CacheLimit /d 256 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Paths\path4" /v CacheLimit /d 256 /t REG_DWORD /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /d 0 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters /v DisablePasswordChange /d 1 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\SysMain /v Start /d 4 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\WinDefend /v Start /d 4 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\WSearch /v Start /d 4 /t REG_DWORD /f
REM	REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "Windows Defender" /f

IF EXIST %SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\ngen.exe %SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\ngen executequeueditems
IF EXIST %SystemRoot%\Microsoft.NET\Framework\v4.0.30319\ngen.exe %SystemRoot%\Microsoft.NET\Framework\v4.0.30319\ngen executequeueditems

IPCONFIG /FLUSHDNS
REG ADD HKCU\Software\Sysinternals\SDelete /v EulaAccepted /d 1 /t REG_DWORD /f
.\SDELETE.EXE -c -z %SystemDrive%:

REM Windows and Office re-arm


PUSHD "%ProgramFiles%\Citrix\XenConvert"
REM	START /WAIT XenConvert P2PVS %SystemDrive% /L /AutoFit
