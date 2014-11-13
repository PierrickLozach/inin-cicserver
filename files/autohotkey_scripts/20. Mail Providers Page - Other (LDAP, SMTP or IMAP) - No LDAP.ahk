#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ==================================
; Wait for the Mail providers screen
; ==================================
WinWait, IC Setup Assistant, I want to configure mail providers, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ================================
; Check Other (LDAP, SMTP or IMAP)
; ================================
Send {tab}{tab}{tab}{tab}{tab}{space}

; =====
; Next!
; =====
Send {tab}{tab}{space}

; =================================
; Wait for the LDAP Provider screen
; =================================
WinWaitActive, IC Setup Assistant, 

; ==============
; No LDAP. Next!
; ==============
Send {tab}{tab}{tab}{tab}{tab}{tab}{tab}{space}

; =================================
; Wait for the SMTP Provider screen
; =================================
WinWait, IC Setup Assistant, Default Sender, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ==========
; Add Sender
; ==========
Sleep 1000 ; Wait for the controls a bit
SendInput administrator@demo.com
Sleep 100

; ============
; Click on Add
; ============
Send {tab}{tab}{tab}{space}

; ==================================
; Wait for the SMTP Transport screen
; ==================================
WinWait, SMTP Transport, Transport Name, 300
IfWinNotActive, SMTP Transport, , WinActivate, SMTP Transport, 
WinWaitActive, SMTP Transport, 

; =========================
; Add Transport information
; =========================
; Transport Name
Sleep 1000 ; Wait for the controls a bit
SendInput hMail
Sleep 100
Send {tab}

; Server
SendInput localhost
Sleep 100
Send {tab}

; Port: Leave it at 25
Send {tab}

; Domain
SendInput demo.com
Send {tab}

; Requires authentication
Send {space} ; Enable authentication
Send {tab}

; Username
SendInput administrator@demo.com
Sleep 100
Send {tab}

; Password
SendInput D0gf00d
Sleep 100
Send {tab}

; Confirm Password
SendInput D0gf00d
Sleep 100
Send {tab}

; Click on OK
Send {space}

; =====
; Next!
; =====
Send {tab}{tab}{tab}{tab}{space}

; =================================
; Wait for the IMAP Provider screen
; =================================
WinWait, IC Setup Assistant, Add one or more IMAP Servers, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; ============
; Click on Add
; ============
Send {tab}{tab}{space}

; ===============================
; Wait for the IMAP Server dialog
; ===============================
WinWait, IMAP Server, Supports proxy authorization, 300
IfWinNotActive, IMAP Server, , WinActivate, IMAP Server, 
WinWaitActive, IMAP Server, 

; Name
Sleep 1000 ; Wait for the UI controls to show up
SendInput hMail
Sleep 100
Send {tab}

; Server
SendInput localhost
Sleep 100
Send {tab}

; Port: Leave it at 143
Send {tab}

; Proxy Authorization: No
Send {tab}

; OK
Send {space}

; ===========================================
; Wait for the IMAP Provider screen to return
; ===========================================
WinWait, IC Setup Assistant, Add one or more IMAP Servers to use, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; =====
; Next!
; =====
Send {tab}{tab}{tab}{tab}{space}

; ================================================
; Wait for the mail review screen to become active
; ================================================
WinWait, IC Setup Assistant, Review the results of your mail provider configuration, 300
WinWaitActive, IC Setup Assistant, 

; =====
; Next!
; =====
Send {tab}{tab}{tab}{tab}{tab}{tab}{tab}{tab}{tab}{space}

; =================================================================
; Wait for the Log Retrieval Assistant Mailbox Configuration screen
; =================================================================
WinWait, IC Setup Assistant, Configure Log Retrieval Assistant, 300
IfWinNotActive, IC Setup Assistant, , WinActivate, IC Setup Assistant, 
WinWaitActive, IC Setup Assistant, 

; =====
; Next!
; =====
Send {tab}{tab}{space}
