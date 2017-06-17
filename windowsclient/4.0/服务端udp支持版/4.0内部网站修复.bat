Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(goto GetUAC)
Rd "%WinDir%\System32\test_permissions" 2>NUL

for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<0.0.0.0\>"') do (if not %%a==192.168.222.2 set gate=%%a)
route add 10.0.0.0 mask 255.0.0.0 %gate%
exit
:GetUAC  
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"  
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"  
"%temp%\getadmin.vbs"  
exit /B  