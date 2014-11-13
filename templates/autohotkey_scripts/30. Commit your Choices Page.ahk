#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ========================
; Wait for the Commit page
; ========================
WinWait, IC Setup Assistant, Click the Commit button below to have IC Setup Assistant, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; =======
; Commit!
; =======
Send {tab}{tab}{tab}{space}
