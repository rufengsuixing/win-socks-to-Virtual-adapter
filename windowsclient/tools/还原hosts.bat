::权限检测
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(goto GetUAC)
Rd "%WinDir%\System32\test_permissions" 2>NUL
cd /d %WinDir%\System32\drivers\etc\
if not exist hosts.bak (echo "没有备份过" & pause &exit)
copy /y hosts.bak hosts
del hosts.bak
echo 还原完成
pause
exit
:GetUAC  
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"  
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"  
"%temp%\getadmin.vbs"  
exit /B  