@echo off
REM 
REG DELETE "HKLM\System\CurrentControlSet\Services\Syncthing\Parameters" /v "AppEnvironmentExtra" /f
REM 
timeout 3
goto :eof
