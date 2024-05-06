@echo off
REM
wmic /namespace:\\root\cimv2 path Win32_PhysicalMemory WHERE "FormFactor = 12" get /value 2>NUL: | findstr /i "BankLabel" > NUL: || goto :eof
REM
echo [INFO] Notebook detected.
REM
REG ADD "HKCU\Software\Synaptics\SynTPEnh" /v "DisableIntPDFeature" /t REG_DWORD /d 0x33 /f
REG ADD "HKCU\Software\Synaptics\SynTPEnh" /v "TrayIcon" /t REG_DWORD /d 0x21 /f
REM
goto :eof
