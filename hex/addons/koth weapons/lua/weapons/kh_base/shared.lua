
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "pistol"
	
end

if CLIENT then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "BASE KOTH SWEP"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	
	
	function SWEP:PrintWeaponInfo(x, y, alpha)

	if (self.DrawWeaponInfoBox == false) then return end

	if (self.InfoMarkup == nil) then
		local str
		local title_color = "<color = 130, 0, 0, 255>"
		local text_color = "<color = 255, 255, 255, 200>"
		
		str = "<font=HudSelectionText>"
		if (self.Author != "") then str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n" end
		if (self.Contact != "") then str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end
		if (self.Purpose != "") then str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end
		if (self.Instructions!= "") then str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n" end
		str = str .. "</font>"
		
		self.InfoMarkup = markup.Parse(str, 250)
	end

	alpha = 180
	
	surface.SetDrawColor(0, 0, 0, alpha)
	surface.SetTexture(self.SpeechBubbleLid)
	
	surface.DrawTexturedRect(x, y - 69.5, 128, 64) 
	draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(0, 0, 0, alpha))
	
	self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
end
	
	
	SWEP.IconLetter = "-"

	SWEP.IconFont = "HL2MPTypeDeath"
		--orig Color( 15, 20, 200, 255 )
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end
	
end

SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Firemodes = { "Primary Fire", "Secondary Fire" }

SWEP.SprintPos = Vector(0,0,0)
SWEP.SprintAng = Vector(0,0,0)

SWEP.Primary.Sound			= Sound("Weapon_USP.Single")
SWEP.Primary.Reload			= Sound("Weapon_USP.Single")
SWEP.Primary.ModeChange		= Sound("weapons/357/357_reload1.wav")
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.15

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 99999
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ModeChange	= Sound("weapons/357/357_reload4.wav")
SWEP.Secondary.Delay  		= 0.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.LastRunFrame = 0

function SWEP:SetViewModelPosition( vec, ang, movetime ) // this is used for anything but sprinting positions
	
	self:SetNWVector("ViewVector",vec)
	self:SetNWVector("ViewAngle",ang)
	self:SetNWInt("ViewDuration",movetime) 
	self:SetNWInt("ViewTime",CurTime())

end

function SWEP:GetViewModelPosition( pos, ang )

	local newpos = self:GetNWVector("ViewVector",nil)
	local newang = self:GetNWVector("ViewAngle",nil)
	local movetime = self:GetNWInt("ViewDuration",0.25) // time to reach position defaults to 0.25
	local duration = self:GetNWInt("ViewTime",0) // the curtime when started
		
	if ( !newpos || !newang ) then
		newpos = pos
		newang = ang
	end
	
	local mul = 0
	
	if self.Owner:KeyDown( IN_SPEED ) then
	
		self.SwayScale 	= 1.25
		self.BobScale 	= 1.25
		
		if (!self.SprintStart) then
			self.SprintStart = CurTime()
		end
		
		mul = math.Clamp( (CurTime() - self.SprintStart) / movetime, 0, 1 )
		
		newang = self.SprintAng
		newpos = self.SprintPos
		
	else 
	
		self.SwayScale 	= 1.0
		self.BobScale 	= 1.0
		
		if ( self.SprintStart ) then
			self.SprintEnd = CurTime()
			self.SprintStart = nil
		end
	
		if ( self.SprintEnd ) then
		
			mul = 1 - math.Clamp( (CurTime() - self.SprintEnd) / movetime, 0, 1 )
			
			newang = self.SprintAng
			newpos = self.SprintPos
			
			if ( mul == 0 ) then
				self.SprintEnd = nil 
			end
			
		else
		
			mul = self:IdleViewModelPos( movetime, duration, mul )
			
		end
	end

	return self:MoveViewModelTo( newpos, newang, pos, ang, mul )
	
end

function SWEP:IdleViewModelPos( movetime, duration, mul )

	mul = 1
		
	if ( CurTime() - movetime < duration ) then
		mul = math.Clamp( (CurTime() - duration) / movetime, 0, 1 )
	end
	
	return mul

