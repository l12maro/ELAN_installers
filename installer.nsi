; MyInstaller.nsi 
; 
; This script installs the SileroVAD-ELAN extension and uninstaller. 
; It will install into a directory that the user selects. 
 

;-------------------------------- 
 
!verbose push
!verbose 4
!verbose pop
!include "Locate.nsh"
!include "Sections.nsh"
!include "FileFunc.nsh"
!include "LogicLib.nsh"
!include "WordFunc.nsh"
!include "TextFunc.nsh"
!include "ReplaceInFile.nsh"

!addplugindir "C:\Program Files (x86)\NSIS\Plugins\"

SetDatablockOptimize on

SetCompressor /SOLID lzma
 
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

    Var /GLOBAL ELAN_PATH
    Var /GLOBAL ELAN_VERSION
    Var /GLOBAL NEWEST_VERSION

    ; Initialize the installation path variables
    StrCpy $ELAN_PATH "" 
    StrCpy $ELAN_VERSION ""
    StrCpy $NEWEST_VERSION "0.1"
    

    ; Search for ELAN_ folder in Program Files for systemwide installation
    ${Locate::Open} "C:\" '/F=0 /D=1 /-SD=NAME /M=ELAN_* /B=1' $0
	StrCmp $0 0 0 loop
	MessageBox MB_OK "Error" IDOK close
    
loop:
	${locate::Find} $0 $1 $2 $3 $4 $5 $6
		
	; Validate and edit installation path
	StrCpy $ELAN_PATH $1 	 
	StrCpy $ELAN_VERSION $3
	Call ValidateELAN
	
	StrCmp $1 '' close loop ; No more results
	
close:
	${locate::Close} $0
	${locate::Unload}

FunctionEnd

;----------------------------------

Function ValidateELAN

; Extract version function
StrCpy $R0 $ELAN_VERSION
StrCpy $R1 0
loop:
    IntOp $R1 $R1 - 1 ; Character offset, from end of string
    StrCpy $R2 $R0 1 $R1 ; Read 1 character into $R2, -$R1 offset from end
    StrCmp $R2 '_' found
    StrCmp $R2 '' stop loop ; No more characters or try again
found:
    IntOp $R1 $R1 + 1 ; Don't include _ in extracted string
stop:
StrCpy $R2 $R0 "" $R1 ; We know the length, extract final string part



; Check that resulting string is a valid version function

${StrFilter} $R2 "13" "." "" $R3

${If} $R2 == $R3
	; Compare version function with previous if exists
	${VersionCompare} $R2 $NEWEST_VERSION $R4
	; If version is newer, edit path and version number
	${AndIf} $R4 == "1"
		StrCpy $NEWEST_VERSION $R2
		StrCpy "$INSTDIR" "$ELAN_PATH\app\extensions"

${EndIf}

; Close function
pop $R0
pop $R1
pop $R2
pop $R3
pop $R4

FunctionEnd

;---------------------------------


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
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\SileroVAD-Elan\sileroVAD-elan.sh" 
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\SileroVAD-Elan\README.md"
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\SileroVAD-Elan\dist\sileroVAD-elan.exe"  

  ; change text in cmdi

  StrCpy $OLD_STR 'sileroVAD-elan.exe'
  StrCpy $FST_OCC 1
  StrCpy $NR_OCC 1
  StrCpy $REPLACEMENT_STR '$SILDIR\sileroVAD-elan.exe'
  StrCpy $FILE_TO_MODIFIED '$SILDIR\sileroVAD-elan.cmdi'
 
!insertmacro ReplaceInFile $OLD_STR $FST_OCC $NR_OCC $REPLACEMENT_STR $FILE_TO_MODIFIED ;job done

  StrCpy $OLD_STR 'sileroVAD-elan.sh'
  StrCpy $FST_OCC all
  StrCpy $NR_OCC all
  StrCpy $REPLACEMENT_STR '$SILDIR\sileroVAD-elan.sh'
  StrCpy $FILE_TO_MODIFIED '$SILDIR\sileroVAD-elan.cmdi'
 
!insertmacro ReplaceInFile $OLD_STR $FST_OCC $NR_OCC $REPLACEMENT_STR $FILE_TO_MODIFIED ;job done
   
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
  Delete "$SILDIR\sileroVAD-elan.sh" 
  Delete "$SILDIR\README.md"
  Delete "$SILDIR\uninstall_SileroVAD-elan.exe" 
  
  ; Remove the directory
  RMDir "$SILDIR"
 
SectionEnd 

;----------------------------------

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
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\voxseg-elan\voxseg-elan.sh" 
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\voxseg-elan\README.md"
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\voxseg-elan\dist\voxseg-elan.exe"
  File "C:\Users\Lorena\Desktop\No_copia\RA\ELAN_6.4\app\extensions\voxseg-elan\ffmpeg.exe"  

  ; change text in cmdi

  StrCpy $OLD_STR 'voxseg-elan.exe'
  StrCpy $FST_OCC 1
  StrCpy $NR_OCC 1
  StrCpy $REPLACEMENT_STR '$VOXDIR\voxseg-elan.exe'
  StrCpy $FILE_TO_MODIFIED '$VOXDIR\voxseg-elan.cmdi'
 
!insertmacro ReplaceInFile $OLD_STR $FST_OCC $NR_OCC $REPLACEMENT_STR $FILE_TO_MODIFIED ;job done

  StrCpy $OLD_STR 'voxseg-elan.sh'
  StrCpy $FST_OCC all
  StrCpy $NR_OCC all
  StrCpy $REPLACEMENT_STR '$VOXDIR\voxseg-elan.sh'
  StrCpy $FILE_TO_MODIFIED '$VOXDIR\voxseg-elan.cmdi'
 
!insertmacro ReplaceInFile $OLD_STR $FST_OCC $NR_OCC $REPLACEMENT_STR $FILE_TO_MODIFIED ;job done

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
  Delete "$VOXDIR\voxseg-elan.sh"
  Delete "$VOXDIR\README.md"
  Delete "$VOXDIR\ffmpeg.exe"
  Delete "$VOXDIR\uninstall_voxseg-elan.exe" 
  
  ; Remove the directory
  RMDir "$VOXDIR"
 
SectionEnd 

;-------------------------------