
----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Category			= "United Hosts"
SWEP.HoldType = "pistol"

if ( CLIENT ) then
	SWEP.DrawCrosshair		= true
	SWEP.Author				= "CSE - Night-Eagle + HeX"
	SWEP.Contact			= "gmail sedhdi"
	SWEP.Purpose			= ""
	SWEP.Instructions		= ""
	SWEP.PrintName			= "Dual Elites"
	SWEP.Instructions		= ""
	SWEP.Slot				= 1
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "s"
	
	killicon.AddFont("cse_elites","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end


SWEP.Base				= "cse_base_s"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_elite.mdl"


SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_ELITE.Single")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= 32
SWEP.Primary.Delay			= 0.06 //Don't use this, use the tables below!
SWEP.Primary.DefaultClip	= 62 //Always set this 1 higher than what you want.
SWEP.Primary.Automatic		= true //Don't use this, use the tables below!
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

//Firemode configuration

SWEP.IronSightsPos = Vector(0,0,0)
SWEP.IronSightsAng = Vector(0,0,0)

SWEP.data = {}
SWEP.mode = "semi" //The starting firemode
SWEP.data.newclip = false //Do not change this



SWEP.data.semi = {}
SWEP.data.semi.Delay = .07
SWEP.data.semi.Cone = 0.021
SWEP.data.semi.ConeZoom = 0.018

//End of configuration

function SWEP:ShootEffects()
	if self.left then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	
	self.left = not self.left
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

end

function SWEP:Think()
	if game.SinglePlayer() then self.data.SinglePlayer(self) end
	if self.data.init then		
		self:SetClip1( self:Clip1() - 2 )
		self.data.init = nil
	end
	if self.data.newclip then
		if self.data.newclip == 0 then
			self.data.newclip = false
			
			if self:Ammo1() > self.Primary.ClipSize - 2 then
				if self.data.oldclip == 0 then
					self:SetClip1( self:Clip1() - 2 )
					if SERVER then
						self.Owner:GiveAmmo(2,self.Primary.Ammo,true)
					end
				elseif self.data.oldclip == 1 then
					self:SetClip1( self:Clip1() - 1 )
					if SERVER then
						self.Owner:GiveAmmo(1,self.Primary.Ammo,true)
					end
				end
			elseif self:Ammo1() > self.Primary.ClipSize - 1 then
				if self.data.oldclip == 0 then
					self:SetClip1( self:Clip1() - 1 )
					if SERVER then
						self.Owner:GiveAmmo(1,self.Primary.Ammo,true)
					end
				end
			end
		else
			self.data.newclip = self.data.newclip - 1
		end
	end
end


----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Category			= "United Hosts"
SWEP.HoldType = "pistol"

if ( CLIENT ) then
	SWEP.DrawCrosshair		= true
	SWEP.Author				= "CSE - Night-Eagle + HeX"
	SWEP.Contact			= "gmail sedhdi"
	SWEP.Purpose			= ""
	SWEP.Instructions		= ""
	SWEP.PrintName			= "Dual Elites"
	SWEP.Instructions		= ""
	SWEP.Slot				= 1
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "s"
	
	killicon.AddFont("cse_elites","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end


SWEP.Base				= "cse_base_s"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_elite.mdl"


SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_ELITE.Single")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= 32
SWEP.Primary.Delay			= 0.06 //Don't use this, use the tables below!
SWEP.Primary.DefaultClip	= 62 //Always set this 1 higher than what you want.
SWEP.Primary.Automatic		= true //Don't use this, use the tables below!
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

//Firemode configuration

SWEP.IronSightsPos = Vector(0,0,0)
SWEP.IronSightsAng = Vector(0,0,0)

SWEP.data = {}
SWEP.mode = "semi" //The starting firemode
SWEP.data.newclip = false //Do not change this



SWEP.data.semi = {}
SWEP.data.semi.Delay = .07
SWEP.data.semi.Cone = 0.021
SWEP.data.semi.ConeZoom = 0.018

//End of configuration

function SWEP:ShootEffects()
	if self.left then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	
	self.left = not self.left
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

end

function SWEP:Think()
	if game.SinglePlayer() then self.data.SinglePlayer(self) end
	if self.data.init then		
		self:SetClip1( self:Clip1() - 2 )
		self.data.init = nil
	end
	if self.data.newclip then
		if self.data.newclip == 0 then
			self.data.newclip = false
			
			if self:Ammo1() > self.Primary.ClipSize - 2 then
				if self.data.oldclip == 0 then
					self:SetClip1( self:Clip1() - 2 )
					if SERVER then
						self.Owner:GiveAmmo(2,self.Primary.Ammo,true)
					end
				elseif self.data.oldclip == 1 then
					self:SetClip1( self:Clip1() - 1 )
					if SERVER then
						self.Owner:GiveAmmo(1,self.Primary.Ammo,true)
					end
				end
			elseif self:Ammo1() > self.Primary.ClipSize - 1 then
				if self.data.oldclip == 0 then
					self:SetClip1( self:Clip1() - 1 )
					if SERVER then
						self.Owner:GiveAmmo(1,self.Primary.Ammo,true)
					end
				end
			end
		else
			self.data.newclip = self.data.newclip - 1
		end
	end
end

