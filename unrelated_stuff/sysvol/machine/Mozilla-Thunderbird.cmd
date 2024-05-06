@echo off
setlocal enabledelayedexpansion
REM
REG ADD "HKLM\Software\Policies\Mozilla\Thunderbird" /v "BackgroundAppUpdate" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Mozilla\Thunderbird" /v "DisableAppUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Thunderbird" /v "DisableTelemetry" /t REG_DWORD /d "1" /f
REM
REG ADD "HKLM\Software\Policies\Mozilla\Thunderbird\Certificates" /v "ImportEnterpriseRoots" /t REG_DWORD /d "1" /f
REM
REG ADD "HKLM\Software\Policies\Mozilla\Thunderbird\DNSOverHTTPS" /v "Enabled" /t REG_DWORD /d "0" /f
REM
goto :eof
