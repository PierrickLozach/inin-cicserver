#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ============================
; Wait for the Identity screen
; ============================
WinWait, IC Setup Assistant, logged on to this IC server, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ============================
; Enter Administrator password
; ============================
SendRaw %LoggedOnUserPassword%
Sleep 50
Send {tab}{tab}{space}