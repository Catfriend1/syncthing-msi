@echo off
setlocal enabledelayedexpansion
REM
REM Remove Browser Managed Bookmarks
REG DELETE "HKCU\SOFTWARE\Policies\Google\Chrome" /v "ManagedBookmarks" /f 2>&1 | find /i "erfolg"
REG DELETE "HKCU\SOFTWARE\Policies\Microsoft\Edge" /v "ManagedFavorites" /f 2>&1 | find /i "erfolg"
REG DELETE "HKCU\Software\Policies\Mozilla\Firefox" /v "ManagedBookmarks" /f 2>&1 | find /i "erfolg"
REM
goto :eof
