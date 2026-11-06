@echo off
rem Time sync setup (does NOT change time zone). Run as Administrator.
net session >nul 2>&1
if errorlevel 1 (
  echo Need Administrator rights: right click - Run as administrator.
  pause
  exit /b 1
)
sc config w32time start= auto
net start w32time
w32tm /config /manualpeerlist:"time.windows.com,0x9 time.google.com,0x9 pool.ntp.org,0x9" /syncfromflags:manual /reliable:yes /update
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient" /v SpecialPollInterval /t REG_DWORD /d 600 /f
net stop w32time
net start w32time
schtasks /create /tn "gc_time_sync" /tr "w32tm /resync /force" /sc minute /mo 10 /ru SYSTEM /f
w32tm /resync /force
echo.
w32tm /query /status
echo.
echo DONE. Time will sync every 10 minutes.
pause
