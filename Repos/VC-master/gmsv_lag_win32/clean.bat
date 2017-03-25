@echo off

echo.
echo ARE YOU SURE?
echo.
pause

if not exist premake5.exe (
	echo.
	echo FAIL
	pause
	exit
)


del *.sln
del *.sdf
del *.vcxproj
del *.vcxproj.user
del *.vcxproj.filters

attrib -H *.suo
del *.suo

rd /S /Q "ipch"
rd /S /Q "obj"

rd /S /Q "Release"

exit