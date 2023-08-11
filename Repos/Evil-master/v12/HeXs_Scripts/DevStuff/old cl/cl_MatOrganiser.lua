--[[
	~ Materials Orgnaiser ~
	~ Lexi ~
--]]

list.Add("OverrideMaterials", "models/player/shared/gold_player")
list.Add("OverrideMaterials", "models/weapons/c_items/gold_wrench")


timer.Simple(0, function()
	local mats = list.GetForEdit("OverrideMaterials")
	local cleaner = {}
	
	for i, mat in pairs(mats) do
		cleaner[mat] = true
		mats[i] = nil
	end
	
	local i = 1
	for mat in pairs(cleaner) do
		mats[i] = mat
		i = i + 1
	end
	
	table.sort(mats)
end)