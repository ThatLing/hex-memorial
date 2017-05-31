
----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------

if (SERVER) then
	AddCSLuaFile("shared.lua")
	resource.AddFile("sound/weapons/boomstick.wav")
	
	SWEP.Weight				= 5
	SWEP.HoldType			= "shotgun"
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("shotgun")  
end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false

	SWEP.DrawCrosshair	= true
	SWEP.IconLetter = "0"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
--	killicon.AddFont( "BOOMSTICK", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "kh_base"
SWEP.Category			= "United Hosts"

SWEP.PrintName			= "BOOMSTICK!"
SWEP.Author				= "HeX"
SWEP.Purpose			= "This is my BOOMSTICK!"
SWEP.Instructions		= "Mouse1 = MY BOOMSTICK!, Mouse2 = Change mode."

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel	= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.Firemodes = { "Single Shot", "Double Blast" }

SWEP.SprintPos = Vector(-0.635, -2.2638, 6.6202)
SWEP.SprintAng = Vector(-18.3251, -0.1794, -4.4458)

--SWEP.Primary.Sound			= Sound("weapons/shotgun/shotgun_fire6.wav")
SWEP.Primary.Sound			= Sound("weapons/boomstick.wav")
SWEP.Primary.Reload         = Sound("weapons/shotgun/shotgun_reload3.wav")
SWEP.Primary.ModeChange		= Sound("weapons/357/357_reload4.wav")
SWEP.Primary.Pump           = Sound("Weapon_Shotgun.Special1")
SWEP.Primary.Recoil			= 25
SWEP.Primary.Damage			= 5
SWEP.Primary.NumShots		= 25
SWEP.Primary.Cone			= 0.110
SWEP.Primary.Delay			= 0.450
SWEP.Primary.PumpDelay      = 0.500

SWEP.Primary.ClipSize		= 6
SWEP.Primary.Automatic		= false

SWEP.Secondary.Sound        = Sound("weapons/shotgun/shotgun_fire7.wav")
SWEP.Secondary.ModeChange	= Sound("weapons/357/357_reload3.wav")
SWEP.Secondary.Recoil		= 30
SWEP.Secondary.Damage		= 5
SWEP.Secondary.NumShots		= 12
SWEP.Secondary.Cone			= 0.120
SWEP.Secondary.Delay        = 0.200

SWEP.PumpPos = Vector(0.3955, -12.5938, -16.5632)
SWEP.PumpAng = Vector(50.4407, -9.9458, 1.3236)

SWEP.PumpTime = 0
SWEP.RaiseTime = 0
SWEP.Pumped = true

function SWEP:CanPrimaryAttack()

	if self.Owner:KeyDown(IN_SPEED) or self.LastRunFrame > CurTime() then
		return false
	end

	if self:GetNWBool("Reloading",false) then
		return false
	end
	
	if self:Clip1() <= 0 then
	
		self.ReloadTimer = CurTime() + 0.35	
		
		self:SetNetworkedBool( "Reloading", true )
		self:SendWeaponAnim( ACT_VM_RELOAD )
		
		return false
		
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	if self:GetFiremode() == 1 then

		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay + 0.3 )

		self:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		self:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
		self:TakePrimaryAmmo( 1 )
		
		if SERVER then
			self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0))
		end
		
		self.PumpTime = CurTime() + self.Primary.PumpDelay
		self.RaiseTime = CurTime() + 0.2
		self.Pumped = false
		self.ReloadTimer = 0
		
	else
	
		if self:Clip1() < 2 then
		
			self.ReloadTimer = CurTime() + 0.35	
		
			self:SetNWBool( "Reloading", true )
			self:SendWeaponAnim( ACT_VM_RELOAD )
		
		else
	
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay + 0.3 )
			self.DoubleShot = 0
			self.DoubleTime = 0
	
		end
	end
end

function SWEP:IdleViewModelPos( movetime, duration, mul )

	mul = 1
		
	if ( CurTime() - movetime < duration ) then
		mul = math.Clamp( (CurTime() - duration) / movetime, 0, 1 )
	end
	
	if self:GetNWBool("ReverseAnim",false) then
		return 1 - mul
	end
	
	return mul

end

