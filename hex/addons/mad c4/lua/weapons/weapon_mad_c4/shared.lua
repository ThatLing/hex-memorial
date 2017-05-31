
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------

SWEP.Base 				= "weapon_mad_base"

SWEP.Category 			= "United Hosts"
SWEP.PrintName			= "C4 Bomb"
SWEP.Author				= "MadCow + HeX"
SWEP.Purpose			= "Big Bada Boom"
SWEP.Instructions		= "Primary = Plant C4, Secondary = Set timer, Hold Use = Defuse"

SWEP.ViewModel			= "models/weapons/v_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 5

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "thumper"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false	
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.Blacklist = {}
SWEP.Blacklist["ent_mad_c4"] 	= true

SWEP.Timer				= 30



function SWEP:Initialize()  
	self:SetWeaponHoldType("slam")  
end


function SWEP:Precache()
	util.PrecacheSound("weapons/c4/c4_disarm.wav")
	util.PrecacheSound("weapons/c4/c4_explode1.wav")
	util.PrecacheSound("weapons/c4/c4_click.wav")
	util.PrecacheSound("weapons/c4/c4_plant.wav")
	util.PrecacheSound("weapons/c4/c4_beep1.wav")
end


function SWEP:PrimaryAttack()
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self:GetDTBool(0)
		self:SetHolsted(bHolsted)

		self:SetNextPrimaryFire(CurTime() + 0.3)
		self:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end

	if not self:CanPrimaryAttack() then return end
	
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
	tr.filter = {self.Owner}
	local trace = util.TraceLine(tr)

	if not trace.Hit then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	timer.Simple(3, function()
		if not IsValid(self) then return end
		if (not IsValid(self.Owner) or not IsValid( self:GetOwner() ) or not self.Owner:Alive() or self:GetOwner():GetActiveWeapon():GetClass() ~= "weapon_mad_c4" or not IsFirstTimePredicted()) then return end

		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

		local tr = {}
		tr.start = self.Owner:GetShootPos()
		tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
		tr.filter = {self.Owner}
		local trace = util.TraceLine(tr)

		if not trace.Hit then
			timer.Simple(0.6, function()
				if not IsValid(self.Owner) then return end
				
				if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
					self:SendWeaponAnim(ACT_VM_DRAW)
				else
					self:Remove()
					self.Owner:ConCommand("lastinv")
				end
			end)
			
			return 
		end
		
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:TakePrimaryAmmo(1)
		
		if CLIENT then return end
		
		local C4 = ents.Create("ent_mad_c4")
			C4:SetPos(trace.HitPos + trace.HitNormal)
			trace.HitNormal.z = -trace.HitNormal.z
			C4:SetAngles(trace.HitNormal:Angle() - Angle(90, 180, 0))
			C4.Owner = self.Owner
			if CPPI then
				C4:CPPISetOwner(self.Owner)
			end
			C4.Timer = self.Timer
		C4:Spawn()
		
		
		local ent = trace.Entity
		if ent then
			if IsValid(ent) then
				local egc = ent:GetClass()
				
				if ent:IsNPC() or ent:IsPlayer() or egc:find("door") or egc:find("func") then --Bad
					if HSP then
						CAT(HSP.GREEN, "[HSP] ", HSP.RED, "C4 can only be planted on props or the world!")
					end
					
					C4:SmallBoom()
					C4:Remove()
					return
				end
			end
			
			if ent:IsWorld() then
				C4:SetMoveType(MOVETYPE_NONE)
			end
			constraint.Weld(C4, ent, 0, 0, 4200, true)
		end
		
		timer.Simple(0.6, function()
			if not IsValid(self) or not IsValid(self.Owner) then return end
			if (not self.Owner:Alive() or self:GetOwner():GetActiveWeapon():GetClass() ~= "weapon_mad_c4") or not IsFirstTimePredicted() then return end
			
			if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
				self:SendWeaponAnim(ACT_VM_DRAW)
			else
				self:Remove()
				self.Owner:ConCommand("lastinv")
			end
		end)
	end)
end


function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.1)
	self:SetNextSecondaryFire(CurTime() + 0.1)
	
	if self.Timer == 30 then
		self.Timer = 60
		
	elseif self.Timer == 60 then
		
		self.Timer = 120
	elseif self.Timer == 120 then
		
		self.Timer = 300
	elseif self.Timer == 300 then
		self.Timer = 30
	end
	
	
	if SERVER then
		self.Owner:PrintMessage(HUD_PRINTTALK, self.Timer.." Seconds.")
	end
	self.Owner:EmitSound("C4.PlantSound")
end


function SWEP:CanPrimaryAttack()
	if (self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) or (self.Owner:WaterLevel() > 2) then
		self:SetNextPrimaryFire(CurTime() + 0.5)
		return false
	end

	if (not self.Owner:IsNPC()) and (self.Owner:KeyDown(IN_SPEED)) then
		self:SetNextPrimaryFire(CurTime() + 0.5)
		return false
	end

	return true
end


function SWEP:Deploy()
	if self:GetNetworkedBool("Suppressor") then
		self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
	else
		self:SendWeaponAnim(ACT_VM_DRAW)
	end

	self:SetNextPrimaryFire(CurTime() + self.DeployDelay)
	self:SetNextSecondaryFire(CurTime() + self.DeployDelay)
	self.ActionDelay = (CurTime() + self.DeployDelay)
	
	return true
end


function SWEP:Holster()
	if CLIENT and self.Ghost:IsValid() then
		self.Ghost:SetColor( Color(255, 255, 255, 0) )
		self.Ghost:Remove()
	end
	
	return true
end


function SWEP:OnRemove()
	if CLIENT and self.Ghost:IsValid() then
		self.Ghost:SetColor( Color(255, 255, 255, 0) )
		self.Ghost:Remove()
	end
	
	return true
