@echo off
color 0e
title HeX's GModMenu backup-er :D
echo.
echo HeX's GModMenu backup-er!
echo.


set SaveTo=C:\Documents and Settings\Administrator\Desktop\Vercas - GMod Menu
set Dropbox=C:\srcds\orangebox\garrysmod\My Dropbox


if not exist "%SaveTo%" (
	color 0c
	echo.
	echo "%SaveTo%" not found
	echo.
	pause
	exit
)
if not exist "C:\Program Files\7-Zip\7z.exe" (
	color 0c
	echo.
	echo "C:\Program Files\7-Zip\7z.exe" not found
	echo.
	pause
	exit
)
if not exist "%SaveTo%\list.lua" (
	color 0c
	echo.
	echo "%SaveTo%\list.lua" not found
	echo.
	pause
	exit
)



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
for /F "tokens=1-4 delims=/:. " %%J IN ("%time%") DO SET TheTime=%%J.%%K
set TheDate=%dd%-%mm%-%yy%
rem set Stamp=%TheDate%_%TheTime%




cd "%SaveTo%"
if exist "gm_backup.7z" del "gm_backup.7z"
if not exist "%TheDate%" mkdir "%TheDate%"


7z -t7z a "%SaveTo%\gm_backup.7z" "%Dropbox%\GMod Menu\" -mx9 -xr@"%SaveTo%\list.lua" -ms=on -mmt
rem 7z -t7z a "%SaveTo%\gm_backup.7z" "%Dropbox%\GMod Menu\" -mx9 -xr!*.png -ms=on -mmt



if exist "%TheDate%\GModMenu.%TheTime%.7z" (
	del "%TheDate%\GModMenu.%TheTime%.7z"
)

if exist "gm_backup.7z" (
	move "gm_backup.7z" "%TheDate%\GModMenu.%TheTime%.7z"
	
	color 0a
	echo.
	echo All done, "%TheDate%\GModMenu.%TheTime%.7z" is awating your attention!
	echo.
	
	) else (
	color 0c
	echo.
	echo "gm_backup.7z" not found?
	echo.
)



rem pause
exit








