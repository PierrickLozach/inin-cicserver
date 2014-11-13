#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ========================
; Wait for the Survey Page
; ========================
WinWait, IC Setup Assistant, existing IC Survey, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ===================
; Create a new Survey
; ===================
Send {tab}{tab}{tab}{space}

; ==========================================
; Wait for the "Create IC Survey File dialog
; ==========================================
WinWait, Create IC Survey File, , 30

; ===============================
; Accept default filename & Close
; ===============================
Send {tab}{tab}{enter}		

; ===================================================
; Wait for the IC Setup Assistant window to be active
; ===================================================
WinWaitActive, IC Setup Assistant, 

; =====
; Next!
; =====
Send {tab}{tab}{space}
