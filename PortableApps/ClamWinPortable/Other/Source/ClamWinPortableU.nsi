;Copyright 2004-2012 John T. Haller

;Website: http://PortableApps.com/ClamWinPortable

;This software is OSI Certified Open Source Software.
;OSI Certified is a certification mark of the Open Source Initiative.

;This program is free software; you can redistribute it and/or
;modify it under the terms of the GNU General Public License
;as published by the Free Software Foundation; either version 2
;of the License, or (at your option) any later version.

;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with this program; if not, write to the Free Software
;Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

!define NAME "ClamWinPortable"
!define PORTABLEAPPNAME "ClamWin Portable"
!define APPNAME "ClamWin"
!define VER "1.6.7.0"
!define WEBSITE "PortableApps.com/ClamWinPortable"
!define DEFAULTEXE "ClamWin.exe"
!define DEFAULTSCANEXE "clamscan.exe"
!define DEFAULTUPDATEEXE "freshclam.exe"
!define DEFAULTAPPDIR "clamwin\bin"
!define DEFAULTDBDIR "db"
!define DEFAULTLOGDIR "log"
!define DEFAULTQUARANTINEDIR "quarantine"
!define DEFAULTSETTINGSDIR "settings"
!define LAUNCHERLANGUAGE "English"

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "John T. Haller"
VIAddVersionKey FileDescription "${PORTABLEAPPNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${PORTABLEAPPNAME}"
VIAddVersionKey LegalTrademarks "PortableApps.com is a Trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "${NAME}.exe"
;VIAddVersionKey PrivateBuild ""
;VIAddVersionKey SpecialBuild ""

;=== Runtime Switches
CRCCheck On
WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user
XPStyle on

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On


;=== Include
!include FileFunc.nsh
!insertmacro GetParameters

; (custom)
!include CheckForPlatformSplashDisable.nsh
!include ReadINIStrWithDefault.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Icon & Stye ===
;!define MUI_ICON "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

Var PROGRAMDIRECTORY
Var DBDIRECTORY
Var LOGDIRECTORY
Var QUARANTINEDIRECTORY
Var SETTINGSDIRECTORY
Var ADDITIONALPARAMETERS
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var SCANEXECUTABLE
Var UPDATEEXECUTABLE
Var DISABLESPLASHSCREEN
Var ISDEFAULTDIRECTORY
Var MISSINGFILEORPATH
Var SECONDARYLAUNCH

