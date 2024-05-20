@echo off
REM
REG ADD "HKCU\Software\WinSuite\NTProtect" /v "WriteLog" /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\WinSuite\NTProtect" /v "ShowLogo" /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\WinSuite\NTProtect" /v "ShowDesktop" /t REG_DWORD /d 0 /f
REM
REM REG ADD "HKCU\Software\WinSuite\ProcView" /v "WindowPoser" /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\WinSuite\ProcView" /v "Hotkey_Tip_Shown" /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\WinSuite\ProcView" /v "DatePrint" /t REG_DWORD /d 1 /f
REM
REG ADD "HKCU\Software\WinSuite" /v "NTProtect" /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\WinSuite" /v "Autoruns" /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\WinSuite" /v "ProcView" /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\WinSuite" /v "SystrayPlayer" /t REG_DWORD /d 1 /f
REM
IF EXIST "X:\Temp" REG ADD "HKCU\Software\WinSuite\SystrayPlayer" /v "PlayerRamdrive" /t REG_SZ /d "X:" /f
REM
REM Add autorun entry.
IF EXIST "%SystemRoot%\Winsuite.exe" REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "WinSuite" /t REG_SZ /d "%SystemRoot%\Winsuite.exe /Usermode" /f
REM
goto :eof
