
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.Category			= "United Hosts"
SWEP.PrintName			= "Plasma Rifle"
SWEP.Author				= "HeX"
SWEP.Purpose			= "Point at enemy"
SWEP.Instructions		= "Mouse1 = Energy Beam, Mouse2 = Change mode."
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_irifle.mdl"
SWEP.WorldModel 		= "models/weapons/w_irifle.mdl"
SWEP.Base				= "kh_base"
SWEP.Weight				= 5
SWEP.HoldType			= "ar2"
SWEP.ViewModelFOV		= 60
SWEP.DrawCrosshair		= true
SWEP.PrintName 			= "Plasma Rifle"
SWEP.Slot 				= 3
SWEP.Slotpos 			= 3
SWEP.IconLetter 		= "2"

SWEP.Firemodes = { "Energy Beam", "Plasma Bomb" }
SWEP.SprintPos = Vector(6.4052, -2.85, 3.048)
SWEP.SprintAng = Vector(-19.1447, 37.0746, -6.773)

SWEP.Primary.Sound			= Sound("weapons/physcannon/energy_sing_flyby1.wav")
SWEP.Primary.Reload     	= Sound("weapons/physcannon/physcannon_charge.wav")
SWEP.Primary.ModeChange		= Sound("weapons/ar2/ar2_reload_rotate.wav")
SWEP.Primary.Damage			= 22 --49
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.Delay       	= 0.2
SWEP.Primary.Automatic		= true

SWEP.Secondary.Sound		= Sound("weapons/airboat/airboat_gun_energy1.wav")
SWEP.Secondary.Reload		= Sound("weapons/ar2/ar2_reload_rotate.wav")
SWEP.Secondary.ModeChange	= Sound("weapons/ar2/ar2_empty.wav")
SWEP.Secondary.Damage		= 90
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0.035
SWEP.Secondary.Delay		= 3
SWEP.Secondary.ClipSize		= 3
SWEP.Secondary.Automatic	= false

SWEP.Load = nil


function SWEP:Initialize()  
	self:SetWeaponHoldType("ar2")  
end


function SWEP:PrimaryAttack()

	if self:Clip1() <= 0 then
		self:DefaultReload( ACT_VM_RELOAD )
	end

	if not self:CanPrimaryAttack() then return end
	self.Load = CurTime() + .3
		
	if self:GetFiremode() == 1 then
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		self:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
		
		local trace = self.Owner:GetEyeTrace() --fucking laser
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetEntity( trace.Entity )
		effectdata:SetAttachment( trace.PhysicsBone )
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
		util.Effect( "ToolTracer", effectdata )
		
		self:TakePrimaryAmmo( 1 )
	else
		self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
		self:EmitSound( self.Secondary.Sound, 100, math.random(95,105) )
		self:TakePrimaryAmmo( 1 )
		
		if SERVER then
			if not hook.Run("HSP_NoFireWeapon", self) then
				self:FirePalsma() 
			end
		end
	end	
end

function SWEP:Think()	
	if self.Owner:KeyDown(IN_SPEED) then
		self.LastRunFrame = CurTime() + 0.3
	end
	
	--[[
	if not self.Load then return end
	if self.Load < CurTime() then
		self:DefaultReload( ACT_VM_RELOAD )
		self.Load = nil
	end
	]]
	
end

