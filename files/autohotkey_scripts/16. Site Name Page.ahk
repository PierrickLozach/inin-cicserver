#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; =============================
; Wait for the site name screen
; =============================
WinWait, IC Setup Assistant, This IC server is set up to use this site name, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ================
; Custom site name
; ================
Send {down}{tab}
Send TestSiteName{tab}

; =====
; Next!
; =====
Send {tab}{space}
