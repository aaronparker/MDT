@ECHO OFF
REM -----------------------------------------------------
REM  Citrix XenApp 6.5 Controller install and configure
REM http://support.citrix.com/proddocs/topic/xenapp65-install/ps-install-command-line.html
REM -----------------------------------------------------

REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

SET FarmName=XenApp65Test
SET CitrixAdministratorAccount="DEMOLAB\aaron"
SET DsnFile="%SOURCE%\XenApp65Test.dsn"
SET OdbcUserName=demolab\citrixservice
SET OdbcPassword=d3m0_lab
SET LicenseServerName=aga2.demolab.test
SET LicenseServerPort=27000
SET LicenseModel=XA
SET ZoneName="Default Zone"
SET OnlinePluginServerUrl="http://storefront.demolab.test/Citrix/DemoLabStore/PNAgent/config.xml"
SET PcmFarmName=XenApp65Test
SET PcmWorkloadName=Demo
SET XmlPort=8080


REM  Install XenApp 6.5
REM --------------------------------------------------------------
REM	SET OPTIONS=/install:XenApp,XenAppEnhancedDesktopExperience,PCMAgentFeature,EdgeSightAgentFeature,SmartAuditorAgentFeature,SSONAgentFeature
SET OPTIONS=/install:XenApp,XenAppEnhancedDesktopExperience
SET OPTIONS=%OPTIONS% /exclude:XA_IISIntegration
SET OPTIONS=%OPTIONS% /Platinum
SET OPTIONS=%OPTIONS% /Logfile:%LOGDIR%\CitrixXenApp65ControllerSetup.log
PUSHD "%SOURCE%\XenApp Server Setup\bin"
START /WAIT XenAppSetupConsole.exe %OPTIONS%
REG DELETE HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v "XenApp Server Role Manager" /f


REM  Join Farm
REM --------------------------------------------------------------
SET OPTIONS=/NotStrict
SET OPTIONS=%OPTIONS% /Log:%LOGDIR%\CitrixXenApp65ControllerJoin.log
SET OPTIONS=%OPTIONS% /ExecutionMode:Join
SET OPTIONS=%OPTIONS% /FarmName:%FarmName%
SET OPTIONS=%OPTIONS% /CitrixAdministratorAccount:%CitrixAdministratorAccount%
SET OPTIONS=%OPTIONS% /DsnFile:%DsnFile%
SET OPTIONS=%OPTIONS% /AuthenticationType:Windows
SET OPTIONS=%OPTIONS% /OdbcUserName:%OdbcUserName%
SET OPTIONS=%OPTIONS% /OdbcPassword:%OdbcPassword%
SET OPTIONS=%OPTIONS% /ImaWorkerMode:False
SET OPTIONS=%OPTIONS% /LicenseServerName:%LicenseServerName%
SET OPTIONS=%OPTIONS% /LicenseServerPort:%LicenseServerPort%
SET OPTIONS=%OPTIONS% /LicenseModel:%LicenseModel%
SET OPTIONS=%OPTIONS% /ZoneName:%ZoneName%
SET OPTIONS=%OPTIONS% /CustomXmlServicePort:%XmlPort%
SET OPTIONS=%OPTIONS% /AddAnonymousUsersToRemoteDesktopUserGroup:False
SET OPTIONS=%OPTIONS% /AddUsersGroupToRemoteDesktopUserGroup:True
SET OPTIONS=%OPTIONS% /OnlinePluginServerUrl:%OnlinePluginServerUrl%
SET OPTIONS=%OPTIONS% /PcmFarmName:%PcmFarmName%
SET OPTIONS=%OPTIONS% /PcmWorkloadName:%PcmWorkloadName%
SET OPTIONS=%OPTIONS% /CreateAnonymousUserAccounts:False
PUSHD "%ProgramFiles(x86)%\Citrix\XenApp\ServerConfig"
START /WAIT XenAppConfigConsole.exe %OPTIONS%


REM =============================================================================================
REM  All options
REM --------------------------------------------------------------
REM /NotStrict
REM /Confirm
REM /Pause
REM /Log:<log file>
REM /SqlExpressRootDir:<SQL Express Install Src Dir> (Default:SqlExpress_2008)
REM /ExecutionMode:[Create | Join | Leave | ImagePrep]
REM /FarmName:<Farm Name>
REM /CitrixAdministratorAccount:<Domain Name\User Name>
REM /SimpleDB
REM /ServerName:<Citrix Server>
REM /DsnFile:<Dsn File>
REM /AuthenticationType:[Windows | Sql] (Default:Windows)
REM /OdbcUserName:<The Odbc User Name>
REM /OdbcPassword:<The Odbc Password>
REM /ImaWorkerMode:[True | False] (Default:False)
REM /LicenseServerName:<License Server Name>
REM /LicenseServerPort:<License Port> (Default:27000)
REM /LicenseModel:<License Model>
REM /ProhibitShadowing:[True | False] (Default:False)
REM /ProhibitRemoteControl:[True | False] (Default:False)
REM /ForceShadowPopup:[True | False] (Default:False)
REM /ForceShadowLogging:[True | False] (Default:False)
REM /SmartAuditorServerName:<Smart Auditor Server>
REM /ZoneName:<Zone Name> (Default:Default Zone)
REM /CustomXmlServicePort:<Port Number> (Default:80)
REM /AddAnonymousUsersToRemoteDesktopUserGroup:[True | False] (Default:True)
REM /AddUsersGroupToRemoteDesktopUserGroup:[True | False] (Default:True)
REM /AddAuthenticatedUsersToRemoteDesktopUserGroup:[True | False] (Default:False)
REM /AddLocalAdmin:[True | False] (Default:False)
REM /SkipXmlSetting:[True | False] (Default:False)
REM /SsoPluginUncPath:<Unc Path to Central Store> (Default:Use Active Directory)
REM /OnlinePluginServerUrl:<Url (or server name) to the PnAgent Server>
REM /PcmFarmName:<Power and Capacity Management Farm Name>
REM /PcmWorkloadName:<Power and Capacity Management Workload Name>
REM /EdgeSightCompanyName:<EdgeSight Company Name>
REM /EdgeSightServerName:<EdgeSight Server Name>
REM /EdgeSightServerPort:<EdgeSight Server Port> (Default:80)
REM /RemoveCurrentServer:[True | False] (Default:True)
REM /PrepMsmq:[True | False] (Default:True)
REM /ClearLocalDatabaseInformation:[True | False] (Default:False)
REM /CreateAnonymousUserAccounts:[True | False] (Default:True)
REM /RemoveAnonymousCitrixAccounts:[True | False] (Default:False)

