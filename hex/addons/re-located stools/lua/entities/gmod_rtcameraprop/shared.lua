
----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------


ENT.Type = "anim"

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""


function ENT:SetupDataTables()

	self:DTVar("Int", 0, "Key");
	self:DTVar("Bool", 0, "On");
	self:DTVar("Vector", 0, "vecTrack");
	self:DTVar("Entity", 0, "entTrack");
	self:DTVar("Entity", 1, "Player");

end

function ENT:SetKey( key )
	self.dt.Key = key
end
function ENT:GetKey()
	return self.dt.Key
end


function ENT:SetOn( bOn )
	self.dt.On = bOn
end
function ENT:IsOn()
	return self.dt.On
end

function ENT:SetPlayer( pPly )
	self.dt.Player = pPly
end

function ENT:GetPlayer()
	return self.dt.Player
end

function ENT:TrackEntity( ent, lpos )

	if ( !ent || !ent:IsValid() ) then return end

	local WPos = ent:LocalToWorld( lpos )
	
	if ( ent:IsPlayer() ) then
		WPos = WPos + Vector( 0, 0, 54 )
	end
	
	local CamPos = self:GetPos()
	local Ang = WPos - CamPos
	
	Ang = Ang:Angle()
	self:SetAngles(Ang)

end

function ENT:CanTool( ply, trace, mode )

	if (self:GetMoveType() == MOVETYPE_NONE) then return false end
	
	return true

end


----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------


ENT.Type = "anim"

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""


function ENT:SetupDataTables()

	self:DTVar("Int", 0, "Key");
	self:DTVar("Bool", 0, "On");
	self:DTVar("Vector", 0, "vecTrack");
	self:DTVar("Entity", 0, "entTrack");
	self:DTVar("Entity", 1, "Player");

end

function ENT:SetKey( key )
	self.dt.Key = key
end
function ENT:GetKey()
	return self.dt.Key
end


function ENT:SetOn( bOn )
	self.dt.On = bOn
end
function ENT:IsOn()
	return self.dt.On
end

function ENT:SetPlayer( pPly )
	self.dt.Player = pPly
end

function ENT:GetPlayer()
	return self.dt.Player
end

function ENT:TrackEntity( ent, lpos )

	if ( !ent || !ent:IsValid() ) then return end

	local WPos = ent:LocalToWorld( lpos )
	
	if ( ent:IsPlayer() ) then
		WPos = WPos + Vector( 0, 0, 54 )
	end
	
	local CamPos = self:GetPos()
	local Ang = WPos - CamPos
	
	Ang = Ang:Angle()
	self:SetAngles(Ang)

end

function ENT:CanTool( ply, trace, mode )

	if (self:GetMoveType() == MOVETYPE_NONE) then return false end
	
	return true

end

