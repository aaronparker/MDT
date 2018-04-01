@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

START /WAIT WebInterface.exe -q -g %LOGDIR%\CitrixWebInterface.log
SET ERROR=%ERRORLEVEL%

REM Create a WI site for internal use
SET OPTIONS1="WIDest=1:/Citrix/WI
SET OPTIONS1=%OPTIONS1%,WIDefaultSite=Yes
SET OPTIONS1=%OPTIONS1%,FarmName=XA65
SET OPTIONS1=%OPTIONS1%,XMLService=xenapp1.demolab.test;xenapp2.demolab.test
SET OPTIONS1=%OPTIONS1%,XMLSPort=80
SET OPTIONS1=%OPTIONS1%,XMLSProtocol=HTTP
SET OPTIONS1=%OPTIONS1%,AppAccessMethods=Remote;Streaming
SET OPTIONS1=%OPTIONS1%,AuthenticationPoint=WebInterface
SET OPTIONS1=%OPTIONS1%,AllowUserPasswordChange=Always
SET OPTIONS1=%OPTIONS1%,IcaFileSigningEnabled=Off
SET OPTIONS1=%OPTIONS1%,UIBranding=Applications"
"%ProgramFiles(x86)%\Citrix\Web Interface\5.4.0\sitemgr.exe" -q -g %LOGDIR%\CitrixWebInterfaceSiteMgrWI.log -c %OPTIONS1%

REM Create a WI site for AGEE
SET OPTIONS2="WIDest=1:/Citrix/AGEE
SET OPTIONS2=%OPTIONS2%,WIDefaultSite=No
SET OPTIONS2=%OPTIONS2%,FarmName=XA65
SET OPTIONS2=%OPTIONS2%,XMLService=xenapp1.demolab.test;xenapp2.demolab.test
SET OPTIONS2=%OPTIONS2%,XMLSPort=80
SET OPTIONS2=%OPTIONS2%,XMLSProtocol=HTTP
SET OPTIONS2=%OPTIONS2%,AppAccessMethods=Remote
SET OPTIONS2=%OPTIONS2%,AuthenticationPoint=AccessGateway
SET OPTIONS2=%OPTIONS2%,AGAuthenticationMethod=Explicit
SET OPTIONS2=%OPTIONS2%,AGAuthServiceURL=https://lab.kelway.co.uk/CitrixAuthService/AuthService.asmx
SET OPTIONS2=%OPTIONS2%,AGPromptPassword=Off
SET OPTIONS2=%OPTIONS2%,AllowUserPasswordChange=Expired-Only
SET OPTIONS2=%OPTIONS2%,IcaFileSigningEnabled=Off
SET OPTIONS2=%OPTIONS2%,UIBranding=Applications"
"%ProgramFiles(x86)%\Citrix\Web Interface\5.4.0\sitemgr.exe" -q -g %LOGDIR%\CitrixWebInterfaceSiteMgrAGEE.log -c %OPTIONS2%

EXIT %ERROR%
