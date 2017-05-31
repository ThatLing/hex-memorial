
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------

local PLUGIN = {}

PLUGIN.Name 			= "Stop Sound"
PLUGIN.Author 			= "::Frosty"
PLUGIN.File 			= "stopsounds.lua"
PLUGIN.Client 			= true
PLUGIN.Server 			= true
PLUGIN.CloseOnClick 	= true
PLUGIN.AllowSelf 		= true

PLUGIN.MenuFunction 	= ""
PLUGIN.SubMenu 			= nil
PLUGIN.SubMenufunction 	= nil

PLUGIN.RunFunction 		= function(Him,ply)
	BroadcastLua([[ LocalPlayer():ConCommand("stopsound") ]])
end

FSA.LoadPlugin(PLUGIN)













----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------

local PLUGIN = {}

PLUGIN.Name 			= "Stop Sound"
PLUGIN.Author 			= "::Frosty"
PLUGIN.File 			= "stopsounds.lua"
PLUGIN.Client 			= true
PLUGIN.Server 			= true
PLUGIN.CloseOnClick 	= true
PLUGIN.AllowSelf 		= true

PLUGIN.MenuFunction 	= ""
PLUGIN.SubMenu 			= nil
PLUGIN.SubMenufunction 	= nil

PLUGIN.RunFunction 		= function(Him,ply)
	BroadcastLua([[ LocalPlayer():ConCommand("stopsound") ]])
end

FSA.LoadPlugin(PLUGIN)












