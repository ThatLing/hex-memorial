
----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------

if (SERVER) then
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 82
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true
	
	SWEP.ViewModelFlip		= false
	
	surface.CreateFont("CSKillIcons", {
		font		= "csd",
		size 		= ScreenScale(30),
		weight		= 500,
		antialias	= true,
		additive	= true,
		}
	)
	surface.CreateFont("CSSelectIcons", {
		font		= "csd",
		size 		= ScreenScale(60),
		weight		= 500,
		antialias	= true,
		additive	= true,
		}
	)
end

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound			= Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Unrecoil		= 4
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.15

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if SERVER then
	SWEP.xhair = {}
	SWEP.xhair.time = CurTime()
	SWEP.xhair.loss = 0
end

SWEP.data = {}
SWEP.data.auto = {}

SWEP.data.zoomfov = 70
SWEP.data.snipefov = 0

function SWEP:Reload()
	self:SetIronsights(false)
	if self.sniping then
		self.sniping = false
	end
	
	if SERVER and self.Owner:GetFOV() ~= 90 then
		self.Owner:SetFOV(90,.3)
	end
	
	self.data.oldclip = self:Clip1()
	
	self:DefaultReload(ACT_VM_RELOAD)
	self.data.newclip = 1
end

function SWEP:Deploy()
	self:SetIronsights(false)
	if self.sniping then
		self.sniping = false
	end
	if SERVER then
		if self.mode == "auto" then
			self:SetNetworkedInt("csef",1)
		elseif self.mode == "burst" then
			self:SetNetworkedInt("csef",2)
		elseif self.mode == "semi" then
			self:SetNetworkedInt("csef",3)
		end
	end
	self.data[self.mode].Init(self)
	return true
end

function SWEP:CSShootBullet( dmg, recoil, numbul, cone )
	
	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01

	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	if numbul == 1 then
		bullet.Spread 	= Vector( cone, cone, 0 ) * self.xhair.loss		// Aim Cone
		if self.Owner:Crouching() then
			bullet.Spread = bullet.Spread * .95
		end
		if !self.Owner:IsOnGround() then
			bullet.Spread = Vector( cone, cone, 0 ) * 20
		end
	else
		bullet.Spread 	= Vector( cone, cone, 0 )		// Aim Cone
	end
	bullet.Tracer	= 4									// Show a tracer on every x bullets 
	bullet.Force	= 5									// Amount of force to give to phys objects
	bullet.Damage	= dmg
	
	self.Owner:FireBullets( bullet )
	self:ShootEffects()
	
	--[[ CUSTOM RECOIL !
	if ( (game.SinglePlayer() && SERVER) || ( !game.SinglePlayer() && CLIENT ) ) then
	
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	
	end]]
	if SERVER then
		self.xhair.loss = self.xhair.loss + self.Primary.Recoil
		
		if self.xhair.loss > 0 then
			self.xhair.loss = self.xhair.loss - (self.Primary.Unrecoil * (CurTime() - self.xhair.time))
			if self.Owner:Crouching() then
				self.xhair.loss = self.xhair.loss * .975
			end
			if !self.Owner:IsOnGround() then
				self.xhair.loss = 20
			end
		end
		if self.xhair.loss <= 0 then
			self.xhair.loss = 0.01
		end
		if self.xhair.loss > 20 then
			self.xhair.loss = 20
		end
		self.xhair.time = CurTime()
	end
end

function SWEP:ShootEffects()
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
end

if game.SinglePlayer() then
	function SWEP.data.SinglePlayer(self)
		if game.SinglePlayer() then
			if SERVER then
				if self.xhair.loss > 0 then
					self.xhair.loss = self.xhair.loss - (self.Primary.Unrecoil * (CurTime() - self.xhair.time))
					if self.Owner:Crouching() then
						self.xhair.loss = self.xhair.loss * .975
					end
					if !self.Owner:IsOnGround() then
						self.xhair.loss = 20
					end
				end
				if self.xhair.loss <= 0 then
					self.xhair.loss = 0.01
				end
				if self.xhair.loss > 20 then
					self.xhair.loss = 20
				end
				self.xhair.time = CurTime()
				
				self:SetNetworkedInt("csefl",self.xhair.loss)
			else
				self.xhair.loss = self:GetNetworkedInt("csefl")
			end
		end
	end
end

//Garry's code below

SWEP.IronSightsPos = Vector(0,0,0)
SWEP.IronSightsAng = Vector(0,0,0)

local IRONSIGHT_TIME = 0.25

function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end

function SWEP:SetIronsights( b )

	if ( self:GetNetworkedBool( "Ironsights" ) == b ) then return end
	self:SetNetworkedBool( "Ironsights", b )

