
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

--Credit to Me, K9, -NPGC-Dominate(UN?D)
--and HeX for fixing up for MP

--SWEP.Base = "weapon_base"


SWEP.PrintName        = "Jumpstick"
SWEP.Category         = "United Hosts"
SWEP.Author           = "fishfingerdude + HeX"
SWEP.Contact          = "kingkardas@hotmail.com"
SWEP.Purpose          = "To hear the splintering of your leg bones"
SWEP.Instructions     = "Left click to low jump, right click to high jump."


SWEP.Slot             = 0
SWEP.SlotPos          = 0
SWEP.DrawAmmo         = false
SWEP.DrawCrosshair    = false
SWEP.ViewModel 			= Model("models/weapons/v_stunstick.mdl")
SWEP.WorldModel			= Model("models/weapons/w_stunbaton.mdl")
SWEP.ReloadSound      = "weapons/pistol/pistol_reload1.wav"
SWEP.HoldType         = "pistol"

SWEP.Weight               = 0
SWEP.AutoSwitchTo         = false
SWEP.AutoSwitchFrom       = false
SWEP.Spawnable            = true
SWEP.AdminSpawnable       = true

SWEP.Primary.Sound                   = "weapons/smg1/smg1_fire1.wav"
SWEP.Primary.Damage                  = 0
SWEP.Primary.NumShots                = 0
SWEP.Primary.Recoil                  = 0
SWEP.Primary.Cone                    = 0
SWEP.Primary.Delay                   = 0
SWEP.Primary.ClipSize                = 0
SWEP.Primary.DefaultClip             = 0
SWEP.Primary.Tracer                  = 0
SWEP.Primary.Force                   = 0
SWEP.Primary.TakeAmmoPerBullet       = false
SWEP.Primary.Automatic               = false
SWEP.Primary.Ammo                    = ""


SWEP.Secondary.Sound                 = "weapons/smg1/smg1_fire1.wav"
SWEP.Secondary.Damage                = 0
SWEP.Secondary.NumShots              = 0
SWEP.Secondary.Recoil                = 0
SWEP.Secondary.Cone                  = 0
SWEP.Secondary.Delay                 = 0
SWEP.Secondary.ClipSize              = 0
SWEP.Secondary.DefaultClip           = 0
SWEP.Secondary.Tracer                = 0
SWEP.Secondary.Force                 = 0
SWEP.Secondary.TakeAmmoPerBullet     = false
SWEP.Secondary.Automatic             = false
SWEP.Secondary.Ammo                  = ""


local BigSound		= Sound("buttons/combine_button3.wav")
local SmallSound	= Sound("buttons/combine_button1.wav")
local FailSound		= Sound("buttons/combine_button2.wav")

SWEP.IconLetter		= "9"

if (CLIENT) then

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

	SWEP.IconLetter		= "9"

	-- Draw weapon info box
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 0,200,255, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end

	killicon.AddFont("jump_stick", "HL2MPTypeDeath", "9", Color( 0,200,255, 255 ) )
end

function SWEP:PrimaryAttack()
    if self.Owner:IsOnGround() then
		self.Owner:EmitSound( SmallSound )
		
        self.Owner:SetVelocity(Vector(0,0,400))
        self.Owner:ViewPunch( Angle(20,0,0) )    
    else
		self.Owner:EmitSound( FailSound )
    end
end

function SWEP:SecondaryAttack()
    if self.Owner:IsOnGround() then
		self.Owner:EmitSound( BigSound )
		
        self.Owner:SetVelocity( Vector(0,0,850) )
        self.Owner:ViewPunch( Angle(45,0,0) )
	else
		self.Owner:EmitSound( FailSound )
    end
end

function SWEP:Holster()
    if CLIENT then return end
    return true
end

function SWEP:Initialize()
end

function SWEP:Think()
end

function SWEP:Reload()
end

function SWEP:Deploy()
end

function SWEP:OnRemove()
end

function SWEP:OnRestore()
end

function SWEP:Precache()
end

function SWEP:OwnerChanged()
end


 

