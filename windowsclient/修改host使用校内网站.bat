Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo 请使用右键管理员身份运行！&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
cd C:\Windows\System32\drivers\etc\
if exist hosts.bak (echo "曾经应用过，请点开还原后重试" & pause &exit)
copy hosts hosts.bak
echo 备份完成为hosts.bak
echo 10.1.10.253  www.bitunion.org >>hosts
echo 10.0.6.51  jwc.bit.edu.cn >>hosts
echo 10.102.50.253  9stars.org >>hosts
echo 10.4.51.158  bbs.century.bit.edu.cn >>hosts
echo 10.0.8.105  hq.bit.edu.cn >>hosts
echo 10.51.69.160  www.bitfx.org >>hosts
echo 10.133.21.233  bbs.bit.edu.cn >>hosts
ipconfig /flushdns
echo 修改完成
pause