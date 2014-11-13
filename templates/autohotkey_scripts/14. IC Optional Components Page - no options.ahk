#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; =======================================
; Wait for the optional components screen
; =======================================
WinWait, IC Setup Assistant, Select any number of optional components, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; =================
; No options. Next!
; =================
Send {tab}{tab}{tab}{tab}{tab}{space}
