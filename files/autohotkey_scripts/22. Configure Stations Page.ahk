#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ======================================
; Wait for the Configure Stations screen
; ======================================
WinWait, IC Setup Assistant, Configure Stations, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ============================================
; Click on the "Add Stations Assistant" button
; ============================================
Send {tab}{space}

; ==========================================
; Wait for the Add Stations Assistant dialog
; ==========================================
WinWait, Add Stations Assistant, Welcome to the Add Stations Assistant, 300
IfWinNotActive, Add Stations Assistant, , WinActivate, Add Stations Assistant, 
WinWaitActive, Add Stations Assistant,

; =====
; Next!
; =====
Send {space}

; ========================================
; Wait for the List of SIP stations screen
; ========================================
WinWait, Add Stations Assistant, Browse for a predefined list of SIP stations, 300
IfWinNotActive, Add Stations Assistant, , WinActivate, Add Stations Assistant, 
WinWaitActive, Add Stations Assistant,

; =====================================
; Select the Import SIP stations option
; =====================================
Send {tab}{tab}{space}

; =======================================
; Wait for the Import SIP Stations screen
; =======================================
WinWait, Import SIP Stations, FolderView, 300
IfWinNotActive, Import SIP Stations, , WinActivate, Import SIP Stations, 
WinWaitActive, Import SIP Stations,

; ================
; Specify CSV file
; ================
Sleep 1000 ;If no sleep here, then the text is not sent correctly
SendInput %A_Desktop%\stations.csv
Sleep 100
Send {ENTER}

; =======================================
; Wait for the CSV verification to finish
; =======================================
WinWait, Add Stations Assistant, The CSV file is OK, 300
IfWinNotActive, Add Stations Assistant, , WinActivate, Add Stations Assistant, 
WinWaitActive, Add Stations Assistant,
Sleep, 3000

; =====
; Next!
; =====
SetControlDelay -1
ControlClick, Button6
SetControlDelay 20

; ====================================
; Wait for the list of stations screen
; ====================================
WinWait, Add Stations Assistant, List1, 300
IfWinNotActive, Add Stations Assistant, , WinActivate, Add Stations Assistant, 
WinWaitActive, Add Stations Assistant,

; =====
; Next!
; =====
Send {tab}{tab}{space}

; =============================================
; Wait for the Dial Plan Classifications screen
; =============================================
WinWait, Add Stations Assistant, Select the dial plan classifications, 300
IfWinNotActive, Add Stations Assistant, , WinActivate, Add Stations Assistant, 
WinWaitActive, Add Stations Assistant,

; =======================
; Add All Classifications
; =======================
Send {tab}{tab}{tab}{space}

; =====
; Next!
; =====
Send {tab}{tab}{tab}{tab}{space}

; ===========================================
; Wait for the Saving SIP Station Data screen
; ===========================================
WinWait, Add Stations Assistant, Click the Commit Changes button, 300
IfWinNotActive, Add Stations Assistant, , WinActivate, Add Stations Assistant, 
WinWaitActive, Add Stations Assistant,

; =========================
; Click on "Commit Changes"
; =========================
Send {tab}{tab}{space}

; =============================
; Wait for the Station Licenses
; =============================
WinWait, Add Stations Assistant, ACD Access License, 300
IfWinNotActive, Add Stations Assistant, , WinActivate, Add Stations Assistant, 
WinWaitActive, Add Stations Assistant,

; =============================
; Uncheck Basic Station License
; =============================
Send {tab}{tab}{space}

; =====
; Next!
; =====
Send {tab}{tab}{tab}{space}

; ===========================================================
; Wait for the "Completing the Add Stations Assistant" screen
; ===========================================================
WinWait, Add Stations Assistant, You have successfully completed the Add Stations Assistant, 300
IfWinNotActive, Add Stations Assistant, , WinActivate, Add Stations Assistant, 
WinWaitActive, Add Stations Assistant,

; ===============
; Click on Finish
; ===============
ControlClick, Button22

; ==========================
; Wait for the Stations list
; ==========================
WinWait, IC Setup Assistant, List1, 300
WinWaitActive, IC Setup Assistant, 

; =====
; Next!
; =====
Send {tab}{tab}{space}

