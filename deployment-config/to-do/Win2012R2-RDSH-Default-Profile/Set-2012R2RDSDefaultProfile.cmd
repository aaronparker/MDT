@ECHO OFF
REM -----------------------------------------------------------------------------
REM  Script configures the Default User Profile in a Windows 2012 R2 RDS
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

REM Command Prompt settings
REG ADD "%HKEY%\Console" /v QuickEdit /t REG_DWORD /d 1 /f
REG ADD "%HKEY%\Software\Microsoft\Command Processor" /v CompletionChar /t REG_DWORD /d 9 /f
REG ADD "%HKEY%\Software\Microsoft\Command Processor" /v PathCompletionChar /t REG_DWORD /d 9 /f
REG ADD "%HKEY%\Software\Microsoft\Windows NT\CurrentVersion\Network\Persistent Connections" /v SaveConnections /d "no" /t REG_SZ /f

REM Hide language bar
REM	REG ADD "%HKEY%\Software\Microsoft\CTF\LangBar" /v ShowStatus /t REG_DWORD /d 3 /f
REM	REG ADD "%HKEY%\Software\Microsoft\CTF\LangBar" /v Label /t REG_DWORD /d 1 /f
REM	REG ADD "%HKEY%\Software\Microsoft\CTF\LangBar" /v ExtraIconsOnMinimized /t REG_DWORD /d 0 /f

REM Windows Explorer and Start Menu
REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSizeMove /t REG_DWORD /d 0 /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete" /v "Append Completion" /t REG_SZ /d YES /f
REG ADD "%HKEY%\AppEvents\Schemes\Apps\Explorer\Navigating\.Current" /ve /t REG_EXPAND_SZ /d "" /f

REM Windows 8 navigation settings
REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v OpenAtLogon /t REG_DWORD /d 0 /f
REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v DesktopFirst /t REG_DWORD /d 0 /f
REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v MakeAllAppsDefault /t REG_DWORD /d 0 /f
REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v MonitorOverride /t REG_DWORD /d 0 /f

REM Set IE as default browser, prevent prompting user
REM	REG ADD "%HKEY%\Software\Clients\StartmenuInternet" /ve /d "IEXPLORE.EXE" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mht\UserChoice" /v Progid /d "IE.AssocFile.MHT" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.html\UserChoice" /v Progid /d "IE.AssocFile.HTM" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.htm\UserChoice" /v Progid /d "IE.AssocFile.HTM" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.url\UserChoice" /v Progid /d "IE.AssocFile.URL" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mhtml\UserChoice" /v Progid /d "IE.AssocFile.MHT" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.xht\UserChoice" /v Progid /d "IE.AssocFile.XHT" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.svg\UserChoice" /v Progid /d "IE.AssocFile.SVG" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.partial\UserChoice" /v Progid /d "IE.AssocFile.PARTIAL" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.website\UserChoice" /v Progid /d "IE.AssocFile.WEBSITE" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.xhtml\UserChoice" /v Progid /d "IE.AssocFile.XHT" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice" /v Progid /d "IE.HTTPS" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice" /v Progid /d "IE.FTP" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice" /v Progid /d "IE.HTTP" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\Shell\Associations\MIMEAssociations\message\rfc822\UserChoice" /v Progid /d "IE.message/rfc822" /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\Shell\Associations\MIMEAssociations\text\html\UserChoice" /v Progid /d "IE.text/html" /f

REM Internet Explorer
REM	REG ADD "%HKEY%\Software\Microsoft\Internet Explorer\TabbedBrowsing" /v PopupsUseNewWindow /t REG_DWORD /d 0 /f
REM	REG ADD "%HKEY%\Software\Microsoft\Internet Explorer\PhishingFilter" /v Enabled /t REG_DWORD /d 1 /f
REM	REG ADD "%HKEY%\Software\Microsoft\Internet Explorer\Main" /v "Enable AutoImageResize" /t REG_SZ /d YES /f
REM	REG ADD "%HKEY%\Software\Microsoft\Internet Explorer\PhishingFilter" /v Enabled /t REG_DWORD /d 2 /f
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\domain.local" /v * /t REG_DWORD /d 1 /f
REM	REG ADD "%HKEY%\Software\Microsoft\Internet Explorer\New Windows\Allow" /v *.domain.local /t REG_BINARY /d 0000 /f

