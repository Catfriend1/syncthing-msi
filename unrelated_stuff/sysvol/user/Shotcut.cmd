@echo off
REM
REG ADD "HKCU\Software\Meltytech\Shotcut" /v "askUpgradeAutmatic" /t REG_SZ /d "false" /f
REG ADD "HKCU\Software\Meltytech\Shotcut" /v "checkUpgradeAutomatic" /t REG_SZ /d "false" /f
REM
goto :eof
