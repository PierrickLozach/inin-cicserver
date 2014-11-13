#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ==========================
; Wait for the Domain screen
; ==========================
WinWait, IC Setup Assistant, IC server to the domain, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; =========
; No domain
; =========
Send {Down}

; =====
; Next!
; =====
Send {tab}{tab}{space}
