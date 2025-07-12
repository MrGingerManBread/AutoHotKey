SetTitleMatchMode, 3 ; match exact window titles

; find SAVIHost folder to set working directory
SAVIHostDIR:
if !RegExMatch(A_ScriptDir, "\\SAVIHost$")
{
	FileSelectFolder, newPath,, 0, Couldn't find SAVIHost folder! Please find and select it:
	if !newPath ; if selection error or dialog canceled
	{
		MsgBox, 4, SAVIHost folder selection failure, Error selecting SAVIHost folder. Would you like to try again?`n`n(NO=exit)
		IfMsgBox, Yes
			Goto, SAVIHostDIR
		ExitApp
	}
	SetWorkingDir, %newPath%
}
else
	SetWorkingDir, %A_ScriptDir%


; check if savihost exes are in working directory
if !(FileExist(A_WorkingDir "\savihost2.exe") || (A_WorkingDir "\savihost3.exe"))
{
	MsgBox ERROR! SAVIHost exe files missing from Loader directory.`n`nPlease move them back and try running me again.`n`n(I'm looking for "savihost2.exe" and "savihost3.exe")
	ExitApp
}


; select VST
VSTselect:
FileSelectFile, fullpathVST,, C:\Program Files\vstplugins, Select a VST to load into SAVIHost VST Loader:, VSTs (*.dll; *.vst3)
if !fullpathVST ; if selection error or dialog canceled
{
	MsgBox, 4, VST selection failure, Error selecting VST file. Would you like to try again?`n`n(NO=exit)
	IfMsgBox, Yes
		Goto, VSTselect
	ExitApp
}

; get VST file information
SplitPath, fullpathVST,,, VSText, VST

; prep for VST2 useage
if (VSText = "dll") ; if VST extension = .dll
	VER:=2
else
	VER:=3

; run program using the version correlated to selected VST type
PROG:= A_WorkingDir "\savihost" VER ".exe"
Run, %PROG%

; auto-insert VST path into dialog of main program
WinWait, Open ahk_class #32770 ahk_exe %PROG%
ControlSetText, Edit1, %fullpathVST%, Open ahk_class #32770 ahk_exe %PROG%
SetControlDelay, -1
ControlClick, Button1, Open ahk_class #32770 ahk_exe %PROG%,,,, NA