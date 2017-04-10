@echo off
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo 请使用右键管理员身份运行！&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
:check
systeminfo>%~dp0tmpall.txt
::检测ipv6
for /f "tokens=*" %%a in ('findstr /r "200[0-9]:.*:.*:.*:.*:.*" %~dp0tmpall.txt') do (set ipv6=%%a )
if defined ipv6 goto ok
set qu=  
set /p qu= 貌似你没有ipv6，要尝试用么（y/n）
if /i "%qu%"=="y" goto ok
if /i "%qu%"=="n" exit
:ok
::检测tap驱动
for /f "tokens=1 delims=[] " %%a in ('find /n "TAP" %~dp0tmpall.txt') do (set wei=%%a)
if %wei%==---------- (
set qu=  
set /p qu= 貌似你没有安装驱动，要安装么（y/n）
if /i "%qu%"=="y" start "qudong" /WAIT %~dp0tap-windows-9.9.2_3.exe 
if not %errorlevel% == 0 (echo 请手动安装tap-windows-9.9.2_3.exe后继续 & pause & goto check)
if /i "%qu%"=="n" exit
)
::检测进程
tasklist|find /i "ShadowsocksR"
if %errorlevel% == 0 (taskkill /F /im ShadowsocksR*)
::读取ssr配置文件
for /f "tokens=1,2,3 delims=, " %%a in ('find /i "index" %~dp0gui-config.json') do (set ser=%%c)
::根据配置文件对应序号手动设置ipv4地址
::if "%ser%"=="0" (set server=*.*.*.*:7300)
::if "%ser%"=="1" (set server=*.*.*.*:7300)
::-----------------------------------------------
findstr /c:"Windows 10" %~dp0tmpall.txt
if %errorlevel% == 0 set sy=1
findstr /c:"Windows 8" %~dp0tmpall.txt
if %errorlevel% == 0 set sy=1
if defined sy (start %~dp0ShadowsocksR-dotnet4.0.exe) else start %~dp0ShadowsocksR-dotnet2.0.exe
::获取tap适配器名称
set "dnamet="
for /f "skip=%wei%  tokens=2* delims=:" %%a in (%~dp0tmpall.txt) do (if not defined dnamet set "dnamet=%%a")
for /f "tokens=* delims= " %%a in ("%dnamet%") do call :ie "%%a"
set dname="%var%"
::修改tap ip
netsh interface ipv4 add dns name=%dname% addr=8.8.8.8 index=1 validate=no
netsh interface ip set address name=%dname% source=static addr=192.168.222.1 mask=255.255.255.0
::启动tun2socks进程
start %~dp0badvpn-tun2socks --tundev tap0901:%dname%:192.168.222.1:192.168.222.0:255.255.255.0 --netif-ipaddr 192.168.222.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr %server% 
::获取主适配器名称
for /f "tokens=1 delims=:" %%a in ('findstr /n /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" %~dp0tmpall.txt') do (set wei2=%%a)
if not defined wei2 goto du
set /a wei2=%wei2% - 5
set "mainnamet="
for /f "skip=%wei2% tokens=2* delims=:" %%a in (%~dp0tmpall.txt) do (if not defined mainnamet set "mainnamet=%%a")
for /f "tokens=* delims= " %%a in ("%mainnamet%") do call :ie "%%a"
set mainname="%var%"
::修改主适配器dns
netsh interface ip set interface %mainname% ignoredefaultroutes=enabled
netsh interface ipv4 del dns name=%mainname% all
netsh interface ipv4 add dns name=%mainname% addr=8.8.8.8 index=1 validate=no
::获取gate（没考虑掩码）
for /f "tokens=2 delims=:" %%a in ('findstr /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" %~dp0tmpall.txt') do (set ip=%%a)
for /f "tokens=1,2 delims=. " %%a in ('echo %ip%') do (set gate=%%a.%%b.0.1)
::延时6秒
choice /t 6 /d y /n >nul
::设置路由
route delete 0.0.0.0
route add 10.0.0.0 mask 255.0.0.0 %gate% 
:du
route add 0.0.0.0 mask 0.0.0.0 192.168.222.2
echo 不要关新开的窗口哦
pause
exit 
::删除前后空格的函数
:ie str 
set "var=%~1"
if "%var:~-1%"==" "  call :ie "%var:~0,-1%"
