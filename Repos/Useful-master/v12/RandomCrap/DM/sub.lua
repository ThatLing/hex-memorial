concommand.Add("fuck", function() include("sub.lua") end)

local LuaName = "lol_poop.lua"
--local LuaName = "._lol_poop.lua"


if LuaName:sub(1,#"._") == "._" then
	print("! lol")
	LuaName = LuaName:gsub("._","")
end
	
print("! : ", LuaName)