REM Windows Media Player
REG ADD "%HKEY%\Software\Microsoft\MediaPlayer\Setup\UserOptions" /v DesktopShortcut /d No /t REG_SZ /f
REG ADD "%HKEY%\Software\Microsoft\MediaPlayer\Setup\UserOptions" /v QuickLaunchShortcut /d 0 /t REG_DWORD /f
REG ADD "%HKEY%\Software\Microsoft\MediaPlayer\Preferences" /v AcceptedPrivacyStatement /d 1 /t REG_DWORD /f
REG ADD "%HKEY%\Software\Microsoft\MediaPlayer\Preferences" /v FirstRun /d 0 /t REG_DWORD /f
REG ADD "%HKEY%\Software\Microsoft\MediaPlayer\Preferences" /v DisableMRU /d 1 /t REG_DWORD /f
REG ADD "%HKEY%\Software\Microsoft\MediaPlayer\Preferences" /v AutoCopyCD /d 0 /t REG_DWORD /f

REM Help and Support
REM	REG ADD "%HKEY%\Software\Microsoft\Assistance\Client\1.0\Settings" /v OnlineAssist /d 1 /t REG_DWORD /f
REM	REG ADD "%HKEY%\Software\Microsoft\Assistance\Client\1.0\Settings" /v IsConnected /d 1 /t REG_DWORD /f
REM	REG ADD "%HKEY%\Software\Microsoft\Assistance\Client\1.0\Settings" /v FirstTimeHelppaneStartup /d 1 /t REG_DWORD /f

REM Remove localisation - Themes, Feeds, Favourites
REM	REG DELETE "%HKEY%\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v mctadmin /f

REM Snipping Tool
REM	REG ADD "%HKEY%\Software\Microsoft\Windows\TabletPC\Snipping Tool" /v ShowCaptureStroke /d 0 /t REG_DWORD /f

REM Move Tracing logs away from User folder
REG ADD "%HKEY%\Software\Microsoft\Tracing\Setup\Lync" /v FileDirectory /t REG_SZ /d "%%LOCALAPPDATA%%\Tracing" /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\uccapi\AttendeeCommunicator" /v FileDirectory /t REG_SZ /d "%%LOCALAPPDATA%%\Tracing" /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\UcClient\UCAddin" /v FileDirectory /t REG_SZ /d "%%LOCALAPPDATA%%\Tracing\OCAddin" /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\uccp\LiveMeeting" /v FileDirectory /v FileDirectory /t REG_SZ /d "%%LOCALAPPDATA%%\Tracing" /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\WPPMedia\ETW" /v WPPFilePath /t REG_SZ /d "%%LOCALAPPDATA%%\Tracing\WPPMedia" /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\WPPMediaPerApp\AttendeeCommunicator" /v WPPFilePath /t REG_SZ /d "%%LOCALAPPDATA%%\Tracing\WPPMedia" /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\WPPMediaPerApp\AttendeeCommunicator\ETW" /v WPPFilePath /t REG_SZ /d "%%LOCALAPPDATA%%\Tracing\WPPMedia" /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\WPPMediaPerApp\Communicator" /v WPPFilePath /t REG_SZ /d "%%LOCALAPPDATA%%\Tracing\WPPMedia" /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\WPPMediaPerApp\Communicator\ETW" /v WPPFilePath /t REG_SZ /d "%%LOCALAPPDATA%%\Tracing\WPPMedia" /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\WPPMediaPerApp\WindowsLiveMessenger" /v WPPFilePath /t REG_SZ /d "%%LOCALAPPDATA%%\Tracing\WPPMedia" /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\uccp\Communicator" /v FileDirectory /d %%LOCALAPPDATA%%\Tracing /t REG_SZ /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\uccapi\Communicator" /v FileDirectory /d %%LOCALAPPDATA%%\Tracing /t REG_SZ /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\uccapi\WindowsLiveMessenger" /v FileDirectory /d %%LOCALAPPDATA%%\Tracing /t REG_SZ /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\WPPMedia" /v WPPFilePath /d %%LOCALAPPDATA%%\Tracing\WPPMedia /t REG_SZ /f
REG ADD "%HKEY%\Software\Microsoft\Tracing\WPPMedia\Debug" /v WPPFilePath /d %%LOCALAPPDATA%%\Tracing\WPPMedia /t REG_SZ /f

