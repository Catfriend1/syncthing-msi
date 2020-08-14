@echo off
endlocal
REM
REM This is called by "update_branch_and_build.cmd"
REM
REM Build Enviroment Consts.
SET GIT_USERNAME=user
SET GIT_EMAIL=email
REM
SET BUILD_HOST=host
SET BUILD_USER=user
REM 
REM Release Consts.
SET CHERRY_PICK_COMMIT=441ef5cedf5ec727475b628f1f2a617089817d88
SET TARGET_VER=v1.8.0
