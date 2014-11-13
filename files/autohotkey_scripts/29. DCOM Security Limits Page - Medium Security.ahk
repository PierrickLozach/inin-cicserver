#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ===============================
; Wait for the DCOM Security page
; ===============================
WinWait, IC Setup Assistant, Allow Everyone, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ================================================
; Leave "Allow Authenticated Users" checked. Next!
; ================================================
Send {tab}{tab}{space}
