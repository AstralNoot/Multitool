@echo off
chcp 65001 >nul
title Software Launcher - Professional Edition

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process '%0' -Verb RunAs"
    exit /b
)

chcp 65001 >nul
cd /d "%USERPROFILE%\Downloads\Funny\Files"

call :CheckSoftware "Chrome" "https://dl.google.com/chrome/install/latest/chrome_installer.exe" "chrome_installer.exe" "C:\\Program Files\\Google\\Chrome\\Application"
call :CheckSoftware "Opera" "https://net.geo.opera.com/opera/stable/windows" "opera_installer.exe" "%LOCALAPPDATA%\\Programs\\Opera"
call :CheckSoftware "Everything" "https://www.voidtools.com/Everything-1.4.1.1024.x64-Setup.exe" "everything_installer.exe" "%PROGRAMFILES%\\Everything\\Everything.exe"
if not exist "Batch-main" (
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/AstralNoot/Batch/archive/refs/heads/main.zip' -OutFile 'Batch-main.zip'"
    powershell -Command "Expand-Archive -Path 'Batch-main.zip' -DestinationPath '.'"
    del "Batch-main.zip"
)

:MainMenu
cls
powershell -Command "Write-Host '███╗   ███╗██╗   ██╗██╗  ████████╗██╗' -ForegroundColor Green"
powershell -Command "Write-Host '████╗ ████║██║   ██║██║  ╚══██╔══╝██║' -ForegroundColor Green"
powershell -Command "Write-Host '██╔████╔██║██║   ██║██║     ██║   ██║' -ForegroundColor Green"
powershell -Command "Write-Host '██║╚██╔╝██║██║   ██║██║     ██║   ██║' -ForegroundColor Green"
powershell -Command "Write-Host '██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║' -ForegroundColor Green"
powershell -Command "Write-Host '╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝' -ForegroundColor Green"
echo.
echo ╔══════════════════════════════════════════╗
echo ║               L A U N C H E R            ║
echo ╠══════════════════════════════════════════╣
echo ║ 1. Chrome                                ║
echo ║ 2. Opera                                 ║
echo ║ 3. Everything (VoidTools)                ║
echo ║ 4. List Devices                          ║
echo ║ 5. Ping Server                           ║
echo ║ 6. Check Public IP                       ║
echo ║ 7. Website Status Checker                ║
echo ║ 8. Notepad++                             ║
echo ║ 9. Exit                                  ║
echo ╚══════════════════════════════════════════╝
echo.

set /p choice="Select an option: "

if "%choice%"=="1" start "" "%CD%\Chrome\chrome.exe"
if "%choice%"=="2" start "" "%CD%\Opera\opera.exe"
if "%choice%"=="3" start "" "%CD%\Everything\Everything.exe"
if "%choice%"=="4" call :ListDevices
if "%choice%"=="5" call :PingServer
if "%choice%"=="6" call :CheckPublicIP
if "%choice%"=="7" call :WebsiteStatus
if "%choice%"=="8" start "" "%CD%\Batch-main\Batch-main\notepad++.exe"
if "%choice%"=="9" exit

goto MainMenu

:CheckSoftware
if not exist %1 (
    echo Checking for %1...
    if exist "%~4" (
        echo %1 detected! Moving to Files\%1...
        mkdir %1
        xcopy "%~4" "%CD%\%1\" /E /H /C /I
        echo %1 moved successfully.
    ) else (
        echo %1 not installed. Downloading...
        powershell -Command "Invoke-WebRequest -Uri '%~2' -OutFile '%~3'"
        echo Installing %1...
        start /wait %~3 /silent /install
        mkdir %1
        xcopy "%~4" "%CD%\%1\" /E /H /C /I
        del %~3
        echo %1 installed successfully.
    )
) else (
    echo %1 is already installed.
)
exit /b

:ListDevices
cls
echo Scanning network for connected devices...
for /f "tokens=1" %%a in ('arp -a') do (
    echo Device IP: %%a
)
pause
exit /b

:PingServer
cls
echo Enter the web address to ping (e.g., www.google.com):
set /p web_address=Web address: 
ping %web_address% -n 1
pause
exit /b

:CheckPublicIP
cls
echo Checking your public IP address...
powershell -Command "(Invoke-WebRequest -Uri 'https://api64.ipify.org').Content"
pause
exit /b

:WebsiteStatus
cls
echo Enter website URL to check (e.g., https://www.google.com):
set /p site_url=Website URL: 
powershell -Command "(Invoke-WebRequest -Uri '%site_url%' -UseBasicParsing).StatusCode"
pause
exit /b