local function RicochetCallback( damage, attacker, tr, dmginfo )
	
	local hitplayer
	
	if tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() then
		hitplayer = tr.Entity
	end
	
	if not tr.HitSky and not hitplayer and damage >= 20 then
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetNormal( tr.HitNormal )
		util.Effect( "laser_bounce", ed, true )
		
		sound.Play( "weapons/physcannon/energy_bounce2.wav", tr.HitPos, 100, math.random(110,130) )
		
	elseif tr.HitSky or damage < 20 or hitplayer then
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetNormal( tr.HitNormal )
		util.Effect( "laser_disintegrate", ed, true )
		
		sound.Play( "weapons/physcannon/energy_disintegrate4.wav", tr.HitPos, 100, math.random(110,130) )
		
		return
	end
	
	if CLIENT then return end
	
	local Dot = tr.HitNormal:Dot( tr.Normal * -1 )
	local bullet = 
	{	
		Num 		= 1,
		Src 		= tr.HitPos,
		Dir 		= ( 2 * tr.HitNormal * Dot ) + tr.Normal, 
		Spread 		= Vector( 0, 0, 0 ),
		Tracer		= 1,
		TracerName 	= "laser_tracer",
		Force		= damage ^ 2,
		Damage		= damage,
		AmmoType 	= "Pistol" 
	}
	
	-- Continue bouncing on the server only
	if SERVER then
		bullet.Callback = function(a,b,c) RicochetCallback(damage - 5, a, b, c) end
	end
	
	timer.Simple(0.08, function()
		attacker.FireBullets(attacker, bullet)
	end)
	
	return false 
end

function SWEP:ShootBullets( damage, numbullets, aimcone )

	local scale = aimcone
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = aimcone * 1.5
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( aimcone / 2, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= math.Round(damage ^ 2)							
	bullet.Damage	= math.Round(damage)
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "laser_tracer"
	
	bullet.Callback = function ( attacker, tr, dmginfo )
		RicochetCallback( self.Primary.Damage, attacker, tr, dmginfo )
	end
	
	self.Owner:FireBullets( bullet )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		-- View model animation
	if not self.Owner.MuzzleFlash then
		return
	end
	self.Owner:MuzzleFlash()								-- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				-- 3rd Person Animation
end

function SWEP:FirePalsma()
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	local ball = ents.Create("sent_plasma")
	ball:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 25)
	ball:SetAngles(self.Owner:GetAngles())
	ball:SetOwner(self.Owner)
	ball:SetPhysicsAttacker(self.Owner)
	ball.Owner = self.Owner
	ball:Spawn()
end

function SWEP:Reload()
	self:DefaultReload( ACT_VM_RELOAD )
end


----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.Category			= "United Hosts"
SWEP.PrintName			= "Plasma Rifle"
SWEP.Author				= "HeX"
SWEP.Purpose			= "Point at enemy"
SWEP.Instructions		= "Mouse1 = Energy Beam, Mouse2 = Change mode."
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_irifle.mdl"
SWEP.WorldModel 		= "models/weapons/w_irifle.mdl"
SWEP.Base				= "kh_base"
SWEP.Weight				= 5
SWEP.HoldType			= "ar2"
SWEP.ViewModelFOV		= 60
SWEP.DrawCrosshair		= true
SWEP.PrintName 			= "Plasma Rifle"
SWEP.Slot 				= 3
SWEP.Slotpos 			= 3
SWEP.IconLetter 		= "2"

SWEP.Firemodes = { "Energy Beam", "Plasma Bomb" }
SWEP.SprintPos = Vector(6.4052, -2.85, 3.048)
SWEP.SprintAng = Vector(-19.1447, 37.0746, -6.773)

SWEP.Primary.Sound			= Sound("weapons/physcannon/energy_sing_flyby1.wav")
SWEP.Primary.Reload     	= Sound("weapons/physcannon/physcannon_charge.wav")
SWEP.Primary.ModeChange		= Sound("weapons/ar2/ar2_reload_rotate.wav")
SWEP.Primary.Damage			= 22 --49
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.Delay       	= 0.2
SWEP.Primary.Automatic		= true

SWEP.Secondary.Sound		= Sound("weapons/airboat/airboat_gun_energy1.wav")
SWEP.Secondary.Reload		= Sound("weapons/ar2/ar2_reload_rotate.wav")
SWEP.Secondary.ModeChange	= Sound("weapons/ar2/ar2_empty.wav")
SWEP.Secondary.Damage		= 90
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0.035
SWEP.Secondary.Delay		= 3
SWEP.Secondary.ClipSize		= 3
SWEP.Secondary.Automatic	= false

SWEP.Load = nil


