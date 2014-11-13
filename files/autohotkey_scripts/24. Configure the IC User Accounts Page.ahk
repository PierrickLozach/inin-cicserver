#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; =====================
; Wait for Users screen
; =====================
WinWait, IC Setup Assistant, Click on Add Users Assistant, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; =======================================
; Click on the Add Users Assistant button
; =======================================
Send {tab}{space}

; =========================================
; Wait for the Add Users Assistant to start
; =========================================
WinWait, Add Users Assistant, Welcome to the Add Users Assistant, 300
IfWinNotActive, Add Users Assistant, , WinActivate, Add Users Assistant, 
WinWaitActive, Add Users Assistant, 

; ============================================
; Use the "Search for new users" option. Next!
; ============================================
Send {tab}{space}

; ==================================
; Wait for the Search options screen
; ==================================
WinWait, Add Users Assistant, How do you want to search for users, 300
IfWinNotActive, Add Users Assistant, , WinActivate, Add Users Assistant, 
WinWaitActive, Add Users Assistant, 

; ====================================================
; Select option to "Import users from a CSV user list"
; ====================================================
Send {down}{down}

; =====
; Next!
; =====
Send {tab}{tab}{space}

; ===================================
; Wait for the CSV file select screen
; ===================================
WinWait, Add Users Assistant, Browse for a predefined list of users, 300
IfWinNotActive, Add Users Assistant, , WinActivate, Add Users Assistant, 
WinWaitActive, Add Users Assistant, 

; ==========================
; Click on the Browse button
; ==========================
Send {tab}{tab}{space}

; =====================================
; Wait for the import users open screen
; =====================================
WinWait, Import Users, FolderView, 300
IfWinNotActive, Import Users, , WinActivate, Import Users, 
WinWaitActive, Import Users, 

; ======================
; Specify users csv file
; ======================
; Using the clipboard because not all characters were sent otherwise
; See http://www.autohotkey.com/board/topic/20354-missing-send-characters/
Sleep 1000 ;If no sleep here, then the text is not sent correctly
SendInput %A_Desktop%\users.csv
Sleep 100
Send {ENTER}

; =========================================
; Wait for the verification of the CSV file
; =========================================
WinWait, Add Users Assistant, The CSV file is OK, 300
IfWinNotActive, Add Users Assistant, , WinActivate, Add Users Assistant, 
WinWaitActive, Add Users Assistant,
Sleep, 3000

; =====
; Next!
; =====
SetControlDelay -1
ControlClick, Button11
SetControlDelay 20

; ==============================
; Wait for the Extensions screen
; ==============================
WinWait, Add Users Assistant, Do you want to automatically create user extensions, 300
IfWinNotActive, Add Users Assistant, , WinActivate, Add Users Assistant, 
WinWaitActive, Add Users Assistant,

; =======================================
; Skip automatic assignment of extensions
; =======================================
Send {up}

; =====
; Next!
; =====
Send {tab}{tab}{space}

; =============================
; Wait for the Passwords screen
; =============================
WinWait, Add Users Assistant, Do you want to automatically assign user passwords, 300
IfWinNotActive, Add Users Assistant, , WinActivate, Add Users Assistant, 
WinWaitActive, Add Users Assistant,

; ===========================
; Keep the skip option. Next!
; ===========================
Send {tab}{tab}{space}

; ===========================
; Wait for the Preview screen
; ===========================
WinWait, Add Users Assistant, Number found, 300
IfWinNotActive, Add Users Assistant, , WinActivate, Add Users Assistant, 
WinWaitActive, Add Users Assistant,

; =====
; Next!
; =====
Send {tab}{tab}{space}

; ==============================
; Wait for the Completing screen
; ==============================
WinWait, Add Users Assistant, You have successfully completed the Add Users Assistant, 300
IfWinNotActive, Add Users Assistant, , WinActivate, Add Users Assistant, 
WinWaitActive, Add Users Assistant,

; ===============
; Click on Finish
; ===============
Send {space}

; ================================
; Wait for the User Worksheet list
; ================================
WinWait, User Worksheet, , 300
IfWinNotActive, User Worksheet, , WinActivate, User Worksheet, 
WinWaitActive, User Worksheet,

; ===================
; File/Save and Close
; ===================
WinMenuSelectItem, User Worksheet, , File, Save and Close
Sleep 3000 ; Wait for users to be added

; =======================
; Wait for the users page
; =======================
WinWaitActive, IC Setup Assistant, 

; =====
; Next!
; =====
Send {tab}{tab}{space}
