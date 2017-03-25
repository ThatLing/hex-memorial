







--[[
local NewTot = {}

local function Merge(tab)
	for k,v in pairs(tab) do
		NewTot[k] = v
	end
end
Merge(Skid1)
Merge(Skid2)
Merge(Bulk)
Merge(Idiots)
Merge(SHers)


local i = 0
for k,v in pairs(NewTot) do
	i = i + 1
	local Name	= v.Name
	local IsSH	= v.SH
	
	local str = ""
	if Name then
		str = str..'Name = "'..Name..'", '
	end
	
	local log = "bulk.txt"
	if IsSH then
		log = "seth.txt"
		str = str.."SH = true"
	else
		str = str.."Skid = true"
	end
	
	local Skid = Format('\t["%s"] = {%s},\n', k, str)
	file.Append(log, Skid)
end

print("! saved "..i.." cheaters!")
]]






