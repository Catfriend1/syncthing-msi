@echo off
setlocal enabledelayedexpansion
REM
REM Windows-Komponenten/Windows Defender SmartScreen/Microsoft Edge
REG ADD "HKLM\Software\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f
REM
REM Windows-Komponenten/Windows Defender SmartScreen/Explorer
REG ADD "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d 0 /f
REG DELETE "HKLM\Software\Policies\Microsoft\Windows\System" /v "ShellSmartScreenLevel" /f 2>&1 | find /i "erfolg"
REM
REM Windows-Komponenten/Windows Defender Antivirus
REG ADD "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d 1 /f
REM
REG ADD "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 0 /f
REM
REM Windows-Komponenten/Windows Defender Antivirus/MAPS
REG ADD "HKLM\Software\Policies\Microsoft\Windows Defender\Spynet" /v "LocalSettingOverrideSpynetReporting" /t REG_DWORD /d 0 /f
REM
REG ADD "HKLM\Software\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d 0 /f
REM
REG ADD "HKLM\Software\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d 2 /f
REM
REM Windows-Komponenten/Windows Defender Antivirus/Ausschlüsse
REG ADD "HKLM\Software\Policies\Microsoft\Windows Defender\Exclusions" /v "Exclusions_Paths" /t REG_DWORD /d 0 /f
REM
goto :eof
