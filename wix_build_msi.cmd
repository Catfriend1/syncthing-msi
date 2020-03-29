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
REM Runtime Vars.
SET WIX_TOOLKIT_DIR_NAME=
for /f "tokens=*" %%A in ('dir /b /a:d "%ProgramFiles(x86)%\Wix Toolset v*"') do SET WIX_TOOLKIT_DIR_NAME=%%A
IF NOT DEFINED WIX_TOOLKIT_DIR_NAME echo [ERROR] Could not resolve WIX_TOOLKIT_DIR_NAME. & goto :EOS
SET WIX_TOOLKIT_BIN_PATH=%ProgramFiles(x86)%\%WIX_TOOLKIT_DIR_NAME%\bin
echo [INFO] WIX_TOOLKIT_BIN_PATH=%WIX_TOOLKIT_BIN_PATH%
REM 
SET WIX_CANDLE_BIN="%WIX_TOOLKIT_BIN_PATH%\candle.exe"
SET WIX_LIGHT_BIN="%WIX_TOOLKIT_BIN_PATH%\light.exe"
REM 
REM 	Input files 
SET WIX_INPUT_SCRIPT_TEMPLATE="%SCRIPT_PATH%%PRODUCT_NAME%.wxs.template"
SET WIX_INPUT_SCRIPT="%SCRIPT_PATH%%PRODUCT_NAME%.wxs"
REM 
REM 		Detect ProductVersion of "syncthing.exe".
SET FILEVER_BIN=%SCRIPT_PATH%filever.exe
SET SYNCTHING_EXE=%SCRIPT_PATH%Syncthing\syncthing.exe
REM 
SET SYNCTHING_EXE_PRODUCTVERSION=
for /f "tokens=2 delims= " %%A in ('%FILEVER_BIN% /v %SYNCTHING_EXE% 2^>NUL: ^| findstr /i "ProductVersion" ^| sed -e "s/\t/ /g" -e "s/v//g"') do SET SYNCTHING_EXE_PRODUCTVERSION=%%A
IF NOT DEFINED SYNCTHING_EXE_PRODUCTVERSION echo [ERROR] Could not determine ProductVersion of EXE. & goto :EOS
echo [INFO] SYNCTHING_EXE_PRODUCTVERSION=v[%SYNCTHING_EXE_PRODUCTVERSION%]
REM 
REM 		Update WIX_INPUT_SCRIPT with SYNCTHING_EXE_PRODUCTVERSION.
type %WIX_INPUT_SCRIPT_TEMPLATE% | sed -e "s/BATCH_PRODUCTVERSION/%SYNCTHING_EXE_PRODUCTVERSION%/g" > %WIX_INPUT_SCRIPT%
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
echo Done.
goto :EOS


:cleanUp
REM 
IF NOT "%DO_CLEANUP%" == "1" goto :eof
REM 
echo [INFO] Cleanup previous build ...
del /f "%PRODUCT_WIX_OBJ%" 2> NUL:
REM del /f "%FILES_WIX_OBJ%" 2> NUL:
del /f "%WIX_INPUT_SCRIPT%" 2> NUL:
REM del /f "%WIX_FILES_SCRIPT%" 2> NUL:
del /f "%WIX_PDB%" 2> NUL:
REM 
goto :eof


:EOS
REM 
call :cleanUp
REM
pause
goto :eof
