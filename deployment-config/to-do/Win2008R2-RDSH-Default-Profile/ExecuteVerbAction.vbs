' USAGE:	cscript.exe ExecuteVerbAction.vbs <file path> <verb name>
'		Example: Pin the outlook shortcut to the start menu
'		cscript.exe ExecuteVerbAction.vbs "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft Office Outlook 2007.lnk" PinToStartMenu
'		Example: Unpin the outlook shortcut from the start menu
'		cscript.exe ExecuteVerbAction.vbs "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows Media Player.lnk" UnpinFromStartMenu
'
' COMMENT:			This script executes defined file-verb
' CHANGELOG:		2010-04-06 - Script Created
'
' Supported VerbActions:
' 	PinToStartMenu (Pin to Start Menu)
' 	UnpinFromStartMenu (Unpin from Start Menu)
' 	PinToTaskbar (Pin to Taskbar)
' 	UnpinFromTaskbar (Unpin from Taskbar)
' PinLocations:
' 	Start Menu, Taskbar
'-------------------------------------------------------------------------------------------------------------------
Dim definedVerbActions, folderItem, filePath, verbAction, returnCode, procOwner
Const DebugEnabled = false
Dim ScriptName : ScriptName = WScript.ScriptName


If (GetProcessOwner(procOwner)) Then DebugInfo("procOwner = " & procOwner)

If Not (ValidateArguments()) Then
	DebugInfo("ValidateArguments(), return = false")
	WScript.Quit(1)
End If

filePath = WScript.Arguments.Item(0)
verbAction = WScript.Arguments.Item(1)
DebugInfo("filePath = " & filePath)
DebugInfo("verbAction = " & verbAction)

'DisplayFolderItemVerbs(filePath)

Set definedVerbActions = GetDefinedVerbActions()
Set folderItem = GetFolderItem(filePath)
If (folderItem Is Nothing) Then
	DebugInfo("GetFolderItem(" & filePath & "), return = null")
	WScript.Quit(0)
End If

returnCode = true
Select Case verbAction
	Case "PinToStartMenu"
		If Not IsPinned(filePath, "Start Menu") Then
			returnCode = ExecuteFolderItemVerbAction(folderItem, definedVerbActions.Item(verbAction))
		End If
	Case "UnpinFromStartMenu"
		If IsPinned(filePath, "Start Menu") Then
			returnCode = ExecuteFolderItemVerbAction(folderItem, definedVerbActions.Item(verbAction))
		End If
	Case "PinToTaskbar"
		If Not IsPinned(filePath, "Taskbar") Then
			returnCode = ExecuteFolderItemVerbAction(folderItem, definedVerbActions.Item(verbAction))
		End If
	Case "UnpinFromTaskbar"
		If IsPinned(filePath, "Taskbar") Then
			returnCode = ExecuteFolderItemVerbAction(folderItem, definedVerbActions.Item(verbAction))
		End If
End Select

If Not returnCode Then
	DebugInfo("ExecuteFolderItemVerbAction() return = " & returnCode)
	WScript.Quit(1)
End If
DebugInfo("ExecuteFolderItemVerbAction() return = " & returnCode)
WScript.Quit(0)


Function ValidateArguments()
	Dim validArguments, filePath, verbAction, oFso
	Dim definedVerbActions, validShortCut, validVerbAction
	
	validArguments = false
	validShortCut = false
	validVerbAction = false
	
	Set oFso = CreateObject("Scripting.FileSystemObject")
	Set definedVerbActions = GetDefinedVerbActions()
	DebugInfo("ValidateArguments::WScript.Arguments.Count = " & WScript.Arguments.Count)
	If (WScript.Arguments.Count = 2) Then
		filePath = WScript.Arguments.Item(0)
		verbAction = WScript.Arguments.Item(1)
		
		If (oFso.FileExists(filePath) And FileIsShortcut(filePath)) Then validShortCut = true
		If definedVerbActions.Exists(verbAction) Then validVerbAction = true
		
		If (validShortCut And validVerbAction) Then validArguments = true
		If (Not oFso.FileExists(filePath)) Then DebugInfo("ValidateArguments::FilePath = false")
		If (Not oFso.FileExists(filePath)) Then validArguments = true
	End If
	
	DebugInfo("ValidateArguments::validShortCut = " & validShortCut)
	DebugInfo("ValidateArguments::validVerbAction = " & validVerbAction)
	
	ValidateArguments = validArguments
	
	Set definedVerbActions = Nothing
	Set oFso = Nothing
End Function

