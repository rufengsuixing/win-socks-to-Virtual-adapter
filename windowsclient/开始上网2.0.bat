@echo off
::权限检测
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo 请使用右键管理员身份运行！&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
cd /d "%~dp0"
if exist tmp.pid echo "上次没有正常关闭（关机等方式），出现问题请使用轻度修复"
::守护跳转
if "%1"=="h" goto begin
set count=1
:check
systeminfo>tmpall.txt
::连线检测(中文可去，只出现一次)
for /f "tokens=2" %%a in ('netsh interface show interface') do (if %%a==已连接 set net=1)
if not “%net%”==“1” (
echo “请检查网络是否连接或你是英文系统”
pause
systeminfo>tmpall.txt
)
::检测ipv6
for /f "tokens=*" %%a in ('findstr /r "200[0-9]:.*:.*:.*:.*:.*" tmpall.txt') do (set ipv6=%%a )
if defined ipv6 goto ok
echo 貌似你没有ipv6，正在尝试重新获取第%count%次
start ipconfig /renew6
choice /t 3 /d y /n >nul
set /a count=%count% + 1
if %count%==5 (echo 无法自动获取ipv6 请检查是不是有ipv6环境 & pause & exit)
goto check
:ok
::检测tap驱动
for /f "tokens=1 delims=[] " %%a in ('find /n "TAP-Windows" tmpall.txt') do (set wei=%%a)
if %wei%==---------- call :checkd&&goto check
::检测进程
tasklist|find /i "gotun2socks"
if %errorlevel% == 0 (echo 程序已经在运行中&pause&exit)
tasklist|find /i "ShadowsocksR"
if %errorlevel% == 0 (goto ssr)
findstr /c:"Windows 10" tmpall.txt
if %errorlevel% == 0 set sy=1
findstr /c:"Windows 8" tmpall.txt
if %errorlevel% == 0 set sy=1
if defined sy (start ShadowsocksR-dotnet4.0.exe) else start ShadowsocksR-dotnet2.0.exe
:ssr
::获取tap适配器名称
set "dnamet="
for /f "skip=%wei%  tokens=2* delims=:" %%a in (tmpall.txt) do (if not defined dnamet set "dnamet=%%a")
for /f "tokens=* delims= " %%a in ("%dnamet%") do call :ie "%%a"
set dname="%var%"
echo %dname%
::启动gotun2socks进程
start gotun2socks -enable-dns-cache -tun-address 192.168.222.1 -tun-gw 192.168.222.2 -tun-mask 255.255.255.0
::修改tap ip
choice /t 1 /d y /n >nul
netsh interface ipv4 add dns name=%dname% addr=8.8.8.8 index=1 validate=no
netsh interface ip set address name=%dname% source=static addr=192.168.222.1 mask=255.255.255.0
::获取主适配器名称和网卡名称第一二个单词（ipv6）
for /f "tokens=1,2 delims=:[] " %%a in ('findstr /n /r "200[0-9]:.*:.*:.*:.*:.*" tmpall.txt') do (set wei2=%%a&set minus=%%b)
if not defined wei2 goto du
set /a wei2=%wei2%-%minus%-3
for /f "tokens=1 delims=:" %%a in ('findstr /n /r "\[[0-9][0-9]\]" tmpall.txt') do (if %%a==%wei2% set cut=1)
if not "1"=="%cut%" set /a wei2=%wei2%-1
set "mainnamet="
for /f "skip=%wei2% tokens=2* delims=:" %%a in (tmpall.txt) do (if not defined mainnamet set "mainnamet=%%a")
for /f "tokens=* delims= " %%a in ("%mainnamet%") do call :ie "%%a"
set mainname="%var%"
set /a wei2=%wei2%-1
set "mainnamef="
for /f "skip=%wei2% tokens=2,3 delims=: " %%a in (tmpall.txt) do (if not defined mainnamef set "mainnamef=%%a %%b")
echo %mainnamef%
::修改主适配器dns
::netsh interface ip set interface %mainname% ignoredefaultroutes=enabled
netsh interface ipv4 del dns name=%mainname% all
netsh interface ipv4 add dns name=%mainname% addr=8.8.8.8 index=1 validate=no
ipconfig /flushdns
::意外关闭
echo %mainname%>tmp.pid
:getgate
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<0.0.0.0\>"') do (if not %%a==192.168.222.2 set gate=%%a)
if not defined gate (call :a1)
for /f "tokens=1 delims=." %%a in ('route print ^| findstr "TAP-Windows"') do (set ift=%%a)
for /f "tokens=1 delims=." %%a in ('route print ^| findstr "%mainnamef%"') do (set iff=%%a)
::make sure
if "%ift%"=="" echo 失败 & goto getgate
if "%iff%"=="" echo 失败 & goto getgate
::echo %ift%>chuanift.txt
::echo %iff%>chuaniff.txt
::延时6秒
choice /t 6 /d y /n >nul
::设置路由
route delete 0.0.0.0
route add 10.0.0.0 mask 255.0.0.0 %gate% if %iff%
:du
if not defined wei2 choice /t 6 /d y /n >nul
route add 0.0.0.0 mask 0.0.0.0 192.168.222.2 if %ift%
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<192.168.222.2\>"') do (if "%%a"=="" route add 0.0.0.0 mask 0.0.0.0 192.168.222.2 if %ift%)
::if not defined gate exit
::守护进程（隐藏窗口,不喜可以注释掉下面一行）
start mshta vbscript:createobject("wscript.shell").run("""%~nx0"" h",0)(window.close)&&exit
:begin
:begin2
::以下为正常批处理命令，不可含有pause set/p等交互命令
::检测进程
choice /t 10 /d y /n >nul
tasklist|find /i "gotun2socks"
if not %errorlevel% == 0 (
call :fix
exit
)
set "gate="
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<0.0.0.0\>"') do (if not %%a==192.168.222.2 set gate=%%a)
if defined gate (call :resetgate)
for /f "tokens=2 delims=(%%" %%a in ('ping -6 ipv6.baidu.com') do (if "%%a"=="100" ipconfig /renew6)
choice /t 10 /d y /n >nul
goto begin2

:fix
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<10.0.0.0\>"') do (set gate=%%a)
route add 0.0.0.0 mask 0.0.0.0 %gate% if %iff%
route delete 10.0.0.0 mask 255.0.0.0 %gate%
netsh interface ip set dns name=%mainname% source=dhcp
netsh interface ip set address name=%mainname% source=dhcp
del tmp.pid
start ipconfig /renew
goto :EOF
::删除前后空格的函数

:ie str 
set "var=%~1"
if "%var:~-1%"==" "  call :ie "%var:~0,-1%"
goto :EOF

:checkd
set qu=  
set /p qu= 貌似你没有安装驱动，要安装么,多次重复请手动安装tap-windows（y/n）
if /i "%qu%"=="y" start /w "" tap-windows-9.9.2_3.exe 
if not %errorlevel% == 0 (echo 请手动安装tap-windows-9.9.2_3.exe后继续 & pause)
if /i "%qu%"=="n" exit
goto :EOF

:a1
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<10.0.0.0\>"') do (set gate=%%a)
goto :EOF

:resetgate
route delete 0.0.0.0 mask 0.0.0.0 %gate%
route delete 10.0.0.0 mask 255.0.0.0
route add 10.0.0.0 mask 255.0.0.0 %gate% if %iff%
goto :EOF