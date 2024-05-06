@echo off
setlocal enabledelayedexpansion
REM
REM Disable NTFS EFS
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableEncryption /t REG_DWORD /d 1 /f
REM
goto :eof
