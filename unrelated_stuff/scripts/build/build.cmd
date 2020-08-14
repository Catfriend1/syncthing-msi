@echo off
setlocal enabledelayedexpansion
cls
SET SCRIPT_PATH=%~dps0
cd /d "%SCRIPT_PATH%"
REM 
REM Script Consts.
SET BUILD_HOST=host
SET BUILD_USER=user
SET TARGET_VER=v1.4.1-symlink
REM 
SET GIT_BIN=
FOR /F "tokens=*" %%A IN ('where git 2^> NUL:') DO SET GIT_BIN="%%A"
REM 
SET GO_ROOT=%ProgramFiles%\Go
SET GO_BIN="%GO_ROOT%\bin\go.exe"
REM 
echo [INFO] Checking prerequisites ...
REM
IF NOT DEFINED GIT_BIN echo [ERROR] GIT_BIN env var not set. & goto :pauseExit
IF NOT DEFINED BUILD_HOST echo [ERROR] BUILD_HOST env var not set. & goto :pauseExit
IF NOT DEFINED BUILD_USER echo [ERROR] BUILD_USER env var not set. & goto :pauseExit
REM 
IF NOT DEFINED TARGET_VER echo [ERROR] TARGET_VER env var not set. & goto :pauseExit
title Syncthing - Build %TARGET_VER%
REM 
IF NOT EXIST %GIT_BIN% echo [ERROR] GIT_BIN not found. & goto :pauseExit
IF NOT EXIST %GO_BIN% echo [ERROR] GO_BIN not found. & goto :pauseExit
REM 
echo [INFO] Performing cleanup ...
call :cleanUp
REM 
REM Build syncthing from source.
echo [INFO] Setting up build environment ...
REM 
SET GOPATH=%TEMP%\go
SET PATH=%GOPATH%\bin;%GO_ROOT%;%GO_ROOT%\bin;%PATH%
REM 
SET GO111MODULE=on
SET CGO_ENABLED=0
REM
MD %GOPATH% 2> NUL:
(echo %TARGET_VER%)> "RELEASE"
REM 
call :runGo version
call :runGo get github.com/josephspurrier/goversioninfo
call :runGo install github.com/josephspurrier/goversioninfo/cmd/goversioninfo
call :runGo mod download
call :runGo run build.go -version %TARGET_VER% -no-upgrade -goos windows -goarch amd64 build syncthing
REM 
goto :eof
















REM ====================
REM FUNCTION BLOCK START
REM ====================
:cleanUp
REM 
goto :eof


:runGit
echo [INFO] git %*
%GIT_BIN% %*
SET RESULT=%ERRORLEVEL%
IF NOT "%RESULT%" == "0" echo [ERROR] git FAILED with error code #%RESULT%. & goto :pauseExit
goto :eof


:runGo
echo [INFO] go %*
%GO_BIN% %*
SET RESULT=%ERRORLEVEL%
IF NOT "%RESULT%" == "0" echo [ERROR] go FAILED with error code #%RESULT%. & goto :pauseExit
goto :eof


:pauseExit
pause
goto :eof
REM ==================
REM FUNCTION BLOCK END
REM ==================
