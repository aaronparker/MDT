@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM http://blog.stealthpuppy.com/virtualisation/sequencing-google-chrome-15/
REM http://www.google.co.uk/intl/en-GB/chrome/business/browser/admin/

START /WAIT MSIEXEC /I GoogleChromeStandaloneEnterprise.MSI ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\GoogleChromeEnterprise.log
SET ERROR=%ERRORLEVEL%
IF DEFINED ProgramFiles(x86) COPY /Y ".\master_preferences" "%ProgramFiles(x86)%\Google\Chrome\Application\master_preferences"
IF NOT DEFINED ProgramFiles(x86) COPY /Y ".\master_preferences" "%ProgramFiles%\Google\Chrome\Application\master_preferences"
sc config gupdate start= disabled
sc config gupdatem start= disabled
schtasks /change /TN "\GoogleUpdateTaskMachineCore" /Disable
schtasks /change /TN "\GoogleUpdateTaskMachineUA" /Disable
IF EXIST "%PUBLIC%\Desktop\Google Chrome.lnk" DEL /F /Q "%PUBLIC%\Desktop\Google Chrome.lnk"
IF "%PROCESSOR_ARCHITECTURE%"=="x86" REG DELETE "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{8A69D345-D564-463c-AFF1-A69D9E530F96}" /f
IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Active Setup\Installed Components\{8A69D345-D564-463c-AFF1-A69D9E530F96}" /f
EXIT %ERROR%
