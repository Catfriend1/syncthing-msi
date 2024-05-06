@echo off
setlocal enabledelayedexpansion
REM
REM Command line.
REM 	"C:\Server\Sync\Sysvol\groupPolicy.cmd" machine
REM 	"C:\Server\Sync\Sysvol\groupPolicy.cmd" user
REM
SET "SCRIPT_PATH=%~dp0"
SET "SCRIPT_ARG=%1"
REM
REM Check command line.
IF NOT DEFINED SCRIPT_ARG echo [ERROR] Missing parameter #1. Stop. & goto :eof
REM
powershell -ExecutionPolicy ByPass ". ($ENV:SCRIPT_PATH + 'groupPolicy.ps1') -contextFolder $ENV:SCRIPT_ARG"
REM
REM pause
REM
goto :eof
