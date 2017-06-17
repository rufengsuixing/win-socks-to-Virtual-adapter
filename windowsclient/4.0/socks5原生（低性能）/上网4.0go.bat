@echo off
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(goto GetUAC)
Rd "%WinDir%\System32\test_permissions" 2>NUL

cd /d "%~dp0"
for /f "tokens=*" %%a in (tapname) do (set "dname=%%a" )

for /f %%a in ('tasklist^|find /i /c "ShadowsocksR"') do (set ssr=%%a)
if %ssr%==2 goto :next
if %ssr%==1 taskkill /f /im ShadowsocksR* & echo 主程序出错正在结束重开

for /f "tokens=*" %%a in (sy) do (set "sy=%%a" )
if %sy%=="1" (start ShadowsocksR-dotnet4.0.exe) else start ShadowsocksR-dotnet2.0.exe

:next
start /min "" gotun2socks -enable-dns-cache -tun-address 192.168.222.1 -tun-gw 192.168.222.2 -tun-mask 255.255.255.0

netsh interface ipv4 set interface interface=%dname%  metric=1
netsh interface ipv4 add dns name=%dname% addr=8.8.8.8 index=1 validate=no
netsh interface ip set address name=%dname% source=static addr=192.168.222.1 mask=255.255.255.0 gateway=192.168.222.2


:GetUAC  
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"  
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"  
"%temp%\getadmin.vbs"  
exit /B