REM Set default theme
REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\ThemeManager" /v ThemeActive /d "1" /t REG_SZ /f
REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\ThemeManager" /v ColorName /d "NormalColor" /t REG_SZ /f
REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\ThemeManager" /v SizeName /d "NormalSize" /t REG_SZ /f
REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\ThemeManager" /v DllName /d "%SystemRoot%\Resources\Themes\aero\aero.msstyles" /t REG_EXPAND_SZ /f
REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Themes" /v CurrentTheme /d "%SystemRoot%\Resources\Themes\aero.theme" /t REG_EXPAND_SZ /f
REG ADD "%HKEY%\Software\Microsoft\Windows\CurrentVersion\Themes" /v InstallTheme /d "%SystemRoot%\Resources\Themes\aero\aero.msstyles" /t REG_EXPAND_SZ /f

REM Unload the default profile hive
REG UNLOAD %HKEY%

REM Configure the default Start Screen
IF NOT EXIST %SystemDrive%\Users\Default\AppData\Local\Microsoft\Windows MD %SystemDrive%\Users\Default\AppData\Local\Microsoft\Windows
POWERSHELL -NonInteractive -Command Import-StartLayout -LayoutPath .\CustomStartScreenLayout.bin -MountPath %SystemDrive%\

REM Setup Taskbar unpin items on first login
IF NOT EXIST "%ProgramFiles%\Scripts" MD "%ProgramFiles%\Scripts"
COPY /Y ExecuteVerbAction.VBS "%ProgramFiles%\Scripts\ExecuteVerbAction.VBS"
COPY /Y ShLib.exe "%ProgramFiles%\Scripts\ShLib.exe"

MD "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
ECHO @ECHO OFF > "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PinnedItemsLibraries.cmd"
ECHO cscript.exe "%ProgramFiles%\Scripts\ExecuteVerbAction.vbs" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Administrative Tools\Server Manager.lnk" UnpinFromTaskbar >> "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PinnedItemsLibraries.cmd"
ECHO cscript.exe "%ProgramFiles%\Scripts\ExecuteVerbAction.vbs" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\System Tools\Windows PowerShell.lnk" UnpinFromTaskbar >> "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PinnedItemsLibraries.cmd"
ECHO cscript.exe "%ProgramFiles%\Scripts\ExecuteVerbAction.vbs" "%%AppData%%\Microsoft\Windows\Start Menu\Programs\Internet Explorer.lnk" PinToTaskbar >> "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PinnedItemsLibraries.cmd"
ECHO "%ProgramFiles%\Scripts\shlib" remove "%%APPDATA%%\Microsoft\Windows\Libraries\Documents.library-ms" %PUBLIC%\Documents >> "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PinnedItemsLibraries.cmd"
ECHO "%ProgramFiles%\Scripts\shlib" remove "%%APPDATA%%\Microsoft\Windows\Libraries\Music.library-ms" %PUBLIC%\Music >> "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PinnedItemsLibraries.cmd"
ECHO "%ProgramFiles%\Scripts\shlib" remove "%%APPDATA%%\Microsoft\Windows\Libraries\Pictures.library-ms" %PUBLIC%\Pictures >> "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PinnedItemsLibraries.cmd"
ECHO "%ProgramFiles%\Scripts\shlib" remove "%%APPDATA%%\Microsoft\Windows\Libraries\Videos.library-ms" %PUBLIC%\Videos >> "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PinnedItemsLibraries.cmd"
ECHO DEL /Q "%%APPDATA%%\Microsoft\Windows\Start Menu\Programs\Startup\PinnedItemsLibraries.cmd" >> "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PinnedItemsLibraries.cmd"

