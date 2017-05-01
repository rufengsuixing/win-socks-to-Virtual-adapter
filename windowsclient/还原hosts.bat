Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo 请使用右键管理员身份运行！&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
cd C:\Windows\System32\drivers\etc\
if not exist hosts.bak (echo "没有备份过" & pause &exit)
copy /y hosts.bak hosts
echo 还原完成
pause
exit