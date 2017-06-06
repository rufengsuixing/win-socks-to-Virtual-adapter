set dnsserver=10.0.0.12
cd "%~dp0"
if not exist source.txt (echo 请先复制内网导航页源文件码到source.txt & pause & exit)
for /f tokens^=3^ delims^=^/^"^: %%a in ('findstr "http://" source.txt') do (echo %%a &call :x1 %%a)
pause
:x1
if "%~1"=="" goto :EOF
for /f "tokens=2 delims= " %%a in (result.txt) do (if "%%a"=="%~1" goto :EOF)
set "ip="
for /f "tokens=2 delims=: " %%a in ('nslookup %~1 %dnsserver% ^| findstr "Address:"') do (if not "%%a"=="%dnsserver%" set ip=%%a)
if "%ip%"=="" goto :EOF
if "%ip:~0,3%"=="10." echo %ip%  %~1>>result.txt
