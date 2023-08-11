
AddCSLuaFile("autorun/client/cl_ChickenBullets.lua")

local Enabled 	= CreateConVar("chicken_bullet_enabled", 	1)
local Velocity	= CreateConVar("chicken_bullet_speed", 		100)
local Multi		= CreateConVar("chicken_bullet_multi", 		2)
local Eggs		= CreateConVar("chicken_bullet_eggs",		1)

local sndTabAttack = {
	Sound("chicken/attack1.wav"),
	Sound("chicken/attack2.wav"),
}


--bullet.Damage is 0 for HL2 guns, dumbass garry!
local HL2Guns = {
	["weapon_ar2"]			= "sk_plr_dmg_ar2",
	["weapon_smg1"]			= "sk_plr_dmg_smg1",
	["weapon_shotgun"]		= "sk_plr_dmg_buckshot",
	["weapon_pistol"]		= "sk_plr_dmg_pistol",
	["weapon_357"]			= "sk_plr_dmg_357",
}

local function FireChickenBullet(self,Bul)
	if not IsValid(self) or not Enabled:GetBool() then return end
	
	//Was a chicken bullet
	if self.CanFireChickenBullet then
		//Fix HL2 gun damage
		local Owner = Bul.Attacker
		if Owner and Owner.GetActiveWeapon then --Is a player shooting these
			local Wep = Owner:GetActiveWeapon()
			
			if IsValid(Wep) then
				local New = HL2Guns[ Wep:GetClass() ]
				
				if New then
					Bul.Damage = GetConVarNumber(New) * Multi:GetFloat()
				end
			end
		end
		
		self.CanFireChickenBullet = false --Don't trigger more chickens
		return true --Override this bullet
	end
	
	
	for i=1, Bul.Num do
		self:EmitSound("chicken/chicken_tube.mp3")
		self:EmitSound( table.Random(sndTabAttack) )
		
		local x 	= Bul.Spread.x
		local y 	= Bul.Spread.y
		local Ang	= Bul.Dir + Vector(0, math.Rand(-x, x), math.Rand(-y, y) )
		
		local Hen = ents.Create("chicken_bullet")
			Hen:SetModel("models/lduke/chicken/chicken3.mdl")
			Hen:SetPos(Bul.Src)
			Hen:SetAngles( Ang:Angle() )	
			Hen:SetOwner(self)
			Hen:SetPhysicsAttacker(self)
			Hen.Owner = self
			Hen:Spawn()
			Hen.Eggs = Eggs:GetBool()
		Hen.Bullet = Bul
		
		if not IsValid(Hen) then return end
		local Phys = Hen.PhysObj
		if IsValid(Phys) then
			Phys:SetVelocity( Hen:GetForward() * (Bul.Force + Velocity:GetInt() ) )
		end
	end
	
	return false --No bullet
end

hook.Add("EntityFireBullets", "FireChickenBullet", FireChickenBullet)



--- Resources ---
resource.AddFile("materials/particles/feather.vtf") --Particle
resource.AddFile("materials/particles/feather.vmt")

resource.AddFile("materials/killicons/chicken_bullet.vtf") --Killicon
resource.AddFile("materials/killicons/chicken_bullet.vmt")

resource.AddFile("materials/models/lduke/chicken/chicken2.vtf") --Materials
resource.AddFile("materials/models/lduke/chicken/chicken2.vmt")

resource.AddFile("models/lduke/chicken/chicken3.mdl") --Models
resource.AddFile("models/lduke/chicken/chicken3.phy")
resource.AddFile("models/lduke/chicken/chicken3.dx80.vtx")
resource.AddFile("models/lduke/chicken/chicken3.dx90.vtx")
resource.AddFile("models/lduke/chicken/chicken3.sw.vtx")
resource.AddFile("models/lduke/chicken/chicken3.vvd")

resource.AddFile("sound/chicken/alert.wav") --Sounds
resource.AddFile("sound/chicken/attack1.wav")
resource.AddFile("sound/chicken/attack2.wav")
resource.AddFile("sound/chicken/death.wav")
resource.AddFile("sound/chicken/idle1.wav")
resource.AddFile("sound/chicken/idle2.wav")
resource.AddFile("sound/chicken/idle3.wav")
resource.AddFile("sound/chicken/pain1.wav")
resource.AddFile("sound/chicken/pain2.wav")
resource.AddFile("sound/chicken/pain3.wav")
resource.AddFile("sound/chicken/chicken_tube.mp3")




























