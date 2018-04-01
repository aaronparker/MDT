@ECHO OFF
REM Set variables
SET SOURCE=%~dp0
SET SOURCE=%SOURCE:~0,-1%
IF NOT DEFINED LOGDIR SET LOGDIR=%SystemRoot%\TEMP

REM Resources
REM https://wiki.documentfoundation.org/Deployment_and_Migration

START /WAIT msiexec /i LibreOffice_4.2.3_Win_x86.msi /qb /l* %LOGDIR%\libreoffice_install_log.txt ^
SELECT_WORD=1 SELECT_EXCEL=1 SELECT_POWERPOINT=1 REGISTER_ALL_MSO_TYPES=1 RebootYesNo=No ADDLOCAL=ALL ^
IS1078=0 IS1025=0 IS1101=0 IS1610=0 IS1059=0 ^
IS1026=0 IS2117=0 IS2121=0 IS1150=0 IS1603=0 IS5146=0 IS1027=0 IS32771=0 IS1029=0 IS1106=0 IS1030=0 IS1031=0 ^
IS1604=0 IS2129=0 IS1032=0 IS2057=0 IS7177=0 IS1553=0 IS1034=0 IS1061=0 IS1069=0 IS1065=0 IS1035=0 IS1036=0 ^
IS2108=0 IS1084=0 IS1110=0 IS1095=0 IS1037=0 IS1081=0 IS1050=0 IS1038=0 IS1057=0 IS1039=0 IS1040=0 IS1041=0 ^
IS1079=0 IS1087=0 IS1107=0 IS1099=0 IS1042=0 IS1111=0 IS1120=0 IS1574=0 IS1134=0 IS1108=0 IS1063=0 IS1062=0 ^
IS1605=0 IS1071=0 IS1100=0 IS1104=0 IS1112=0 IS1102=0 IS1109=0 IS1044=0 IS1121=0 IS1043=0 IS2068=0 IS1580=0 ^
IS1132=0 IS1154=0 IS2162=0 IS1096=0 IS1094=0 IS1045=0 IS2070=0 IS1046=0 IS1048=0 IS1049=0 IS1569=0 IS1103=0 ^
IS1606=0 IS1113=0 IS2074=0 IS2133=0 IS1051=0 IS1060=0 IS1052=0 IS3098=0 IS1579=0 IS1072=0 IS1053=0 IS1089=0 ^
IS1097=0 IS1098=0 IS1064=0 IS1054=0 IS1074=0 IS1055=0 IS1073=0 IS1092=0 IS1152=0 IS1058=0 IS1091=0 IS1075=0 ^
IS1066=0 IS1076=0 IS2052=0 IS1028=0 IS1077=0 IS1050=0 IS1033=1 ^
REMOVE=gm_Reportbuilder,gm_o_Activexcontrol,gm_o_Extensions,gm_o_Onlineupdate,gm_o_Pyuno_LibreLogo,^
gm_o_Quickstart,gm_o_Winexplorerext,gm_o_Winexplorerext_x64,gm_r_ex_Dictionary_Af,gm_r_ex_Dictionary_An,^
gm_r_ex_Dictionary_Ar,gm_r_ex_Dictionary_Be,gm_r_ex_Dictionary_Bg,gm_r_ex_Dictionary_Bn,gm_r_ex_Dictionary_Br,^
gm_r_ex_Dictionary_Bs,gm_r_ex_Dictionary_Ca,gm_r_ex_Dictionary_Cs,gm_r_ex_Dictionary_Da,gm_r_ex_Dictionary_De,^
gm_r_ex_Dictionary_El,gm_r_ex_Dictionary_Es,gm_r_ex_Dictionary_Et,gm_r_ex_Dictionary_Fr,gm_r_ex_Dictionary_Gd,^
gm_r_ex_Dictionary_Gl,gm_r_ex_Dictionary_Gu,gm_r_ex_Dictionary_He,gm_r_ex_Dictionary_Hi,gm_r_ex_Dictionary_Hr,^
gm_r_ex_Dictionary_Hu,gm_r_ex_Dictionary_Is,gm_r_ex_Dictionary_It,gm_r_ex_Dictionary_Lo,gm_r_ex_Dictionary_Lt,^
gm_r_ex_Dictionary_Lv,gm_r_ex_Dictionary_Ne,gm_r_ex_Dictionary_Nl,gm_r_ex_Dictionary_No,gm_r_ex_Dictionary_Oc,^
gm_r_ex_Dictionary_Pl,gm_r_ex_Dictionary_Pt_Br,gm_r_ex_Dictionary_Pt_Pt,gm_r_ex_Dictionary_Ro,gm_r_ex_Dictionary_Ru,^
gm_r_ex_Dictionary_Si,gm_r_ex_Dictionary_Sk,gm_r_ex_Dictionary_Sl,gm_r_ex_Dictionary_Sr,gm_r_ex_Dictionary_Sv,^
gm_r_ex_Dictionary_Te,gm_r_ex_Dictionary_Th,gm_r_ex_Dictionary_Uk,gm_r_ex_Dictionary_Vi,gm_r_ex_Dictionary_Zu

IF EXIST "%Public%\Desktop\LibreOffice 4.2.lnk" DEL /Q "%Public%\Desktop\LibreOffice 4.2.lnk"


GOTO :EOF
gm_o_Extensions_MEDIAWIKI
gm_o_Extensions_NLPSolver
gm_o_Extensions_Script_Provider_For_BS
gm_o_Extensions_Script_Provider_For_JS