end

function SWEP:AngApproach( newang, ang, mul )

	ang:RotateAroundAxis( ang:Right(), 		newang.x * mul )
	ang:RotateAroundAxis( ang:Up(), 		newang.y * mul )
	ang:RotateAroundAxis( ang:Forward(), 	newang.z * mul )
	
	return ang

end

function SWEP:PosApproach( newpos, pos, ang, mul ) 

	local right 	= ang:Right()
	local up 		= ang:Up()
	local forward 	= ang:Forward()

	pos = pos + newpos.x * right * mul
	pos = pos + newpos.y * forward * mul
	pos = pos + newpos.z * up * mul
	
	return pos

end

function SWEP:MoveViewModelTo( newpos, newang, pos, ang, mul )

	ang = self:AngApproach( newang, ang, mul )
	pos = self:PosApproach( newpos, pos, ang, mul )

	return pos, ang

end

function SWEP:GetModeName( mode )

	return self.Weapon.Firemodes[ mode ]

end

function SWEP:GetFiremode()

	return self:GetNWInt("Firemode",1)

end

function SWEP:SetFiremode( mode )
	
	self:SetNWInt("Firemode",mode)
	
end

function SWEP:OnModeChange( mode )

end 

function SWEP:Initialize()

	self.ReloadPlay = true

	--fucking update 78
	self:SetWeaponHoldType( self.HoldType )

end

function SWEP:Deploy()

	if SERVER then
		self:SetViewModelPosition()
	end	

	self:SendWeaponAnim(ACT_VM_DRAW)
	return true
	
end  

function SWEP:Think()	

	if self.Owner:KeyDown(IN_SPEED) then
		self.LastRunFrame = CurTime() + 0.3
	end

end

function SWEP:Reload()

	self:DefaultReload( ACT_VM_RELOAD )
	
	if not self.ReloadPlay then
		self.ReloadPlay = true
		self:EmitSound( self.Primary.Reload )
	end
	
end

function SWEP:CanPrimaryAttack()

	if self.Owner:KeyDown(IN_SPEED) or self.LastRunFrame > CurTime() then
		return false
	end

	if self:Clip1() <= 0 then
	
		self:SetNextPrimaryFire(CurTime() + 0.5)
		self:EmitSound( self.Primary.Reload )
		self:DefaultReload( ACT_VM_RELOAD )
		return false
		
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	if self:GetFiremode() == 1 then

		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		self:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		self:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
		self:TakePrimaryAmmo( 1 )
		
	else
	
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		self:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		
		self.Owner:ChatPrint("secondary fire mode testing 123")
	
	end
end

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire(CurTime() + 0.5)
	
	if self:GetFiremode() == 1 then
		self:EmitSound(self.Primary.ModeChange)
		self:SetFiremode(2)
	else
		self:EmitSound(self.Secondary.ModeChange)
		self:SetFiremode(1)
	end
	
	self:OnModeChange( self:GetFiremode() )
	
	if SERVER then
		self.Owner:ChatPrint("Firemode selected: "..self.Firemodes[self:GetFiremode()])
	end

end

function SWEP:ShootBullets( damage, numbullets, aimcone )

	self.ReloadPlay = false

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
	bullet.Force	= math.Round(damage * 2)							
	bullet.Damage	= math.Round(damage)
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		
	end
	
	self.Owner:FireBullets( bullet )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	
	if not self.Owner.MuzzleFlash then
		return
	end
	
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
end

if CLIENT then

	SWEP.CrossRed = CreateClientConVar( "crosshair_r", 255, true, false )
	SWEP.CrossGreen = CreateClientConVar( "crosshair_g", 255, true, false )
	SWEP.CrossBlue = CreateClientConVar( "crosshair_b", 255, true, false )
	SWEP.CrossAlpha = CreateClientConVar( "crosshair_a", 255, true, false )
	SWEP.CrossScale = CreateClientConVar( "crosshair_scale", 1, true, false )

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
		scale = math.Clamp( scale / 2, 0, 10 )
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
--         2014-07-12 20:33:13          --
------------------------------------------
if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "pistol"
	
