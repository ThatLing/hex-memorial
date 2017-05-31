
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------

 function SWEP:Precache()
 	util.PrecacheSound( "npc/combine_gunship/attack_stop2.wav" ) 
 	util.PrecacheSound( "NPC_Strider.Charge" ) 
 	util.PrecacheSound( "Weapon_Mortar.Impact" ) 
 	util.PrecacheSound( "NPC_Strider.FireMinigun" ) 
 	util.PrecacheSound( "vo/npc/male01/fantastic01.wav" ) 
	util.PrecacheSound( "weapon_AWP.Single" )
 end 

if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	
	resource.AddFile("materials/vgui/entities/weapon_stridercannon.vmt")
	resource.AddFile("materials/vgui/entities/weapon_stridercannon.vtf")
end



	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
--	SWEP.ViewModelFOV		= 74
--	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true

	
	SWEP.Author				= "HeX"
--	SWEP.Contact			= ""
	SWEP.Purpose			= "Killing"
	SWEP.Instructions		= "Mouse1 = Plasma Cannon, Mouse2 = Warp Cannon."
	SWEP.Category			= "United Hosts"
	
if CLIENT then
	
	SWEP.PrintName			= "Strider Cannon"	
	SWEP.Slot				= 3
	SWEP.SlotPos			= 10
	
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
	
	
	SWEP.IconLetter			= "3" --a
	
	--killicon.AddFont("weapon_stridercannon", "HL2MPTypeDeath", SWEP.IconLetter, Color( 15, 20, 200, 255 )) --CSKillIcons Color(255,220,0,255)
	
	-- Draw weapon info box
	--orig Color( 15, 20, 200, 255 )
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end

end

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Sound			= Sound("NPC_Strider.FireMinigun")
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 0.2
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Recoil			= 2

SWEP.Primary.ClipSize		= 16
SWEP.Primary.DefaultClip	= 45
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"

SWEP.Cannon = {}
SWEP.Cannon.ShootSound		= Sound("NPC_Strider.Shoot")
SWEP.Cannon.ChargeSound		= Sound("NPC_Strider.Charge")
SWEP.Cannon.BoomSound		= Sound("Weapon_Mortar.Impact")
SWEP.Cannon.Damage			= 100
SWEP.Cannon.Radius			= 350
SWEP.Cannon.Delay			= 2
SWEP.Cannon.Recoil			= 6

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "AR2AltFire" --AR2AltFire

SWEP.firing = 0

function SWEP:Initialize()

	self:SetWeaponHoldType("rpg")  

	self.Charging = false
	
end

function SWEP:PrimaryAttack()

	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	if not self:CanPrimaryAttack() then return end
	
	self:EmitSound(self.Primary.Sound)
	self:TakePrimaryAmmo(1)
	
	self:ShootStriderBullet(
		self.Primary.Damage,
		self.Primary.Recoil,
		self.Primary.NumShots,
		self.Primary.Cone
	)
	
end


function SWEP:SecondaryAttack()

	--[[
	if self:Ammo2() <= 0 then
	
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextSecondaryFire(CurTime() + 0.2)
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
		
	end
	--]]

	self:SetNextSecondaryFire(CurTime() + 1.35 + self.Cannon.Delay)
	self:SetNextPrimaryFire(CurTime() + 1.35 + self.Cannon.Delay)

	self:EmitSound(self.Cannon.ChargeSound)
	
	local fx = EffectData()
	fx:SetEntity(self.Owner)
	fx:SetAttachment(1)
	util.Effect("stridcan_charge",fx)
	
	self.Charging = true
	
	if CLIENT then return end
	timer.Simple(1.35, function()
		if IsValid(self) then
			self:ShootCannon()
		end
	end)

end

