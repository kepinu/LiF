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
        MsgBox % check "josh"
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
  return RunWait, powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\Josh-2019\source\repos\LiF\compare.ps1" -ArgumentList "%file1%", "%file2%",Hide
  }