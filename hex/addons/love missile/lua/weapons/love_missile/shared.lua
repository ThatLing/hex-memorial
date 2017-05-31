
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------


SWEP.Author				= "HeX + Henry00"
SWEP.Contact			= "HeX"
SWEP.Purpose			= "Heat-Seeking Bazooka"
SWEP.Instructions		= "MOUSE1: Fire the missile, MOUSE2: Self-destruct all missiles!"
SWEP.Category			= "United Hosts"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.PrintName			= "Love Missile"			
SWEP.Slot				= 3
SWEP.SlotPos			= 10
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"
SWEP.FiresUnderwater	= false

SWEP.Primary.Sound 			= "weapons/grenade_launcher1.wav"
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.2 --2 --Gone, let them fire their 3 RPGs as fast as they want
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "RPG_Round"
SWEP.Primary.NextFire 		= 0

SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= -1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.Delay		= 2
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.NextFire 	= 0

SWEP.UH_BB_CanFire = true
SWEP.UH_BB_MaxAmmo = 10


function SWEP:PrimaryAttack()
	if not SERVER then return end
	
	if self.Primary.NextFire <= CurTime() then
		self.UH_BB_CanFire = true
	end
	
	if IsValid(self.Owner) and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 and self.UH_BB_CanFire then
		self.Primary.NextFire = CurTime() + self.Primary.Delay
		self.UH_BB_CanFire = false
		
		if hook.Run("HSP_NoFireWeapon", self) then return end
		
		
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		
		if self.Owner:GetAmmoCount(self.Primary.Ammo) > self.UH_BB_MaxAmmo then
			self.Owner:EmitSound( Sound("bot/what_are_you_doing.wav") )
			self.Owner:RemoveAmmo(1, self.Primary.Ammo)
			self:Ignite(4)
			self.Owner:DropWeapon(self)
		else
			self:EmitSound( Sound(self.Primary.Sound) )
			
			local nuke = ents.Create("uh_bb_missile")
				nuke.Owner = self.Owner
				if CPPI then
					nuke:CPPISetOwner(self.Owner)
				end
				nuke:SetOwner(self.Owner)
				nuke:SetPos( self.Owner:GetShootPos() + (64*self.Owner:GetForward()) + (16*self.Owner:GetRight()) )
				nuke:SetAngles( self.Owner:GetAngles() )
				nuke:Spawn()
			nuke:Activate()
			
			nuke:EmitSound( Sound("weapons/stinger_fire1.wav") )
			
			self:TakePrimaryAmmo(1)
		end
	end
end



function SWEP:SecondaryAttack() --Secondary, explode all missles
	if SERVER then
		for k,v in pairs( ents.FindByClass("uh_bb_missile") ) do
			if IsValid(v) and IsValid(v.Owner) and v.Owner == self.Owner then
				v:UH_BB_Detonate(nil,true) --explode
			end
		end
	end
end




function SWEP:Holster()
	return true
end
function SWEP:OnRemove()
	return true
end
function SWEP:Initialize()
	util.PrecacheSound(self.Primary.Sound) 
end
function SWEP:Deploy()
end
function SWEP:Reload()
end







----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------


SWEP.Author				= "HeX + Henry00"
SWEP.Contact			= "HeX"
SWEP.Purpose			= "Heat-Seeking Bazooka"
SWEP.Instructions		= "MOUSE1: Fire the missile, MOUSE2: Self-destruct all missiles!"
SWEP.Category			= "United Hosts"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.PrintName			= "Love Missile"			
SWEP.Slot				= 3
SWEP.SlotPos			= 10
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"
SWEP.FiresUnderwater	= false

SWEP.Primary.Sound 			= "weapons/grenade_launcher1.wav"
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.2 --2 --Gone, let them fire their 3 RPGs as fast as they want
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "RPG_Round"
SWEP.Primary.NextFire 		= 0

SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= -1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.Delay		= 2
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.NextFire 	= 0

SWEP.UH_BB_CanFire = true
SWEP.UH_BB_MaxAmmo = 10


function SWEP:PrimaryAttack()
	if not SERVER then return end
	
	if self.Primary.NextFire <= CurTime() then
		self.UH_BB_CanFire = true
	end
	
	if IsValid(self.Owner) and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 and self.UH_BB_CanFire then
		self.Primary.NextFire = CurTime() + self.Primary.Delay
		self.UH_BB_CanFire = false
		
		if hook.Run("HSP_NoFireWeapon", self) then return end
		
		
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		
		if self.Owner:GetAmmoCount(self.Primary.Ammo) > self.UH_BB_MaxAmmo then
			self.Owner:EmitSound( Sound("bot/what_are_you_doing.wav") )
			self.Owner:RemoveAmmo(1, self.Primary.Ammo)
			self:Ignite(4)
			self.Owner:DropWeapon(self)
		else
			self:EmitSound( Sound(self.Primary.Sound) )
			
			local nuke = ents.Create("uh_bb_missile")
				nuke.Owner = self.Owner
				if CPPI then
					nuke:CPPISetOwner(self.Owner)
				end
				nuke:SetOwner(self.Owner)
				nuke:SetPos( self.Owner:GetShootPos() + (64*self.Owner:GetForward()) + (16*self.Owner:GetRight()) )
				nuke:SetAngles( self.Owner:GetAngles() )
				nuke:Spawn()
			nuke:Activate()
			
			nuke:EmitSound( Sound("weapons/stinger_fire1.wav") )
			
			self:TakePrimaryAmmo(1)
		end
	end
end



function SWEP:SecondaryAttack() --Secondary, explode all missles
	if SERVER then
		for k,v in pairs( ents.FindByClass("uh_bb_missile") ) do
			if IsValid(v) and IsValid(v.Owner) and v.Owner == self.Owner then
				v:UH_BB_Detonate(nil,true) --explode
			end
		end
	end
end




function SWEP:Holster()
	return true
end
function SWEP:OnRemove()
	return true
end
function SWEP:Initialize()
	util.PrecacheSound(self.Primary.Sound) 
end
function SWEP:Deploy()
end
function SWEP:Reload()
end






