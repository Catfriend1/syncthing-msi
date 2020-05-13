@echo off
REM 
REG ADD "HKLM\System\CurrentControlSet\Services\Syncthing\Parameters" /v "AppEnvironmentExtra" /t REG_MULTI_SZ /d "STRECHECKDBEVERY=0\0" /f
REM 
timeout 3
