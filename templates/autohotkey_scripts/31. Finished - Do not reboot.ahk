#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ======================
; Wait for the last page
; ======================
WinWait, IC Setup Assistant, The IC Setup Assistant has configured your IC server, 1800
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; =============
; Do not reboot
; =============
ControlClick, Button3

; ==========================
; Click on the Finish button
; ==========================
Send {tab}{space}
