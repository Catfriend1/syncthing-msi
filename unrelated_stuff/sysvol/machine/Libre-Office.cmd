@echo off
setlocal enabledelayedexpansion
REM
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Filter\Microsoft\Import\CreateMSOLockFiles" /v "Value" /t REG_SZ /d "true" /f
REM
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Font\Substitution\FontPairs\_0/#fuse\Always" /v "Value" /t REG_SZ /d "true" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Font\Substitution\FontPairs\_0/#fuse\OnScreenOnly" /v "Value" /t REG_SZ /d "false" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Font\Substitution\FontPairs\_0/#fuse\ReplaceFont" /v "Value" /t REG_SZ /d "Liberation Sans" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Font\Substitution\FontPairs\_0/#fuse\SubstituteFont" /v "Value" /t REG_SZ /d "Calibri" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Font\Substitution\FontPairs\_1/#fuse\Always" /v "Value" /t REG_SZ /d "true" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Font\Substitution\FontPairs\_1/#fuse\OnScreenOnly" /v "Value" /t REG_SZ /d "false" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Font\Substitution\FontPairs\_1/#fuse\ReplaceFont" /v "Value" /t REG_SZ /d "Liberation Serif" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Font\Substitution\FontPairs\_1/#fuse\SubstituteFont" /v "Value" /t REG_SZ /d "Calibri" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Font\Substitution\Replacement" /v "Value" /t REG_SZ /d "true" /f
REM
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Misc\CollectUsageInformation" /v "Value" /t REG_SZ /d "false" /f
REM
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Save\Document\WarnAlienFormat" /v "Value" /t REG_SZ /d "false" /f
REM
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Common\Security\Scripting\MacroSecurityLevel" /v "Value" /t REG_SZ /d "3" /f
REM
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.OptionsDialog\OptionsDialogGroups\ProductName/#fuse\Pages\Fonts/#fuse\Hide" /v "Value" /t REG_SZ /d "false" /f
REM
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Writer\DefaultFont\Caption" /v "Value" /t REG_SZ /d "" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Writer\DefaultFont\CaptionHeight" /v "Value" /t REG_SZ /d "423" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Writer\DefaultFont\Heading" /v "Value" /t REG_SZ /d "" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Writer\DefaultFont\HeadingHeight" /v "Value" /t REG_SZ /d "494" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Writer\DefaultFont\Index" /v "Value" /t REG_SZ /d "" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Writer\DefaultFont\IndexHeight" /v "Value" /t REG_SZ /d "423" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Writer\DefaultFont\List" /v "Value" /t REG_SZ /d "" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Writer\DefaultFont\ListHeight" /v "Value" /t REG_SZ /d "423" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Writer\DefaultFont\Standard" /v "Value" /t REG_SZ /d "Calibri" /f
REG ADD "HKLM\Software\Policies\LibreOffice\org.openoffice.Office.Writer\DefaultFont\StandardHeight" /v "Value" /t REG_SZ /d "423" /f
REM
goto :eof