end



----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------

if (SERVER) then
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 82
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true
	
	SWEP.ViewModelFlip		= false
	
	surface.CreateFont("CSKillIcons", {
		font		= "csd",
		size 		= ScreenScale(30),
		weight		= 500,
		antialias	= true,
		additive	= true,
		}
	)
	surface.CreateFont("CSSelectIcons", {
		font		= "csd",
		size 		= ScreenScale(60),
		weight		= 500,
		antialias	= true,
		additive	= true,
		}
	)
end

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound			= Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Unrecoil		= 4
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.15

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if SERVER then
	SWEP.xhair = {}
	SWEP.xhair.time = CurTime()
	SWEP.xhair.loss = 0
end

SWEP.data = {}
SWEP.data.auto = {}

SWEP.data.zoomfov = 70
SWEP.data.snipefov = 0

function SWEP:Reload()
	self:SetIronsights(false)
	if self.sniping then
		self.sniping = false
	end
	
	if SERVER and self.Owner:GetFOV() ~= 90 then
		self.Owner:SetFOV(90,.3)
	end
	
	self.data.oldclip = self:Clip1()
	
	self:DefaultReload(ACT_VM_RELOAD)
	self.data.newclip = 1
end

function SWEP:Deploy()
	self:SetIronsights(false)
	if self.sniping then
		self.sniping = false
	end
	if SERVER then
		if self.mode == "auto" then
			self:SetNetworkedInt("csef",1)
		elseif self.mode == "burst" then
			self:SetNetworkedInt("csef",2)
		elseif self.mode == "semi" then
			self:SetNetworkedInt("csef",3)
		end
	end
	self.data[self.mode].Init(self)
	return true
end

function SWEP:CSShootBullet( dmg, recoil, numbul, cone )
	
	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01

	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	if numbul == 1 then
		bullet.Spread 	= Vector( cone, cone, 0 ) * self.xhair.loss		// Aim Cone
		if self.Owner:Crouching() then
			bullet.Spread = bullet.Spread * .95
		end
		if !self.Owner:IsOnGround() then
			bullet.Spread = Vector( cone, cone, 0 ) * 20
		end
	else
		bullet.Spread 	= Vector( cone, cone, 0 )		// Aim Cone
	end
	bullet.Tracer	= 4									// Show a tracer on every x bullets 
	bullet.Force	= 5									// Amount of force to give to phys objects
	bullet.Damage	= dmg
	
	self.Owner:FireBullets( bullet )
	self:ShootEffects()
	
	--[[ CUSTOM RECOIL !
	if ( (game.SinglePlayer() && SERVER) || ( !game.SinglePlayer() && CLIENT ) ) then
	
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	
	end]]
	if SERVER then
		self.xhair.loss = self.xhair.loss + self.Primary.Recoil
		
		if self.xhair.loss > 0 then
			self.xhair.loss = self.xhair.loss - (self.Primary.Unrecoil * (CurTime() - self.xhair.time))
			if self.Owner:Crouching() then
				self.xhair.loss = self.xhair.loss * .975
			end
			if !self.Owner:IsOnGround() then
				self.xhair.loss = 20
			end
		end
		if self.xhair.loss <= 0 then
			self.xhair.loss = 0.01
		end
		if self.xhair.loss > 20 then
			self.xhair.loss = 20
		end
		self.xhair.time = CurTime()
	end
end

function SWEP:ShootEffects()
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
end

if game.SinglePlayer() then
	function SWEP.data.SinglePlayer(self)
		if game.SinglePlayer() then
			if SERVER then
				if self.xhair.loss > 0 then
					self.xhair.loss = self.xhair.loss - (self.Primary.Unrecoil * (CurTime() - self.xhair.time))
					if self.Owner:Crouching() then
						self.xhair.loss = self.xhair.loss * .975
					end
					if !self.Owner:IsOnGround() then
						self.xhair.loss = 20
					end
				end
				if self.xhair.loss <= 0 then
					self.xhair.loss = 0.01
				end
				if self.xhair.loss > 20 then
					self.xhair.loss = 20
				end
				self.xhair.time = CurTime()
				
				self:SetNetworkedInt("csefl",self.xhair.loss)
			else
				self.xhair.loss = self:GetNetworkedInt("csefl")
			end
		end
	end
end

//Garry's code below

SWEP.IronSightsPos = Vector(0,0,0)
SWEP.IronSightsAng = Vector(0,0,0)

local IRONSIGHT_TIME = 0.25

function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end

function SWEP:SetIronsights( b )

	if ( self:GetNetworkedBool( "Ironsights" ) == b ) then return end
	self:SetNetworkedBool( "Ironsights", b )

end


