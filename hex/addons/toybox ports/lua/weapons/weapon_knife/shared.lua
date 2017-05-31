
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------

if SERVER then
	AddCSLuaFile("shared.lua")
end


if CLIENT then
	SWEP.PrintName = "Knife"
	SWEP.Slot = 3
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	
	
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

	SWEP.IconLetter		= "j"

	-- Draw weapon info box
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "CSKillIcons", x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end

	killicon.AddFont( "weapon_knife", "CSKillIcons", "j", Color( 0, 255, 0, 255 ) )
end


SWEP.Author			= "Doug Tyrrell + HeX"
SWEP.Instructions	= "Left click to stab"
SWEP.Purpose		= "Knife"
SWEP.Category		= "United Hosts"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.NextStrike = 0
  
SWEP.ViewModel      = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel   = "models/weapons/w_knife_t.mdl"
  

SWEP.Primary.Delay			= 0.9 	--In seconds
SWEP.Primary.Recoil			= 0		--Gun Kick
SWEP.Primary.Damage			= 15	--Damage per Bullet
SWEP.Primary.NumShots		= 1		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= -1	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Primary.Automatic   	= true	--Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo         	= "none"--Ammo Type


SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"


util.PrecacheSound("weapons/knife/knife_deploy1.wav")
util.PrecacheSound("weapons/knife/knife_hitwall1.wav")
util.PrecacheSound("weapons/knife/knife_hit1.wav")
util.PrecacheSound("weapons/knife/knife_hit2.wav")
util.PrecacheSound("weapons/knife/knife_hit3.wav")
util.PrecacheSound("weapons/knife/knife_hit4.wav")
util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")


local FleshHit = {
	Sound("weapons/knife/knife_hit1.wav"),
	Sound("weapons/knife/knife_hit2.wav"),
	Sound("weapons/knife/knife_hit3.wav"),
	Sound("weapons/knife/knife_hit4.wav")
}


function SWEP:Initialize()
	self:SetWeaponHoldType("melee")
end


function SWEP:Deploy()
	self.Owner:EmitSound("weapons/knife/knife_deploy1.wav")
	return true
end

function SWEP:PrimaryAttack()
	if (CLIENT) then return end
	
	if ( CurTime() < self.NextStrike ) then return end
	self.NextStrike = (CurTime() + 0.5)
	
 	local trace = self.Owner:GetEyeTrace()
	local ent	= trace.Entity
	
	if IsValid(ent) and (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75) then
		if ent:IsPlayer() then
			self.Owner:EmitSound( table.Random(FleshHit) )
			
		elseif ent:GetClass():find("turret_") then
			ent:Fire("SelfDestruct")
			
		else
			self.Owner:EmitSound( Sound("weapons/knife/knife_hitwall1.wav") )
			return
		end
		
		local bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0,0,0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 502
		self.Owner:FireBullets(bullet)
	else
		self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	end
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_HITCENTER)
end


function SWEP:Precache()
end

function SWEP:SecondaryAttack()
end 







----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------

if SERVER then
	AddCSLuaFile("shared.lua")
end


if CLIENT then
	SWEP.PrintName = "Knife"
	SWEP.Slot = 3
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	
	
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

	SWEP.IconLetter		= "j"

	-- Draw weapon info box
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "CSKillIcons", x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end

	killicon.AddFont( "weapon_knife", "CSKillIcons", "j", Color( 0, 255, 0, 255 ) )
end


SWEP.Author			= "Doug Tyrrell + HeX"
SWEP.Instructions	= "Left click to stab"
SWEP.Purpose		= "Knife"
SWEP.Category		= "United Hosts"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.NextStrike = 0
  
SWEP.ViewModel      = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel   = "models/weapons/w_knife_t.mdl"
  

SWEP.Primary.Delay			= 0.9 	--In seconds
SWEP.Primary.Recoil			= 0		--Gun Kick
SWEP.Primary.Damage			= 15	--Damage per Bullet
SWEP.Primary.NumShots		= 1		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= -1	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Primary.Automatic   	= true	--Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo         	= "none"--Ammo Type


SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"


util.PrecacheSound("weapons/knife/knife_deploy1.wav")
util.PrecacheSound("weapons/knife/knife_hitwall1.wav")
util.PrecacheSound("weapons/knife/knife_hit1.wav")
util.PrecacheSound("weapons/knife/knife_hit2.wav")
util.PrecacheSound("weapons/knife/knife_hit3.wav")
util.PrecacheSound("weapons/knife/knife_hit4.wav")
util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")


local FleshHit = {
	Sound("weapons/knife/knife_hit1.wav"),
	Sound("weapons/knife/knife_hit2.wav"),
	Sound("weapons/knife/knife_hit3.wav"),
	Sound("weapons/knife/knife_hit4.wav")
}


function SWEP:Initialize()
	self:SetWeaponHoldType("melee")
end


function SWEP:Deploy()
	self.Owner:EmitSound("weapons/knife/knife_deploy1.wav")
	return true
end

function SWEP:PrimaryAttack()
	if (CLIENT) then return end
	
	if ( CurTime() < self.NextStrike ) then return end
	self.NextStrike = (CurTime() + 0.5)
	
 	local trace = self.Owner:GetEyeTrace()
	local ent	= trace.Entity
	
	if IsValid(ent) and (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75) then
		if ent:IsPlayer() then
			self.Owner:EmitSound( table.Random(FleshHit) )
			
		elseif ent:GetClass():find("turret_") then
			ent:Fire("SelfDestruct")
			
		else
			self.Owner:EmitSound( Sound("weapons/knife/knife_hitwall1.wav") )
			return
		end
		
		local bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0,0,0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 502
		self.Owner:FireBullets(bullet)
	else
		self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	end
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_HITCENTER)
end


function SWEP:Precache()
end

function SWEP:SecondaryAttack()
end 






