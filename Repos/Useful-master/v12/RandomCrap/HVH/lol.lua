
--[[
concommand.Add( "hook", function( ply, cmd, args )
    --hook.Call( "Hook_BETA1", nil, unpack(args) )
	
	print( tobool(hook.Call( "Hook_BETA1", nil, unpack(args) )) )
end)



local function fuck(lol1,lol2,lol3)
	print("! typ: ", lol1)
	
	return true
end
hook.Add("Hook_BETA1", "YouForgotThisUniqueName", fuck)

]]

--poo = "autorun/client/poop.lua"
poo = "poop.lua"

local SubTAB = {
	["lua"]				= "",
	["autorun"]			= "",
	["client"]			= "",
	["menu_plugins"]	= "",
	["custom_menu"] 	= "",
}
function NiceLuaName(str)
	str = str:gsub("%a+", SubTAB):gsub("%.", "")
	return str or "=Fuckup="
end

print("\n", NiceLuaName(poo) )






