@echo off
setlocal enabledelayedexpansion
cls
SET SCRIPT_PATH=%~dps0
cd /d "%SCRIPT_PATH%"
REM 
REM Script Consts.
SET GIT_BIN=
FOR /F "tokens=*" %%A IN ('where git 2^> NUL:') DO SET GIT_BIN="%%A"
REM 
SET GO_ROOT=%ProgramFiles%\Go
SET GO_BIN="%GO_ROOT%\bin\go.exe"
REM 
echo [INFO] Checking prerequisites ...
REM
call setenv.cmd
IF NOT DEFINED GIT_BIN echo [ERROR] GIT_BIN env var not set. & goto :pauseExit
IF NOT DEFINED GIT_USERNAME echo [ERROR] GIT_USERNAME env var not set. & goto :pauseExit
IF NOT DEFINED GIT_EMAIL echo [ERROR] GIT_EMAIL env var not set. & goto :pauseExit
IF NOT DEFINED BUILD_HOST echo [ERROR] BUILD_HOST env var not set. & goto :pauseExit
IF NOT DEFINED BUILD_USER echo [ERROR] BUILD_USER env var not set. & goto :pauseExit
REM 
IF NOT DEFINED CHERRY_PICK_COMMIT echo [ERROR] CHERRY_PICK_COMMIT env var not set. & goto :pauseExit
IF NOT DEFINED TARGET_VER echo [ERROR] TARGET_VER env var not set. & goto :pauseExit
title Syncthing - Update branch and build %TARGET_VER%
REM 
IF NOT EXIST %GIT_BIN% echo [ERROR] GIT_BIN not found. & goto :pauseExit
IF NOT EXIST %GO_BIN% echo [ERROR] GO_BIN not found. & goto :pauseExit
REM 
IF NOT EXIST "%SCRIPT_PATH%\syncthing" echo [ERROR] Execute this script on one directory level up. & goto :pauseExit
cd /d "%SCRIPT_PATH%\syncthing"
REM 
echo [INFO] Performing cleanup ...
call :cleanUp
REM 
call :runGit config --replace-all --global user.name "%GIT_USERNAME%"
call :runGit config --replace-all --global user.email "%GIT_EMAIL%"
call :runGit checkout master
call :runGit pull upstream master
call :runGit fetch --all
call :runGit checkout %TARGET_VER%
call :runGit checkout -b symlink-support_%TARGET_VER%
REM 
call :runGit cherry-pick %CHERRY_PICK_COMMIT%
REM 
echo.
:askUserToPush
SET UI_ANSWER=
SET /p UI_ANSWER=Do you want to push the branch to remote? [y/n]
IF "%UI_ANSWER%" == "n" goto :skipPush
IF NOT "%UI_ANSWER%" == "y" goto :askUserToPush
REM 
call :runGit push --set-upstream origin symlink-support_%TARGET_VER%
REM 
:skipPush
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
cd /d "%SCRIPT_PATH%"
REM 
goto :eof
















REM ====================
REM FUNCTION BLOCK START
REM ====================
:cleanUp
call :runGit checkout -f master
REM
REM Delete branch.
%GIT_BIN% branch -D symlink-support_%TARGET_VER%
REM %GIT_BIN% push origin --delete symlink-support_%TARGET_VER%
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
