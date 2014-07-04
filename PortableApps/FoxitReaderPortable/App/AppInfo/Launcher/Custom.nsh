${SegmentFile}

Var RegKeyFDFExists
Var RegKeyPDFExists
Var RegKeyPDFIsBlank
Var Usertype

${SegmentPrePrimary}
	UserInfo::GetAccountType
	Pop $Usertype
	${If} $Usertype == "admin"
		${If} ${RegistryKeyExists} "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.pdf"
			StrCpy $RegKeyPDFExists true
			${registry::Read} "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.pdf" "" $R0 $R1
			${If} $R0 == ""
				StrCpy $RegKeyPDFIsBlank true
			${EndIf}
		${EndIf}
		${If} ${RegistryKeyExists} "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.fdf"
			StrCpy $RegKeyFDFExists true
		${EndIf}
	${EndIf}
!macroend

${SegmentPostPrimary}
	UserInfo::GetAccountType
	Pop $Usertype
	${If} $Usertype == "admin"
		${If} $RegKeyPDFExists != true
			${registry::DeleteKey} "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.pdf" $R0
		${EndIf}
		${If} $RegKeyPDFIsBlank == true
			${registry::Read} "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.pdf" "" $R0 $R1
			${If} $R0 != ""
				${registry::DeleteValue} "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.pdf" "" $R0
			${EndIf}
		${EndIf}
		${If} $RegKeyFDFExists != true
			${registry::DeleteKey} "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.fdf" $R0
		${EndIf}
	${EndIf}
!macroend