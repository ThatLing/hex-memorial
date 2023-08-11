


local pMeta = FindMetaTable("Player")

function pMeta:TeamColor()
	return team.GetColor( self:Team() )
end

function pMeta:IsHeX()
	return self:SteamID() == "STEAM_0:0:17809124"
end

function pMeta:SID()
	return self:SteamID():gsub(":","_")
end


function HeX.StringInTable(str,tab)
	if not tab then
		ErrorNoHalt("StringInTable, no table!\n", 2)
		return false,false,false
	end
	
	for k,v in pairs(tab) do
		if str:find(v) then
			return true,k,v
		end
	end
	return false,false,false
end
string.InTable = HeX.StringInTable











