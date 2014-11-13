#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Run "C:\Users\Administrator\Desktop\GetHostIDU\GetHostIDU.exe"
WinWait, Host Identifier(s), 
IfWinNotActive, Host Identifier(s), , WinActivate, Host Identifier(s), 
WinWaitActive, Host Identifier(s), 

Send {UP}{SHIFTDOWN}{CTRL DOWN}{RIGHT}{SHIFT UP}{CTRL UP}^c{TAB}{TAB}{TAB}{SPACE}