function SWEP:Think()

	if self.DoubleShot then
	
		if self.DoubleTime < CurTime() then
		
			self.DoubleShot = self.DoubleShot + 1
			self.DoubleTime = CurTime() + self.Secondary.Delay

			self:EmitSound( self.Secondary.Sound, 100, math.random(95,105) )
			self:ShootBullets( self.Secondary.Damage, self.Secondary.NumShots, self.Secondary.Cone )
			self:TakePrimaryAmmo( 1 )
		
		end
		
		if self.DoubleShot >= 2 then
		
			if SERVER then
				self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0))
				if !self.Owner:OnGround() then
					self.Owner:SetVelocity(self.Owner:GetVelocity() + self.Owner:GetAimVector() * -300 + Vector(0,0,100))
				end
			end
		
			self.DoubleShot = nil
			self.PumpTime = CurTime() + self.Primary.PumpDelay
			self.RaiseTime = CurTime() + 0.2
			self.Pumped = false
			self.ReloadTimer = 0
		
		end
	end

	if not self.Pumped then
	
		if self.RaiseTime <= CurTime() and SERVER then
		
			self:SetNWBool("ReverseAnim", false)
			self:SetViewModelPosition( self.PumpPos, self.PumpAng, 0.3 )
			self.RaiseTime = CurTime() + 5
	
		elseif self.PumpTime <= CurTime() then
	
			self:PumpIt()
			self:SetNWBool("ReverseAnim", true)
			self:SetViewModelPosition( self.PumpPos, self.PumpAng, 0.3 )
			self.PumpTime = CurTime() + 5
			
		end
	end
	
	if self:GetNWBool( "Reloading", false ) then
	
		if self.ReloadTimer < CurTime() then
			
			local clip1 = self:Clip1() or 0
			
			// Finished reloading
			if clip1 == self.Primary.ClipSize then
				self:SetNWBool( "Reloading", false )
				return
			end
			
			// Next cycle
			self.ReloadTimer = CurTime() + self.Primary.Delay
			self:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self:SetClip1( clip1 + 1 )
			
			// Sounds
			self:EmitSound( self.Primary.Reload, 100, math.random(90,110) )
			
			// Finish filling, final pump
			if ( self:Clip1() >= self.Primary.ClipSize ) then
				self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
			end
		end
	end
end

function SWEP:Reload()
	
	if self:Clip1() < self.Primary.ClipSize then
		
		self.ReloadTimer = CurTime() + 0.35	
		
		self:SetNWBool( "Reloading", true )
		self:SendWeaponAnim( ACT_VM_RELOAD )
		
	end
end

function SWEP:PumpIt()

	self.Pumped = true

	self:SetNWBool( "Reloading", false )
	self:SendWeaponAnim( ACT_SHOTGUN_PUMP )
	self:EmitSound( self.Primary.Pump )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end

function SWEP:OnModeChange( mode )
	
	if mode == 1 then
		self:PumpIt()
		self:TakePrimaryAmmo( 1 )
	end

end 


