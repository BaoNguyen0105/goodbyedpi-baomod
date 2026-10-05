@ECHO OFF
PUSHD "%~dp0"

echo ==========================================
echo REMOVING GOODBYEDPI SERVICE & RESTORING DNS
echo ==========================================
echo Stopping and deleting GoodbyeDPI service...
C:\Windows\System32\sc.exe stop "GoodbyeDPI"
C:\Windows\System32\sc.exe delete "GoodbyeDPI"

echo.
echo Re-enabling IPv6 (Optional)...
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Get-NetAdapterBinding -ComponentID ms_tcpip6 | Enable-NetAdapterBinding"

echo.
echo Clearing DNS cache...
C:\Windows\System32\ipconfig.exe /flushdns

echo.
echo ==========================================
echo REMOVAL COMPLETED!
echo ==========================================
pause