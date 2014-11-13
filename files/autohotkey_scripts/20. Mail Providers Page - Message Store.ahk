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
; Check Interaction Message Store
; ===============================
Send {tab}{space}

; =====
; Next!
; =====
Send {tab}{tab}{tab}{tab}{tab}{tab}{space}

; ================================================
; Wait for the mail review screen to become active
; ================================================
WinWait, IC Setup Assistant, Review the results of your mail provider configuration, 300
WinWaitActive, IC Setup Assistant, 

; =====
; Next!
; =====
Send {tab}{tab}{tab}{tab}{tab}{tab}{tab}{tab}{tab}{space}
