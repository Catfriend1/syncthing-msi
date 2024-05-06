@echo off
setlocal enabledelayedexpansion
REM
REM System/Windows-Zeitdienst/Zeitanbieter
REM 	Windows-NTP-Client konfigurieren - Aktiviert
REG ADD "HKLM\Software\Policies\Microsoft\W32time\TimeProviders\NtpClient" /v "Enabled" /t REG_DWORD /d 1 /f
REG ADD "HKLM\Software\Policies\Microsoft\W32time\Parameters" /v "Type" /t REG_SZ /d "NTP" /f
REG ADD "HKLM\Software\Policies\Microsoft\W32time\Parameters" /v "NtpServer" /t REG_SZ /d "0.pool.europe.ntp.org,0x1" /f
REM 
REG ADD "HKLM\Software\Policies\Microsoft\W32time\TimeProviders\NtpClient" /v "CrossSiteSyncFlags" /t REG_DWORD /d 2 /f
REG ADD "HKLM\Software\Policies\Microsoft\W32time\TimeProviders\NtpClient" /v "EventLogFlags" /t REG_DWORD /d 0 /f
REG ADD "HKLM\Software\Policies\Microsoft\W32time\TimeProviders\NtpClient" /v "ResolvePeerBackoffMinutes" /t REG_DWORD /d 15 /f
REG ADD "HKLM\Software\Policies\Microsoft\W32time\TimeProviders\NtpClient" /v "ResolvePeerBackoffMaxTimes" /t REG_DWORD /d 7 /f
REG ADD "HKLM\Software\Policies\Microsoft\W32time\TimeProviders\NtpClient" /v "SpecialPollInterval" /t REG_DWORD /d 3600 /f
REM
goto :eof
