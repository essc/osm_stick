${SegmentFile}

${SegmentPrePrimary}
	ReadEnvStr $0 PAL:LanguageCustom

	Delete "$EXEDIR\App\Notepad++\nativeLang.xml"
	${If} $0 != "English"
		${If} ${FileExists} "$EXEDIR\App\Notepad++\localization\$0.xml"
			CopyFiles /SILENT "$EXEDIR\App\Notepad++\localization\$0.xml" "$EXEDIR\App\Notepad++\"
			Rename "$EXEDIR\App\Notepad++\$0.xml" "$EXEDIR\App\Notepad++\nativeLang.xml"
		${EndIf}
	${EndIf}
!macroend