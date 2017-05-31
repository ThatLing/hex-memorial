
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

SWEP.Author			= "Stingwraith + HeX"
SWEP.Contact		= "stingwraith123@yahoo.com"
SWEP.Purpose		= "Sacrifice yourself"
SWEP.Instructions	= "Left Click to make yourself EXPLODE. Right click to taunt."

SWEP.Category			= "United Hosts"

SWEP.DrawCrosshair		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay			= 3

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

local TauntSound = Sound("vo/npc/male01/overhere01.wav")

function SWEP:Initialize()
    util.PrecacheSound("siege/big_explosion_new.mp3")
    util.PrecacheSound("siege/jihad.mp3")
	self:SetWeaponHoldType("slam")
end




function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 3)
	
	if self.Owner:Frags() <= 2 then
		if SERVER then
			if HSP then
				self.Owner:CAT(HSP.GREEN, "[HSP] ", HSP.RED, "You need more than 2 kills to use the Suicide Bomb!")
			end
			
			self.Owner:EmitSound("vo/npc/male01/question11.wav")
		end
		return
	end
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetPos() )
		effectdata:SetNormal( self.Owner:GetPos() )
		effectdata:SetMagnitude(8)
		effectdata:SetScale(1)
		effectdata:SetRadius(16)
	util.Effect("Sparks", effectdata)
	
	self.BaseClass.ShootEffects( self )
	
	if SERVER then
		self.Owner:EmitSound("siege/jihad.mp3", 90, math.random(100,140) )
		
		self.Owner.SACHSuicideWindow = true
		timer.Simple(2, function() 
			if not IsValid(self) or not IsValid(self.Owner) or not self.Owner:Alive() then return end
			
			self.Owner.SACHSuicideWindow = false
			
			local ent = ents.Create("env_explosion")
				ent:SetPos( self.Owner:GetPos() )
				ent:SetOwner(self.Owner)
				ent:Spawn()
				ent:SetKeyValue("iMagnitude", "250")
			ent:Fire("Explode", 0, 0)
			
			ent:EmitSound("siege/big_explosion_new.mp3", 500)
			
			self.Owner:AddFrags(-2)
			self.Owner:Kill()
		end)
	end
end


function SWEP:SecondaryAttack()	
	self:SetNextSecondaryFire( CurTime() + 1 )
	
	if SERVER then
		if hook.Run("HSP_NoFireWeapon", self) then return end
		self.Owner:EmitSound( TauntSound, 90, math.random(100,110) )
	end
end














----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

SWEP.Author			= "Stingwraith + HeX"
SWEP.Contact		= "stingwraith123@yahoo.com"
SWEP.Purpose		= "Sacrifice yourself"
SWEP.Instructions	= "Left Click to make yourself EXPLODE. Right click to taunt."

SWEP.Category			= "United Hosts"

SWEP.DrawCrosshair		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay			= 3

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

local TauntSound = Sound("vo/npc/male01/overhere01.wav")

function SWEP:Initialize()
    util.PrecacheSound("siege/big_explosion_new.mp3")
    util.PrecacheSound("siege/jihad.mp3")
	self:SetWeaponHoldType("slam")
end




function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 3)
	
	if self.Owner:Frags() <= 2 then
		if SERVER then
			if HSP then
				self.Owner:CAT(HSP.GREEN, "[HSP] ", HSP.RED, "You need more than 2 kills to use the Suicide Bomb!")
			end
			
			self.Owner:EmitSound("vo/npc/male01/question11.wav")
		end
		return
	end
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetPos() )
		effectdata:SetNormal( self.Owner:GetPos() )
		effectdata:SetMagnitude(8)
		effectdata:SetScale(1)
		effectdata:SetRadius(16)
	util.Effect("Sparks", effectdata)
	
	self.BaseClass.ShootEffects( self )
	
	if SERVER then
		self.Owner:EmitSound("siege/jihad.mp3", 90, math.random(100,140) )
		
		self.Owner.SACHSuicideWindow = true
		timer.Simple(2, function() 
			if not IsValid(self) or not IsValid(self.Owner) or not self.Owner:Alive() then return end
			
			self.Owner.SACHSuicideWindow = false
			
			local ent = ents.Create("env_explosion")
				ent:SetPos( self.Owner:GetPos() )
				ent:SetOwner(self.Owner)
				ent:Spawn()
				ent:SetKeyValue("iMagnitude", "250")
			ent:Fire("Explode", 0, 0)
			
			ent:EmitSound("siege/big_explosion_new.mp3", 500)
			
			self.Owner:AddFrags(-2)
			self.Owner:Kill()
		end)
	end
end


function SWEP:SecondaryAttack()	
	self:SetNextSecondaryFire( CurTime() + 1 )
	
	if SERVER then
		if hook.Run("HSP_NoFireWeapon", self) then return end
		self.Owner:EmitSound( TauntSound, 90, math.random(100,110) )
	end
end













