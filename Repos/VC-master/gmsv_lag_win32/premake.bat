
start /W clean.bat

premake5 --os=windows --file=premake5.lua vs2010

if ERRORLEVEL 1 (
	pause
)