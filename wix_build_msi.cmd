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
SET GNU_SED_DEPENDENCIES_FILENAME=sed-4.2.1-dep.zip
SET GNU_SED_BINARIES_FILENAME=sed-4.2.1-bin.zip
SET NSSM_FILENAME=nssm-2.24-101-g897c7ad.zip
SET SYNCTHING_VERSION=v1.4.0
SET SYNCTHING_FILENAME=syncthing-windows-amd64-%SYNCTHING_VERSION%.zip
REM 
REM Download prerequisites.
REM 	GNU SED
REM 		Binaries
echo [INFO] Downloading GNU SED Binaries ...
IF NOT EXIST "%SCRIPT_PATH%%GNU_SED_BINARIES_FILENAME%" call :psDownloadFile "http://sourceforge.net/projects/gnuwin32/files//sed/4.2.1/%GNU_SED_BINARIES_FILENAME%/download" "%SCRIPT_PATH%%GNU_SED_BINARIES_FILENAME%"
call :psExpandArchive "%SCRIPT_PATH%%GNU_SED_BINARIES_FILENAME%" "%SCRIPT_PATH%sed"
copy /y "%SCRIPT_PATH%sed\bin\sed.exe" "%SCRIPT_PATH%\Syncthing\sed.exe"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\sed.exe" echo [ERROR] File not found: sed.exe" & pause & goto :eof
REM 
REM 		Dependencies
echo [INFO] Downloading GNU SED Dependencies ...
IF NOT EXIST "%SCRIPT_PATH%%GNU_SED_DEPENDENCIES_FILENAME%" call :psDownloadFile "http://sourceforge.net/projects/gnuwin32/files//sed/4.2.1/%GNU_SED_DEPENDENCIES_FILENAME%/download" "%SCRIPT_PATH%%GNU_SED_DEPENDENCIES_FILENAME%"
call :psExpandArchive "%SCRIPT_PATH%%GNU_SED_DEPENDENCIES_FILENAME%" "%SCRIPT_PATH%sed"
copy /y "%SCRIPT_PATH%sed\bin\libiconv2.dll" "%SCRIPT_PATH%\Syncthing\libiconv2.dll"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\libiconv2.dll" echo [ERROR] File not found: libiconv2.dll" & pause & goto :eof
copy /y "%SCRIPT_PATH%sed\bin\libintl3.dll" "%SCRIPT_PATH%\Syncthing\libintl3.dll"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\libintl3.dll" echo [ERROR] File not found: libintl3.dll" & pause & goto :eof
copy /y "%SCRIPT_PATH%sed\bin\regex2.dll" "%SCRIPT_PATH%\Syncthing\regex2.dll"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\regex2.dll" echo [ERROR] File not found: regex2.dll" & pause & goto :eof
REM 
REM 	NSSM
echo [INFO] Downloading NSSM ...
IF NOT EXIST "%SCRIPT_PATH%%NSSM_FILENAME%" call :psDownloadFile "https://nssm.cc/ci/%NSSM_FILENAME%" "%SCRIPT_PATH%%NSSM_FILENAME%"
call :psExpandArchive "%SCRIPT_PATH%%NSSM_FILENAME%" "%SCRIPT_PATH%"
copy /y "%SCRIPT_PATH%%NSSM_FILENAME:.zip=%\win32\nssm.exe" "%SCRIPT_PATH%\Syncthing\nssm_x86.exe"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\nssm_x86.exe" echo [ERROR] File not found: nssm_x86.exe" & pause & goto :eof
copy /y "%SCRIPT_PATH%%NSSM_FILENAME:.zip=%\win64\nssm.exe" "%SCRIPT_PATH%\Syncthing\nssm_x64.exe"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\nssm_x64.exe" echo [ERROR] File not found: nssm_x64.exe" & pause & goto :eof
REM 
REM 	Syncthing
echo [INFO] Downloading Syncthing ...
IF NOT EXIST "%SCRIPT_PATH%%SYNCTHING_FILENAME%" call :psDownloadFile "https://github.com/syncthing/syncthing/releases/download/%SYNCTHING_VERSION%/%SYNCTHING_FILENAME%" "%SCRIPT_PATH%%SYNCTHING_FILENAME%"
call :psExpandArchive "%SCRIPT_PATH%%SYNCTHING_FILENAME%" "%SCRIPT_PATH%"
copy /y "%SCRIPT_PATH%%SYNCTHING_FILENAME:.zip=%\AUTHORS.txt" "%SCRIPT_PATH%\Syncthing\AUTHORS.txt"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\AUTHORS.txt" echo [ERROR] File not found: AUTHORS.txt" & pause & goto :eof
copy /y "%SCRIPT_PATH%%SYNCTHING_FILENAME:.zip=%\LICENSE.txt" "%SCRIPT_PATH%\Syncthing\LICENSE.txt"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\LICENSE.txt" echo [ERROR] File not found: LICENSE.txt" & pause & goto :eof
copy /y "%SCRIPT_PATH%%SYNCTHING_FILENAME:.zip=%\README.txt" "%SCRIPT_PATH%\Syncthing\README.txt"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\README.txt" echo [ERROR] File not found: README.txt" & pause & goto :eof
copy /y "%SCRIPT_PATH%%SYNCTHING_FILENAME:.zip=%\syncthing.exe" "%SCRIPT_PATH%\Syncthing\syncthing.exe"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\syncthing.exe" echo [ERROR] File not found: syncthing.exe" & pause & goto :eof
copy /y "%SCRIPT_PATH%%SYNCTHING_FILENAME:.zip=%\metadata\release.sig" "%SCRIPT_PATH%\Syncthing\syncthing.exe.sig"
IF NOT EXIST "%SCRIPT_PATH%\Syncthing\syncthing.exe.sig" echo [ERROR] File not found: syncthing.exe.sig" & pause & goto :eof
REM 
REM Testing prerequisites.
SET "PATH=%PATH%;%SCRIPT_PATH%\Syncthing"
where /q sed
IF NOT "%ERRORLEVEL%" == "0" echo [ERROR] sed.exe not found on PATH env var. & pause & goto :eof
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


:psDownloadFile
REM 
SET TMP_URL_TO_DOWNLOAD=%1
IF DEFINED TMP_URL_TO_DOWNLOAD SET TMP_URL_TO_DOWNLOAD="%TMP_URL_TO_DOWNLOAD:"=%
REM 
SET TMP_TARGET_FILENAME=%2
IF DEFINED TMP_TARGET_FILENAME SET TMP_TARGET_FILENAME="%TMP_TARGET_FILENAME:"=%
REM 
powershell -ExecutionPolicy "ByPass" "(new-object System.Net.WebClient).DownloadFile('%TMP_URL_TO_DOWNLOAD%','%TMP_TARGET_FILENAME%')"
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
