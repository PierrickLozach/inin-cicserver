#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ============================
; Wait for the DialPlan screen
; ============================
WinWait, IC Setup Assistant, Dial Plan File, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ==================
; Create a dial plan
; ==================
Send {tab}{tab}{tab}{space}

; =============================
; Wait for the Area Code screen
; =============================
WinWait, IC Setup Assistant, New Area Code, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; =============
; Set Area Code
; =============
Send 317{tab}{space}{tab}{tab}{tab}{tab}{tab}{space}

; ===================================
; Wait for the local exchanges screen
; ===================================
WinWait, IC Setup Assistant, Number of digits, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; =========================
; No local exchanges. Next!
; =========================
Send {tab}{tab}{tab}{tab}{tab}{tab}{tab}{space}
