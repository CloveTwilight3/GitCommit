; GitCommit NSIS Installer Script
!define PRODUCT_NAME "GitCommit"
!define PRODUCT_VERSION "1.0.0"
!define PRODUCT_PUBLISHER "CloveTwilight3"
!define PRODUCT_WEB_SITE "https://github.com/CloveTwilight3/GitCommit"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\GitCommit.bat"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

SetCompressor lzma

; Modern UI
!include "MUI2.nsh"

; General
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "GitCommit-${PRODUCT_VERSION}-Setup.exe"
InstallDir "$PROGRAMFILES\GitCommit"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
RequestExecutionLevel admin

; Interface Settings
!define MUI_ABORTWARNING
!define MUI_ICON "icon.ico"
!define MUI_UNICON "icon.ico"

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Languages
!insertmacro MUI_LANGUAGE "English"

; Functions for PATH manipulation
!define Environ 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'

Function AddToPath
  Exch $0
  Push $1
  Push $2
  Push $3
  
  ReadRegStr $1 ${Environ} "PATH"
  ${If} $1 == ""
    WriteRegExpandStr ${Environ} "PATH" "$0"
  ${Else}
    ${StrLoc} $2 "$1" "$0;" ""
    ${If} $2 == ""
      ${StrLoc} $2 "$1" ";$0" ""
      ${If} $2 == ""
        ${StrLoc} $2 "$1" "$0" ""
        ${If} $2 == ""
          WriteRegExpandStr ${Environ} "PATH" "$1;$0"
        ${EndIf}
      ${EndIf}
    ${EndIf}
  ${EndIf}
  
  ; Notify system of environment change
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
  
  Pop $3
  Pop $2
  Pop $1
  Pop $0
FunctionEnd

Function un.RemoveFromPath
  Exch $0
  Push $1
  Push $2
  Push $3
  
  ReadRegStr $1 ${Environ} "PATH"
  ${StrStr} $2 "$1" "$0;"
  ${If} $2 != ""
    ${StrRep} $1 "$1" "$0;" ""
    Goto done
  ${EndIf}
  
  ${StrStr} $2 "$1" ";$0"
  ${If} $2 != ""
    ${StrRep} $1 "$1" ";$0" ""
    Goto done
  ${EndIf}
  
  ${StrStr} $2 "$1" "$0"
  ${If} $2 != ""
    ${StrRep} $1 "$1" "$0" ""
  ${EndIf}
  
  done:
  WriteRegExpandStr ${Environ} "PATH" "$1"
  
  ; Notify system of environment change
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
  
  Pop $3
  Pop $2
  Pop $1
  Pop $0
FunctionEnd

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "..\..\src\GitCommit.ps1"
  File "..\..\src\GitCommit.bat"

  ; Add to PATH
  Push "$INSTDIR"
  Call AddToPath

  ; Create registry entries
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\GitCommit.bat"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\GitCommit.bat"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteUninstaller "$INSTDIR\uninst.exe"
SectionEnd

Section Uninstall
  ; Remove from PATH
  Push "$INSTDIR"
  Call un.RemoveFromPath

  ; Remove files
  Delete "$INSTDIR\GitCommit.ps1"
  Delete "$INSTDIR\GitCommit.bat"
  Delete "$INSTDIR\uninst.exe"
  RMDir "$INSTDIR"

  ; Remove registry entries
  DeleteRegKey HKLM "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
SectionEnd