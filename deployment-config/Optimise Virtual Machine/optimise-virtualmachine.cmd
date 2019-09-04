@ECHO OFF
REM ---------------------------------------
REM  Optimisations for virtual machines
REM ---------------------------------------



REM Disable SuperFetch
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0x0 /f

REM Disk timeout value
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Disk" /v TimeOutValue /t REG_DWORD /d 200 /f

REM Change the event log sizes and retention settings
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Application" /v MaxSize /t REG_DWORD /d 0x100000 /f
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Application" /v Retention /t REG_DWORD /d 0x0 /f
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\System" /v MaxSize /t REG_DWORD /d 0x100000 /f
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\System" /v Retention /t REG_DWORD /d 0x0 /f
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Security" /v MaxSize /t REG_DWORD /d 0x100000 /f
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Security" /v Retention /t REG_DWORD /d 0x0 /f

REM Disable the Network Location Wizard
REG ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f

REM Disable crash dumps
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl" /v CrashDumpEnabled /t REG_DWORD /d 0x0 /f


REM Disable services
REM BitLocker Drive Encryption Service
sc config BDESVC start= disabled

REM Block Level Backup Engine Service
sc config wbengine start= disabled

REM Diagnostic Policy Service
sc config DPS start= disabled

REM Desktop Window Manager Session Manager
REM	sc config UxSms start= disabled

REM Disk Defragmenter
sc config Defragsvc start= disabled

REM HomeGroup Listener
sc config HomeGroupListener start= disabled

REM HomeGroup Provider
sc config HomeGroupProvider start= disabled

REM IP Helper
REM	sc config iphlpsvc start= disabled

REM Microsoft iSCSI Initiator Service
sc config MSiSCSI start= disabled

REM Microsoft Software Shadow Copy Provider
sc config swprv start= disabled

REM Offline Files
sc config CscService start= disabled

REM Secure Socket Tunneling Protocol Service
sc config SstpSvc start= disabled

REM Windows Security Center
sc config wscsvc start= disabled

REM SSDP Discovery
sc config SSDPSRV start= disabled

REM SuperFetch
sc config SysMain start= disabled

REM Tablet Input Service 
sc config TabletInputService start= disabled

REM Universal Plug and Play (UPnP) Device Host
sc config upnphost start= disabled

REM Volume Shadow Copy Service
REM	sc config VSS start= disabled

REM Windows Backup
sc config SDRSVC start= disabled

REM Windows Defender
sc config WinDefend start= disabled

REM Windows Error Reporting Service
sc config WerSvc start= disabled

REM Windows Firewall
REM	sc config MpsSvc start= disabled

REM Windows Media Center Receiver Service
sc config ehRecvr start= disabled

REM Windows Media Center Scheduler Service
sc config ehSched start= disabled

REM WLAN AutoConfig
sc config Wlansvc start= disabled

REM WWAN AutoConfig
sc config WwanSvc start= disabled

REM Windows Search
REM	sc config WSearch start= disabled

REM Windows Update
REM	sc config wuauserv start= disabled

REM Themes
REM	sc config Themes start= disabled


REM Making miscellaneous modifications
REM Disable the boot animation
bcdedit /set BOOTUX disabled

REM Disable Startup Repair option
bcdedit /set {default} bootstatuspolicy ignoreallfailures

REM Disable hiberation and set power scheme to maximum
powercfg -H OFF
powercfg -setactive SCHEME_MIN

REM Disable NTFS last access timestamp
fsutil behavior set DisableLastAccess 1

REM Disable System Restore and delete any existing restore points
vssadmin delete shadows /All /Quiet
Powershell disable-computerrestore -drive %SystemDrive%

REM Disable Windows Firewall profiles on all interfaces
REM	netsh advfirewall set allprofiles state off


REM Making modifications to Scheduled Tasks
schtasks /change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Disable
schtasks /change /TN "\Microsoft\Windows\SystemRestore\SR" /Disable
schtasks /change /TN "\Microsoft\Windows\Registry\RegIdleBackup" /Disable
schtasks /change /TN "\Microsoft\Windows Defender\MPIdleTask" /Disable
schtasks /change /TN "\Microsoft\Windows Defender\MP Scheduled Scan" /Disable
schtasks /change /TN "\Microsoft\Windows\Maintenance\WinSAT" /Disable

