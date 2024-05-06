@echo off
REM
REM Excel
REG ADD "HKCU\Software\Microsoft\Office\16.0\Excel\Options" /v "AutoHyperlink" /t REG_DWORD /d 0 /f
REM
REM Outlook - Wetterleiste deaktivieren
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\outlook\options\calendar" /v "disableweather" /t REG_DWORD /d 1 /f
REM
REM EnableADAL=0 : Login ohne MFA mit runas möglich. EnableADAL=1: MFA Login möglich, runas nicht
REG ADD "HKCU\Software\Microsoft\Office\16.0\Common\Identity" /v "EnableADAL" /t REG_DWORD /d 1 /f
REM
goto :eof
