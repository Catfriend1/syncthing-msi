@echo off
setlocal enabledelayedexpansion
REM 
SET SCRIPT_PATH=%~dps0
cd /d "%SCRIPT_PATH%"
cls
REM
REM Consts.
SET DO_CLEANUP=1
SET PRODUCT_NAME=Syncthing
REM 
REM Consts: Prerequisites.
SET NSSM_FILENAME=nssm-2.24-101-g897c7ad.zip
SET SYNCTHING_VERSION=v1.5.0
SET SYNCTHING_FILENAME=syncthing-windows-amd64-%SYNCTHING_VERSION%.zip
SET WIX_TOOLSET_FILENAME=wix311-binaries.zip
REM 
REM Download prerequisites.
REM 
REM 	NSSM
echo [INFO] Downloading NSSM ...
IF NOT EXIST "%SCRIPT_PATH%%NSSM_FILENAME%" call :psDownloadFile "https://nssm.cc/ci/%NSSM_FILENAME%" "%SCRIPT_PATH%%NSSM_FILENAME%"
call :psExpandArchive "%SCRIPT_PATH%%NSSM_FILENAME%" "%SCRIPT_PATH%"
copy /y "%SCRIPT_PATH%%NSSM_FILENAME:.zip=%\win32\nssm.exe" "%SCRIPT_PATH%\Syncthing\nssm_x86.exe"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\nssm_x86.exe" echo [ERROR] File not found: nssm_x86.exe & pause & goto :eof
REM 
REM 	Syncthing
echo [INFO] Downloading Syncthing ...
IF NOT EXIST "%SCRIPT_PATH%%SYNCTHING_FILENAME%" call :psDownloadFile "https://github.com/syncthing/syncthing/releases/download/%SYNCTHING_VERSION%/%SYNCTHING_FILENAME%" "%SCRIPT_PATH%%SYNCTHING_FILENAME%"
call :psExpandArchive "%SCRIPT_PATH%%SYNCTHING_FILENAME%" "%SCRIPT_PATH%"
copy /y "%SCRIPT_PATH%%SYNCTHING_FILENAME:.zip=%\AUTHORS.txt" "%SCRIPT_PATH%\Syncthing\AUTHORS.txt"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\AUTHORS.txt" echo [ERROR] File not found: AUTHORS.txt & pause & goto :eof
copy /y "%SCRIPT_PATH%%SYNCTHING_FILENAME:.zip=%\LICENSE.txt" "%SCRIPT_PATH%\Syncthing\LICENSE.txt"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\LICENSE.txt" echo [ERROR] File not found: LICENSE.txt & pause & goto :eof
copy /y "%SCRIPT_PATH%%SYNCTHING_FILENAME:.zip=%\README.txt" "%SCRIPT_PATH%\Syncthing\README.txt"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\README.txt" echo [ERROR] File not found: README.txt & pause & goto :eof
copy /y "%SCRIPT_PATH%%SYNCTHING_FILENAME:.zip=%\syncthing.exe" "%SCRIPT_PATH%\Syncthing\syncthing.exe"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\syncthing.exe" echo [ERROR] File not found: syncthing.exe & pause & goto :eof
REM 
REM   WiX Toolset
echo [INFO] Downloading WiX Toolset ...
IF NOT EXIST "%SCRIPT_PATH%%WIX_TOOLSET_FILENAME%" call :psDownloadFile "https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/%WIX_TOOLSET_FILENAME%" "%SCRIPT_PATH%%WIX_TOOLSET_FILENAME%"
call :psExpandArchive "%SCRIPT_PATH%%WIX_TOOLSET_FILENAME%" "%SCRIPT_PATH%wix"
SET WIX_CANDLE_BIN="%SCRIPT_PATH%wix\candle.exe"
SET WIX_LIGHT_BIN="%SCRIPT_PATH%wix\light.exe"
IF NOT EXIST %WIX_CANDLE_BIN% echo [ERROR] File not found: wix\candle.exe & pause & goto :eof
IF NOT EXIST %WIX_LIGHT_BIN% echo [ERROR] File not found: wix\light.exe & pause & goto :eof
REM 
REM Testing prerequisites.
SET "PATH=%PATH%;%SCRIPT_PATH%\Syncthing"
REM 
REM Runtime Vars.
REM 
REM 	Input files 
SET WIX_INPUT_SCRIPT_TEMPLATE="%SCRIPT_PATH%%PRODUCT_NAME%.wxs.template"
SET WIX_INPUT_SCRIPT="%SCRIPT_PATH%%PRODUCT_NAME%.wxs"
REM 
REM 		Detect ProductVersion of "syncthing.exe".
SET SYNCTHING_EXE=%SCRIPT_PATH%Syncthing\syncthing.exe
REM 
SET SYNCTHING_EXE_PRODUCTVERSION=
for /f "tokens=*" %%A in ('powershell -ExecutionPolicy "ByPass" "(Get-Item -path \"%SYNCTHING_EXE%\").VersionInfo.ProductVersion"') do SET SYNCTHING_EXE_PRODUCTVERSION=%%A
IF NOT DEFINED SYNCTHING_EXE_PRODUCTVERSION echo [ERROR] Could not determine ProductVersion of EXE. & goto :EOS
echo [INFO] SYNCTHING_EXE_PRODUCTVERSION=v[%SYNCTHING_EXE_PRODUCTVERSION%]
REM 
REM 		Update WIX_INPUT_SCRIPT with SYNCTHING_EXE_PRODUCTVERSION.
type %WIX_INPUT_SCRIPT_TEMPLATE% | Syncthing\psreplace "BATCH_PRODUCTVERSION" "%SYNCTHING_EXE_PRODUCTVERSION%" > %WIX_INPUT_SCRIPT%
REM 
REM 	Output files
SET PRODUCT_WIX_OBJ="%SCRIPT_PATH%%PRODUCT_NAME%.wixobj"
REM 
REM Get "Property_ProductVersion" from WXS script.
SET MSI_PRODUCT_VERSION=
for /f delims^=^"^ tokens^=2 %%A in ('type %WIX_INPUT_SCRIPT% 2^>NUL: ^| find /i "Property_ProductVersion ="') do SET MSI_PRODUCT_VERSION=%%A
IF NOT DEFINED MSI_PRODUCT_VERSION echo [ERROR] Could not extract MSI_PRODUCT_VERSION from WXS script. & goto :EOS
echo [INFO] ProductVersion=[v%MSI_PRODUCT_VERSION%]
REM 
REM 	Output files
SET WIX_PDB="%SCRIPT_PATH%%PRODUCT_NAME%_v%MSI_PRODUCT_VERSION%.wixpdb"
SET MSI_TARGET="%SCRIPT_PATH%%PRODUCT_NAME%_v%MSI_PRODUCT_VERSION%.msi"
REM 
del /f %MSI_TARGET% 2> NUL:
REM 
echo [INFO] Running LINT ...
%WIX_CANDLE_BIN% -nologo -out %PRODUCT_WIX_OBJ% -ext WixUiExtension -ext WixUtilExtension %WIX_INPUT_SCRIPT% -sw1150
IF NOT EXIST %PRODUCT_WIX_OBJ% echo [ERROR] Failed to build in step #1 & goto :EOS
REM 
echo [INFO] Merging MSI ...
%WIX_LIGHT_BIN% -nologo %PRODUCT_WIX_OBJ% -out %MSI_TARGET% -ext WixUiExtension -ext WixUtilExtension -sw1076
del /f "%WIX_PDB%" 2> NUL:
REM
if NOT EXIST %MSI_TARGET% echo [ERROR] Failed to merge MSI in step #2 & goto :EOS
REM 
echo [INFO] Done.
goto :EOS


