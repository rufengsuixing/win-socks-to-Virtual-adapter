@echo off
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(goto GetUAC)
Rd "%WinDir%\System32\test_permissions" 2>NUL

cd /d "%~dp0"
systeminfo>tmpall.txt

set sy="1"
findstr /c:"Windows 10" tmpall.txt || findstr /c:"Windows 8" tmpall.txt || set sy="0"
echo %sy%>sy

:next
::检测安装tap驱动
for /f "tokens=1 delims=[] " %%a in ('find /n "TAP-Windows" tmpall.txt') do (set wei=%%a)
if "%wei%"=="----------" start /w "" tap-windows-9.9.2_3.exe || (echo 请手动安装tap-windows-9.9.2_3.exe后继续 & pause)


::获取tap适配器名称
set "dnamet="
for /f "skip=%wei%  tokens=2* delims=:" %%a in (tmpall.txt) do (if not defined dnamet set "dnamet=%%a")
for /f "tokens=* delims= " %%a in ("%dnamet%") do call :ie "%%a"
set dname="%var%"

echo %dname%>tapname
netsh interface ipv4 set interface interface=%dname%  metric=1
netsh interface ipv4 add dns name=%dname% addr=8.8.8.8 index=1 validate=no
netsh interface ip set address name=%dname% source=static addr=192.168.222.1 mask=255.255.255.0 gateway=192.168.222.2
del tmpall.txt
echo 安装完成
pause
exit

:ie str 
set "var=%~1"
if "%var:~-1%"==" "  call :ie "%var:~0,-1%"
goto :EOF

:GetUAC  
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"  
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"  
"%temp%\getadmin.vbs"  
exit /B