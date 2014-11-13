#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ===============================
; Wait for the Certificate screen
; ===============================
WinWait, IC Setup Assistant, Select one of the following certificate management, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; =================================================
; Click on the first radio option (first IC server)
; =================================================
Control, Check,, Button1

; ======
; Next !
; ======
Send {tab}{tab}{space}