function SWEP:ShootCannon()

	if not self.Charging then return end
	if not self.Weapon or not self:IsValid() then return end
	if not self.Owner or not self.Owner:Alive() then return end

	local PlayerPos = self.Owner:GetShootPos() 
	local tr = self.Owner:GetEyeTrace()
	
	local dist = (tr.HitPos - PlayerPos):Length()
	local delay = dist/8000
	
	--self:TakeSecondaryAmmo(1)
	
	--self:EmitSound(self.Cannon.ShootSound)
	self:EmitSound("npc/combine_gunship/attack_stop2.wav")
	
	local fx = EffectData()
	fx:SetEntity(self.Owner)
	fx:SetOrigin(tr.HitPos)
	fx:SetAttachment(1)
	util.Effect("stridcan_fire",fx)
	--util.Effect("stridcan_mzzlflash",fx)
	
	--play animations
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	--apply recoil
	self.Owner:ViewPunch( Angle(math.Rand(-0.2,-0.1)*self.Cannon.Recoil,math.Rand(-0.1,0.1)*self.Cannon.Recoil, 0))
	
	--timer.Simple(delay,self,tr)
	timer.Simple(delay, function()
		if IsValid(self) then
			self:Disintegrate(tr)
		end
	end)

	
end

function SWEP:Disintegrate(tr)
	if CLIENT then return end
	
	if self.firing == 0 then
		self.firing = 1
		timer.Simple( 1.0, function()
			if IsValid(self) then
				self:EmitSound("vo/npc/male01/fantastic01.wav")
			end
		end)
		
		timer.Simple( 2.9, function()
			if IsValid(self) then
				self:Boom()
				self.firing = 0
			end
		end)
	end
	
	
	
end

function SWEP:Boom()
	local boom = ents.Create( "env_explosion" )
	boom:SetOwner( self.Owner )
	boom:SetPos( self.Owner:GetShootPos() )
	boom:Spawn()
	boom:SetKeyValue( "iMagnitude", "90" )
	boom:Fire( "Explode", 0, 0 )	
	self.Owner:Kill( )
	boom:EmitSound( "weapon_AWP.Single", 400, 400 )
end

function SWEP:Think()	

end


function SWEP:Reload()

	self:DefaultReload(ACT_VM_RELOAD)
	
end


