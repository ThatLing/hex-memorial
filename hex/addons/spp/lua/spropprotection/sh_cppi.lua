
----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------
------------------------------------
--	Simple Prop Protection
--	By Spacetech
-- 	http://code.google.com/p/simplepropprotection
------------------------------------

function CPPI:GetName()
	return "Simple Prop Protection"
end

function CPPI:GetVersion()
	return SPropProtection.Version
end

function CPPI:GetInterfaceVersion()
	return 1.1
end

function CPPI:GetNameFromUID(uid)
	return CPPI_NOTIMPLEMENTED
end

local Player = FindMetaTable("Player")
if(!Player) then
	print("EXTREME ERROR 1")
	return
end

function Player:CPPIGetFriends()
	if(SERVER) then
		local Table = {}
		for k, v in pairs(player.GetAll()) do
			if(table.HasValue(SPropProtection[self:SteamID()], v:SteamID())) then
				table.insert(Table, v)
			end
		end
		return Table
	else
		return CPPI_NOTIMPLEMENTED
	end
end

local Entity = FindMetaTable("Entity")
if(!Entity) then
	print("EXTREME ERROR 2")
	return
end

function Entity:CPPIGetOwner()
	if(self.SPPOwnerless) then
		return true, CPPI_NOTIMPLEMENTED
	end
	
	local Player = self:GetNetworkedEntity("OwnerObj", false)
	
	if(SERVER) then
		if(SPropProtection.Props[self:EntIndex()]) then
			Player = SPropProtection.Props[self:EntIndex()].Owner
		end
	end
	
	if(!Player or !Player:IsValid()) then
		return nil, CPPI_NOTIMPLEMENTED
	end
	
	local UID = CPPI_NOTIMPLEMENTED
	
	if(SERVER) then
		UID = Player:UniqueID()
	end
	
	return Player, UID
end

if(SERVER) then
	function Entity:CPPISetOwner(ply)
		if(!ply or !ply:IsValid() or !ply:IsPlayer()) then
			return false
		end
		return SPropProtection.PlayerMakePropOwner(ply, self)
	end
	
	function Entity:CPPISetOwnerless(Bool)
		self.SPPOwnerless = Bool
		if(Bool) then
			self:SetNetworkedString("Owner", "Ownerless")
			self:SetNetworkedEntity("OwnerObj", GetWorldEntity())
		else
			self:SetNetworkedString("Owner", "N/A")
		end
	end
	
	function Entity:CPPISetOwnerUID(uid)
		if(!uid) then
			return false
		end
		
		local ply = player.GetByUniqueID(tostring(uid))
		if(!ply) then
			return false
		end
		
		return SPropProtection.PlayerMakePropOwner(ply, self)
	end
	
	function Entity:CPPICanTool(ply, toolmode)
		if(!ply or !ply:IsValid() or !ply:IsPlayer() or !toolmode) then
			return false
		end
		return SPropProtection.PlayerCanTouch(ply, self)
	end
	
	function Entity:CPPICanPhysgun(ply)
		if(!ply or !ply:IsValid() or !ply:IsPlayer()) then
			return false
		end
		if(SPropProtection.PhysGravGunPickup(ply, self) == false) then
			return false
		end
		return true
	end
	
	function Entity:CPPICanPickup(ply)
		if(!ply or !ply:IsValid() or !ply:IsPlayer()) then
			return false
		end
		if(SPropProtection.PhysGravGunPickup(ply, self) == false) then
			return false
		end
		return true
	end
	
	function Entity:CPPICanPunt(ply)
		if(!ply or !ply:IsValid() or !ply:IsPlayer()) then
			return false
		end
		if(SPropProtection.PhysGravGunPickup(ply, self) == false) then
			return false
		end
		return true
	end
end

local function CPPIInitGM()
	function GAMEMODE:CPPIAssignOwnership(ply, ent)
	end
	function GAMEMODE:CPPIFriendsChanged(ply, ent)
	end
