
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------

local PLUGIN = {}

PLUGIN.Name 			= "Respawn" 			--Name to be displayed
PLUGIN.Author			= "::Frosty" 			--Your steam nick name
PLUGIN.File 			= "respawn.lua" 		--filename of plugin like "kill.lua"
PLUGIN.Client 			= true 					--Run Client Side
PLUGIN.Server 			= true 					--Run Server Side
PLUGIN.CloseOnClick 	= true 					--Sets if the menu should close once a player is selected
PLUGIN.AllowSelf 		= true 					--Sets if LocalPlayer can perform action on self

PLUGIN.MenuFunction 	= "AllPlayers" 			--List Method, "AllPlayers" Lists everyone, "AllExceptLocal" Lists Everyone Except The LocalPlayer
PLUGIN.SubMenu 			= {						--"Sub 1", "Sub 2" Table of strings for a submenu, nil for none
	"At Spawn (ASK2)",
	"At Spawn",
	"At Same Point"
}

PLUGIN.SubMenufunction	= { 						--Only Runs On Server. { func1, func2 } Table of corresponding functions to the submenu, nil for none
	function(Him,ply)
		Him:Spawn()
		Him:GodDisable()
		Him.ASK2Spawned = false
	end,
	
	function(Him,ply)
		Him:Spawn()
		Him:GodDisable()
		Him.ASK2Spawned = true
	end,
	
	function(Him,ply)
		local pos = Him:GetPos()
		local ang = Him:EyeAngles()
		
		Him:Spawn()
		Him:GodDisable()
		Him.ASK2Spawned = true
		
		Him:SetPos(pos)
		Him:SetEyeAngles(ang)
	end,
}

PLUGIN.RunFunction		= function(Him,ply) end

FSA.LoadPlugin(PLUGIN) --Call this to load the plugin

















----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------

local PLUGIN = {}

PLUGIN.Name 			= "Respawn" 			--Name to be displayed
PLUGIN.Author			= "::Frosty" 			--Your steam nick name
PLUGIN.File 			= "respawn.lua" 		--filename of plugin like "kill.lua"
PLUGIN.Client 			= true 					--Run Client Side
PLUGIN.Server 			= true 					--Run Server Side
PLUGIN.CloseOnClick 	= true 					--Sets if the menu should close once a player is selected
PLUGIN.AllowSelf 		= true 					--Sets if LocalPlayer can perform action on self

PLUGIN.MenuFunction 	= "AllPlayers" 			--List Method, "AllPlayers" Lists everyone, "AllExceptLocal" Lists Everyone Except The LocalPlayer
PLUGIN.SubMenu 			= {						--"Sub 1", "Sub 2" Table of strings for a submenu, nil for none
	"At Spawn (ASK2)",
	"At Spawn",
	"At Same Point"
}

PLUGIN.SubMenufunction	= { 						--Only Runs On Server. { func1, func2 } Table of corresponding functions to the submenu, nil for none
	function(Him,ply)
		Him:Spawn()
		Him:GodDisable()
		Him.ASK2Spawned = false
	end,
	
	function(Him,ply)
		Him:Spawn()
		Him:GodDisable()
		Him.ASK2Spawned = true
	end,
	
	function(Him,ply)
		local pos = Him:GetPos()
		local ang = Him:EyeAngles()
		
		Him:Spawn()
		Him:GodDisable()
		Him.ASK2Spawned = true
		
		Him:SetPos(pos)
		Him:SetEyeAngles(ang)
	end,
}

PLUGIN.RunFunction		= function(Him,ply) end

FSA.LoadPlugin(PLUGIN) --Call this to load the plugin
