function SWEP:ShootBullets( damage, numbullets, aimcone )

	self.ReloadPlay = false

	local scale = aimcone
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = aimcone * 1.5
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( aimcone / 1.2, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= math.Round(damage * 2)							
	bullet.Damage	= math.Round(damage)
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		
	end
	
	self.Owner:FireBullets( bullet )
	
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	
	if self.Owner.MuzzleFlash then
		self.Owner:MuzzleFlash()
		self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	end
end


SWEP.CrosshairScale = 1
function SWEP:DrawHUD()

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	local scalebywidth = ( ScrW() / 1024 ) * 10
	
	local scale = self.Primary.Cone
	
	if self:GetFiremode() == 2 then
		scale = self.Secondary.Cone
	end
	
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = scale * 1.5
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( scale / 1.2, 0, 10 )
	end
	
	//scale = math.Clamp( ( 10 + ( scale * ( 260 * (ScrH()/720) ) ) ) * self.CrossScale:GetFloat(), 0, (ScrH()/2) - 100 )
	//self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 )
	
	// CAN'T GET THIS TO WORK NICELY
	
	scale = scale * scalebywidth * self.CrossScale:GetFloat()
	
	local dist = math.abs(self.CrosshairScale - scale)
	self.CrosshairScale = math.Approach(self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05)
	
	local gap = 40 * self.CrosshairScale
	local length = gap + 20 * self.CrosshairScale
	
	surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
	surface.DrawLine(x - length, y, x - gap, y)
	surface.DrawLine(x + length, y, x + gap, y)
	surface.DrawLine(x, y - length, x, y - gap)
	surface.DrawLine(x, y + length, x, y + gap)
	
end


----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------

if (SERVER) then
	AddCSLuaFile("shared.lua")
	resource.AddFile("sound/weapons/boomstick.wav")
	
	SWEP.Weight				= 5
	SWEP.HoldType			= "shotgun"
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("shotgun")  
end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false

	SWEP.DrawCrosshair	= true
	SWEP.IconLetter = "0"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
--	killicon.AddFont( "BOOMSTICK", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "kh_base"
SWEP.Category			= "United Hosts"

SWEP.PrintName			= "BOOMSTICK!"
SWEP.Author				= "HeX"
SWEP.Purpose			= "This is my BOOMSTICK!"
SWEP.Instructions		= "Mouse1 = MY BOOMSTICK!, Mouse2 = Change mode."

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel	= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.Firemodes = { "Single Shot", "Double Blast" }

SWEP.SprintPos = Vector(-0.635, -2.2638, 6.6202)
SWEP.SprintAng = Vector(-18.3251, -0.1794, -4.4458)

--SWEP.Primary.Sound			= Sound("weapons/shotgun/shotgun_fire6.wav")
SWEP.Primary.Sound			= Sound("weapons/boomstick.wav")
SWEP.Primary.Reload         = Sound("weapons/shotgun/shotgun_reload3.wav")
SWEP.Primary.ModeChange		= Sound("weapons/357/357_reload4.wav")
SWEP.Primary.Pump           = Sound("Weapon_Shotgun.Special1")
SWEP.Primary.Recoil			= 25
SWEP.Primary.Damage			= 5
SWEP.Primary.NumShots		= 25
SWEP.Primary.Cone			= 0.110
SWEP.Primary.Delay			= 0.450
SWEP.Primary.PumpDelay      = 0.500

SWEP.Primary.ClipSize		= 6
SWEP.Primary.Automatic		= false

SWEP.Secondary.Sound        = Sound("weapons/shotgun/shotgun_fire7.wav")
SWEP.Secondary.ModeChange	= Sound("weapons/357/357_reload3.wav")
SWEP.Secondary.Recoil		= 30
SWEP.Secondary.Damage		= 5
SWEP.Secondary.NumShots		= 12
SWEP.Secondary.Cone			= 0.120
SWEP.Secondary.Delay        = 0.200

SWEP.PumpPos = Vector(0.3955, -12.5938, -16.5632)
SWEP.PumpAng = Vector(50.4407, -9.9458, 1.3236)

SWEP.PumpTime = 0
SWEP.RaiseTime = 0
SWEP.Pumped = true

function SWEP:CanPrimaryAttack()

	if self.Owner:KeyDown(IN_SPEED) or self.LastRunFrame > CurTime() then
		return false
	end

	if self:GetNWBool("Reloading",false) then
		return false
	end
	
	if self:Clip1() <= 0 then
	
		self.ReloadTimer = CurTime() + 0.35	
		
		self:SetNetworkedBool( "Reloading", true )
		self:SendWeaponAnim( ACT_VM_RELOAD )
		
		return false
		
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	if self:GetFiremode() == 1 then

		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay + 0.3 )

		self:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		self:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
		self:TakePrimaryAmmo( 1 )
		
		if SERVER then
			self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0))
		end
		
		self.PumpTime = CurTime() + self.Primary.PumpDelay
		self.RaiseTime = CurTime() + 0.2
		self.Pumped = false
		self.ReloadTimer = 0
		
	else
	
		if self:Clip1() < 2 then
		
			self.ReloadTimer = CurTime() + 0.35	
		
			self:SetNWBool( "Reloading", true )
			self:SendWeaponAnim( ACT_VM_RELOAD )
		
		else
	
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay + 0.3 )
			self.DoubleShot = 0
			self.DoubleTime = 0
	
		end
	end
end

function SWEP:IdleViewModelPos( movetime, duration, mul )

	mul = 1
		
	if ( CurTime() - movetime < duration ) then
		mul = math.Clamp( (CurTime() - duration) / movetime, 0, 1 )
	end
	
	if self:GetNWBool("ReverseAnim",false) then
		return 1 - mul
	end
	
	return mul

end

