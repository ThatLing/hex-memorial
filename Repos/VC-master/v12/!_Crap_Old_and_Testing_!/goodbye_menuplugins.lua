
--[[
	Menu plugins
	A system in GMod 12 where a script can be loaded at the GMod main menu state (there are 3 stats, MENU, CLIENT and SERVER)
	
	I use this in GMod 12 for stuff like:
	server logger
	screenshot tagger
	auto-status (shows "status" when i open the console)
	snowflakes on december
	spray logger
	custom disconnect messages
	gmod logos
	derma skin overrider
	download filter
	etc etc
	
	Garry decided he'd remove the menu_plugins folder for no reason at the start of the GMod 13 beta.
	These are all my methods of loading menu_plugins in GMod 13, before garry broke the final method on 03.08.2012
]]



Method #0: lua/menu_plugins, Beta U9
Auto-loads lua files placed in this folder into the menustate
--Removed by garry for unknown reasons, probably cheats.

Method #1: pl_MenuPlugins
Load as source plugin, use gbps' CStateManager class to get ILuaInterface of the menustate
then use IFileSystem to loop through and read files in lua/menu_plugins and ILuaInterface::RunString the contents.
--Broken, Garry changed the vtable for ILuaShared

Method #2: pl_MenuPlugins2
Load as source plugin, hook ILuaInterface::FindAndRunScript, use IFileSystem to FindAndRunScript each file in lua/menu_plugins
--Broken, Garry removed addons in Beta U9 (.vdf addons still do not work in the current beta)

Method #3: in_MenuPlugins3
Inject dll into hl2.exe, hook ILuaInterface::FindAndRunScript, use IFileSystem to FindAndRunScript each file in lua/menu_plugins
--Broken, sig out of date

Method #4: in_MenuPlugins4
Inject dll into hl2.exe, use new headers for ILuaShared to get ILuaInterface of the menustate
unable to use ILuaInterface::RunString() due to Garry's new "NOT MAIN THREAD" bullcrap.
Register my own lua_run_in concommand using ICVar, then *rum my own command from my module*
using IVEngineClient::ClientCmd("lua_run_in include(\"in_menuplugins.lua\")"), this avoids the thread catcher.
--Broken, crashes on exit due to the CVar, not very useful since it needs to be loaded manually.

Method #5: gsg_MenuPlugins5
Source auto-loads any dll in mod/bin/game_shader_generic_*.dll, load as game_shader_generic_menuplugins.dll
use ILuaShared::GetLuaInterface to get ILuaInterface of the menustate
hook ILuaInterface::RunString and wait for first call, then wait for "lua\\menu\\menu.lua" to load
then use WinAPI functions to loop the menu_plugins folder and ILuaInterface::RunString("include(\"menu_plugins/%s\")")
--Broken, Garry packed lua_shared to defeat hooks, ruining this method.

Method #6: gsg_MenuPlugins6, Beta U27
Load as game_shader_generic_menuplugins.dll, use ILuaShared::GetLuaInterface to get ILuaInterface of the menustate
Register my own gsg_luad concommand using ICVar, then *rum my gsg_luad from my module* using 
IVEngineClient::ClientCmd("gsg_luad").
then in the concommand func, use WinAPI functions to loop the menu_plugins folder and ILuaInterface::RunString("include(\"menu_plugins/%s\")")
--Broken, Garry changed the module headers twice and removed ILuaShared/ILuaInterface/ILuaObject


--[[
	I give up.
]]





















