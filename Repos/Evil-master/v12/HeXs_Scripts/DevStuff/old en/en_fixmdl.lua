if !CLIENT then return end

--[[
local SetModel = _R.Entity.SetModel
_R.Entity.SetModel = function( self, mdl )
	local b, e = pcall( SetModel( self, mdl ) )
	if !b then
		ErrorNoHalt( "Catching model-related error: "..e.."\n" )
	end
end
]]

local SetModel = _R.Entity.SetModel
_R.Entity.SetModel = function(self, mdl)
	if !util.IsValidModel(mdl) then
		Msg("[!] SetModel on "..tostring(self).." Failed. Invalid model: "..mdl.."\n")
		SetModel(self, mdl)
	end
	SetModel(self, mdl)
end


--[[
local oldMaterial = _G.Material --fucked
_G.Material = function(mat)
	if not file.Exists("materials/"..mat..".vmt", true) then
		Msg("[!] Material invalid: materials/"..tostring(mat).."\n")
		return oldMaterial(mat)
	end
	oldMaterial(mat)
end
]]





