#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ============================
; Wait for the Recorder screen
; ============================
WinWait, IC Setup Assistant, Configure Interaction Recorder, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ==========================
; Click on the Browse button
; ==========================
Send {tab}{tab}{space}

; ==========================
; Wait for the Browse dialog
; ==========================
WinWait, Browse For Folder, Browse for the compressed recordings, 300
IfWinNotActive, Browse For Folder, , WinActivate, Browse For Folder, 
WinWaitActive, Browse For Folder, 

; =================================
; Set folder to D:\I3\IC\Recordings
; =================================
Send {tab}{tab}{tab}
Send D:\I3\IC\Recordings{tab}{space}

; =====
; Next!
; =====
Send {tab}{tab}{tab}{space}
