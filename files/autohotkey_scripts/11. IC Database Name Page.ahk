#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; =================================
; Wait for the Database name screen
; =================================
WinWait, IC Setup Assistant, Select whether to create a new IC database, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; =====
; Next!
; =====
Send {tab}{tab}{space}
