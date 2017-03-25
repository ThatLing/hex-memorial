@echo off
color F9
title HeX's GModMenu backup-er :D
echo.
echo HeX's GModMenu backup-er!
echo.


set SaveTo=C:\Documents and Settings\Administrator\Desktop\GONE
set Dropbox=C:\srcds\orangebox\garrysmod\My Dropbox
set Data=C:\srcds\orangebox\garrysmod\data



if not exist "%SaveTo%" (
	color 0c
	echo.
	echo %SaveTo% not found
	echo.
	pause
	exit
)
if not exist "C:\Program Files\7-Zip\7z.exe" (
	color 0c
	echo.
	echo 7z.exe not found
	echo.
	pause
	exit
)


echo [GMBackup] Running..>>"%Data%\hsp_cron_tmp.txt"


color 0e
cd "%SaveTo%"
if exist "gm_backup.7z" del "gm_backup.7z"

rem 7z -t7z a "%SaveTo%\gm_backup.7z" "%Dropbox%\GONE\" -mx9 -xr@"%List%" -ms=on -mmt
7z -t7z a "%SaveTo%\gm_backup.7z" "%Dropbox%\GONE\" -mx9 -xr!*.png -ms=on -mmt


rem Urrgh
for /f "skip=1 tokens=2-4 delims=(-)" %%a in ('echo.^|date') do (
	set A=%%a&set B=%%b&set C=%%c
)
set t=2&if "%date%z" LSS "A" set t=1

for /f "skip=1 tokens=2-4 delims=(-)" %%a in ('echo.^|date') do (
	for /f "tokens=%t%-4 delims=.-/ " %%d in ('date/t') do (
		set dd=%%d&set mm=%%e&set yy=%%f
	)
)
for /F "tokens=1-4 delims=/:. " %%J IN ("%time%") DO SET thetime=%%J.%%K
set Stamp=%dd%-%mm%-%yy%_%thetime%



if exist "GModMenu.%Stamp%.7z" (
	del "GModMenu.%Stamp%.7z"
)

if exist "gm_backup.7z" (
	ren "gm_backup.7z" "GModMenu.%Stamp%.7z"
	
	color 0a
	echo [GMBackup] Complete!>>"%Data%\hsp_cron_tmp.txt"
	echo.
	echo All done, "GModMenu.%Stamp%.7z" is awating your attention!
	echo.
	
	) else (
	color 0c
	echo.
	echo "gm_backup.7z" not found?
	echo.
)



rem pause
exit