Function GetFolderItem(ByVal filePath)
	On Error Resume Next
	Dim oFso, shell, folder, folderItem
	Dim folderPath, fileName
	
	Set oFso = CreateObject("Scripting.FileSystemObject")
	Set shell = CreateObject("Shell.Application")
	
	Set folderItem = Nothing
	
	If (oFso.FileExists(filePath)) Then
		folderPath = Mid(filePath, 1, InStrRev(filePath, "\") - 1)
		fileName = Mid(filePath, InStrRev(filePath, "\") + 1)
		
		Set folder = shell.Namespace(folderPath)
		If Not (folder Is Nothing) Then Set folderItem = folder.ParseName(fileName)
	End If
	
	Set GetFolderItem = folderItem
	
	Set shell = Nothing
	Set oFso = Nothing
End Function

Function IsPinned(ByVal filePath, ByVal pinLocation)
	Dim folderItem, itemIsPinned
	'DebugInfo("IsPinned(" & filePath & ", " & pinLocation & ")")
	itemIsPinned = false
	
	Set folderItem = GetFolderItem(filePath)
	If VerbActionExists(folderItem, "Unpin from " & pinLocation) Then itemIsPinned = true
	DebugInfo("IsPinned::itemIsPinned = " & itemIsPinned)
	IsPinned = itemIsPinned
	
	Set folderItem = Nothing
End Function

Function VerbActionExists(ByRef folderItem, ByVal verbAction)
	Dim actionExists, verb
	
	VerbActionExists = False
	
	If (folderItem Is Nothing) Then Exit Function
	
	For each verb in folderItem.Verbs() 
		If (UCase(verbAction) = UCase(GetVerbAction(verb))) Then
			VerbActionExists = True
			Exit For
		End If
	Next
End Function

Function ExecuteFolderItemVerbAction(ByRef folderItem, ByVal verbAction)
	On Error Resume Next
	Dim verb
	
	ExecuteFolderItemVerbAction = False
	
	If (folderItem Is Nothing) Then Exit Function
	
	If VerbActionExists(folderItem, verbAction) Then
		Set verb = GetVerbForVerbAction(folderItem, verbAction)
		verb.DoIt()
		If Err = 0 Then ExecuteFolderItemVerbAction = True
		DebugInfo("ExecuteFolderItemVerbAction::verb.DoIt(), return = " & Err)
		Err.Clear
		Set verb = Nothing
	End If
End Function

Function GetVerbForVerbAction(ByRef folderItem, ByVal verbAction)
	Dim returnVerb, verb
	
	Set returnVerb = Nothing
	
	For each verb in folderItem.Verbs() 
		If (UCase(verbAction) = UCase(GetVerbAction(verb))) Then
			Set returnVerb = verb
			Exit For
		End If
	Next
	
	Set GetVerbForVerbAction = returnVerb
End Function

Function GetVerbAction(ByVal verb)
	Dim verbAction
	verbAction = verb.Name
	
	If InStr(verb.Name, "&") Then verbAction = replace(verb.Name, "&", "")
	
	GetVerbAction = verbAction
End Function

Function GetDefinedVerbActions()
	Dim verbActions
	Const CompareMode_CaseInsensitive = 1	'// Text compare mode
	
	Set verbActions = CreateObject("Scripting.Dictionary")
	verbActions.CompareMode = CompareMode_CaseInsensitive
	
	verbActions.Add "PinToStartMenu", "Pin to Start Menu"
	verbActions.Add "UnpinFromStartMenu", "Unpin from Start Menu"
	verbActions.Add "PinToTaskbar", "Pin to Taskbar"
	verbActions.Add "UnpinFromTaskbar", "Unpin from Taskbar"
	
	Set GetDefinedVerbActions = verbActions
End Function

Function FileIsShortcut(ByVal filePath)
	Dim folderItem
	
	FileIsShortcut = false
	
	Set folderItem = GetFolderItem(filePath)
	If Not (folderItem Is Nothing) Then FileIsShortcut = folderItem.IsLink
	
	Set folderItem = Nothing
End Function

Sub DisplayFolderItemVerbs(ByVal filePath)
	Dim folderItem, i
	
	Set folderItem = GetFolderItem(filePath)
	'WScript.Echo "folderItemVerbs: " & folderItem.Verbs.Count
	For i = 0 To folderItem.Verbs.Count - 1
		'WScript.Echo i & " = " & folderItem.Verbs.Item(i)
	Next
End Sub

Function DebugInfo(ByVal info)
	Const LogTypeSuccess = 0
	Const LogTypeInformation = 4
	
	info = ScriptName & " -> " & info
	WScript.Echo info
	
	If DebugEnabled Then DebugInfo = LogMessage(LogTypeInformation, info)
End Function

Function LogMessage(ByVal logType, ByVal msg)
	Dim oWshShell
	Set oWshShell = CreateObject("WScript.Shell")
	
	LogMessage = oWshShell.LogEvent(logType, msg)
	
	Set oWshShell = Nothing
End Function

Function GetProcessOwner(ByRef procOwner)
	On Error Resume Next
	Dim wmiQuery, oWMIService, processes, process
	Dim processName, username, domain
	
	GetProcessOwner = false
	
	processName = Mid(WScript.FullName, InStrRev(WScript.FullName, "\") + 1)
	
	Set oWMIService = GetObject("winmgmts:" _
		& "{impersonationLevel=impersonate}!\\.\root\cimv2")
	
	wmiQuery = "SELECT * FROM Win32_Process WHERE Name = '" & processName & "'"
	Set processes = oWMIService.ExecQuery(wmiQuery)
	
	For Each process in processes
		If (InStr(process.CommandLine, WScript.ScriptName) <> 0) Then
			If (process.GetOwner(username, domain) = 0) Then
				procOwner = domain & "\" & username
				GetProcessOwner = true
			End If
			Exit For
		End If
	Next
	
	On Error GoTo 0
	
	Set processes = Nothing
	Set oWMIService = Nothing
End Function

