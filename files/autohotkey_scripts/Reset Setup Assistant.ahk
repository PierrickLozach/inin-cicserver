;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win2008
; Author:         Pierrick Lozach
;
; Script Function:
;	Cleans up any execution of the Setup Wizard
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Delete/Reset Setup Assistant keys
RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE, SOFTWARE\Interactive Intelligence\Setup Assistant, Complete, 0
RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\Interactive Intelligence\Setup Assistant, Current Manifest
RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\Interactive Intelligence\Setup Assistant, IC Administrator Account
RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\Interactive Intelligence\Setup Assistant, IC Administrator Domain Account
RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\Interactive Intelligence\Setup Assistant, ICServerVersionInstalled

;Delete Manifest file
if fileexist("c:\I3\IC\Manifest\New Survey.ICSurvey")
{
  filedelete, c:\I3\IC\Manifest\New Survey.ICSurvey
}

;Delete default IC License file
if fileexist("c:\I3\IC\CurrentLicenseAdmin.I3Lic")
{
  filedelete, c:\I3\IC\CurrentLicenseAdmin.I3Lic
}

;Delete PuppetStation
RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\Interactive Intelligence\EIC\Directory Services\Root\CustomerSite\Production\AdminConfig\StationInfo\PuppetStation
RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\Interactive Intelligence\EIC\Directory Services\Root\CustomerSite\Production\WIN-LBTLIP3TQ4I\Workstations\PuppetStation

; Delete CIC users
RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\Interactive Intelligence\EIC\Directory Services\Root\TestSiteName\Production\Users

; Stop IC
RunWait, sc stop "Interaction Center"