local StriderBulletCallback = function(attacker, tr, dmginfo)

	local fx = EffectData()
	fx:SetOrigin(tr.HitPos)
	fx:SetNormal(tr.HitNormal)
	fx:SetScale(20)
	util.Effect("cball_bounce",fx)
	util.Effect("AR2Impact",fx)
	
	if tr.HitWorld then
		util.Decal("FadingScorch",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
		--util.Decal("RedGlowFade",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)    
	end

	return true

end

function SWEP:ShootStriderBullet(dmg, recoil, numbul, cone)

	--send the bullet
	local bullet 		= {} 
	bullet.Num			= numbul 
	bullet.Src			= self.Owner:GetShootPos() 
	bullet.Dir			= self.Owner:GetAimVector()
	bullet.Spread		= Vector(cone,cone,0) 
	bullet.Tracer		= 1	 
	bullet.TracerName 	= "AirboatGunTracer"
	bullet.Force		= 0.5*dmg
	bullet.Damage 		= dmg 
	bullet.Callback		= StriderBulletCallback
	self.Owner:FireBullets(bullet)

	--play animations
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if not self.Owner.MuzzleFlash then
		return
	end
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	--apply recoil
	self.Owner:ViewPunch( Angle(math.Rand(-0.2,0.1)*recoil,math.Rand(-0.1,0.1)*recoil, 0))

end

function SWEP:StopCharging()

	self:StopSound(self.Cannon.ChargeSound)
	self.Charging = false

end

function SWEP:Holster(wep) 		self:StopCharging() 	return true end
function SWEP:Equip(NewOwner) 	self:StopCharging() 	return true end
function SWEP:OnRemove() 		self:StopCharging() 	return true end
function SWEP:OnDrop() 			self:StopCharging() 	return true end
function SWEP:OwnerChanged() 	self:StopCharging() 	return true end




----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------

 function SWEP:Precache()
 	util.PrecacheSound( "npc/combine_gunship/attack_stop2.wav" ) 
 	util.PrecacheSound( "NPC_Strider.Charge" ) 
 	util.PrecacheSound( "Weapon_Mortar.Impact" ) 
 	util.PrecacheSound( "NPC_Strider.FireMinigun" ) 
 	util.PrecacheSound( "vo/npc/male01/fantastic01.wav" ) 
	util.PrecacheSound( "weapon_AWP.Single" )
 end 

if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	
	resource.AddFile("materials/vgui/entities/weapon_stridercannon.vmt")
	resource.AddFile("materials/vgui/entities/weapon_stridercannon.vtf")
end



	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
--	SWEP.ViewModelFOV		= 74
--	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true

	
	SWEP.Author				= "HeX"
--	SWEP.Contact			= ""
	SWEP.Purpose			= "Killing"
	SWEP.Instructions		= "Mouse1 = Plasma Cannon, Mouse2 = Warp Cannon."
	SWEP.Category			= "United Hosts"
	
if CLIENT then
	
	SWEP.PrintName			= "Strider Cannon"	
	SWEP.Slot				= 3
	SWEP.SlotPos			= 10
	
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
	
	
	SWEP.IconLetter			= "3" --a
	
	--killicon.AddFont("weapon_stridercannon", "HL2MPTypeDeath", SWEP.IconLetter, Color( 15, 20, 200, 255 )) --CSKillIcons Color(255,220,0,255)
	
	-- Draw weapon info box
	--orig Color( 15, 20, 200, 255 )
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end

end

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Sound			= Sound("NPC_Strider.FireMinigun")
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 0.2
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Recoil			= 2

SWEP.Primary.ClipSize		= 16
SWEP.Primary.DefaultClip	= 45
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"

SWEP.Cannon = {}
SWEP.Cannon.ShootSound		= Sound("NPC_Strider.Shoot")
SWEP.Cannon.ChargeSound		= Sound("NPC_Strider.Charge")
SWEP.Cannon.BoomSound		= Sound("Weapon_Mortar.Impact")
SWEP.Cannon.Damage			= 100
SWEP.Cannon.Radius			= 350
SWEP.Cannon.Delay			= 2
SWEP.Cannon.Recoil			= 6

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "AR2AltFire" --AR2AltFire

SWEP.firing = 0

function SWEP:Initialize()

	self:SetWeaponHoldType("rpg")  

	self.Charging = false
	
end

function SWEP:PrimaryAttack()

	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	if not self:CanPrimaryAttack() then return end
	
	self:EmitSound(self.Primary.Sound)
	self:TakePrimaryAmmo(1)
	
	self:ShootStriderBullet(
		self.Primary.Damage,
		self.Primary.Recoil,
		self.Primary.NumShots,
		self.Primary.Cone
	)
	
end


function SWEP:SecondaryAttack()

	--[[
	if self:Ammo2() <= 0 then
	
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextSecondaryFire(CurTime() + 0.2)
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
		
	end
	--]]

	self:SetNextSecondaryFire(CurTime() + 1.35 + self.Cannon.Delay)
	self:SetNextPrimaryFire(CurTime() + 1.35 + self.Cannon.Delay)

	self:EmitSound(self.Cannon.ChargeSound)
	
	local fx = EffectData()
	fx:SetEntity(self.Owner)
	fx:SetAttachment(1)
	util.Effect("stridcan_charge",fx)
	
	self.Charging = true
	
	if CLIENT then return end
	timer.Simple(1.35, function()
		if IsValid(self) then
			self:ShootCannon()
		end
	end)

end

function SWEP:ShootCannon()

	if not self.Charging then return end
	if not self.Weapon or not self:IsValid() then return end
	if not self.Owner or not self.Owner:Alive() then return end

	local PlayerPos = self.Owner:GetShootPos() 
	local tr = self.Owner:GetEyeTrace()
	
	local dist = (tr.HitPos - PlayerPos):Length()
	local delay = dist/8000
	
	--self:TakeSecondaryAmmo(1)
	
	--self:EmitSound(self.Cannon.ShootSound)
	self:EmitSound("npc/combine_gunship/attack_stop2.wav")
	
	local fx = EffectData()
	fx:SetEntity(self.Owner)
	fx:SetOrigin(tr.HitPos)
	fx:SetAttachment(1)
	util.Effect("stridcan_fire",fx)
	--util.Effect("stridcan_mzzlflash",fx)
	
	--play animations
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	--apply recoil
	self.Owner:ViewPunch( Angle(math.Rand(-0.2,-0.1)*self.Cannon.Recoil,math.Rand(-0.1,0.1)*self.Cannon.Recoil, 0))
	
	--timer.Simple(delay,self,tr)
	timer.Simple(delay, function()
		if IsValid(self) then
			self:Disintegrate(tr)
		end
	end)

	
end

function SWEP:Disintegrate(tr)
	if CLIENT then return end
	
	if self.firing == 0 then
		self.firing = 1
		timer.Simple( 1.0, function()
			if IsValid(self) then
				self:EmitSound("vo/npc/male01/fantastic01.wav")
			end
		end)
		
		timer.Simple( 2.9, function()
			if IsValid(self) then
				self:Boom()
				self.firing = 0
			end
		end)
	end
	
	
	
end

function SWEP:Boom()
	local boom = ents.Create( "env_explosion" )
	boom:SetOwner( self.Owner )
	boom:SetPos( self.Owner:GetShootPos() )
	boom:Spawn()
	boom:SetKeyValue( "iMagnitude", "90" )
	boom:Fire( "Explode", 0, 0 )	
	self.Owner:Kill( )
	boom:EmitSound( "weapon_AWP.Single", 400, 400 )
end

function SWEP:Think()	

end


function SWEP:Reload()

	self:DefaultReload(ACT_VM_RELOAD)
	
end


local StriderBulletCallback = function(attacker, tr, dmginfo)

	local fx = EffectData()
	fx:SetOrigin(tr.HitPos)
	fx:SetNormal(tr.HitNormal)
	fx:SetScale(20)
	util.Effect("cball_bounce",fx)
	util.Effect("AR2Impact",fx)
	
	if tr.HitWorld then
		util.Decal("FadingScorch",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
		--util.Decal("RedGlowFade",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)    
	end

	return true

end

function SWEP:ShootStriderBullet(dmg, recoil, numbul, cone)

	--send the bullet
	local bullet 		= {} 
	bullet.Num			= numbul 
	bullet.Src			= self.Owner:GetShootPos() 
	bullet.Dir			= self.Owner:GetAimVector()
	bullet.Spread		= Vector(cone,cone,0) 
	bullet.Tracer		= 1	 
	bullet.TracerName 	= "AirboatGunTracer"
	bullet.Force		= 0.5*dmg
	bullet.Damage 		= dmg 
	bullet.Callback		= StriderBulletCallback
	self.Owner:FireBullets(bullet)

	--play animations
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if not self.Owner.MuzzleFlash then
		return
	end
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	--apply recoil
	self.Owner:ViewPunch( Angle(math.Rand(-0.2,0.1)*recoil,math.Rand(-0.1,0.1)*recoil, 0))

end

function SWEP:StopCharging()

	self:StopSound(self.Cannon.ChargeSound)
	self.Charging = false

end

function SWEP:Holster(wep) 		self:StopCharging() 	return true end
function SWEP:Equip(NewOwner) 	self:StopCharging() 	return true end
function SWEP:OnRemove() 		self:StopCharging() 	return true end
function SWEP:OnDrop() 			self:StopCharging() 	return true end
function SWEP:OwnerChanged() 	self:StopCharging() 	return true end



