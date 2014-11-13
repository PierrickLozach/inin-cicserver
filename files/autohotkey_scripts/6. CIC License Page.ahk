#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ===============================
; Wait for the CIC license screen
; ===============================
WinWait, IC Setup Assistant, License File, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ==================
; Open Browse dialog
; ==================
Send {tab}{space}

; ==========================
; Wait for the Browse dialog
; ==========================
WinWait, Update License
IfWinNotActive, Update License, , WinActivate, Update License, 
WinWaitActive, Update License, 

; ===========================
; Specify License file to use
; ===========================
Send %A_Desktop% \License.I3Lic{tab}{tab}{space}

; =====
; Next!
; =====
Send {tab}{tab}{tab}{tab}{tab}{space}
