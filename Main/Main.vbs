'Get name of this script and replace extension with .PS1
strN0 = Replace(Ucase(WScript.ScriptFullName), ".VBS", ".PS1")
'Read Arguments
Set objArgs = Wscript.Arguments
For Each strArg in objArgs
	If Instr(1, strArg, " ", vbTextCompare)>0 then 'if contains a space
		StrAllArg=StrAllArg&" """&strArg&""""	'Enclose with double quotes
	Else
		StrAllArg=StrAllArg&" "&strArg
	End If
	
Next

StrCommand = "powershell.exe -nologo -command """&strN0&""" "&StrAllArg
set WSshell = CreateObject("WScript.Shell")

'MsgBox(StrCommand)

'Launch Powershell hidden
WSshell.Run StrCommand,0	'0=run Hidden
'WSshell.Run StrCommand