end

if CLIENT then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "BASE KOTH SWEP"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	
	
	function SWEP:PrintWeaponInfo(x, y, alpha)

	if (self.DrawWeaponInfoBox == false) then return end

	if (self.InfoMarkup == nil) then
		local str
		local title_color = "<color = 130, 0, 0, 255>"
		local text_color = "<color = 255, 255, 255, 200>"
		
		str = "<font=HudSelectionText>"
		if (self.Author != "") then str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n" end
		if (self.Contact != "") then str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end
		if (self.Purpose != "") then str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end
		if (self.Instructions!= "") then str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n" end
		str = str .. "</font>"
		
		self.InfoMarkup = markup.Parse(str, 250)
	end

	alpha = 180
	
	surface.SetDrawColor(0, 0, 0, alpha)
	surface.SetTexture(self.SpeechBubbleLid)
	
	surface.DrawTexturedRect(x, y - 69.5, 128, 64) 
	draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(0, 0, 0, alpha))
	
	self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
end
	
	
	SWEP.IconLetter = "-"

	SWEP.IconFont = "HL2MPTypeDeath"
		--orig Color( 15, 20, 200, 255 )
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end
	
end

SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Firemodes = { "Primary Fire", "Secondary Fire" }

SWEP.SprintPos = Vector(0,0,0)
SWEP.SprintAng = Vector(0,0,0)

SWEP.Primary.Sound			= Sound("Weapon_USP.Single")
SWEP.Primary.Reload			= Sound("Weapon_USP.Single")
SWEP.Primary.ModeChange		= Sound("weapons/357/357_reload1.wav")
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.15

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 99999
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ModeChange	= Sound("weapons/357/357_reload4.wav")
SWEP.Secondary.Delay  		= 0.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.LastRunFrame = 0

function SWEP:SetViewModelPosition( vec, ang, movetime ) // this is used for anything but sprinting positions
	
	self:SetNWVector("ViewVector",vec)
	self:SetNWVector("ViewAngle",ang)
	self:SetNWInt("ViewDuration",movetime) 
	self:SetNWInt("ViewTime",CurTime())

end

function SWEP:GetViewModelPosition( pos, ang )

	local newpos = self:GetNWVector("ViewVector",nil)
	local newang = self:GetNWVector("ViewAngle",nil)
	local movetime = self:GetNWInt("ViewDuration",0.25) // time to reach position defaults to 0.25
	local duration = self:GetNWInt("ViewTime",0) // the curtime when started
		
	if ( !newpos || !newang ) then
		newpos = pos
		newang = ang
	end
	
	local mul = 0
	
	if self.Owner:KeyDown( IN_SPEED ) then
	
		self.SwayScale 	= 1.25
		self.BobScale 	= 1.25
		
		if (!self.SprintStart) then
			self.SprintStart = CurTime()
		end
		
		mul = math.Clamp( (CurTime() - self.SprintStart) / movetime, 0, 1 )
		
		newang = self.SprintAng
		newpos = self.SprintPos
		
	else 
	
		self.SwayScale 	= 1.0
		self.BobScale 	= 1.0
		
		if ( self.SprintStart ) then
			self.SprintEnd = CurTime()
			self.SprintStart = nil
		end
	
		if ( self.SprintEnd ) then
		
			mul = 1 - math.Clamp( (CurTime() - self.SprintEnd) / movetime, 0, 1 )
			
			newang = self.SprintAng
			newpos = self.SprintPos
			
			if ( mul == 0 ) then
				self.SprintEnd = nil 
			end
			
		else
		
			mul = self:IdleViewModelPos( movetime, duration, mul )
			
		end
	end

	return self:MoveViewModelTo( newpos, newang, pos, ang, mul )
	
end

function SWEP:IdleViewModelPos( movetime, duration, mul )

	mul = 1
		
	if ( CurTime() - movetime < duration ) then
		mul = math.Clamp( (CurTime() - duration) / movetime, 0, 1 )
	end
	
	return mul