end
hook.Add("Initialize", "CPPIInitGM", CPPIInitGM)


----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------
------------------------------------
--	Simple Prop Protection
--	By Spacetech
-- 	http://code.google.com/p/simplepropprotection
------------------------------------

function CPPI:GetName()
	return "Simple Prop Protection"
end

function CPPI:GetVersion()
	return SPropProtection.Version
end

function CPPI:GetInterfaceVersion()
	return 1.1
end

function CPPI:GetNameFromUID(uid)
	return CPPI_NOTIMPLEMENTED
end

local Player = FindMetaTable("Player")
if(!Player) then
	print("EXTREME ERROR 1")
	return
end

function Player:CPPIGetFriends()
	if(SERVER) then
		local Table = {}
		for k, v in pairs(player.GetAll()) do
			if(table.HasValue(SPropProtection[self:SteamID()], v:SteamID())) then
				table.insert(Table, v)
			end
		end
		return Table
	else
		return CPPI_NOTIMPLEMENTED
	end
end

local Entity = FindMetaTable("Entity")
if(!Entity) then
	print("EXTREME ERROR 2")
	return
end

function Entity:CPPIGetOwner()
	if(self.SPPOwnerless) then
		return true, CPPI_NOTIMPLEMENTED
	end
	
	local Player = self:GetNetworkedEntity("OwnerObj", false)
	
	if(SERVER) then
		if(SPropProtection.Props[self:EntIndex()]) then
			Player = SPropProtection.Props[self:EntIndex()].Owner
		end
	end
	
	if(!Player or !Player:IsValid()) then
		return nil, CPPI_NOTIMPLEMENTED
	end
	
	local UID = CPPI_NOTIMPLEMENTED
	
	if(SERVER) then
		UID = Player:UniqueID()
	end
	
	return Player, UID
end

if(SERVER) then
	function Entity:CPPISetOwner(ply)
		if(!ply or !ply:IsValid() or !ply:IsPlayer()) then
			return false
		end
		return SPropProtection.PlayerMakePropOwner(ply, self)
	end
	
	function Entity:CPPISetOwnerless(Bool)
		self.SPPOwnerless = Bool
		if(Bool) then
			self:SetNetworkedString("Owner", "Ownerless")
			self:SetNetworkedEntity("OwnerObj", GetWorldEntity())
		else
			self:SetNetworkedString("Owner", "N/A")
		end
	end
	
	function Entity:CPPISetOwnerUID(uid)
		if(!uid) then
			return false
		end
		
		local ply = player.GetByUniqueID(tostring(uid))
		if(!ply) then
			return false
		end
		
		return SPropProtection.PlayerMakePropOwner(ply, self)
	end
	
	function Entity:CPPICanTool(ply, toolmode)
		if(!ply or !ply:IsValid() or !ply:IsPlayer() or !toolmode) then
			return false
		end
		return SPropProtection.PlayerCanTouch(ply, self)
	end
	
	function Entity:CPPICanPhysgun(ply)
		if(!ply or !ply:IsValid() or !ply:IsPlayer()) then
			return false
		end
		if(SPropProtection.PhysGravGunPickup(ply, self) == false) then
			return false
		end
		return true
	end
	
	function Entity:CPPICanPickup(ply)
		if(!ply or !ply:IsValid() or !ply:IsPlayer()) then
			return false
		end
		if(SPropProtection.PhysGravGunPickup(ply, self) == false) then
			return false
		end
		return true
	end
	
	function Entity:CPPICanPunt(ply)
		if(!ply or !ply:IsValid() or !ply:IsPlayer()) then
			return false
		end
		if(SPropProtection.PhysGravGunPickup(ply, self) == false) then
			return false
		end
		return true
	end
end

local function CPPIInitGM()
	function GAMEMODE:CPPIAssignOwnership(ply, ent)
	end
	function GAMEMODE:CPPIFriendsChanged(ply, ent)
	end
end
hook.Add("Initialize", "CPPIInitGM", CPPIInitGM)

