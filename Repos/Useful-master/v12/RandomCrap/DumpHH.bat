@echo off

color F9
title HeX's Dumper :D
echo.
echo HeX's Dumper!
echo.
rem pause

if exist "dump.lua" del "dump.lua"

color 0e
wget "SomeURLWasHere.com/file.lua" -U "Googlebot" -O "dump.lua"


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



if exist "dump.lua" (
	if exist "Dump.%Stamp%.lua" (
		del "Dump.%Stamp%.lua"
	)
	ren "dump.lua" "Dump.%Stamp%.lua"
	
	color 0a
	echo.
	echo All done, "Dump.%Stamp%.lua" is awating your attention!
	echo.
	
	) else (
	color 0c
	echo.
	echo "dump.lua" not found, HTTP error?
	echo.
)


rem pause
exit