Section "Main"
	;=== Check if already running
	System::Call 'kernel32::CreateMutex(i 0, i 0, t "${NAME}") i .r1 ?e'
	Pop $0
	StrCmp $0 0 INIReading
		StrCpy $SECONDARYLAUNCH "true"

	INIReading:
	;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\${NAME}.ini" "" NoINI
			;=== Read the parameters from the INI file
			${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Directory" "App\${DEFAULTAPPDIR}"
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\$0"
			${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "DBDirectory" "Data\${DEFAULTDBDIR}"
			StrCpy $DBDIRECTORY "$EXEDIR\$0"
			${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "LogDirectory" "Data\${DEFAULTLOGDIR}"
			StrCpy $LOGDIRECTORY "$EXEDIR\$0"
			${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "QuarantineDirectory" "Data\${DEFAULTQUARANTINEDIR}"
			StrCpy $QUARANTINEDIRECTORY "$EXEDIR\$0"
			${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "SettingsDirectory" "Data\${DEFAULTSETTINGSDIR}"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\$0"
			${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$EXEDIR\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
			${ReadINIStrWithDefault} $PROGRAMEXECUTABLE "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Executable" "${DEFAULTEXE}"
			${ReadINIStrWithDefault} $SCANEXECUTABLE "$EXEDIR\${NAME}.ini" "${NAME}" "ScanExecutable" "${DEFAULTSCANEXE}"
			${ReadINIStrWithDefault} $UPDATEEXECUTABLE "$EXEDIR\${NAME}.ini" "${NAME}" "UpdateExecutable" "${DEFAULTUPDATEEXE}"
			${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$EXEDIR\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"
			IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE NoProgramEXE

	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy $ADDITIONALPARAMETERS ""
		StrCpy $PROGRAMEXECUTABLE "${DEFAULTEXE}"
		StrCpy $SCANEXECUTABLE "${DEFAULTSCANEXE}"
		StrCpy $UPDATEEXECUTABLE "${DEFAULTUPDATEEXE}"

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy $DBDIRECTORY "$EXEDIR\Data\${DEFAULTDBDIR}"
			StrCpy $LOGDIRECTORY "$EXEDIR\Data\${DEFAULTLOGDIR}"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\${DEFAULTSETTINGSDIR}"
			StrCpy $QUARANTINEDIRECTORY "$EXEDIR\Data\${DEFAULTQUARANTINEDIR}"
			StrCpy $ISDEFAULTDIRECTORY "true"
			IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	FoundProgramEXE:
		StrCmp $SECONDARYLAUNCH "true" GetPassedParameters
		FindProcDLL::FindProc "${DEFAULTEXE}"
		StrCmp $R0 "1" WarnAnotherInstance DisplaySplash

	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Abort
		
	DisplaySplash:
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
		StrCmp $DISABLESPLASHSCREEN "true" GetPassedParameters
			;=== Show the splash screen before processing the files
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 1200 0 0 -1 /L $PLUGINSDIR\splash.jpg
	
	GetPassedParameters:
		;=== Get any passed parameters
		${GetParameters} $0
		StrCmp "'$0'" "''" "" LaunchProgramParameters

		;=== No parameters
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE"`
		Goto AdditionalParameters

	LaunchProgramParameters:
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" $0`

	AdditionalParameters:
		StrCmp $ADDITIONALPARAMETERS "" Settings

		;=== Additional Parameters
		StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`
	
	Settings:
		StrCmp $SECONDARYLAUNCH "true" ComSpecCheck
		IfFileExists `$SETTINGSDIRECTORY\*.*` UpdateSettings
			CreateDirectory $SETTINGSDIRECTORY
			CreateDirectory $DBDIRECTORY
			CreateDirectory $LOGDIRECTORY
			CreateDirectory $QUARANTINEDIRECTORY
			CopyFiles `$EXEDIR\App\DefaultData\ClamWin.conf` `$SETTINGSDIRECTORY`
			
	UpdateSettings:
		Rename "$SETTINGSDIRECTORY\ClamWin.conf" "$PROGRAMDIRECTORY\ClamWin.conf"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "clamscan" "$PROGRAMDIRECTORY\$SCANEXECUTABLE"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "freshclam" "$PROGRAMDIRECTORY\$UPDATEEXECUTABLE"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "database" "$DBDIRECTORY"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "quarantinedir" "$QUARANTINEDIRECTORY"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "logfile" "$LOGDIRECTORY\ClamScanLog.txt"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "Updates" "dbupdatelogfile" "$LOGDIRECTORY\ClamUpdateLog.txt"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "Schedule" "path" "$PROGRAMDIRECTORY\"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "UI" "standalone" "1"
		Goto ComSpecCheck
		
	ComSpecCheck:
		;=== Be sure the ComSpec environment variable is set right
		ReadEnvStr $R0 "COMSPEC"
		StrLen $0 $R0
		IntCmp $0 1 CreateComSpec CreateComSpec LaunchNow
		
	CreateComSpec:
		;=== We need to set the variable
		ReadEnvStr $R0 "SYSTEMROOT"
		IfFileExists "$R0\system32\cmd.exe" "" AltComSpecPath
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("COMSPEC", "$R0\system32\cmd.exe").r0'
		Goto LaunchNow

	AltComSpecPath:
		IfFileExists "$R0\command.com" "" NoComSpec
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("COMSPEC", "$R0\command.com").r0'
		Goto LaunchNow
	
	NoComSpec:
		StrCpy $MISSINGFILEORPATH `command.com/cmd.exe`
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
	
	LaunchNow:
		StrCmp $SECONDARYLAUNCH "true" LaunchAndExit
		ExecWait $EXECSTRING
		
	CheckRunning:
		Sleep 1000
		FindProcDLL::FindProc "${DEFAULTEXE}"                  
		StrCmp $R0 "1" CheckRunning
		Delete "$SETTINGSDIRECTORY\ClamWin.conf"
		Rename "$PROGRAMDIRECTORY\ClamWin.conf" "$SETTINGSDIRECTORY\ClamWin.conf"
		Delete '$TEMP\ClamWin*.log'
		Delete '$TEMP\ClamWin*.txt'
		Delete '$TEMP\clamav-*.*'		
		Delete '$TEMP\ClamWin_Up*.*'
		Goto TheEnd
		
	LaunchAndExit:
		Exec $EXECSTRING
		
	TheEnd:
		newadvsplash::stop /WAIT
SectionEnd