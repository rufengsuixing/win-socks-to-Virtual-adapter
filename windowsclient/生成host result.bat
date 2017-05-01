
cd "%~dp0"
for /f tokens^=3^ delims^=^/^" %%a in ('findstr "http://" source.txt') do (call :x1 %%a)

:x1
set "ip="
for /f "tokens=2 delims=: " %%a in ('nslookup %~1 10.0.0.11 ^| findstr "Address:"') do (if not %%a==10.0.0.11 set ip=%%a)
if "%ip:~0,3%"=="10." echo %ip%  %~1>>result.txt