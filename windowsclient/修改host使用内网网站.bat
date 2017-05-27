::权限检测
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(goto GetUAC)
Rd "%WinDir%\System32\test_permissions" 2>NUL
cd /d %WinDir%\System32\drivers\etc\
if exist hosts.bak (echo "曾经应用过，请点开还原后重试" & pause &exit)
copy hosts hosts.bak
echo 备份完成为hosts.bak
cd /d "%~dp0"
if not exist result.txt (echo 请先生成result & pause & exit)
for /f "tokens=1,2 delims= " %%a in (result.txt) do (echo %%a %%b>>%WinDir%\System32\drivers\etc\hosts)
ipconfig /flushdns
echo 修改完成
pause
exit
:GetUAC  
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"  
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"  
"%temp%\getadmin.vbs"  
exit /B  