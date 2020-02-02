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

REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /d 1 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v ScheduledInstallDay /d 0 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v ScheduledInstallTime /d 3 /t REG_DWORD /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\wuauserv /v Start /d 4 /t REG_DWORD /f

REG ADD HKLM\Software\Citrix\ProvisioningServices /v DeviceOptimizerRun /d 1 /t REG_DWORD /f
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\NetCache /v Enabled /d 0 /t REG_DWORD /f
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

REM Compile .NET Framework assemblies
IF EXIST %SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\ngen.exe %SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\ngen executequeueditems
IF EXIST %SystemRoot%\Microsoft.NET\Framework\v4.0.30319\ngen.exe %SystemRoot%\Microsoft.NET\Framework\v4.0.30319\ngen executequeueditems

REM Disable the boot animation
bcdedit /set BOOTUX disabled

REM Disable Startup Repair option
bcdedit /set {default} bootstatuspolicy ignoreallfailures

REM Disable hiberation and set power scheme to maximum
powercfg -H OFF
powercfg -setactive SCHEME_MIN

REM Disable NTFS last access timestamp
fsutil behavior set DisableLastAccess 1

REM Making modifications to Scheduled Tasks
schtasks /change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Disable
REM	schtasks /change /TN "\Microsoft\Windows\SystemRestore\SR" /Disable
schtasks /change /TN "\Microsoft\Windows\Registry\RegIdleBackup" /Disable
REM	schtasks /change /TN "\Microsoft\Windows Defender\MPIdleTask" /Disable
schtasks /change /TN "\Microsoft\Windows Defender\MP Scheduled Scan" /Disable
REM	schtasks /change /TN "\Microsoft\Windows\Maintenance\WinSAT" /Disable

REM Windows and Office re-arm

IPCONFIG /FLUSHDNS
REG ADD HKCU\Software\Sysinternals\SDelete /v EulaAccepted /d 1 /t REG_DWORD /f
.\SDELETE.EXE -c -z %SystemDrive%:

ECHO Converting image..
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /d "0" /t REG_DWORD /f
REM	PUSHD "%ProgramFiles%\Citrix\XenConvert"
REM	START /WAIT XenConvert P2PVS %SystemDrive% /L /AutoFit

PUSHD "%ProgramFiles%\Citrix\Provisioning Services"
START /WAIT P2PVS.exe Volume2Volume %SystemDrive% E:

IF EXIST D:\MININT RD /Q /S D:\MININT & DEL /Q "D:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\LiteTouch.lnk"
IF EXIST E:\MININT RD /Q /S E:\MININT & DEL /Q "E:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\LiteTouch.lnk"
IF EXIST F:\MININT RD /Q /S F:\MININT & DEL /Q "F:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\LiteTouch.lnk"
REM	REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /d "1" /t REG_DWORD /f



