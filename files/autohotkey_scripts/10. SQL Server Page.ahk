#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ==========================================
; Wait for the SQL server credentials screen
; ==========================================
WinWait, IC Setup Assistant, Enter an account, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ===============================
; SQL server name and credentials
; ===============================
Send %A_ComputerName%{down}{tab}{tab}sa{tab}D0gf00d{tab}{tab}{tab}{space}

; ==========================================
; Wait for the credentials test confirmation
; ==========================================
SetTitleMatchMode, Slow
WinWait, IC Setup Assistant, The administrator and password information is correct, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 
SetTitleMatchMode, Fast

; =====
; Next!
; =====
Send {tab}{tab}{tab}{space}
