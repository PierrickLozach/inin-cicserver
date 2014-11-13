#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ================================================
; Wait for the IC Setup Assistant dialog to appear
; ================================================
WinWait, IC Setup Assistant, 
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ==============================
; Check "Latest SU is installed"
; ==============================
Send {tab}{tab}{space}

; =====
; Next!
; =====
Send {tab}{space}
