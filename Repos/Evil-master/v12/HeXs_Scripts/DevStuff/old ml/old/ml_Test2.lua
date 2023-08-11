
require("stringtables")


hook.Add("InstallStringTableCallback", "InstallCallback", function(name)
	--print("InstallStringTableCallback", name)
	
	if name == "GModGameInfo" then
		return true
	end
end)



--[[
InstallStringTableCallback	GModGameInfo
OnStringTableChanged	GModGameInfo	18	1	0	scriptenf
OnStringTableChanged	GModGameInfo	18	2	1	loading_url
]]


hook.Add("OnStringTableChanged", "OnTableChanged", function(tab,num,str)
	if str != "scriptenf" then return end
	--[[
	print("! Changed: ", tab:GetName(), tab:GetTableID(), tab:GetNumStrings(), num, str)
	
	print( tab:DumpInfo() )
	print( tab:FindStringIndex("scriptenf") )
	
	tab:SetString(0, "scriptenf")
	tab:SetString(1, "scriptenf")
	]]
	
	
	
	print("! off")
end)

concommand.Add("lol", function()

StringTable("GModGameInfo"):SetString(0, "scriptenf")

end)





