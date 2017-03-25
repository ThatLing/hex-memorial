--[[
	=== HSP Plugin Module ===
	sv_Spew, v1.3
	Log everything from the console
]]



local LastSpew = ""
local Map = game.GetMap()

local function MakeTreeForFile(path)
	local Tab 	= string.Explode("/",path)
	local Here	= ""
	
	for k,v in ipairs(Tab) do
		if k != #Tab then --Last entry in path table
			Here = Here..v.."/"
		end
	end
	
	if not file.IsDir(Here, "DATA") then
		file.CreateDir(Here, "DATA")
	end
end

local function Append(path,cont)
	MakeTreeForFile(path)
	
	--Write-append
	local Out = file.Open(path, "a", "DATA")
		if not Out then return end
		Out:Write(cont)
	Out:Close()
end



local function ProcessSpew(typ,spew,group,lev)
	if spew == LastSpew then
		LastSpew = ""
		return
	end
	LastSpew = spew
	
	local Date = os.date("%d-%m-%Y_%A")
	
	Append("spew/"..Date.."/"..Map..".txt", spew, "DATA")
	
	if spew:find("L ") and spew:find("say") then
		Append("spew/"..Date.."_TALK/"..Map..".txt", spew, "DATA")
	end
end
hook.Add("SimpleSpew", "ProcessSpew", ProcessSpew)








