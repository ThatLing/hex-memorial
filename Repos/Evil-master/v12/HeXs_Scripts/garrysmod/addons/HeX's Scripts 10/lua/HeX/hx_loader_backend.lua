

if not iface3 then
	HeXInclude = include
end
local Typ = type(HeX)
if (Typ == "number" or Typ == "boolean") then
	_G.HeXGlobal_AC = true
end
HeX = {
	include = HeXInclude,
}

HeX.include("HeX/hx_loader_modules.lua")
HeX.include("HeX/hx_loader_meta.lua")
HeX.include("HeX/hx_loader_globals.lua")

IsMainGMod = file.Exists("MAIN.lua",true)

if (SERVER) then
	for k,v in ipairs( file.FindInLua("HeX/server/*.lua") ) do
		Msg("   HeX/server/"..v.."\n")
		include("HeX/server/"..v)
	end
end

for k,v in ipairs( file.FindInLua("HeX/sh_*.lua") ) do
	Msg("   HeX/"..v.."\n")
	HeX.include("HeX/"..v)
end


if (CLIENT) then
	for k,v in ipairs( file.FindInLua("HeX/client/*.lua") ) do
		Msg("   HeX/"..v.."\n")
		HeX.include("HeX/client/"..v)
	end
end