:cleanUp
REM 
IF NOT "%DO_CLEANUP%" == "1" goto :eof
REM 
echo [INFO] Cleanup previous build ...
IF DEFINED PRODUCT_WIX_OBJ del /f "%PRODUCT_WIX_OBJ%" 2> NUL:
REM del /f "%FILES_WIX_OBJ%" 2> NUL:
IF DEFINED WIX_INPUT_SCRIPT del /f "%WIX_INPUT_SCRIPT%" 2> NUL:
REM del /f "%WIX_FILES_SCRIPT%" 2> NUL:
IF DEFINED WIX_PDB del /f "%WIX_PDB%" 2> NUL:
REM 
goto :eof


:EOS
REM 
call :cleanUp
REM
pause
goto :eof


:psDownloadFile
REM 
SET TMP_URL_TO_DOWNLOAD=%1
IF DEFINED TMP_URL_TO_DOWNLOAD SET TMP_URL_TO_DOWNLOAD="%TMP_URL_TO_DOWNLOAD:"=%
REM 
SET TMP_TARGET_FILENAME=%2
IF DEFINED TMP_TARGET_FILENAME SET TMP_TARGET_FILENAME="%TMP_TARGET_FILENAME:"=%
REM 
powershell -ExecutionPolicy "ByPass" "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (new-object System.Net.WebClient).DownloadFile('%TMP_URL_TO_DOWNLOAD%','%TMP_TARGET_FILENAME%')"
REM 
goto :eof


:psExpandArchive
REM 
SET TMP_ARCHIVE_FULLFN=%1
IF DEFINED TMP_ARCHIVE_FULLFN SET TMP_ARCHIVE_FULLFN="%TMP_ARCHIVE_FULLFN:"=%
REM 
SET TMP_TARGET_FOLDER=%2
IF DEFINED TMP_TARGET_FOLDER SET TMP_TARGET_FOLDER="%TMP_TARGET_FOLDER:"=%
REM 
powershell -ExecutionPolicy "ByPass" "Expand-Archive '%TMP_ARCHIVE_FULLFN%' -DestinationPath '%TMP_TARGET_FOLDER%' -Force"
REM 
goto :eof
