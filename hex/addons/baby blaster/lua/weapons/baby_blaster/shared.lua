
----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------

if SERVER then
	AddCSLuaFile("shared.lua")
	
	resource.AddFile("materials/vgui/entities/baby_blaster.vmt")
	resource.AddFile("materials/vgui/entities/baby_blaster.vtf")
end


SWEP.PrintName		 		= "Baby Blaster"
SWEP.Author					= "cppchriscpp + HeX"
SWEP.Contact				= "None"
SWEP.Purpose				= "Blasts Babies"
SWEP.Instructions			= "Left click to shoot babby"
SWEP.Category				= "United Hosts"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.HoldType				= "shotgun"
SWEP.ViewModel				= "models/weapons/v_physcannon.mdl"
SWEP.WorldModel				= "models/weapons/w_physics.mdl"
SWEP.Weight					= 5

SWEP.Primary.Sound			= Sound("ambient/creatures/teddy.wav")
SWEP.Primary.Damage			= -1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.6
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Buckshot"
SWEP.Primary.NumShots		= 6
SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 6
SWEP.UH_BAB_Remove			= 4.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Recoil		= 5


function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()
	if (self:Clip1() != self.Primary.ClipSize) then
		self:EmitSound( Sound("weapons/physcannon/physcannon_charge.wav"), 90)
		self:DefaultReload(ACT_VM_RELOAD)
	end
end

local function UH_BAB_Detonate(self,babby)
	timer.Simple(1, function()
		if IsValid(babby) then
			babby:Remove()
		end
	end)
	
	if babby.UH_BAB_BeingRemoved then return end
	babby.UH_BAB_BeingRemoved = true
	
	if babby:IsOnFire() then
		babby:Extinguish()
	end
	
	babby:SetNotSolid(true)
	babby:SetMoveType(MOVETYPE_NONE)
	babby:SetNoDraw(true)
	
	if babby.UH_BAB_FleshBabby then
		babby:EmitSound( Sound("ambient/voices/f_scream1.wav"), 90, math.random(100,120) )
		
		local effect = EffectData()
			effect:SetOrigin( babby:GetPos() + Vector(0,0,5) )
			effect:SetStart( Vector(255,0,0) )
		util.Effect("balloon_pop", effect, true, true)
		
		if IsValid(self) and IsValid(self.Owner) then
			util.BlastDamage(self, self:GetOwner(), babby:GetPos(), 150, 62)
		end
	else
		local effect = EffectData()
			effect:SetEntity(babby)
		util.Effect("entity_remove", effect, true, true)
	end
	
	babby.Owner = NULL --So as not to keep effecting it
end


function SWEP:UH_BAB_Shoot(forward,right,upv)
	if not IsValid(self.Owner) then return end
	
	local ang = self.Owner:GetEyeTrace().HitPos:Length()
	local pos = self.Owner:EyePos() + (self.Owner:GetAimVector() * forward) + Vector(0,0,upv) +(self.Owner:GetRight()*right)
	
	local babby = ents.Create("prop_physics_multiplayer")
		babby:SetModel("models/props_c17/doll01.mdl")
		babby:SetPos(pos)
		babby.BaseProp = true --No physgun!
		babby.UH_BAB_IsBabby = true
		babby:SetAngles( self.Owner:EyeAngles() )
		--babby:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		babby:SetPhysicsAttacker(self.Owner)
		babby:SetOwner(self.Owner)
	babby:Spawn()
	
	if (math.random(1,6) == 6) and (self:WaterLevel() == 0) then
		babby.UH_BAB_FleshBabby = true
		babby:Ignite(4,1)
		babby:SetMaterial("models/flesh")
	end
	
	local phys = babby:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(5)
		phys:ApplyForceCenter(self.Owner:GetAimVector() * 9500)
	end
	
	
	timer.Simple(self.UH_BAB_Remove, function()
		if IsValid(babby) then
			UH_BAB_Detonate(self,babby)
		end
	end)
end


function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	self.BaseClass.ShootEffects(self)
	self:EmitSound( Sound("weapons/physcannon/superphys_launch"..math.random(1,4)..".wav" ) )
	
	self:TakePrimaryAmmo(1)
	
	timer.Simple(0.2, function()
		if IsValid(self) then
			self:EmitSound(self.Primary.Sound, 100, math.random(120,130) )
		end
	end)
	
	if SERVER then
		self:UH_BAB_Shoot(20,  -2,	 1)
		self:UH_BAB_Shoot(20, 	0,   1)
		self:UH_BAB_Shoot(20, 	2, 	 1)
		self:UH_BAB_Shoot(20,  -2,	-1)
		self:UH_BAB_Shoot(20, 	0, 	-1)
		self:UH_BAB_Shoot(20, 	2, 	-1)
	end
end


function SWEP:SecondaryAttack()
	if SERVER then
		for k,babby in pairs( ents.FindByModel("models/props_c17/doll01.mdl") ) do
			if IsValid(babby) and IsValid(self) and IsValid(self.Owner) and (babby:GetOwner() == self.Owner) then
				UH_BAB_Detonate(self,babby)
			end
		end
	end
