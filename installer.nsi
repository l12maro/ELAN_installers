; MyInstaller.nsi 
; 
; This script installs the SileroVAD-ELAN extension and uninstaller. 
; It will install into a directory that the user selects. 
 
;-------------------------------- 
 
!include Locate.nsh
!include "Sections.nsh"
!addplugindir "C:\Program Files (x86)\NSIS\Plugins\"
 
; The name of the installer 
Name "Installer" 
 
; The file to write 
OutFile "Installer.exe" 

; The default installation directory 
InstallDir $INSTDIR
 
; Registry key to check for directory (so if you install again, it will  
; overwrite the old one automatically) 
InstallDirRegKey HKLM "Software\SileroVAD-elan" "Install_Dir" 
 
;-------------------------------- 
 
; Pages 
;
; This lists the pages that will be shown to the user when
;    they run the install/uninstall wizards
;
; Install the wizard offers the user the following:
;    a components page (select which components to install)
Insttype "/CUSTOMSTRING=Please make your choice"
Insttype "SileroVAD-ELAN"
Insttype "Voxseg-ELAN"
;    a directory page  (select the installation directory)
;    an install page (shown while the installation runs)
Page components 
Page directory 
Page instfiles 
 
; The uninstall wizard shows the user a confirmation page
;     (checking if they really want to uninstall)
;     then an install page (shown while the uninstaller runs)
UninstPage uninstConfirm 
UninstPage instfiles 
 
;-------------------------------- 
 

; Locate the default ELAN directory (newest version):
Function .onInit

    Var /GLOBAL INSTALL_PATH
    StrCpy $INSTALL_PATH "" ; Initialize the installation path variable

    Push $0
    Push $1

    ; Search for ELAN_ folder in Program Files
    FindFirst $0 $1 "$PROGRAMFILES64\ELAN*"
    StrCmp $1 "" not_found found
	
	found:
		StrCpy $INSTDIR "$PROGRAMFILES64\$1\app\extensions"
		FindClose $0
		Goto end

	not_found:
		StrCpy $INSTDIR "$PROGRAMFILES64\"
		FindClose $0

	end:
		Pop $1
		Pop $0

;  Var /GLOBAL ROOT
;  StrCpy $ROOT "C:"
;  ${Locate::Open} '$ROOT' '/F=0 /D=1 /M=ELAN_[0-9]*\.[0-9]*\\app\\extensions /G=1 /B=1' $0
;  ${Locate::Open} '$ROOT' '/F=0 /D=1 /M=\\app\\extensions /G=1 /B=1' $0
;  ${Locate::Find} $0 $1 $2 $3 $4 $5 $6
   ; Set as default installation directory
;  StrCpy "$INSTDIR" "$1"
;  ${locate::Close} "$0";


FunctionEnd


Section "SileroVAD-ELAN" SEC_SIL
 
  SectionIn 1
  
  ; Create directory within installation directory and set as default for this component
  Var /GLOBAL SILDIR
  CreateDirectory "$INSTDIR\SileroVAD-elan"
  StrCpy $SILDIR "$INSTDIR\SileroVAD-elan"
   
  ; Write the installation path into the registry 
  WriteRegStr HKLM SOFTWARE\SileroVAD-ELAN "Install_Dir" "$SILDIR" 

  ; you can specify new target subdirectories within the
  ;     user's chosen install directory
  SetOutPath "$SILDIR" 
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\SileroVAD-Elan\sileroVAD-elan.cmdi" 
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\SileroVAD-Elan\README.md"
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\SileroVAD-Elan\dist\sileroVAD-elan.exe"  
   
  ; Write the uninstall keys for Windows 
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\SileroVAD-ELAN" "DisplayName" "SileroVAD-ELAN" 
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\SileroVAD-ELAN" "UninstallString" '"$SILDIR\uninstall_SileroVAD-elan.exe"' 
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\SileroVAD-ELAN" "NoModify" 1 
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\SileroVAD-ELAN" "NoRepair" 1 
  WriteUninstaller "uninstall_SileroVAD-elan.exe" 
   
SectionEnd 
 
;-------------------------------- 
 
; Uninstaller for SileroVAD-ELAN
 
Section "un.Uninstall.SILDIR"

  SectionIn 1
   
  ; Remove registry keys 
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\SileroVAD-ELAN" 
  DeleteRegKey HKLM SOFTWARE\SileroVAD-ELAN 
 
  ; Remove the newly installed files and the uninstaller executable
  Delete "$SILDIR\sileroVAD-elan.exe" 
  Delete "$SILDIR\sileroVAD-elan.cmdi" 
  Delete "$SILDIR\README.md"
  Delete "$SILDIR\uninstall_SileroVAD-elan.exe" 
  
  ; Remove the directory
  RMDir "$SILDIR"
 
SectionEnd 

Section "Voxseg-elan" SEC_VOX
 
  SectionIn 2 
  
  ; Create directory within installation directory and set as default for this component
  Var /GLOBAL VOXDIR
  CreateDirectory "$INSTDIR\voxseg-elan"
  StrCpy $VOXDIR "$INSTDIR\voxseg-elan"
   
  ; Write the installation path into the registry 
  WriteRegStr HKLM SOFTWARE\voxseg-elan "Install_Dir" "$VOXDIR" 

  ; you can specify new target subdirectories within the
  ;     user's chosen install directory
  SetOutPath "$VOXDIR" 
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\voxseg-elan\voxseg-elan.cmdi" 
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\voxseg-elan\README.md"
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\voxseg-elan\dist\voxseg-elan.exe"
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\voxseg-elan\ffmpeg.exe"  

   
  ; Write the uninstall keys for Windows 
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\voxseg-elan" "DisplayName" "voxseg-elan" 
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\voxseg-elan" "UninstallString" '"$VOXDIR\uninstall_voxseg-elan.exe"' 
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\voxseg-elan" "NoModify" 1 
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\voxseg-elan" "NoRepair" 1 
  WriteUninstaller "uninstall_voxseg-elan.exe" 
   
SectionEnd 
 
;-------------------------------- 
 
; Uninstaller for Voxseg-elan
 
Section "un.Uninstall.VOXDIR"
  
  SectionIn 2
   
  ; Remove registry keys 
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\voxseg-elan" 
  DeleteRegKey HKLM SOFTWARE\voxseg-elan 
 
  ; Remove the newly installed files and the uninstaller executable
  Delete "$VOXDIR\voxseg-elan.exe" 
  Delete "$VOXDIR\voxseg-elan.cmdi" 
  Delete "$VOXDIR\README.md"
  Delete "$VOXDIR\ffmpeg.exe"
  Delete "$VOXDIR\uninstall_voxseg-elan.exe" 
  
  ; Remove the directory
  RMDir "$VOXDIR"
 
SectionEnd 
