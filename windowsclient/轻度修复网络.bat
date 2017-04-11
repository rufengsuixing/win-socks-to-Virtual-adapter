@echo off
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo 请使用右键管理员身份运行！&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
NETSH WINHTTP RESET PROXY
cd "%~dp0"
systeminfo>tmpall.txt
for /f "tokens=2 delims=:" %%a in ('findstr /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" tmpall.txt') do (set ip=%%a)
if not defined ip echo 请连接校园网后开始或者使用强力修复 & pause & exit
::获取主适配器名称
for /f "tokens=1 delims=:" %%a in ('findstr /n /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" tmpall.txt') do (set wei2=%%a)
if not defined wei2 goto du
set /a wei2=%wei2% - 5
set "mainnamet="
for /f "skip=%wei2% tokens=2* delims=:" %%a in (tmpall.txt) do (if not defined mainnamet set "mainnamet=%%a")
for /f "tokens=* delims= " %%a in ("%mainnamet%") do call :ie "%%a"
set mainname="%var%"
netsh interface ip set interface %mainname% ignoredefaultroutes=disabled
netsh interface ip set dns name=%mainname% source=dhcp
netsh interface ip set address name=%mainname% source=dhcp
ipconfig /renew
echo 如果没有修复使用强力修复
pause
exit
::删除前后空格的函数
:ie str
set "var=%~1"
if "%var:~-1%"==" "  call :ie "%var:~0,-1%"
