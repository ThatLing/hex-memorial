@echo off
title MFSiNC's ChatFilter List Copier :D
color 0c
echo.


set Root=C:\Documents and Settings\User\Desktop\mfsinc.googlecode.com
set SimpleFilter=%Root%\SimpleFilter\lua
set HSP=%Root%\HeX's Server Plugins\addons\HeX's Server Plugins\lua\HSP\ChatFilter
set DeX=%Root%\DeX


set Server=192.168.0.8
set GMod=\\%Server%\garrysmod\addons\HeX's Server Plugins\lua\HSP\ChatFilter


ping %Server% -n 2 -w 300 >nul
if ERRORLEVEL 1 (
	echo GMod server offline, can't do anything :(
	sleep 1
	exit
)

set Done=false



::SimpleFilter
if exist "%SimpleFilter%" (
	echo [SimpleFilter]
	if exist "%GMod%\sv_f_List.lua" (
		del "%SimpleFilter%\sv_f_List.lua"
		copy "%GMod%\sv_f_List.lua" "%SimpleFilter%\sv_f_List.lua"
		set Done=true
	) else (
		echo [SimpleFilter] No sv_f_List.lua
		sleep 1
	)
	
	
	if exist "%GMod%\sv_f_Crap.lua" (
		del "%SimpleFilter%\sv_f_Crap.lua"
		copy "%GMod%\sv_f_Crap.lua" "%SimpleFilter%\sv_f_Crap.lua"
		set Done=true
	) else (
		echo No sv_f_Crap.lua
		sleep 1
	)
	
) else (
	echo.
	echo No SimpleFilter!
	sleep 1
)


echo.


::DeX
if exist "%DeX%" (
	echo [DeX]
	if exist "%GMod%\sv_f_List.lua" (
		del "%DeX%\sv_f_List.lua"
		copy "%GMod%\sv_f_List.lua" "%DeX%\sv_f_List.lua"
		set Done=true
	) else (
		echo [DeX] No sv_f_List.lua
		sleep 1
	)
	
	
	if exist "%GMod%\sv_f_Crap.lua" (
		del "%DeX%\sv_f_Crap.lua"
		copy "%GMod%\sv_f_Crap.lua" "%DeX%\sv_f_Crap.lua"
		set Done=true
	) else (
		echo No sv_f_Crap.lua
		sleep 1
	)
	
) else (
	echo.
	echo No DeX!
	sleep 1
)



echo.


::HSP
if exist "%HSP%" (
	echo [HSP]
	if exist "%GMod%\sv_f_List.lua" (
		del "%HSP%\sv_f_List.lua"
		copy "%GMod%\sv_f_List.lua" "%HSP%\sv_f_List.lua"
		set Done=true
	) else (
		echo No sv_f_List.lua
		sleep 1
	)
	
	
	if exist "%GMod%\sv_f_Crap.lua" (
		del "%HSP%\sv_f_Crap.lua"
		copy "%GMod%\sv_f_Crap.lua" "%HSP%\sv_f_Crap.lua"
		set Done=true
	) else (
		echo [HSP] No sv_f_Crap.lua
		sleep 1
	)
	
) else (
	echo.
	echo No HSP!
	sleep 1
)


if %Done% == true (
	color 0a
	sleep 2
) else (
	pause
)

exit














