@echo off
setlocal enabledelayedexpansion
REM 
REM Purpose:
REM 	Install MSI using the SYSTEM account to simulate environment during GPO software installation.
REM 
REM Runtime Variables.
SET SCRIPT_PATH="%~dps0"
for /f "tokens=*" %%G in ('dir /b /a:-d %SCRIPT_PATH%Syncthing_v*.msi') do call :psExecInstallMsi "%SCRIPT_PATH%%%G"
REM 
goto :eof


:psExecInstallMsi
REM 
REM Syntax:
REM 	call :psExecInstallMsi [MSI_FULLFN]
REM 
REM Variables.
SET TMP_PSEIM_MSI_FULLFN=%1
IF DEFINED TMP_PSEIM_MSI_FULLFN SET TMP_PSEIM_MSI_FULLFN=%TMP_PSEIM_MSI_FULLFN:"=%
REM 
REM For testing purposes only.
echo "[INFO] Installing MSI [%TMP_PSEIM_MSI_FULLFN%] ..."
psexec -s -h -i msiexec /i "%TMP_PSEIM_MSI_FULLFN%" /qn
REM 
goto :eof