function SWEP:Initialize()  
	self:SetWeaponHoldType("ar2")  
end


function SWEP:PrimaryAttack()

	if self:Clip1() <= 0 then
		self:DefaultReload( ACT_VM_RELOAD )
	end

	if not self:CanPrimaryAttack() then return end
	self.Load = CurTime() + .3
		
	if self:GetFiremode() == 1 then
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		self:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
		
		local trace = self.Owner:GetEyeTrace() --fucking laser
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetEntity( trace.Entity )
		effectdata:SetAttachment( trace.PhysicsBone )
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
		util.Effect( "ToolTracer", effectdata )
		
		self:TakePrimaryAmmo( 1 )
	else
		self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
		self:EmitSound( self.Secondary.Sound, 100, math.random(95,105) )
		self:TakePrimaryAmmo( 1 )
		
		if SERVER then
			if not hook.Run("HSP_NoFireWeapon", self) then
				self:FirePalsma() 
			end
		end
	end	
end

function SWEP:Think()	
	if self.Owner:KeyDown(IN_SPEED) then
		self.LastRunFrame = CurTime() + 0.3
	end
	
	--[[
	if not self.Load then return end
	if self.Load < CurTime() then
		self:DefaultReload( ACT_VM_RELOAD )
		self.Load = nil
	end
	]]
	
end

local function RicochetCallback( damage, attacker, tr, dmginfo )
	
	local hitplayer
	
	if tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() then
		hitplayer = tr.Entity
	end
	
	if not tr.HitSky and not hitplayer and damage >= 20 then
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetNormal( tr.HitNormal )
		util.Effect( "laser_bounce", ed, true )
		
		sound.Play( "weapons/physcannon/energy_bounce2.wav", tr.HitPos, 100, math.random(110,130) )
		
	elseif tr.HitSky or damage < 20 or hitplayer then
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetNormal( tr.HitNormal )
		util.Effect( "laser_disintegrate", ed, true )
		
		sound.Play( "weapons/physcannon/energy_disintegrate4.wav", tr.HitPos, 100, math.random(110,130) )
		
		return
	end
	
	if CLIENT then return end
	
	local Dot = tr.HitNormal:Dot( tr.Normal * -1 )
	local bullet = 
	{	
		Num 		= 1,
		Src 		= tr.HitPos,
		Dir 		= ( 2 * tr.HitNormal * Dot ) + tr.Normal, 
		Spread 		= Vector( 0, 0, 0 ),
		Tracer		= 1,
		TracerName 	= "laser_tracer",
		Force		= damage ^ 2,
		Damage		= damage,
		AmmoType 	= "Pistol" 
	}
	
	-- Continue bouncing on the server only
	if SERVER then
		bullet.Callback = function(a,b,c) RicochetCallback(damage - 5, a, b, c) end
	end
	
	timer.Simple(0.08, function()
		attacker.FireBullets(attacker, bullet)
	end)
	
	return false 
end

function SWEP:ShootBullets( damage, numbullets, aimcone )

	local scale = aimcone
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = aimcone * 1.5
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( aimcone / 2, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= math.Round(damage ^ 2)							
	bullet.Damage	= math.Round(damage)
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "laser_tracer"
	
	bullet.Callback = function ( attacker, tr, dmginfo )
		RicochetCallback( self.Primary.Damage, attacker, tr, dmginfo )
	end
	
	self.Owner:FireBullets( bullet )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		-- View model animation
	if not self.Owner.MuzzleFlash then
		return
	end
	self.Owner:MuzzleFlash()								-- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				-- 3rd Person Animation
end

function SWEP:FirePalsma()
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	local ball = ents.Create("sent_plasma")
	ball:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 25)
	ball:SetAngles(self.Owner:GetAngles())
	ball:SetOwner(self.Owner)
	ball:SetPhysicsAttacker(self.Owner)
	ball.Owner = self.Owner
	ball:Spawn()
end

function SWEP:Reload()
	self:DefaultReload( ACT_VM_RELOAD )
end