function SWEP:Think()

	if self.DoubleShot then
	
		if self.DoubleTime < CurTime() then
		
			self.DoubleShot = self.DoubleShot + 1
			self.DoubleTime = CurTime() + self.Secondary.Delay

			self:EmitSound( self.Secondary.Sound, 100, math.random(95,105) )
			self:ShootBullets( self.Secondary.Damage, self.Secondary.NumShots, self.Secondary.Cone )
			self:TakePrimaryAmmo( 1 )
		
		end
		
		if self.DoubleShot >= 2 then
		
			if SERVER then
				self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0))
				if !self.Owner:OnGround() then
					self.Owner:SetVelocity(self.Owner:GetVelocity() + self.Owner:GetAimVector() * -300 + Vector(0,0,100))
				end
			end
		
			self.DoubleShot = nil
			self.PumpTime = CurTime() + self.Primary.PumpDelay
			self.RaiseTime = CurTime() + 0.2
			self.Pumped = false
			self.ReloadTimer = 0
		
		end
	end

	if not self.Pumped then
	
		if self.RaiseTime <= CurTime() and SERVER then
		
			self:SetNWBool("ReverseAnim", false)
			self:SetViewModelPosition( self.PumpPos, self.PumpAng, 0.3 )
			self.RaiseTime = CurTime() + 5
	
		elseif self.PumpTime <= CurTime() then
	
			self:PumpIt()
			self:SetNWBool("ReverseAnim", true)
			self:SetViewModelPosition( self.PumpPos, self.PumpAng, 0.3 )
			self.PumpTime = CurTime() + 5
			
		end
	end
	
	if self:GetNWBool( "Reloading", false ) then
	
		if self.ReloadTimer < CurTime() then
			
			local clip1 = self:Clip1() or 0
			
			// Finished reloading
			if clip1 == self.Primary.ClipSize then
				self:SetNWBool( "Reloading", false )
				return
			end
			
			// Next cycle
			self.ReloadTimer = CurTime() + self.Primary.Delay
			self:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self:SetClip1( clip1 + 1 )
			
			// Sounds
			self:EmitSound( self.Primary.Reload, 100, math.random(90,110) )
			
			// Finish filling, final pump
			if ( self:Clip1() >= self.Primary.ClipSize ) then
				self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
			end
		end
	end
end

function SWEP:Reload()
	
	if self:Clip1() < self.Primary.ClipSize then
		
		self.ReloadTimer = CurTime() + 0.35	
		
		self:SetNWBool( "Reloading", true )
		self:SendWeaponAnim( ACT_VM_RELOAD )
		
	end
end

function SWEP:PumpIt()

	self.Pumped = true

	self:SetNWBool( "Reloading", false )
	self:SendWeaponAnim( ACT_SHOTGUN_PUMP )
	self:EmitSound( self.Primary.Pump )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end

function SWEP:OnModeChange( mode )
	
	if mode == 1 then
		self:PumpIt()
		self:TakePrimaryAmmo( 1 )
	end

end 


function SWEP:ShootBullets( damage, numbullets, aimcone )

	self.ReloadPlay = false

	local scale = aimcone
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = aimcone * 1.5
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( aimcone / 1.2, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= math.Round(damage * 2)							
	bullet.Damage	= math.Round(damage)
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		
	end
	
	self.Owner:FireBullets( bullet )
	
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	
	if self.Owner.MuzzleFlash then
		self.Owner:MuzzleFlash()
		self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	end
end


SWEP.CrosshairScale = 1
function SWEP:DrawHUD()

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	local scalebywidth = ( ScrW() / 1024 ) * 10
	
	local scale = self.Primary.Cone
	
	if self:GetFiremode() == 2 then
		scale = self.Secondary.Cone
	end
	
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = scale * 1.5
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( scale / 1.2, 0, 10 )
	end
	
	//scale = math.Clamp( ( 10 + ( scale * ( 260 * (ScrH()/720) ) ) ) * self.CrossScale:GetFloat(), 0, (ScrH()/2) - 100 )
	//self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 )
	
	// CAN'T GET THIS TO WORK NICELY
	
	scale = scale * scalebywidth * self.CrossScale:GetFloat()
	
	local dist = math.abs(self.CrosshairScale - scale)
	self.CrosshairScale = math.Approach(self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05)
	
	local gap = 40 * self.CrosshairScale
	local length = gap + 20 * self.CrosshairScale
	
	surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
	surface.DrawLine(x - length, y, x - gap, y)
	surface.DrawLine(x + length, y, x + gap, y)
	surface.DrawLine(x, y - length, x, y - gap)
	surface.DrawLine(x, y + length, x, y + gap)
	
end

