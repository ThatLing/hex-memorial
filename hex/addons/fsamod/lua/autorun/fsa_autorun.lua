
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------

FSA = {
	Plugins = {},
	Ranks 	= {},
}


if SERVER then
	AddCSLuaFile("autorun/fsa_autorun.lua")
	
	AddCSLuaFile("FSA/client.lua")
	AddCSLuaFile("FSA/coreplugins.lua")
	AddCSLuaFile("FSA/shared.lua")
	
	
	include("FSA/server.lua")
	include("FSA/shared.lua")
	include("FSA/ranks.lua")
	
	print("[FSA] Loaded SERVER")
end


if CLIENT then
	include("FSA/shared.lua")
	include("FSA/client.lua")
	
	print("[FSA] Loaded CLIENT")
end



















----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------

FSA = {
	Plugins = {},
	Ranks 	= {},
}


if SERVER then
	AddCSLuaFile("autorun/fsa_autorun.lua")
	
	AddCSLuaFile("FSA/client.lua")
	AddCSLuaFile("FSA/coreplugins.lua")
	AddCSLuaFile("FSA/shared.lua")
	
	
	include("FSA/server.lua")
	include("FSA/shared.lua")
	include("FSA/ranks.lua")
	
	print("[FSA] Loaded SERVER")
end


if CLIENT then
	include("FSA/shared.lua")
	include("FSA/client.lua")
	
	print("[FSA] Loaded CLIENT")
end


















