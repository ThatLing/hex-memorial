
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
include('shared.lua')

SWEP.Slot				= 4							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

SWEP.Ghost 				= NULL


SWEP.WepSelectIcon	= surface.GetTextureID("vgui/entities/weapon_mad_c4")


local Trans = Color(255, 255, 255, 100)
local Invis = Color(255, 255, 255, 0)



function SWEP:Think()
	if self.Owner != LocalPlayer() then return end
	
	if not self.Ghost:IsValid() then
		self.Ghost = ents.CreateClientProp("prop_physics")
		self.Ghost:SetModel("models/weapons/w_c4_planted.mdl")
		self.Ghost:SetOwner(self.Owner)
		
		self.Ghost:SetRenderMode(1)
	end
	
	if not self.Ghost:IsValid() then return end
	
	
	local tr = {}
		tr.start = self.Owner:GetShootPos()
		tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
		tr.filter = {self.Ghost, self.Owner}
	local trace = util.TraceLine(tr)
	
	
	if trace.Hit then
		self.Ghost:SetPos(trace.HitPos + trace.HitNormal)
		trace.HitNormal.z = -trace.HitNormal.z
		self.Ghost:SetAngles(trace.HitNormal:Angle() - Angle(90, 180, 0))
		
		self.Ghost:SetColor(Trans)
	else
		self.Ghost:SetColor(Invis)
	end
	
	self:NextThink( CurTime() )
	return true
end



















----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
include('shared.lua')

SWEP.Slot				= 4							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

SWEP.Ghost 				= NULL


SWEP.WepSelectIcon	= surface.GetTextureID("vgui/entities/weapon_mad_c4")


local Trans = Color(255, 255, 255, 100)
local Invis = Color(255, 255, 255, 0)



function SWEP:Think()
	if self.Owner != LocalPlayer() then return end
	
	if not self.Ghost:IsValid() then
		self.Ghost = ents.CreateClientProp("prop_physics")
		self.Ghost:SetModel("models/weapons/w_c4_planted.mdl")
		self.Ghost:SetOwner(self.Owner)
		
		self.Ghost:SetRenderMode(1)
	end
	
	if not self.Ghost:IsValid() then return end
	
	
	local tr = {}
		tr.start = self.Owner:GetShootPos()
		tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
		tr.filter = {self.Ghost, self.Owner}
	local trace = util.TraceLine(tr)
	
	
	if trace.Hit then
		self.Ghost:SetPos(trace.HitPos + trace.HitNormal)
		trace.HitNormal.z = -trace.HitNormal.z
		self.Ghost:SetAngles(trace.HitNormal:Angle() - Angle(90, 180, 0))
		
		self.Ghost:SetColor(Trans)
	else
		self.Ghost:SetColor(Invis)
	end
	
	self:NextThink( CurTime() )
	return true
end


















