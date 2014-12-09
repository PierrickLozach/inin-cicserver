#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; =============================
; Wait for the SIP lines screen
; =============================
WinWait, IC Setup Assistant, Line Name Prefix, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ====================
; Set the phone number
; ====================
Send {tab}
SendRaw %OutboundAddress%
Sleep 50

; =====
; Next!
; =====
Send {tab}{tab}{tab}{tab}{tab}{space}
