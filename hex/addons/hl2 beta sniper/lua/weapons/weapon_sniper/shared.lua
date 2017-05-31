
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------

AddCSLuaFile("shared.lua")

SWEP.Category		= "United Hosts"
SWEP.PrintName		= "HL2 Beta Sniper"	
SWEP.Author			= "HeX"
SWEP.Purpose		= "Kill things."
SWEP.Instructions	= "Pull Trigger."

SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true
SWEP.Slot			= 3
SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_sniper.mdl"
SWEP.WorldModel		= "models/weapons/w_snip_awp.mdl"
SWEP.AnimPrefix		= "ar2"
SWEP.HoldType		= "ar2"


SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Delay			= 0.2
SWEP.Primary.Ammo			= "357"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "SMG1"

SWEP.Zoom = false

function SWEP:Initialize()
	self:SetWeaponHoldType("smg")
end


function SWEP:Holster()
	if SERVER then
		self.Owner:SetFOV(0, 0.25)
	end
	self.Zoom = false
	
	return true
end


function SWEP:Reload()
	self:Holster()
	
	if self:DefaultReload(ACT_VM_RELOAD) then 
		self:EmitSound("weapons/sniper/sniper_reload.wav")
	end
end



function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	if SERVER and IsFirstTimePredicted() then
		--self:EmitSound("weapons/sniper/sniper_fire.wav")
		self.Owner:EmitSound("weapons/sniper/44k/sniper_fire.wav")
	end
	
	self:TakePrimaryAmmo(1)
	self:ShootBullet(90, 1, 0.0005)
	
	self:Reload()
end


local bullet = {
	Force = 1,
	Tracer = 1,
	AmmoType = "357",
}

function SWEP:ShootBullet(damage,num_bullets,aimcone)
	bullet.Num = num_bullets
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector(aimcone,aimcone,0)
	bullet.Damage = damage
	
	self.Owner:FireBullets(bullet)
	
	self:ShootEffects()
end 


function SWEP:SecondaryAttack()
	if not self.Zoom then
		if SERVER then
			self.Owner:SetFOV(8, 0.25) --25
		end
		
		self:EmitSound("Weapon_AR2.Special1")
		self.Zoom = true
	else
		if SERVER then
			self.Owner:SetFOV(0, 0.25)
		end
		
		self:EmitSound("Weapon_AR2.Special2")
		self.Zoom = false
	end
end

function SWEP:AdjustMouseSensitivity()
	return self.Owner:GetFOV() < 10 and 0.1 or nil
end



if CLIENT then
	function SWEP:PrintWeaponInfo(x, y, alpha)
		if self.DrawWeaponInfoBox == false then return end
		
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
	
	SWEP.IconLetter		= "r"
	
	-- Draw weapon info box
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "CSKillIcons", x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end
end







----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------

AddCSLuaFile("shared.lua")

SWEP.Category		= "United Hosts"
SWEP.PrintName		= "HL2 Beta Sniper"	
SWEP.Author			= "HeX"
SWEP.Purpose		= "Kill things."
SWEP.Instructions	= "Pull Trigger."

SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true
SWEP.Slot			= 3
SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_sniper.mdl"
SWEP.WorldModel		= "models/weapons/w_snip_awp.mdl"
SWEP.AnimPrefix		= "ar2"
SWEP.HoldType		= "ar2"


SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Delay			= 0.2
SWEP.Primary.Ammo			= "357"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "SMG1"

SWEP.Zoom = false

function SWEP:Initialize()
	self:SetWeaponHoldType("smg")
end


function SWEP:Holster()
	if SERVER then
		self.Owner:SetFOV(0, 0.25)
	end
	self.Zoom = false
	
	return true
end


function SWEP:Reload()
	self:Holster()
	
	if self:DefaultReload(ACT_VM_RELOAD) then 
		self:EmitSound("weapons/sniper/sniper_reload.wav")
	end
end



function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	if SERVER and IsFirstTimePredicted() then
		--self:EmitSound("weapons/sniper/sniper_fire.wav")
		self.Owner:EmitSound("weapons/sniper/44k/sniper_fire.wav")
	end
	
	self:TakePrimaryAmmo(1)
	self:ShootBullet(90, 1, 0.0005)
	
	self:Reload()
end


local bullet = {
	Force = 1,
	Tracer = 1,
	AmmoType = "357",
}

function SWEP:ShootBullet(damage,num_bullets,aimcone)
	bullet.Num = num_bullets
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector(aimcone,aimcone,0)
	bullet.Damage = damage
	
	self.Owner:FireBullets(bullet)
	
	self:ShootEffects()
end 


function SWEP:SecondaryAttack()
	if not self.Zoom then
		if SERVER then
			self.Owner:SetFOV(8, 0.25) --25
		end
		
		self:EmitSound("Weapon_AR2.Special1")
		self.Zoom = true
	else
		if SERVER then
			self.Owner:SetFOV(0, 0.25)
		end
		
		self:EmitSound("Weapon_AR2.Special2")
		self.Zoom = false
	end
end

function SWEP:AdjustMouseSensitivity()
	return self.Owner:GetFOV() < 10 and 0.1 or nil
end



if CLIENT then
	function SWEP:PrintWeaponInfo(x, y, alpha)
		if self.DrawWeaponInfoBox == false then return end
		
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
	
	SWEP.IconLetter		= "r"
	
	-- Draw weapon info box
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "CSKillIcons", x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end
end