end











----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------

if SERVER then
	AddCSLuaFile("shared.lua")
	
	resource.AddFile("materials/vgui/entities/baby_blaster.vmt")
	resource.AddFile("materials/vgui/entities/baby_blaster.vtf")
end


SWEP.PrintName		 		= "Baby Blaster"
SWEP.Author					= "cppchriscpp + HeX"
SWEP.Contact				= "None"
SWEP.Purpose				= "Blasts Babies"
SWEP.Instructions			= "Left click to shoot babby"
SWEP.Category				= "United Hosts"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.HoldType				= "shotgun"
SWEP.ViewModel				= "models/weapons/v_physcannon.mdl"
SWEP.WorldModel				= "models/weapons/w_physics.mdl"
SWEP.Weight					= 5

SWEP.Primary.Sound			= Sound("ambient/creatures/teddy.wav")
SWEP.Primary.Damage			= -1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.6
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Buckshot"
SWEP.Primary.NumShots		= 6
SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 6
SWEP.UH_BAB_Remove			= 4.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Recoil		= 5


function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()
	if (self:Clip1() != self.Primary.ClipSize) then
		self:EmitSound( Sound("weapons/physcannon/physcannon_charge.wav"), 90)
		self:DefaultReload(ACT_VM_RELOAD)
	end
end

local function UH_BAB_Detonate(self,babby)
	timer.Simple(1, function()
		if IsValid(babby) then
			babby:Remove()
		end
	end)
	
	if babby.UH_BAB_BeingRemoved then return end
	babby.UH_BAB_BeingRemoved = true
	
	if babby:IsOnFire() then
		babby:Extinguish()
	end
	
	babby:SetNotSolid(true)
	babby:SetMoveType(MOVETYPE_NONE)
	babby:SetNoDraw(true)
	
	if babby.UH_BAB_FleshBabby then
		babby:EmitSound( Sound("ambient/voices/f_scream1.wav"), 90, math.random(100,120) )
		
		local effect = EffectData()
			effect:SetOrigin( babby:GetPos() + Vector(0,0,5) )
			effect:SetStart( Vector(255,0,0) )
		util.Effect("balloon_pop", effect, true, true)
		
		if IsValid(self) and IsValid(self.Owner) then
			util.BlastDamage(self, self:GetOwner(), babby:GetPos(), 150, 62)
		end
	else
		local effect = EffectData()
			effect:SetEntity(babby)
		util.Effect("entity_remove", effect, true, true)
	end
	
	babby.Owner = NULL --So as not to keep effecting it
end


function SWEP:UH_BAB_Shoot(forward,right,upv)
	if not IsValid(self.Owner) then return end
	
	local ang = self.Owner:GetEyeTrace().HitPos:Length()
	local pos = self.Owner:EyePos() + (self.Owner:GetAimVector() * forward) + Vector(0,0,upv) +(self.Owner:GetRight()*right)
	
	local babby = ents.Create("prop_physics_multiplayer")
		babby:SetModel("models/props_c17/doll01.mdl")
		babby:SetPos(pos)
		babby.BaseProp = true --No physgun!
		babby.UH_BAB_IsBabby = true
		babby:SetAngles( self.Owner:EyeAngles() )
		--babby:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		babby:SetPhysicsAttacker(self.Owner)
		babby:SetOwner(self.Owner)
	babby:Spawn()
	
	if (math.random(1,6) == 6) and (self:WaterLevel() == 0) then
		babby.UH_BAB_FleshBabby = true
		babby:Ignite(4,1)
		babby:SetMaterial("models/flesh")
	end
	
	local phys = babby:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(5)
		phys:ApplyForceCenter(self.Owner:GetAimVector() * 9500)
	end
	
	
	timer.Simple(self.UH_BAB_Remove, function()
		if IsValid(babby) then
			UH_BAB_Detonate(self,babby)
		end
	end)
end


function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	self.BaseClass.ShootEffects(self)
	self:EmitSound( Sound("weapons/physcannon/superphys_launch"..math.random(1,4)..".wav" ) )
	
	self:TakePrimaryAmmo(1)
	
	timer.Simple(0.2, function()
		if IsValid(self) then
			self:EmitSound(self.Primary.Sound, 100, math.random(120,130) )
		end
	end)
	
	if SERVER then
		self:UH_BAB_Shoot(20,  -2,	 1)
		self:UH_BAB_Shoot(20, 	0,   1)
		self:UH_BAB_Shoot(20, 	2, 	 1)
		self:UH_BAB_Shoot(20,  -2,	-1)
		self:UH_BAB_Shoot(20, 	0, 	-1)
		self:UH_BAB_Shoot(20, 	2, 	-1)
	end
end


function SWEP:SecondaryAttack()
	if SERVER then
		for k,babby in pairs( ents.FindByModel("models/props_c17/doll01.mdl") ) do
			if IsValid(babby) and IsValid(self) and IsValid(self.Owner) and (babby:GetOwner() == self.Owner) then
				UH_BAB_Detonate(self,babby)
			end
		end
	end
end










