
----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------


H00.Weapon.Populate(SWEP,
	-- information
	'Christmas Gun',								-- name
	'HeX + Henry00',								-- author
	'Holy poo it\'s christmas lights!',				-- description
	'Primary = Kill, Secondary = Heal',				-- instructions
	
	-- model
	'models/weapons/w_smg_tmp.mdl',					-- world model
	'models/weapons/v_smg_tmp.mdl',					-- view model
		75,											-- view model FOV
		true,										-- view model flip
		
	-- primary
	'smg1',											-- ammo type
	50,												-- pickup clip size
	25,												-- clip size
	0.1,											-- automatic fire speed (0:off)
	
	-- secondary
	'none',											-- ammo type
	-1,												-- pickup clip size
	-1,												-- clip size
	0.1,											-- automatic fire speed (0:off)
	
	-- interface
	4,												-- slot column
	5												-- slot row
)


if SERVER then
	AddCSLuaFile		'shared.lua'
	resource.AddFile	'materials/vgui/entities/xmas_gun.vmt'
	resource.AddFile	'materials/vgui/entities/xmas_gun.vtf'
end


SWEP.Primary.Damage	= 10
SWEP.Sound_Fire		= Sound 'NPC_Sniper.FireBullet'
SWEP.Sound_Heal		= Sound 'items/medshot4.wav'
SWEP.Sound_Full		= Sound 'buttons/button16.wav'


function SWEP:PrimaryFire()

	local bullet = {
		Num			= 1,
		Src			= self.Owner:GetShootPos(),		
		Dir			= self.Owner:GetAimVector(),	
		Spread		= Vector(0,0,0),
		Tracer		= 1,
		Force		= math.Round(self.Primary.Damage * 1.1),						
		Damage		= math.Round(self.Primary.Damage),
		AmmoType	= "Pistol",
		TracerName	= "laser_red",
	}
	
	self.Owner:FireBullets(bullet)
	
	-- animate
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if IsValid(self.Owner) then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	self:EmitSound( self.Sound_Fire, 100, math.random(100,120) )
	
	return 1 -- fired 1 bullet
end


function SWEP:SecondaryFire()
	local bullet = {
		Num			= 1,
		Src			= self.Owner:GetShootPos(),		
		Dir			= self.Owner:GetAimVector(),	
		Spread		= Vector(0,0,0),
		Tracer		= 1,
		Force		= 10,						
		Damage		= 0,
		AmmoType	= "Pistol",
		TracerName	= "laser_green",
	}
	
	bullet.Callback = function(attacker,tr,dmginfo)
		if SERVER then
			if tr.HitWorld or not tr.Entity then return end
			local ent = tr.Entity
			
			if ent:IsPlayer() and ent:Alive() then
				local Health = ent:Health()
				if not ent.XM_Hit then ent.XM_Hit = 0 end
				
				if Health < 500 then
					ent:SetHealth( math.Clamp(Health + 25, 1, 500) )
					ent:EmitSound(self.Sound_Heal, 100, math.Clamp(100 + ((Health/500)*155), 100, 255) )
					
					if ent.XM_Hit > 0 then
						ent.XM_Hit = ent.XM_Hit - 1
					end
				else
					ent:EmitSound(self.Sound_Full)
					
					ent.XM_Hit = ent.XM_Hit + 1
					
					if ent.XM_Hit > 10 then
						ent.XM_Hit = 0
						
						self.Owner:SetHealth(100)
						ent:SetHealth(100)
					end
				end
				
			elseif IsValid(ent) then
				if ent.Exp_Revert then
					ent:Exp_Revert()
					ent:EmitSound(self.Sound_Full)
					
				elseif ent:GetClass():find("obj_teleport") then
					ent:SetHealth(175)
				end
			end
		end
	end
	
	self.Owner:FireBullets(bullet)
	
	--animate
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if IsValid(self.Owner) then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	self:EmitSound("player/geiger1.wav"--[[self.Sound_Fire]], 100, math.random(100,120) )
end




if (CLIENT) then
	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.IconFont = "CSSelectIcons"
	
	SWEP.PrintName = "Christmas Gun"
	SWEP.Slot = 4
	SWEP.Slotpos = 5
	SWEP.IconLetter = "d"
	
	local COLOR = Color(0,255,0,255)
	killicon.AddFont("xmas_gun", "CSKillIcons", SWEP.IconLetter, COLOR)
	
	function SWEP:PrintWeaponInfo(x, y, alpha)
		self.InfoMarkup = nil
		
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
	
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText("d", "CSKillIcons", x + wide/2, y + tall/2.5, COLOR, TEXT_ALIGN_CENTER)
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end
end

























