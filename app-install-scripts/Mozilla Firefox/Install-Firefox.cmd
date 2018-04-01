@ECHO OFF
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
SET INSTALLPATH=%ProgramFiles%\Mozilla Firefox

REM Resources
REM http://stealthpuppy.com/prepare-mozilla-firefox-for-enterprise-deployment-and-virtualization/
REM http://www.mozilla.org/en-US/firefox/all/

REM Create the Firefox answer file
ECHO [Install] > "%SOURCE%\Firefox.ini"
REM	ECHO InstallDirectoryName=Firefox >> "%SOURCE%\Firefox.ini"
REM	ECHO InstallDirectoryPath=%INSTALLPATH% >> "%SOURCE%\Firefox.ini"
ECHO QuickLaunchShortcut=false >> "%SOURCE%\Firefox.ini"
ECHO DesktopShortcut=false >> "%SOURCE%\Firefox.ini"
ECHO StartMenuShortcuts=true >> "%SOURCE%\Firefox.ini"
ECHO MaintenanceService=false >> "%SOURCE%\Firefox.ini"

REM Find the Firefox setup
FOR %%f IN (*.EXE) DO SET EXE=%%f

REM Install Firefox
START /WAIT "Firefox" /D "%SOURCE%" "%EXE%" /INI="%SOURCE%\Firefox.ini"
DEL /Q "%SOURCE%\Firefox.ini"

REM Configure Firefox profile defaults and preferences locking
IF NOT EXIST "%INSTALLPATH%\browser\defaults\profile\chrome" MD "%INSTALLPATH%\browser\defaults\profile\chrome"
COPY /Y %SOURCE%\userChrome.css "%INSTALLPATH%\browser\defaults\profile\chrome\userChrome.css"
IF NOT EXIST "%INSTALLPATH%\browser\defaults\preferences" MD "%INSTALLPATH%\browser\defaults\preferences"
COPY /Y %SOURCE%\local-settings.js "%INSTALLPATH%\browser\defaults\preferences\local-settings.js"
COPY /Y %SOURCE%\Mozilla.cfg "%INSTALLPATH%\Mozilla.cfg"
COPY /Y %SOURCE%\override.ini "%INSTALLPATH%\browser\override.ini"

REM Disable the Mozilla Maintenance Service to prevent updates (in the event the service is installed)
sc config MozillaMaintenance start= disabled
