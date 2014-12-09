#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ================
; Check parameters
; ================
if %0% < 5
{
  MsgBox Too few parameters
  Exit -1
}

OrganizationName      = %1%
LocationName          = %2%
SiteName              = %3%
OutboundAddress       = %4%
LoggedOnUserPassword  = %5%

; ==================
; Kill Other Scripts
; ==================
AHKPanic(1, 0, 0, 0)

;----- Common settings -----
#SingleInstance force
StringCaseSense On
AutoTrim OFF
;Process Priority,,High
SetWinDelay 0
SetKeyDelay -1
SetBatchLines -1

;----- Included scripts -----
#Include 1. Start Setup Assistant.ahk
#Include 2. Welcome Page - Check SU.ahk
#Include 3. Survey Page - Create Default Survey.ahk
#Include 4. Identity Page.ahk
#Include 5. Domain Page - No Domain.ahk
#Include 6. CIC License Page.ahk
#Include 7. Dial Plan Page - One Area Code.ahk
#Include 8. Reporting Page.ahk
#Include 9. Database Configuration Page - SQL.ahk
#Include 10. SQL Server Page.ahk
#Include 11. IC Database Name Page.ahk
#Include 12. Database IC Accounts Page.ahk
#Include 13. SQL Database Files Page.ahk
#Include 14. IC Optional Components Page - no options.ahk
#Include 15. Site Information Page.ahk
#Include 16. Site Name Page.ahk
#Include 17. Server Group Certificate and Private Key Page.ahk
#Include 18. Interaction Recorder Compressed Files Location Page.ahk
#Include 19. Speech Recognition Page - No Options.ahk
#Include 20. Mail Providers Page - No Mail.ahk
#Include 21. SIP Lines and the Default Registration Group Page.ahk
#Include 22. Configure Stations Page.ahk
#Include 23. IC User Accounts Page.ahk
#Include 24. Configure the IC User Accounts Page.ahk
#Include 25. Configure IC Workgroups Page - CompanyOperator only.ahk
#Include 26. Configure IC Role Memberships Page.ahk
#Include 27. Configure Default Normal Hours of Operation Page.ahk
#Include 28. Configure Group Call Processing Page.ahk
#Include 29. DCOM Security Limits Page - Medium Security.ahk
#Include 30. Commit your Choices Page.ahk
#Include 31. Finished - Do not reboot.ahk

;----- Functions -----
AHKPanic(Kill=0, Pause=0, Suspend=0, SelfToo=0) {
  DetectHiddenWindows, On
  WinGet, IDList ,List, ahk_class AutoHotkey
  Loop %IDList%
  {
    ID:=IDList%A_Index%
    WinGetTitle, ATitle, ahk_id %ID%
    IfNotInString, ATitle, %A_ScriptFullPath%
    {
      If Suspend
        PostMessage, 0x111, 65305,,, ahk_id %ID%  ; Suspend. 
      If Pause
        PostMessage, 0x111, 65306,,, ahk_id %ID%  ; Pause.
      If Kill
        WinClose, ahk_id %ID% ;kill
    }
  }
  If SelfToo
  {
    If Suspend
      Suspend, Toggle  ; Suspend. 
    If Pause
      Pause, Toggle, 1  ; Pause.
    If Kill
      ExitApp
  }
}