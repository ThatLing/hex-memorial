
----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------

if SERVER then
	AddCSLuaFile("shared.lua")
	
	resource.AddFile("materials/vgui/entities/flechette_awp.vmt") 
	resource.AddFile("materials/vgui/entities/flechette_awp.vtf") 
end

if CLIENT then

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

SWEP.IconLetter			= "r"

	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "CSKillIcons", x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end
	
end

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_awp.mdl"


SWEP.Primary.NumShots			= 1
SWEP.Primary.Delay				= 0.1 --0.2
SWEP.Primary.ClipSize			= 15 --45
SWEP.Primary.DefaultClip		= 55 --85
SWEP.Primary.Ammo				= "357"
SWEP.Primary.Automatic			= true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.HoldType			= "AR2"

SWEP.Purpose			= "To shoot flechettes"
SWEP.Instructions		= "Mouse1 = flechettes, Mouse2 = Zoom."
SWEP.Author				= "HeX"
SWEP.PrintName			= "Flechette AWP"
SWEP.Category			= "United Hosts"
SWEP.Slot				= 2
SWEP.SlotPos			= 0

SWEP.DrawCrosshair		= true


function SWEP:Holster()
	self.Owner:SetFOV( 0, 0.25 )
	self.Zoom = 0

	return true
end

function SWEP:Initialize()
	self:SetWeaponHoldType("smg")
	self.Zoom = 0
end

local ShootSound = Sound("NPC_Hunter.FlechetteShoot")

function SWEP:Reload()
	if self:DefaultReload( ACT_VM_RELOAD ) then 
		if(SERVER) then
			self.Owner:SetFOV( 0, 0.25 )
			self.Zoom = 0
		end
	end
end


function SWEP:Think()
end


function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	self:EmitSound(ShootSound)
	self:ShootEffects(self)
	
	if not SERVER then return end
	if hook.Run("HSP_NoFireWeapon", self) then return end
	
	local Forward = self.Owner:EyeAngles():Forward()
	local ent = ents.Create("hunter_flechette")
	if IsValid(ent) then
		ent:SetPos( self.Owner:GetShootPos() + Forward * 32 )
		ent:SetAngles( self.Owner:EyeAngles() )
		ent:Spawn()
		ent:SetVelocity( Forward * 2600 )
		ent:SetOwner(self.Owner)
	end
	
	self:TakePrimaryAmmo(1)
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if self:Clip1() <= 0 then
		if SERVER then
			self.Owner:SetFOV( 0, 0.25 )
			self.Zoom = 0
		end
		self:DefaultReload(ACT_VM_RELOAD)
	end
end


function SWEP:SecondaryAttack()

	if (self.Zoom == 0) then
		if(SERVER) then
			self.Owner:SetFOV( 8, 0.25 ) --25
		end
		
		self:EmitSound("Weapon_AR2.Special1")
		self.Zoom = 1
	else
		if(SERVER) then
			self.Owner:SetFOV( 0, 0.25 )
		end
		
		self:EmitSound("Weapon_AR2.Special2")
		self.Zoom = 0
	end
end


function SWEP:Deploy()
	return true
end








----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------

if SERVER then
	AddCSLuaFile("shared.lua")
	
	resource.AddFile("materials/vgui/entities/flechette_awp.vmt") 
	resource.AddFile("materials/vgui/entities/flechette_awp.vtf") 
end

if CLIENT then

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

SWEP.IconLetter			= "r"

	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "CSKillIcons", x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end
	
end

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_awp.mdl"


SWEP.Primary.NumShots			= 1
SWEP.Primary.Delay				= 0.1 --0.2
SWEP.Primary.ClipSize			= 15 --45
SWEP.Primary.DefaultClip		= 55 --85
SWEP.Primary.Ammo				= "357"
SWEP.Primary.Automatic			= true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.HoldType			= "AR2"

SWEP.Purpose			= "To shoot flechettes"
SWEP.Instructions		= "Mouse1 = flechettes, Mouse2 = Zoom."
SWEP.Author				= "HeX"
SWEP.PrintName			= "Flechette AWP"
SWEP.Category			= "United Hosts"
SWEP.Slot				= 2
SWEP.SlotPos			= 0

SWEP.DrawCrosshair		= true


function SWEP:Holster()
	self.Owner:SetFOV( 0, 0.25 )
	self.Zoom = 0

	return true
end

function SWEP:Initialize()
	self:SetWeaponHoldType("smg")
	self.Zoom = 0
end

local ShootSound = Sound("NPC_Hunter.FlechetteShoot")

function SWEP:Reload()
	if self:DefaultReload( ACT_VM_RELOAD ) then 
		if(SERVER) then
			self.Owner:SetFOV( 0, 0.25 )
			self.Zoom = 0
		end
	end
end


function SWEP:Think()
end


function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	self:EmitSound(ShootSound)
	self:ShootEffects(self)
	
	if not SERVER then return end
	if hook.Run("HSP_NoFireWeapon", self) then return end
	
	local Forward = self.Owner:EyeAngles():Forward()
	local ent = ents.Create("hunter_flechette")
	if IsValid(ent) then
		ent:SetPos( self.Owner:GetShootPos() + Forward * 32 )
		ent:SetAngles( self.Owner:EyeAngles() )
		ent:Spawn()
		ent:SetVelocity( Forward * 2600 )
		ent:SetOwner(self.Owner)
	end
	
	self:TakePrimaryAmmo(1)
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if self:Clip1() <= 0 then
		if SERVER then
			self.Owner:SetFOV( 0, 0.25 )
			self.Zoom = 0
		end
		self:DefaultReload(ACT_VM_RELOAD)
	end
end


function SWEP:SecondaryAttack()

	if (self.Zoom == 0) then
		if(SERVER) then
			self.Owner:SetFOV( 8, 0.25 ) --25
		end
		
		self:EmitSound("Weapon_AR2.Special1")
		self.Zoom = 1
	else
		if(SERVER) then
			self.Owner:SetFOV( 0, 0.25 )
		end
		
		self:EmitSound("Weapon_AR2.Special2")
		self.Zoom = 0
	end
end


function SWEP:Deploy()
	return true
end







