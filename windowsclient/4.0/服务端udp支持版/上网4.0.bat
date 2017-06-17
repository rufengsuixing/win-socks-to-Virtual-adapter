cd /d "%~dp0"
for /f "tokens=*" %%a in (tapname) do (set "dname=%%a" )

for /f %%a in ('tasklist^|find /i /c "ShadowsocksR"') do (set ssr=%%a)
if %ssr%==2 goto :next
if %ssr%==1 taskkill /f /im ShadowsocksR* & echo 主程序出错正在结束重开

for /f "tokens=*" %%a in (sy) do (set "sy=%%a" )
if %sy%=="1" (start ShadowsocksR-dotnet4.0.exe) else start ShadowsocksR-dotnet2.0.exe

:next
start /min "" badvpn-tun2socks --tundev tap0901:%dname%:192.168.222.1:192.168.222.0:255.255.255.0 --netif-ipaddr 192.168.222.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 192.168.221.100:7300 --loglevel 3