end


----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------

SWEP.Base 				= "weapon_mad_base"

SWEP.Category 			= "United Hosts"
SWEP.PrintName			= "C4 Bomb"
SWEP.Author				= "MadCow + HeX"
SWEP.Purpose			= "Big Bada Boom"
SWEP.Instructions		= "Primary = Plant C4, Secondary = Set timer, Hold Use = Defuse"

SWEP.ViewModel			= "models/weapons/v_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 5

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "thumper"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false	
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.Blacklist = {}
SWEP.Blacklist["ent_mad_c4"] 	= true

SWEP.Timer				= 30



function SWEP:Initialize()  
	self:SetWeaponHoldType("slam")  
end


function SWEP:Precache()
	util.PrecacheSound("weapons/c4/c4_disarm.wav")
	util.PrecacheSound("weapons/c4/c4_explode1.wav")
	util.PrecacheSound("weapons/c4/c4_click.wav")
	util.PrecacheSound("weapons/c4/c4_plant.wav")
	util.PrecacheSound("weapons/c4/c4_beep1.wav")
end


function SWEP:PrimaryAttack()
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self:GetDTBool(0)
		self:SetHolsted(bHolsted)

		self:SetNextPrimaryFire(CurTime() + 0.3)
		self:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end

	if not self:CanPrimaryAttack() then return end
	
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
	tr.filter = {self.Owner}
	local trace = util.TraceLine(tr)

	if not trace.Hit then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	timer.Simple(3, function()
		if not IsValid(self) then return end
		if (not IsValid(self.Owner) or not IsValid( self:GetOwner() ) or not self.Owner:Alive() or self:GetOwner():GetActiveWeapon():GetClass() ~= "weapon_mad_c4" or not IsFirstTimePredicted()) then return end

		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

		local tr = {}
		tr.start = self.Owner:GetShootPos()
		tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
		tr.filter = {self.Owner}
		local trace = util.TraceLine(tr)

		if not trace.Hit then
			timer.Simple(0.6, function()
				if not IsValid(self.Owner) then return end
				
				if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
					self:SendWeaponAnim(ACT_VM_DRAW)
				else
					self:Remove()
					self.Owner:ConCommand("lastinv")
				end
			end)
			
			return 
		end
		
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:TakePrimaryAmmo(1)
		
		if CLIENT then return end
		
		local C4 = ents.Create("ent_mad_c4")
			C4:SetPos(trace.HitPos + trace.HitNormal)
			trace.HitNormal.z = -trace.HitNormal.z
			C4:SetAngles(trace.HitNormal:Angle() - Angle(90, 180, 0))
			C4.Owner = self.Owner
			if CPPI then
				C4:CPPISetOwner(self.Owner)
			end
			C4.Timer = self.Timer
		C4:Spawn()
		
		
		local ent = trace.Entity
		if ent then
			if IsValid(ent) then
				local egc = ent:GetClass()
				
				if ent:IsNPC() or ent:IsPlayer() or egc:find("door") or egc:find("func") then --Bad
					if HSP then
						CAT(HSP.GREEN, "[HSP] ", HSP.RED, "C4 can only be planted on props or the world!")
					end
					
					C4:SmallBoom()
					C4:Remove()
					return
				end
			end
			
			if ent:IsWorld() then
				C4:SetMoveType(MOVETYPE_NONE)
			end
			constraint.Weld(C4, ent, 0, 0, 4200, true)
		end
		
		timer.Simple(0.6, function()
			if not IsValid(self) or not IsValid(self.Owner) then return end
			if (not self.Owner:Alive() or self:GetOwner():GetActiveWeapon():GetClass() ~= "weapon_mad_c4") or not IsFirstTimePredicted() then return end
			
			if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
				self:SendWeaponAnim(ACT_VM_DRAW)
			else
				self:Remove()
				self.Owner:ConCommand("lastinv")
			end
		end)
	end)
end


function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.1)
	self:SetNextSecondaryFire(CurTime() + 0.1)
	
	if self.Timer == 30 then
		self.Timer = 60
		
	elseif self.Timer == 60 then
		
		self.Timer = 120
	elseif self.Timer == 120 then
		
		self.Timer = 300
	elseif self.Timer == 300 then
		self.Timer = 30
	end
	
	
	if SERVER then
		self.Owner:PrintMessage(HUD_PRINTTALK, self.Timer.." Seconds.")
	end
	self.Owner:EmitSound("C4.PlantSound")
end


function SWEP:CanPrimaryAttack()
	if (self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) or (self.Owner:WaterLevel() > 2) then
		self:SetNextPrimaryFire(CurTime() + 0.5)
		return false
	end

	if (not self.Owner:IsNPC()) and (self.Owner:KeyDown(IN_SPEED)) then
		self:SetNextPrimaryFire(CurTime() + 0.5)
		return false
	end

	return true
end


function SWEP:Deploy()
	if self:GetNetworkedBool("Suppressor") then
		self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
	else
		self:SendWeaponAnim(ACT_VM_DRAW)
	end

	self:SetNextPrimaryFire(CurTime() + self.DeployDelay)
	self:SetNextSecondaryFire(CurTime() + self.DeployDelay)
	self.ActionDelay = (CurTime() + self.DeployDelay)
	
	return true
end


function SWEP:Holster()
	if CLIENT and self.Ghost:IsValid() then
		self.Ghost:SetColor( Color(255, 255, 255, 0) )
		self.Ghost:Remove()
	end
	
	return true
end


function SWEP:OnRemove()
	if CLIENT and self.Ghost:IsValid() then
		self.Ghost:SetColor( Color(255, 255, 255, 0) )
		self.Ghost:Remove()
	end
	
	return true
end

