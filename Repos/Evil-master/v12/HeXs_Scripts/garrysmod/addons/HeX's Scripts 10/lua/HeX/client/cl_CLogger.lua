

LtGreen	= Color(174,255,0)
PURPLE	= Color(149,102,255)

if not _R.Player.TeamColor then
	function _R.Player:TeamColor()
		return team.GetColor( self:Team() )
	end
end


function _R.Player:CommunityID()
	local SID = self:SteamID()
	return "7656"..tostring(SID:sub(11) * 2 + SID:sub(9,9) + 1197960265728)
end


local CLogged = {}
function _R.Player:AddToCLog()
	if self:IsBot() then return end
	
	local CFile	= Format("CLog/%s.txt", os.date("%d-%m-%Y_%A") )
	
	local LogTable = {
		Format("[%s]\n", 			os.date("%d-%m-%y %I:%M%p") ),
		Format("%s\n", 				GetHostName() ),
		Format("GM: %s\n", 			GAMEMODE.Name),
		Format("Players: %s/%s\n", 	#player.GetAll(), MaxPlayers() ),
		Format("Map: %s\n", 		game.GetMap() ),
		Format("Ver: U%s\n", 		VERSION),
		Format("Nick: %s\n", 		self:Nick() ),
		Format("Name: %s\n",  		self:Name() ),
		Format("SteamID: %s\n",  	self:SteamID() ),
		Format("CommunityID: %s\n", self:CommunityID() ),
		Format("URL: http://steamcommunity.com/profiles/%s\n\n\n", self:CommunityID() ),
	}
	
	local CLog = ""
	for k,v in ipairs(LogTable) do
		CLog = CLog..v
	end
	
	CLogged[self] = true
	file.Append(CFile, CLog)
end




local Active 	= false
local First 	= {}
local function FirstSave()
	local Done = 0
	for k,v in pairs( player.GetAll() ) do
		if IsValid(v) and (v != LocalPlayer()) then
			v:AddToCLog()
			First[v] = true
			Done = Done + 1
		end
	end
	
	if (Done != 0) then
		chat.AddText(LtGreen, "[", PURPLE, "C", LtGreen, "Log] All "..Done.." players have been logged!")
		surface.PlaySound( Sound("buttons/button8.wav") )
	end
	
	Active = true
end
timer.Simple(1, FirstSave) --Got to wait for Nick/Name to take effect




local function EntityCreated(ent)
	timer.Simple(2, function() --Got to wait for Nick/Name to take effect
		if Active and IsValid(ent) and (ent:IsPlayer() and not ent:IsBot()) and (ent != LocalPlayer()) and not First[ent] then
			if CLogged[ent] then
				chat.AddText(LtGreen, "[", PURPLE, "C", LtGreen, "Log] ", ent, LtGreen, " Has spawned")
			else
				chat.AddText(LtGreen, "[", PURPLE, "C", LtGreen, "Log] ", ent, LtGreen, " Has spawned, logged")
				ent:AddToCLog()
			end
			
			surface.PlaySound( Sound("buttons/button5.wav") )
		end
	end)
end
hook.Add("OnEntityCreated", "EntityCreated", EntityCreated)



local function InServer(ply)
	for k,v in pairs( player.GetAll() ) do
		if (v == ply) then
			return true
		end
	end
	return false
end


local function EntityRemoved(ent)
	if not Active or not ent:IsPlayer() or ent:IsBot() or (ent == LocalPlayer()) then return end
	
	local Nick	= ent:Nick()
	local Col	= ent:TeamColor()
	
	timer.Simple(0.5, function()
		if not IsValid(ent) or not InServer(ent) then
			chat.AddText(LtGreen, "[", PURPLE, "C", LtGreen, "Log] ", Col,Nick, PURPLE, " Has disconnected!")
			surface.PlaySound( Sound("buttons/button19.wav") )
		end
	end)
end
hook.Add("EntityRemoved", "EntityRemoved", EntityRemoved)
