----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------


H00.Weapon.Populate(SWEP,
	-- information
	'Christmas Gun',								-- name
	'HeX + Henry00',								-- author
	'Holy poo it\'s christmas lights!',				-- description
	'Primary = Kill, Secondary = Heal',				-- instructions
	
	-- model
	'models/weapons/w_smg_tmp.mdl',					-- world model
	'models/weapons/v_smg_tmp.mdl',					-- view model
		75,											-- view model FOV
		true,										-- view model flip
		
	-- primary
	'smg1',											-- ammo type
	50,												-- pickup clip size
	25,												-- clip size
	0.1,											-- automatic fire speed (0:off)
	
	-- secondary
	'none',											-- ammo type
	-1,												-- pickup clip size
	-1,												-- clip size
	0.1,											-- automatic fire speed (0:off)
	
	-- interface
	4,												-- slot column
	5												-- slot row
)


if SERVER then
	AddCSLuaFile		'shared.lua'
	resource.AddFile	'materials/vgui/entities/xmas_gun.vmt'
	resource.AddFile	'materials/vgui/entities/xmas_gun.vtf'
end


SWEP.Primary.Damage	= 10
SWEP.Sound_Fire		= Sound 'NPC_Sniper.FireBullet'
SWEP.Sound_Heal		= Sound 'items/medshot4.wav'
SWEP.Sound_Full		= Sound 'buttons/button16.wav'


function SWEP:PrimaryFire()

	local bullet = {
		Num			= 1,
		Src			= self.Owner:GetShootPos(),		
		Dir			= self.Owner:GetAimVector(),	
		Spread		= Vector(0,0,0),
		Tracer		= 1,
		Force		= math.Round(self.Primary.Damage * 1.1),						
		Damage		= math.Round(self.Primary.Damage),
		AmmoType	= "Pistol",
		TracerName	= "laser_red",
	}
	
	self.Owner:FireBullets(bullet)
	
	-- animate
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if IsValid(self.Owner) then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	self:EmitSound( self.Sound_Fire, 100, math.random(100,120) )
	
	return 1 -- fired 1 bullet
end


function SWEP:SecondaryFire()
	local bullet = {
		Num			= 1,
		Src			= self.Owner:GetShootPos(),		
		Dir			= self.Owner:GetAimVector(),	
		Spread		= Vector(0,0,0),
		Tracer		= 1,
		Force		= 10,						
		Damage		= 0,
		AmmoType	= "Pistol",
		TracerName	= "laser_green",
	}
	
	bullet.Callback = function(attacker,tr,dmginfo)
		if SERVER then
			if tr.HitWorld or not tr.Entity then return end
			local ent = tr.Entity
			
			if ent:IsPlayer() and ent:Alive() then
				local Health = ent:Health()
				if not ent.XM_Hit then ent.XM_Hit = 0 end
				
				if Health < 500 then
					ent:SetHealth( math.Clamp(Health + 25, 1, 500) )
					ent:EmitSound(self.Sound_Heal, 100, math.Clamp(100 + ((Health/500)*155), 100, 255) )
					
					if ent.XM_Hit > 0 then
						ent.XM_Hit = ent.XM_Hit - 1
					end
				else
					ent:EmitSound(self.Sound_Full)
					
					ent.XM_Hit = ent.XM_Hit + 1
					
					if ent.XM_Hit > 10 then
						ent.XM_Hit = 0
						
						self.Owner:SetHealth(100)
						ent:SetHealth(100)
					end
				end
				
			elseif IsValid(ent) then
				if ent.Exp_Revert then
					ent:Exp_Revert()
					ent:EmitSound(self.Sound_Full)
					
				elseif ent:GetClass():find("obj_teleport") then
					ent:SetHealth(175)
				end
			end
		end
	end
	
	self.Owner:FireBullets(bullet)
	
	--animate
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if IsValid(self.Owner) then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	self:EmitSound("player/geiger1.wav"--[[self.Sound_Fire]], 100, math.random(100,120) )
end




if (CLIENT) then
	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.IconFont = "CSSelectIcons"
	
	SWEP.PrintName = "Christmas Gun"
	SWEP.Slot = 4
	SWEP.Slotpos = 5
	SWEP.IconLetter = "d"
	
	local COLOR = Color(0,255,0,255)
	killicon.AddFont("xmas_gun", "CSKillIcons", SWEP.IconLetter, COLOR)
	
	function SWEP:PrintWeaponInfo(x, y, alpha)
		self.InfoMarkup = nil
		
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
	
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText("d", "CSKillIcons", x + wide/2, y + tall/2.5, COLOR, TEXT_ALIGN_CENTER)
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end
end
























