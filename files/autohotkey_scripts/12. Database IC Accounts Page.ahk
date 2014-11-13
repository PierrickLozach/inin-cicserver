#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ==================================
; Wait for the DB IC Accounts screen
; ==================================
WinWait, IC Setup Assistant, Enter names and passwords, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; Set passwords
Send {tab}D0gf00d{tab}D0gf00d{tab}
Send {tab}D0gf00d{tab}D0gf00d{tab}
Send {tab}D0gf00d{tab}D0gf00d{tab}

; =====
; Next!
; =====
Send {tab}{space}
