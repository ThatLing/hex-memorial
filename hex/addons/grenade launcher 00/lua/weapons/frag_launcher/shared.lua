
----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------

H00.Weapon.Populate(SWEP,
					-- information
					'Grenade Launcher',								-- name
					'HeX + Henry00',								-- author
					'Launch a grenade with high speed',				-- description
					'Primary = Launch',								-- instructions

					-- model
					'models/weapons/w_rocket_launcher.mdl',			-- world model
					'models/weapons/v_rpg.mdl',						-- view model
						54,											-- view model FOV
						false,										-- view model flip
						
					-- primary
					'grenade',										-- ammo type
					6,												-- pickup clip size
					3,												-- clip size
					0.3,											-- automatic fire speed (0:off)
					
					-- secondary
					'none',											-- ammo type
					-1,												-- pickup clip size
					-1,												-- clip size
					0.0,											-- automatic fire speed (0:off)
					
					-- interface
					4,												-- slot column
					4												-- slot row
)

--[[---------------------------------------------------------
	Server Configuration
-----------------------------------------------------------]]
if SERVER then
	AddCSLuaFile		'shared.lua'
	resource.AddFile	'materials/vgui/entities/frag_launcher.vmt'
	resource.AddFile	'materials/vgui/entities/frag_launcher.vtf'
end

SWEP.Sound_Fire		= Sound 'NPC_Combine.GrenadeLaunch'



function SWEP:PrimaryFire()
	if SERVER then
		if hook.Run("HSP_NoFireWeapon", self) then return end
		
		local ent = ents.Create("npc_grenade_frag")
			ent.NoTrail = true
			ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 14))
			ent:SetAngles(self.Owner:EyeAngles())
			ent:SetOwner(self.Owner)
			ent:Input("settimer",self.Owner,self.Owner,"2.5")
		ent:Spawn()
		
		util.SpriteTrail(ent, 0, team.GetColor( self.Owner:Team() ), false, 15, 1, 4, 1/(15+1)*0.5, "trails/laser.vmt")
		
		local V = self.Owner:GetAimVector()
		V:Normalize()
		
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:ApplyForceCenter(V * 1100) --9900000
		end
	end
	
	-- animate
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound( self.Sound_Fire, 100, math.random(100,120) )
	
	return 1 --fired 1 bullet
end


function SWEP:SecondaryFire()
	self:Malfunction()
end











----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------

H00.Weapon.Populate(SWEP,
					-- information
					'Grenade Launcher',								-- name
					'HeX + Henry00',								-- author
					'Launch a grenade with high speed',				-- description
					'Primary = Launch',								-- instructions

					-- model
					'models/weapons/w_rocket_launcher.mdl',			-- world model
					'models/weapons/v_rpg.mdl',						-- view model
						54,											-- view model FOV
						false,										-- view model flip
						
					-- primary
					'grenade',										-- ammo type
					6,												-- pickup clip size
					3,												-- clip size
					0.3,											-- automatic fire speed (0:off)
					
					-- secondary
					'none',											-- ammo type
					-1,												-- pickup clip size
					-1,												-- clip size
					0.0,											-- automatic fire speed (0:off)
					
					-- interface
					4,												-- slot column
					4												-- slot row
)

--[[---------------------------------------------------------
	Server Configuration
-----------------------------------------------------------]]
if SERVER then
	AddCSLuaFile		'shared.lua'
	resource.AddFile	'materials/vgui/entities/frag_launcher.vmt'
	resource.AddFile	'materials/vgui/entities/frag_launcher.vtf'
end

SWEP.Sound_Fire		= Sound 'NPC_Combine.GrenadeLaunch'



function SWEP:PrimaryFire()
	if SERVER then
		if hook.Run("HSP_NoFireWeapon", self) then return end
		
		local ent = ents.Create("npc_grenade_frag")
			ent.NoTrail = true
			ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 14))
			ent:SetAngles(self.Owner:EyeAngles())
			ent:SetOwner(self.Owner)
			ent:Input("settimer",self.Owner,self.Owner,"2.5")
		ent:Spawn()
		
		util.SpriteTrail(ent, 0, team.GetColor( self.Owner:Team() ), false, 15, 1, 4, 1/(15+1)*0.5, "trails/laser.vmt")
		
		local V = self.Owner:GetAimVector()
		V:Normalize()
		
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:ApplyForceCenter(V * 1100) --9900000
		end
	end
	
	-- animate
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound( self.Sound_Fire, 100, math.random(100,120) )
	
	return 1 --fired 1 bullet
end


function SWEP:SecondaryFire()
	self:Malfunction()
end










