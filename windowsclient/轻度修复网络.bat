@echo off
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo 请使用右键管理员身份运行！&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
NETSH WINHTTP RESET PROXY
cd "%~dp0"
::systeminfo>tmpall.txt
::for /f "tokens=2 delims=:" %%a in ('findstr /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" tmpall.txt') do (set ip=%%a)
::if not defined ip ipconfig /renew &echo 请连接校园网后开始或者使用强力修复 & pause & exit
::获取主适配器名称
::for /f "tokens=1 delims=:" %%a in ('findstr /n /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" tmpall.txt') do (set wei2=%%a)
::if not defined wei2 goto du
::set /a wei2=%wei2% - 4
::for /f "tokens=1 delims=:" %%a in ('findstr /n /r "\[[0-9][0-9]\]" tmpall.txt') do (if %%a==%wei2% set cut=1)
::if not "1"=="%cut%" set /a wei2=%wei2%-1
::set "mainnamet="
::for /f "skip=%wei2% tokens=2* delims=:" %%a in (tmpall.txt) do (if not defined mainnamet set "mainnamet=%%a")
::for /f "tokens=* delims= " %%a in ("%mainnamet%") do call :ie "%%a"
::set mainname="%var%"
::netsh interface ip set interface %mainname% ignoredefaultroutes=disabled
::netsh interface ip set dns name=%mainname% source=dhcp
::netsh interface ip set address name=%mainname% source=dhcp
::获取gate（route方式）
::for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<0.0.0.0\>"') do (if not %%a==192.168.222.2 set gate=%%a)
::获取所有适配器（中文）
::for /f "tokens=2* delims=器:" %%a in ('ipconfig ^| findstr "器.* :$"') do (echo %%a>>shipei.txt)
route delete 10.0.0.0 mask 255.0.0.0
::获取所有适配器(兼容)
for /f "skip=3 tokens=3,* delims= " %%a in ('netsh interface show interface') do (echo "%%b">>shipei.txt)
::for /f "skip=3 tokens=3,* delims= " %%a in ('netsh interface show interface') do call :qukong "%%b" )
for /f "tokens=* delims= " %%a in (shipei.txt)do (netsh interface ip set address name=%%a source=dhcp)
for /f "tokens=* delims= " %%a in (shipei.txt)do (netsh interface ip set dns name=%%a source=dhcp)
del shipei.txt
ipconfig /renew
echo 如果没有修复使用强力修复
pause
exit
::删除前后空格的函数
:ie str
set "var=%~1"
if "%var:~-1%"==" "  call :ie "%var:~0,-1%"
goto :eof
::qukong str
::set "var=%~1"
::set "var=%var:~0,-1%"
::echo %var%>>shipei.txt
