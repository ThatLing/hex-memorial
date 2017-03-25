

local LastSpew = ""

local function ProcessSpew(typ,spew,group,lev, r,g,b,a)
	if spew == LastSpew then
		LastSpew = ""
		return
	end
	LastSpew = spew
	
	local Date	= os.date("%d-%m-%Y_%A")
	local Map	= g_MapName or "menu"
	
	--HeX.file.Append("spew/"..Date.."/"..Map..".txt", spew, "DATA")
	
	file.Append("lol.txt", spew, "DATA")
end
hook.Add("SimpleSpew", "ProcessSpew", ProcessSpew)


function GetSpew(spew)
	file.Append("lol.txt", spew)
end

require("simplespew")



