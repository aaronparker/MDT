@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM http://technet.microsoft.com/en-gb/library/jj680037.aspx

SET OPTIONS=
REM	SET OPTIONS=%OPTIONS% SettingsStoragePath=%%HOMESHARE%%
REM	SET OPTIONS=%OPTIONS% SettingsTemplateCatalogPath=\\DC1\UEV\Templates
REM	SET OPTIONS=%OPTIONS% RegisterMSTemplates=FALSE
SET OPTIONS=%OPTIONS% SyncMethod=None
SET OPTIONS=%OPTIONS% SyncTimeoutInMilliseconds=2000
SET OPTIONS=%OPTIONS% SyncEnabled=True
REM	SET OPTIONS=%OPTIONS% MaxPackageSizeInBytes=
SET OPTIONS=%OPTIONS% CEIPEnabled=FALSE

START /WAIT MSIEXEC /I AgentSetupx86.MSI %OPTIONS% ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\UEV-Agent.log
REM	MSIEXEC /I ToolsSetupx86.MSI ALLUSERS=TRUE REBOOT=SUPPRESS /QB- /l* %LOGDIR%\UEV-Tools.log
"%\ProgramFiles%\Microsoft User Experience Virtualization\Agent\x64\ApplySettingsTemplateCatalog.exe"
