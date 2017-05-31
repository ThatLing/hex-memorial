
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------


if SERVER then
	AddCSLuaFile		'shared.lua'
	resource.AddFile	'materials/vgui/entities/weapon_flaregun.vmt'
	resource.AddFile	'materials/vgui/entities/weapon_flaregun.vtf'
end


H00.Weapon.Populate(SWEP,
					-- information
					'Flare Gun',									-- name
					'HeX + Henry00',								-- author
					'Fire, don\'t breath this!',					-- description
					'Primary = Flares',								-- instructions

					-- model
					'models/weapons/w_357.mdl',						-- world model
					'models/weapons/v_357.mdl',						-- view model
						54,											-- view model FOV
						false,										-- view model flip
						
					-- primary
					'357',											-- ammo type
					20,												-- pickup clip size
					6,												-- clip size
					0.8,											-- automatic fire speed (0:off)
					
					-- secondary
					'none',											-- ammo type
					-1,												-- pickup clip size
					-1,												-- clip size
					0.0,											-- automatic fire speed (0:off)
					
					-- interface
					1,												-- slot column
					3												-- slot row
)


SWEP.Sound_Fire		= Sound 'weapons/flaregun/fire.wav'
SWEP.Flares			= {}

SWEP.IconLetter		= "."

function SWEP:PrimaryFire()
	if SERVER then
		if hook.Run("HSP_NoFireWeapon", self) then
			self.Owner:Ignite(90)
		else
			local Flare = ents.Create("env_flare")
				Flare:SetPos(self.Owner:GetShootPos() )
				Flare:SetAngles(self.Owner:GetAimVector():Angle() )
				Flare:SetKeyValue("scale", "1")
				Flare:EmitSound("Weapon_Flaregun.Burn")
				Flare:Spawn()
				Flare:Activate()
				Flare:SetOwner( self.Owner )
				Flare:Fire("Launch", "2100", 0.1)
				Flare:Fire("Die", "0.1", 2.9)
				
				Flare.Owner = self.Owner
				Flare:SetOwner(self.Owner)
				
				timer.Simple(0.15, function()
					if IsValid(Flare) then
						Flare:Ignite(14,1)
					end
				end)
			self.Flares[Flare] = true --The old one only tracked the last Flare shot, we store every single one.
		end
	end
	
	--animate
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound( self.Sound_Fire, 100, math.random(100,120) )
	
	return 1 -- fired 1 bullet
end


function SWEP:OnThink()
	if CLIENT then return end
	
	for Flare,k in pairs(self.Flares) do
		if not IsValid(Flare) then continue end
		
		if Flare:WaterLevel() > 0 then
			Flare:Extinguish()
			Flare:Fire("Die", "0.1", 0)
		end
		
		for k,v in pairs( ents.FindInSphere(Flare:GetPos(), 12) ) do
			if IsValid(v) and v != self.Owner and v != self and v != Flare and v:Health() > 0 then
				v:Ignite(math.Rand(6,14), 1)
			end
		end
	end
end




















----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------


if SERVER then
	AddCSLuaFile		'shared.lua'
	resource.AddFile	'materials/vgui/entities/weapon_flaregun.vmt'
	resource.AddFile	'materials/vgui/entities/weapon_flaregun.vtf'
end


H00.Weapon.Populate(SWEP,
					-- information
					'Flare Gun',									-- name
					'HeX + Henry00',								-- author
					'Fire, don\'t breath this!',					-- description
					'Primary = Flares',								-- instructions

					-- model
					'models/weapons/w_357.mdl',						-- world model
					'models/weapons/v_357.mdl',						-- view model
						54,											-- view model FOV
						false,										-- view model flip
						
					-- primary
					'357',											-- ammo type
					20,												-- pickup clip size
					6,												-- clip size
					0.8,											-- automatic fire speed (0:off)
					
					-- secondary
					'none',											-- ammo type
					-1,												-- pickup clip size
					-1,												-- clip size
					0.0,											-- automatic fire speed (0:off)
					
					-- interface
					1,												-- slot column
					3												-- slot row
)


SWEP.Sound_Fire		= Sound 'weapons/flaregun/fire.wav'
SWEP.Flares			= {}

SWEP.IconLetter		= "."

function SWEP:PrimaryFire()
	if SERVER then
		if hook.Run("HSP_NoFireWeapon", self) then
			self.Owner:Ignite(90)
		else
			local Flare = ents.Create("env_flare")
				Flare:SetPos(self.Owner:GetShootPos() )
				Flare:SetAngles(self.Owner:GetAimVector():Angle() )
				Flare:SetKeyValue("scale", "1")
				Flare:EmitSound("Weapon_Flaregun.Burn")
				Flare:Spawn()
				Flare:Activate()
				Flare:SetOwner( self.Owner )
				Flare:Fire("Launch", "2100", 0.1)
				Flare:Fire("Die", "0.1", 2.9)
				
				Flare.Owner = self.Owner
				Flare:SetOwner(self.Owner)
				
				timer.Simple(0.15, function()
					if IsValid(Flare) then
						Flare:Ignite(14,1)
					end
				end)
			self.Flares[Flare] = true --The old one only tracked the last Flare shot, we store every single one.
		end
	end
	
	--animate
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound( self.Sound_Fire, 100, math.random(100,120) )
	
	return 1 -- fired 1 bullet
end


function SWEP:OnThink()
	if CLIENT then return end
	
	for Flare,k in pairs(self.Flares) do
		if not IsValid(Flare) then continue end
		
		if Flare:WaterLevel() > 0 then
			Flare:Extinguish()
			Flare:Fire("Die", "0.1", 0)
		end
		
		for k,v in pairs( ents.FindInSphere(Flare:GetPos(), 12) ) do
			if IsValid(v) and v != self.Owner and v != self and v != Flare and v:Health() > 0 then
				v:Ignite(math.Rand(6,14), 1)
			end
		end
	end
end



















