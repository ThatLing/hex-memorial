
--require("simplespew")

local Map = "Menustate"

hook.Add("OnLoadingStarted", "GetMap", function()
	Map = client.GetMapName()
end)

hook.Add("OnLoadingStopped", "ResetMap", function()
	Map = "Menustate"
end)


local function ProcessSpew(typ,spew,group,lev,red,green,blue,alpha)
	if not client then
		hook.Remove("SimpleSpew", "ProcessSpew") --Don't call own hook!
		ErrorNoHalt("Extras gone, can't use client.GetMapName for spew!")
		return
	end
	
	local Date = os.date("%d-%m-%Y_%A")
	
	file.Append("spew/"..Date.."/"..Map..".txt", spew)
	
	--[[
	if spew:find(": ") then
		file.Append("spew/"..Date.."_TALK/"..Map..".txt", spew)
	end
	]]
end
hook.Add("SimpleSpew", "ProcessSpew", ProcessSpew)


