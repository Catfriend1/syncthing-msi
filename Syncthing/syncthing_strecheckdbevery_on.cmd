@echo off
REM 
REG ADD "HKLM\System\CurrentControlSet\Services\Syncthing\Parameters" /v "AppEnvironmentExtra" /t REG_MULTI_SZ /d "STRECHECKDBEVERY=1s\0" /f
REM 
timeout 3
goto :eof
