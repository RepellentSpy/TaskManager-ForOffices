@echo off

:start
title Task Manager for Offices

echo Task Manager for Offices
echo ------------------------
echo.
echo 1.) Kill Task
echo 2.) Change Task Priority
echo 3.) Restart Windows Explorer
echo 4.) Component Usage and Monitoring
echo.
choice /c 1234 /n /m "Enter chosen action: "

if %errorlevel% == 1 goto kill
if %errorlevel% == 2 goto priority
if %errorlevel% == 3 goto explorer
if %errorlevel% == 4 goto usage


:usage
cls
echo Component Usage
echo ---------------
echo.
echo Processor:
wmic cpu get loadpercentage
echo Memory:
systeminfo | findstr /C:"Total Physical Memory"
systeminfo |find "Available Physical Memory"
echo.
echo Free Disk Space:
dir|find "bytes free"
echo.
echo Network
echo 1.) Monitor Outgoing Packets
echo 2.) Available Bandwidth
echo 3.) Go Back

choice /c 123 /n /m "Enter chosen action: "

if %errorlevel% == 1 (goto packets) else exit
if %errorlevel% == 2 (goto bandwidth) else exit
if %errorlevel% == 3 goto start
pause
exit

:packets
cls
echo Outgoing Packets Monitoring
echo ---------------------------
echo CTRL+C to end
echo.
typeperf "Network Interface(*)\Packets sent/sec"
echo Monitorovani odchozich paketu bylo preruseno
pause >NUL
goto start

:bandwidth         // broken
cls
echo Available Bandwidth
echo -------------------
echo CTRL+C to end
typeperf "Network Interface(*)\Current Bandwidth"
pause >NUL
goto start

:explorer
taskkill /IM explorer.exe /f && start explorer.exe || goto explorererror
echo Windows Explorer has been restarted
pause
goto start

:explorererror
echo ERROR: Failed to restart Windows Explorer
pause
exit

:kill
cls
echo Kill Task
echo ---------
echo.
SET /p programname="Task name + file type (e.g. explorer.exe): "
taskkill /IM %programname% /f || goto error
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Info', 'Task %programname% byla uspesne vypnuta', [System.Windows.Forms.ToolTipIcon]::None)}"
pause
exit

:error
color 04
echo.
echo ERROR: Failed to kill %programname%. It either isn't currently opened or doesn't exist
echo.
pause
goto start

:priority
SET /a realtime=256
SET /a high=128
SET /a abovenormal=32768
SET /a normal=32
SET /a belownormal=16384
SET /a low=64

cls
echo Zmenit prioritu ulohy
echo --------------------------
echo.
SET /p programname="Task name + file type (e.g. explorer.exe): "
echo.
echo Choose New Priority for %programname%: Realtime, High, Above, Normal, Below, Low
echo.
SET /p prioritylevel="Chosen priority: "
IF %prioritylevel% == realtime goto realtimewarning
IF %prioritylevel% == high goto high
IF %prioritylevel% == above goto abovenormal
IF %prioritylevel% == normal goto normal
IF %prioritylevel% == below goto belownormal
IF %prioritylevel% == low goto low
IF %prioritylevel% == Realtime goto realtimewarning
IF %prioritylevel% == High goto high
IF %prioritylevel% == Above goto abovenormal
IF %prioritylevel% == Normal goto normal
IF %prioritylevel% == Below goto belownormal
IF %prioritylevel% == Low goto low
pause
exit

:realtimewarning
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Setting a task to the realtime priority can cause Windows to become unstable. Are you sure?', 'Priority Warning', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %TEMP%\out.tmp
set /p OUT=<%TEMP%\out.tmp
IF %OUT%==Yes (goto realtime)
IF %OUT%==No (goto cancel)

:cancel
cls
color 04
echo Process terminated by user
pause
exit

:realtime
wmic process where name="%programname%" call setpriority %realtime%
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Info', 'Task %programname% set to %prioritylevel%', [System.Windows.Forms.ToolTipIcon]::None)}"
pause
exit

:high
wmic process where name="%programname%" call setpriority %high%
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Info', 'Task %programname% set to %prioritylevel%', [System.Windows.Forms.ToolTipIcon]::None)}"
pause
exit

:abovenormal
wmic process where name="%programname%" call setpriority %abovenormal%
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Info', 'Task %programname% set to %prioritylevel%', [System.Windows.Forms.ToolTipIcon]::None)}"
pause
exit

:normal
wmic process where name="%programname%" call setpriority %normal%
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Info', 'Task %programname% set to %prioritylevel%', [System.Windows.Forms.ToolTipIcon]::None)}"
pause
exit

:belownormal
wmic process where name="%programname%" call setpriority %belownormal%
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Info', 'Task %programname% set to %prioritylevel%', [System.Windows.Forms.ToolTipIcon]::None)}"
pause
exit

:low
wmic process where name="%programname%" call setpriority %low%
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Info', 'Task %programname% set to %prioritylevel%', [System.Windows.Forms.ToolTipIcon]::None)}"
pause
exit