----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

--Credit to Me, K9, -NPGC-Dominate(UN?D)
--and HeX for fixing up for MP

--SWEP.Base = "weapon_base"


SWEP.PrintName        = "Jumpstick"
SWEP.Category         = "United Hosts"
SWEP.Author           = "fishfingerdude + HeX"
SWEP.Contact          = "kingkardas@hotmail.com"
SWEP.Purpose          = "To hear the splintering of your leg bones"
SWEP.Instructions     = "Left click to low jump, right click to high jump."


SWEP.Slot             = 0
SWEP.SlotPos          = 0
SWEP.DrawAmmo         = false
SWEP.DrawCrosshair    = false
SWEP.ViewModel 			= Model("models/weapons/v_stunstick.mdl")
SWEP.WorldModel			= Model("models/weapons/w_stunbaton.mdl")
SWEP.ReloadSound      = "weapons/pistol/pistol_reload1.wav"
SWEP.HoldType         = "pistol"

SWEP.Weight               = 0
SWEP.AutoSwitchTo         = false
SWEP.AutoSwitchFrom       = false
SWEP.Spawnable            = true
SWEP.AdminSpawnable       = true

SWEP.Primary.Sound                   = "weapons/smg1/smg1_fire1.wav"
SWEP.Primary.Damage                  = 0
SWEP.Primary.NumShots                = 0
SWEP.Primary.Recoil                  = 0
SWEP.Primary.Cone                    = 0
SWEP.Primary.Delay                   = 0
SWEP.Primary.ClipSize                = 0
SWEP.Primary.DefaultClip             = 0
SWEP.Primary.Tracer                  = 0
SWEP.Primary.Force                   = 0
SWEP.Primary.TakeAmmoPerBullet       = false
SWEP.Primary.Automatic               = false
SWEP.Primary.Ammo                    = ""


SWEP.Secondary.Sound                 = "weapons/smg1/smg1_fire1.wav"
SWEP.Secondary.Damage                = 0
SWEP.Secondary.NumShots              = 0
SWEP.Secondary.Recoil                = 0
SWEP.Secondary.Cone                  = 0
SWEP.Secondary.Delay                 = 0
SWEP.Secondary.ClipSize              = 0
SWEP.Secondary.DefaultClip           = 0
SWEP.Secondary.Tracer                = 0
SWEP.Secondary.Force                 = 0
SWEP.Secondary.TakeAmmoPerBullet     = false
SWEP.Secondary.Automatic             = false
SWEP.Secondary.Ammo                  = ""


local BigSound		= Sound("buttons/combine_button3.wav")
local SmallSound	= Sound("buttons/combine_button1.wav")
local FailSound		= Sound("buttons/combine_button2.wav")

SWEP.IconLetter		= "9"

if (CLIENT) then

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

	SWEP.IconLetter		= "9"

	-- Draw weapon info box
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 0,200,255, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end

	killicon.AddFont("jump_stick", "HL2MPTypeDeath", "9", Color( 0,200,255, 255 ) )
end

function SWEP:PrimaryAttack()
    if self.Owner:IsOnGround() then
		self.Owner:EmitSound( SmallSound )
		
        self.Owner:SetVelocity(Vector(0,0,400))
        self.Owner:ViewPunch( Angle(20,0,0) )    
    else
		self.Owner:EmitSound( FailSound )
    end
end

function SWEP:SecondaryAttack()
    if self.Owner:IsOnGround() then
		self.Owner:EmitSound( BigSound )
		
        self.Owner:SetVelocity( Vector(0,0,850) )
        self.Owner:ViewPunch( Angle(45,0,0) )
	else
		self.Owner:EmitSound( FailSound )
    end
end

function SWEP:Holster()
    if CLIENT then return end
    return true
end

function SWEP:Initialize()
end

function SWEP:Think()
end

function SWEP:Reload()
end

function SWEP:Deploy()
end

function SWEP:OnRemove()
end

function SWEP:OnRestore()
end

function SWEP:Precache()
end

function SWEP:OwnerChanged()
end


 