end

function SWEP:AngApproach( newang, ang, mul )

	ang:RotateAroundAxis( ang:Right(), 		newang.x * mul )
	ang:RotateAroundAxis( ang:Up(), 		newang.y * mul )
	ang:RotateAroundAxis( ang:Forward(), 	newang.z * mul )
	
	return ang

end

function SWEP:PosApproach( newpos, pos, ang, mul ) 

	local right 	= ang:Right()
	local up 		= ang:Up()
	local forward 	= ang:Forward()

	pos = pos + newpos.x * right * mul
	pos = pos + newpos.y * forward * mul
	pos = pos + newpos.z * up * mul
	
	return pos

end

function SWEP:MoveViewModelTo( newpos, newang, pos, ang, mul )

	ang = self:AngApproach( newang, ang, mul )
	pos = self:PosApproach( newpos, pos, ang, mul )

	return pos, ang

end

function SWEP:GetModeName( mode )

	return self.Weapon.Firemodes[ mode ]

end

function SWEP:GetFiremode()

	return self:GetNWInt("Firemode",1)

end

function SWEP:SetFiremode( mode )
	
	self:SetNWInt("Firemode",mode)
	
end

function SWEP:OnModeChange( mode )

end 

function SWEP:Initialize()

	self.ReloadPlay = true

	--fucking update 78
	self:SetWeaponHoldType( self.HoldType )

end

function SWEP:Deploy()

	if SERVER then
		self:SetViewModelPosition()
	end	

	self:SendWeaponAnim(ACT_VM_DRAW)
	return true
	
end  

function SWEP:Think()	

	if self.Owner:KeyDown(IN_SPEED) then
		self.LastRunFrame = CurTime() + 0.3
	end

end

function SWEP:Reload()

	self:DefaultReload( ACT_VM_RELOAD )
	
	if not self.ReloadPlay then
		self.ReloadPlay = true
		self:EmitSound( self.Primary.Reload )
	end
	
end

function SWEP:CanPrimaryAttack()

	if self.Owner:KeyDown(IN_SPEED) or self.LastRunFrame > CurTime() then
		return false
	end

	if self:Clip1() <= 0 then
	
		self:SetNextPrimaryFire(CurTime() + 0.5)
		self:EmitSound( self.Primary.Reload )
		self:DefaultReload( ACT_VM_RELOAD )
		return false
		
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	if self:GetFiremode() == 1 then

		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		self:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		self:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
		self:TakePrimaryAmmo( 1 )
		
	else
	
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		self:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		
		self.Owner:ChatPrint("secondary fire mode testing 123")
	
	end
end

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire(CurTime() + 0.5)
	
	if self:GetFiremode() == 1 then
		self:EmitSound(self.Primary.ModeChange)
		self:SetFiremode(2)
	else
		self:EmitSound(self.Secondary.ModeChange)
		self:SetFiremode(1)
	end
	
	self:OnModeChange( self:GetFiremode() )
	
	if SERVER then
		self.Owner:ChatPrint("Firemode selected: "..self.Firemodes[self:GetFiremode()])
	end

end

function SWEP:ShootBullets( damage, numbullets, aimcone )

	self.ReloadPlay = false

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
	bullet.Force	= math.Round(damage * 2)							
	bullet.Damage	= math.Round(damage)
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		
	end
	
	self.Owner:FireBullets( bullet )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	
	if not self.Owner.MuzzleFlash then
		return
	end
	
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
end

if CLIENT then

	SWEP.CrossRed = CreateClientConVar( "crosshair_r", 255, true, false )
	SWEP.CrossGreen = CreateClientConVar( "crosshair_g", 255, true, false )
	SWEP.CrossBlue = CreateClientConVar( "crosshair_b", 255, true, false )
	SWEP.CrossAlpha = CreateClientConVar( "crosshair_a", 255, true, false )
	SWEP.CrossScale = CreateClientConVar( "crosshair_scale", 1, true, false )

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
		scale = math.Clamp( scale / 2, 0, 10 )
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


