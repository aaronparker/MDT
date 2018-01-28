@ECHO OFF
REM -----------------------------------------------------------------------------
REM  Windows 7 virtual machine specific customisation
REM -----------------------------------------------------------------------------

REM ---
REM System customisations

REM Change default background for login screen - match Windows 7 background with Windows Server 2008 R2, so users don't know the difference
REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background /v OEMBackground /d 1 /t REG_DWORD /f
MD %SystemRoot%\system32\OOBE\info\backgrounds
COPY /Y backgroundDefault.jpg %SystemRoot%\system32\OOBE\info\backgrounds

REM Improve mouse cursor performance for remote connections (remove Aero cursors and mouse shadow)
REG DELETE "HKU\.DEFAULT\Control Panel\Cursors" /f
REG ADD "HKU\.DEFAULT\Control Panel\Cursors" /f
REG ADD "HKU\.DEFAULT\Control Panel\Desktop" /v UserPreferencesMask /d 9E1E078012000000 /t REG_BINARY /f
REM [ Default value 9E3E078012000000 ]


REM ---
REM Additional default profile customisations
REM Improve mouse cursor performance for remote connections (remove Aero cursors and mouse shadow)

REM Load the default profile hive
SET HKEY=HKU\Default
REG LOAD %HKEY% %SystemDrive%\Users\Default\NTUSER.DAT

REM Sound and end-application
REG ADD "%HKEY%\Control Panel\Cursors" /f
REG ADD "%HKEY%\Control Panel\Desktop" /v UserPreferencesMask /d 9E1E078012000000 /t REG_BINARY /f

REM Unload the default profile hive
REG UNLOAD %HKEY%
