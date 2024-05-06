@echo off
setlocal enabledelayedexpansion
REM
REM Netzwerk/DNS-Client
REM 	Multicastnamensauflösung deaktivieren - Aktiviert
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "DisableSmartNameResolution" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f
REM
goto :eof
