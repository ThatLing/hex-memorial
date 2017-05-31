
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
if SERVER then
	AddCSLuaFile("shared.lua")
	
	resource.AddFile("materials/vgui/entities/suicide_deagle.vmt")
	resource.AddFile("materials/vgui/entities/suicide_deagle.vtf")
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("pistol")  
end

if CLIENT then

	SWEP.PrintName			= "Suicide Deagle"			
	SWEP.Author				= "HeX"

	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	
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
	
	SWEP.IconLetter			= "f"
	
	--killicon.AddFont("suicide_deagle", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))

end

SWEP.Base				= "weapon_cs_base"
SWEP.Category			= "United Hosts"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= "weapons/deagle/deagle-1.wav"
SWEP.Primary.Recoil			= 2.5
SWEP.Primary.Damage			= 60
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 48
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector(0, -25, 5)
SWEP.IronSightsAng 		= Vector(0, -90, 5)

util.PrecacheSound("weapons/deagle/deagle-1.wav")
util.PrecacheSound("vo/npc/male01/question04.wav")
util.PrecacheSound("vo/npc/vortigaunt/calm.wav")

function SWEP:PrimaryAttack()
	if self:Clip1() == 0 then
		self:Reload()
		return
	end
	
	if SERVER then
		if hook.Run("HSP_NoFireWeapon", self) then return end
		
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:MuzzleFlash()
		self:EmitSound(self.Primary.Sound)
		self:TakePrimaryAmmo(1)
	end
	
	if self:GetNWBool("Ironsights")	then
		local data = EffectData()
			data:SetOrigin(self.Owner:EyePos())
		util.Effect("BloodImpact", data)
		
		if SERVER then
			self.Owner:Kill()
		end
		
	else
		self.Owner:SetAnimation(PLAYER_ATTACK1)	
		
		local bullet = {}
			bullet.Num 			= self.Primary.NumShots
			bullet.Src 			= self.Owner:GetShootPos()
			bullet.Dir 			= self.Owner:GetAimVector()
			bullet.Spread 		= Vector(self.Primary.Cone, self.Primary.Cone, 0)
			bullet.Tracer		= 4
			bullet.Force		= 5
			bullet.Damage		= self.Primary.Damage
			bullet.Attacker 	= self.Owner	
		
		self:FireBullets(bullet)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end

end

function SWEP:SecondaryAttack()

	if (!self.IronSightsPos) || !SERVER then return end
	
	local bIronsights = !self:GetNetworkedBool("Ironsights", false)
	
	if bIronsights then 
		self.Owner:EmitSound("vo/npc/male01/question04.wav")
	else
		self.Owner:EmitSound("vo/npc/vortigaunt/calm.wav")
	end
	
	self:SetIronsights(bIronsights)
	
	if bIronSights then
		self:SetNextPrimaryFire(CurTime() + 6.5)
		self:SetNextSecondaryFire(CurTime() + 6.5)
	else
		self:SetNextPrimaryFire(CurTime() + 2)
		self:SetNextSecondaryFire(CurTime() + 2)
	end

end


----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
if SERVER then
	AddCSLuaFile("shared.lua")
	
	resource.AddFile("materials/vgui/entities/suicide_deagle.vmt")
	resource.AddFile("materials/vgui/entities/suicide_deagle.vtf")
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("pistol")  
end

if CLIENT then

	SWEP.PrintName			= "Suicide Deagle"			
	SWEP.Author				= "HeX"

	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	
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
	
	SWEP.IconLetter			= "f"
	
	--killicon.AddFont("suicide_deagle", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))

end

SWEP.Base				= "weapon_cs_base"
SWEP.Category			= "United Hosts"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= "weapons/deagle/deagle-1.wav"
SWEP.Primary.Recoil			= 2.5
SWEP.Primary.Damage			= 60
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 48
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector(0, -25, 5)
SWEP.IronSightsAng 		= Vector(0, -90, 5)

util.PrecacheSound("weapons/deagle/deagle-1.wav")
util.PrecacheSound("vo/npc/male01/question04.wav")
util.PrecacheSound("vo/npc/vortigaunt/calm.wav")

function SWEP:PrimaryAttack()
	if self:Clip1() == 0 then
		self:Reload()
		return
	end
	
	if SERVER then
		if hook.Run("HSP_NoFireWeapon", self) then return end
		
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:MuzzleFlash()
		self:EmitSound(self.Primary.Sound)
		self:TakePrimaryAmmo(1)
	end
	
	if self:GetNWBool("Ironsights")	then
		local data = EffectData()
			data:SetOrigin(self.Owner:EyePos())
		util.Effect("BloodImpact", data)
		
		if SERVER then
			self.Owner:Kill()
		end
		
	else
		self.Owner:SetAnimation(PLAYER_ATTACK1)	
		
		local bullet = {}
			bullet.Num 			= self.Primary.NumShots
			bullet.Src 			= self.Owner:GetShootPos()
			bullet.Dir 			= self.Owner:GetAimVector()
			bullet.Spread 		= Vector(self.Primary.Cone, self.Primary.Cone, 0)
			bullet.Tracer		= 4
			bullet.Force		= 5
			bullet.Damage		= self.Primary.Damage
			bullet.Attacker 	= self.Owner	
		
		self:FireBullets(bullet)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end

end

function SWEP:SecondaryAttack()

	if (!self.IronSightsPos) || !SERVER then return end
	
	local bIronsights = !self:GetNetworkedBool("Ironsights", false)
	
	if bIronsights then 
		self.Owner:EmitSound("vo/npc/male01/question04.wav")
	else
		self.Owner:EmitSound("vo/npc/vortigaunt/calm.wav")
	end
	
	self:SetIronsights(bIronsights)
	
	if bIronSights then
		self:SetNextPrimaryFire(CurTime() + 6.5)
		self:SetNextSecondaryFire(CurTime() + 6.5)
	else
		self:SetNextPrimaryFire(CurTime() + 2)
		self:SetNextSecondaryFire(CurTime() + 2)
	end

end

