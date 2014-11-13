#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ==================================
; Wait for the Mail providers screen
; ==================================
WinWait, IC Setup Assistant, I want to configure mail providers, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ===============================
; Uncheck Mail Providers checkbox
; ===============================
Send {space}

; =====
; Next!
; =====
Send {tab}{tab}{space}
