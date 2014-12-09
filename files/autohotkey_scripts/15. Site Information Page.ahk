#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ====================================
; Wait for the Site Information screen
; ====================================
WinWait, IC Setup Assistant, Enter the name of your company, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; =======================
; Organization & Location
; =======================
SendRaw %OrganizationName%
Sleep 50
Send {tab}
SendRaw %LocationName%
Sleep 50
Send {tab}

; =====
; Next!
; =====
Send {tab}{space}
