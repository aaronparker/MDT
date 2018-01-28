@ECHO OFF
REM -----------------------------------------------------------------------------
REM  Script configures the Default User Profile in a Windows 2008 image
REM -----------------------------------------------------------------------------

REM Load the default profile hive
SET HKEY=HKU\Default
REG LOAD %HKEY% %SystemDrive%\Users\Default\NTUSER.DAT

REM Sound and end-application
REG ADD "%HKEY%\Control Panel\Sound" /v Beep /t REG_SZ /d NO /f
REG ADD "%HKEY%\Control Panel\Sound" /v ExtendedSounds /t REG_SZ /d NO /f
REG ADD "%HKEY%\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 5000 /f
REG ADD "%HKEY%\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f
REG ADD "%HKEY%\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 4000 /f

REM Command Prompt
REG ADD "%HKEY%\Console" /v QuickEdit /t REG_DWORD /d 1 /f
REG ADD "%HKEY%\Software\Microsoft\Command Processor" /v CompletionChar /t REG_DWORD /d 9 /f
REG ADD "%HKEY%\Software\Microsoft\Command Processor" /v PathCompletionChar /t REG_DWORD /d 9 /f
REG ADD "%HKEY%\Software\Microsoft\Windows NT\CurrentVersion\Network\Persistent Connections" /v SaveConnections /d "no" /t REG_SZ /f

REM Language bar
REG ADD "%HKEY%\Software\Microsoft\CTF\LangBar" /v ShowStatus /t REG_DWORD /d 3 /f
REG ADD "%HKEY%\Software\Microsoft\CTF\LangBar" /v Label /t REG_DWORD /d 1 /f
REG ADD "%HKEY%\Software\Microsoft\CTF\LangBar" /v ExtraIconsOnMinimized /t REG_DWORD /d 0 /f

REM Windows Explorer and Start Menu
REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete" /v "Append Completion" /t REG_SZ /d YES /f
REG ADD "%HKEY%\AppEvents\Schemes\Apps\Explorer\Navigating\.Current" /ve /t REG_EXPAND_SZ /d "" /f

REM Internet Explorer
REG ADD "%HKEY%\Software\Microsoft\Internet Explorer\TabbedBrowsing" /v PopupsUseNewWindow /t REG_DWORD /d 0 /f
REG ADD "%HKEY%\Software\Microsoft\Internet Explorer\PhishingFilter" /v Enabled /t REG_DWORD /d 1 /f
REG ADD "%HKEY%\Software\Microsoft\Internet Explorer\Main" /v "Enable AutoImageResize" /t REG_SZ /d YES /f
REG ADD "%HKEY%\Software\Microsoft\Internet Explorer\PhishingFilter" /v Enabled /t REG_DWORD /d 2 /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\domain.local" /v * /t REG_DWORD /d 1 /f
REM	REG ADD "%HKEY%\Software\Microsoft\Internet Explorer\New Windows\Allow" /v *.domain.local /t REG_BINARY /d 0000 /f

REM Remove localisation - Themes, Feeds, Favourites
REG DELETE "%HKEY%\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v mctadmin /f

REM Snipping Tool
REG ADD "%HKEY%\Software\Microsoft\Windows\TabletPC\Snipping Tool" /v ShowCaptureStroke /d 0 /t REG_DWORD /f

REM Unload the default profile hive
REG UNLOAD %HKEY%

exit 0