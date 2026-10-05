@ECHO OFF
PUSHD "%~dp0"

echo ==========================================
echo 1. CONFIGURING SECURE DNS (CLOUDFLARE)
echo ==========================================
echo Changing DNS to 1.1.1.1...
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Set-DnsClientServerAddress -ServerAddresses '1.1.1.1','1.0.0.1'"

echo Disabling IPv6 to prevent ISP interference...
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Get-NetAdapterBinding -ComponentID ms_tcpip6 | Disable-NetAdapterBinding"

echo Flushing DNS cache...
C:\Windows\System32\ipconfig.exe /flushdns

echo.
echo ==========================================
echo 2. INSTALLING GOODBYEDPI SERVICE
echo ==========================================
echo Removing existing service (if any)...
C:\Windows\System32\sc.exe stop "GoodbyeDPI"
C:\Windows\System32\sc.exe delete "GoodbyeDPI"

echo.
echo Setting up new service...
set _arch=x86
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set _arch=x86_64)
if defined PROCESSOR_ARCHITEW6432 (set _arch=x86_64)
echo Detected architecture: %_arch%
C:\Windows\System32\sc.exe create "GoodbyeDPI" binPath= "\"%~dp0%_arch%\goodbyedpi.exe\" -9 --blacklist \"%~dp0blacklist.txt\" --dns-addr 1.1.1.1 --dns-port 53" start= auto

C:\Windows\System32\sc.exe description "GoodbyeDPI" "Bypass DPI"
C:\Windows\System32\sc.exe start "GoodbyeDPI"

echo.
echo ==========================================
echo FINISHED!
echo ==========================================
pause