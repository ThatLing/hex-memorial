
require("concommand")
require("cvars")

include("includes/compat.lua")
include("includes/util/model_database.lua")
include("includes/util/vgui_showlayout.lua")
include("includes/util/tooltips.lua")
include("includes/util/client.lua")


if not client then --Don't load twice!
	require("extras")
end
if not client then
	fuckup = true
end

IsMainGMod	= file.Exists("MAIN.lua",true)
IsKida		= file.Exists("KIDA.lua",true)



BROWN		= Color(128,128,0)
EntityColor	= Color(151,211,255)
CMIColor	= Color(153,217,234)
BLUE		= Color(51,153,255)
WHITE		= Color(255,255,255)
PINK		= Color(255,175,202)
GREY		= Color(196,196,196)
GREEN		= Color(182,231,18)
RED			= Color(237,16,29)
ADMINRED	= Color(255,50,50)
MODGREEN	= Color(0,255,0)

function COLCON(...)
	if fuckup then
		for k, v in pairs( {...} ) do
			if ( type(v) == "string" ) then
				Msg(v)
			end
		end
		Msg("\n")
		return
	end
	
	local color = WHITE
	for k, v in pairs( {...} ) do
		if ( type( v ) == "table" && v["b"] && v["g"] && v["r"] ) then
			color = v
		elseif ( type( v ) == "Player" and IsValid( v ) ) then
			console.PrintColor( team.GetColor( v:Team() ), v:GetName() )
		elseif ( ( type( v ) == "Entity" or type( v ) == "Weapon" or type( v ) == "Vehicle" or type( v ) == "NPC" ) and IsValid( v ) ) then
			console.PrintColor( EntityColor, v:GetClass() )
		else
			console.PrintColor( color, tostring(v) )
		end
	end
	console.PrintColor( color, "\n" )
end
--COLCON = MsgC


if not RealTime then RealTime = CurTime end
function StringCheck(str,check)
	return tostring(str):sub(1,#check) == check
end


local function LoadCMI()
	Msg("\n")
	COLCON(GREEN, "///////////////////////////////////////")
	COLCON(GREEN, "//          Custom Menu Inc          //")
	COLCON(GREEN, "///////////////////////////////////////")
	
	for k,v in pairs( file.FindInLua("custom_menu/ml_B_*.lua") ) do
		COLCON( CMIColor, " Loading ", PINK, "Base", WHITE, ": "..v )
		include("custom_menu/"..v)
	end
	
	for k,v in pairs( file.FindInLua("custom_menu/ml_H_*.lua") ) do
		COLCON( CMIColor, " Loading ", RED, "Script", WHITE, ": "..v )
		include("custom_menu/"..v)
	end
	
	for k,v in pairs( file.FindInLua("custom_menu/ml_*.lua") ) do
		if not (v:sub(1,5) == "ml_B_" or v:sub(1,5) == "ml_H_") then
			COLCON( CMIColor, " Loading ", GREEN, "Plugin", WHITE, ": "..v )
			include("custom_menu/"..v)
		end
	end
	--[[
	for k,v in pairs( file.FindInLua("skins/*.lua") ) do --include skins
		COLCON( CMIColor, " Loading ", GREY, "Skin", WHITE, ": "..v )
		include("skins/"..v)
	end
	]]
	COLCON(GREEN, "///////////////////////////////////////")
	COLCON(GREEN, "//            CMI Loaded!            //")
	COLCON(GREEN, "///////////////////////////////////////")
	Msg("\n")
end
concommand.Add("cmi_reload", LoadCMI)
timer.Simple(0, LoadCMI)


