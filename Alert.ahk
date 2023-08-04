;#Persistent
#SingleInstance

; Call  the initial function to create the list of files that are expected
;CheckInitialFileModification()
URL := 
SetTimer, CheckFileModification, 1000  ; Run the CheckFileModification function every 1 second

; Set the target directory
global targetDirectory := "C:\Games\Life is Feudal MMO\default\game\game\eu\art\Textures\Heraldry\Cache"

;working directory
global workingDirectory := "C:\Users\Living Room\Desktop\LiF Parser\LiF"
;UrlDownloadToFile := "https://drive.google.com/file/d/1pCZOW9fQVF_oH2JOCJn8sGAttGoqAHdU/view?usp=sharing", "C:\Users\Josh-2019\source\repos\LiF\whitelist1.zip"

; Primary loop that will check for new files
CheckFileModification:
; Get a list of files in the directory
Loop, Files, %targetDirectory%\*.*
{
    filePath := A_LoopFileLongPath
    fileName := StrReplace(A_LoopFileName, ".", "")
    loopWhitelist(fileName)
}

loopWhitelist(newFileName){
    Loop, Files, %workingDirectory%\whitelist\*.*
        {
        whitePath := A_LoopFileLongPath
        whiteName := StrReplace(A_LoopFileName, ".", "")
        check := checkWhitelist(whiteName,newFileName)
        MsgBox % check whiteName newFileName
        if (check = 1){
            Continue
            }
        else {
            triggerAlert()
            }
}
}
checkWhitelist(f1,f2) {
    file1 := workingDirectory . "\whitelist\" . f1
    fixedFile1 := SubStr(file1, 1, -3) . "." . SubStr(file1, -2)
    file2 := targetDirectory . "\" . f2 
    fixedFile2 := SubStr(file2, 1, -3) . "." . SubStr(file2, -2)
    content1 := ""
    content2 := ""
    
    match := FilesMatchPowershell(fixedFile1,fixedFile2)
    MsgBox % match f1 f2
    return match
    }

