--[[
	---=== Nyoom!, by HeX ===---
]]


local Def_Skip = {
	["i'm"] 		= 1,
	["im"] 			= 1,
	["in"] 			= 1,
	["i"] 			= 1,
	["so"] 			= 1,
	["is"] 			= 1,
	["do"] 			= 1,
	["its"] 		= 1,
	["it"] 			= 1,
	["ryan"] 		= 1,
	["you"] 		= 1,
	["my"] 			= 1,
	["the"] 		= 1,
	["has"] 		= 1,
	["are"] 		= 1,
	["this"] 		= 1,
	["dont"] 		= 1,
	["don't"] 		= 1,
	["help"] 		= 1,
	["chat"] 		= 1,
	["talk"] 		= 1,
	["speak"] 		= 1,
	["write"] 		= 1,
	["type"] 		= 1,
	["give"] 		= 1,
	["up"] 			= 1,
	["even"] 		= 1,
	["game"] 		= 1,
	["play"] 		= 1,
	["console"] 	= 1,
	["bagpipes"] 	= 1,
	["hammer"] 		= 1,
	["wheres"] 		= 1,
	["burst"] 		= 1,
	["me"] 			= 1,
	["too"] 		= 1,
	["young"] 		= 1,
	["for"] 		= 1,
	["gmod"] 		= 1,
	["hex"] 		= 1,
	["happening"] 	= 1,
}

function string.Nyoom(self, Skip)
	Skip = Skip or Def_Skip
	
	local Out 	= ""
	local Last 	= ""
	for k,v in pairs( self:Split(" ") ) do
		local Punc 	= v:match("%p") or ""
		local Cap	= (k == 1 or Last == ".") and "Nyoom" or "nyoom"
		local Nyoom = ( Skip[ v:lower():sub(0, -#Punc - 1) ] and v or Cap..Punc).." "
		
		Last = Punc
		
		//Over-nyoom'd
		local Count = #(Out..Nyoom)
		if not no_over_nyoom and Count > 100 then
			Out = "Over-nyoom'd! ("..Count..") > 100"
			break
		end
		
		Out = Out..Nyoom
	end
	
	return Out:Trim()
end













