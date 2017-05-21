::权限检测
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(goto GetUAC)
Rd "%WinDir%\System32\test_permissions" 2>NUL
NETSH WINHTTP RESET PROXY
cd /d "%~dp0"
route delete 10.0.0.0 mask 255.0.0.0
::获取所有适配器(兼容)
for /f "skip=3 tokens=3,* delims= " %%a in ('netsh interface show interface') do (echo "%%b">>shipei.txt)
for /f "tokens=* delims= " %%a in (shipei.txt)do (netsh interface ip set address name=%%a source=dhcp)
for /f "tokens=* delims= " %%a in (shipei.txt)do (netsh interface ip set dns name=%%a source=dhcp)
del shipei.txt
ipconfig /renew
echo 如果没有修复使用强力修复
pause
exit
:GetUAC  
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"  
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"  
"%temp%\getadmin.vbs"  
exit /B  