triggerAlert(){
    WinGetTitle, lifWindowTitle
    SoundBeep
    SoundPlay "C:\Users\Josh-2019\source\repos\LiF\tindeck_1.wav"
    
    Gui, Destroy
    Gui, PvPAlert:New, +AlwaysOnTop -Caption Border
    Gui, Font, bold s12 c00FF00 q5
    Gui, Color, FF0000
    Gui, Add, Text,,PvPAlert, A new Guild is detected within 500 BEWARE.
    Gui, Show, y100
    WinActivate, MMO
    Sleep, 10000
    Gui, Destroy
    }


    FilesMatchContents(vPath1, vPath2)
{
	FileGetSize, vSize1, % vPath1
	FileGetSize, vSize2, % vPath2
	if !(vSize1 = vSize2)
		return 0
	if (vSize1 = 0) && (vSize2 = 0)
		return 1
	oFile := FileOpen(vPath1, "r")
	oFile.Pos := 0
	oFile.RawRead(vData1, oFile.Length)
	oFile.Close()
	oFile := FileOpen(vPath2, "r")
	oFile.Pos := 0
	oFile.RawRead(vData2, oFile.Length)
	oFile.Close()
	return !DllCall("msvcrt\memcmp", Ptr,&vData1, Ptr,&vData2, UPtr,vSize1, "Cdecl Int")
}

  FilesMatchHashContents(vPath1, vPath2)
  {
  ;hash1 := File(vPath1).Hash( "MD5")
  ;hash2 := File(vPath2).Hash( "MD5")
  if (hash1 = hash2)
    {
  MsgBox, The files are identical.
    }
  else
    {
    MsgBox, The files are different.
    }
  }

  FilesMatchPowershell(file1,file2)
  {
    file1 := " """ file1 """"
    file2 := " """ file2 """"
    
    command := "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File ""C:\Users\Living Room\Desktop\Lif Parser\lif\compare.ps1"" "   file1  file2 
    
    resultsvar := RunCMD(command)
    ;Fileread, resultsvar, results.log
    ;Filedelete, results.log
    
    return resultsvar
    ;match := RunWait(powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\Living Room\Desktop\Lif Parser\lif\compare.ps1" -ArgumentList "%file1%", "%file2%",Hide)
    ;MsgBox, %match%`r`n`r`n%CMDout%
    ;command := "powershell.exe -nologo -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File 'C:\Users\Living Room\Desktop\Lif Parser\lif\compare.ps1' -ArgumentList '%file1%', '%file2',Hide"
    ;shell := ComObjCreate("powershell.exe")
    ; Execute a single command via cmd.exe
    ;exec := shell.Exec(ComSpec " /C " command)
    ; Read and return the command's output
    ;return exec.StdOut.ReadAll()
    ;command := "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File \"C:\Users\Living Room\Desktop\Lif Parser\lif\compare.ps1\" -ArgumentList \"%file1%\", \"%file2%\",Hide"
    ;return RunWait, powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\Living Room\Desktop\Lif Parser\lif\compare.ps1" -ArgumentList "%file1%", "%file2%",Hide
  }

  RunCMD(CmdLine, WorkingDir:="", Codepage:="CP0", Fn:="RunCMD_Output", Slow:=1) { ; RunCMD v0.97
    Local         ; RunCMD v0.97 by SKAN on D34E/D67E @ autohotkey.com/boards/viewtopic.php?t=74647
    Global A_Args ; Based on StdOutToVar.ahk by Sean @ autohotkey.com/board/topic/15455-stdouttovar
    
      Slow := !! Slow
    , Fn := IsFunc(Fn) ? Func(Fn) : 0
    , DllCall("CreatePipe", "PtrP",hPipeR:=0, "PtrP",hPipeW:=0, "Ptr",0, "Int",0)
    , DllCall("SetHandleInformation", "Ptr",hPipeW, "Int",1, "Int",1)
    , DllCall("SetNamedPipeHandleState","Ptr",hPipeR, "UIntP",PIPE_NOWAIT:=1, "Ptr",0, "Ptr",0)
    
    , P8 := (A_PtrSize=8)
    , VarSetCapacity(SI, P8 ? 104 : 68, 0)                          ; STARTUPINFO structure
    , NumPut(P8 ? 104 : 68, SI)                                     ; size of STARTUPINFO
    , NumPut(STARTF_USESTDHANDLES:=0x100, SI, P8 ? 60 : 44,"UInt")  ; dwFlags
    , NumPut(hPipeW, SI, P8 ? 88 : 60)                              ; hStdOutput
    , NumPut(hPipeW, SI, P8 ? 96 : 64)                              ; hStdError
    , VarSetCapacity(PI, P8 ? 24 : 16)                              ; PROCESS_INFORMATION structure
    
      If not DllCall("CreateProcess", "Ptr",0, "Str",CmdLine, "Ptr",0, "Int",0, "Int",True
                    ,"Int",0x08000000 | DllCall("GetPriorityClass", "Ptr",-1, "UInt"), "Int",0
                    ,"Ptr",WorkingDir ? &WorkingDir : 0, "Ptr",&SI, "Ptr",&PI)
         Return Format("{1:}", "", ErrorLevel := -1
                       ,DllCall("CloseHandle", "Ptr",hPipeW), DllCall("CloseHandle", "Ptr",hPipeR))
    
      DllCall("CloseHandle", "Ptr",hPipeW)
    , A_Args.RunCMD := { "PID": NumGet(PI, P8? 16 : 8, "UInt") }
    , File := FileOpen(hPipeR, "h", Codepage)
    
    , LineNum := 1,  sOutput := ""
      While  ( A_Args.RunCMD.PID | DllCall("Sleep", "Int",Slow) )
        and  DllCall("PeekNamedPipe", "Ptr",hPipeR, "Ptr",0, "Int",0, "Ptr",0, "Ptr",0, "Ptr",0)
             While A_Args.RunCMD.PID and StrLen(Line := File.ReadLine())
                   sOutput .= Fn ? Fn.Call(Line, LineNum++) : Line
    
      A_Args.RunCMD.PID := 0
    , hProcess := NumGet(PI, 0)
    , hThread  := NumGet(PI, A_PtrSize)
    
    , DllCall("GetExitCodeProcess", "Ptr",hProcess, "PtrP",ExitCode:=0)
    , DllCall("CloseHandle", "Ptr",hProcess)
    , DllCall("CloseHandle", "Ptr",hThread)
    , DllCall("CloseHandle", "Ptr",hPipeR)
    , ErrorLevel := ExitCode
    
    Return sOutput
    }