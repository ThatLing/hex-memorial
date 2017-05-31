
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------


if SERVER then
	resource.AddFile("materials/VGUI/entities/weapon_ioncannon.vmt")
	resource.AddFile("materials/VGUI/entities/weapon_ioncannon.vtf")
	AddCSLuaFile("shared.lua")
end


game.AddParticles("particles/weapon_fx.pcf")
game.AddParticles("particles/choreo_dog_v_strider.pcf")

PrecacheParticleSystem("strider_impale_ground")
PrecacheParticleSystem("Weapon_Combine_Ion_Cannon")

sound.Add(
	{
		name 		= "NPC_Combine_Cannon.FireBullet",
		channel 	= CHAN_STATIC,
		volume 		= 1.0,
		pitchstart 	= 98,
		pitchend 	= 102,
		soundlevel 	= 120,
		
		sound 		= {
			"ambient/energy/ion_cannon_shot1.wav",
			"ambient/energy/ion_cannon_shot2.wav",
			"ambient/energy/ion_cannon_shot3.wav",
		},
	}
)




SWEP.Category                = "United Hosts"
SWEP.PrintName                = "Ion Cannon"
SWEP.Author                    = "Andrew McWatters + HeX"
SWEP.Purpose                = "Fire your laz0r"
SWEP.Instructions            = "Mouse1=Shoop Mouse2=Scope"
SWEP.IconLetter			= "2"
SWEP.HoldType			= "rpg"
SWEP.DrawCrosshair = true

SWEP.Base				= "swep_ar2"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

--SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
--SWEP.WorldModel			= "models/Combine_turrets/combine_cannon_gun.mdl"
SWEP.WorldModel		= "models/weapons/w_irifle.mdl"


SWEP.Primary.Sound			= Sound("NPC_Combine_Cannon.FireBullet")
SWEP.Primary.Damage			= 64
SWEP.Primary.Cone			= VECTOR_CONE_1DEGREES

SWEP.Primary.Delay			= 0.65 --0.35 --0.75
SWEP.Primary.Force			= 0 --2000
// SWEP.Primary.Ammo			= "CombineHeavyCannon"
SWEP.Primary.Tracer			= 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "None"

SWEP.HoldPos 			= Vector( -5, 2, -12 )
SWEP.HoldAng			= Vector( 17, -5, 60 )



function SWEP:SecondaryAttack()
	if ( !self:CanSecondaryAttack() ) then return end
	self:ToggleZoom()
end

function SWEP:ShootBullet( damage, num_bullets, aimcone )
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	self:SendWeaponAnim(ACT_VM_RELOAD)
	self:EmitSound( Sound("Weapon_AR2.Reload_Rotate") )
	
	
	local info = {}
	info.Num = num_bullets
	info.Src = self.Owner:GetShootPos()
	info.Force = self.Primary.Force
	info.Dir = self.Owner:GetAimVector()
	info.Spread = aimcone
	info.Damage = damage
	info.Tracer = self.Primary.Tracer
	info.TracerName = self.Primary.TracerName

	info.Owner = self.Owner
	info.Weapon = self.Weapon

	info.DoImpactEffect = self.DoImpactEffect
	info.ShootCallback = self.ShootCallback

	info.Callback = function( attacker, trace, dmginfo )
		return info:ShootCallback( attacker, trace, dmginfo )
	end
	self.Owner:gFireBullets(info)
	
	local trace = self.Owner:GetEyeTraceNoCursor()
	if SERVER then
		self:DoRadialDamage(trace)
	end
	self:DoImpactEffects(trace)
end


function SWEP:DoRadialDamage(tr)
    local damageInfo = DamageInfo()
		damageInfo:SetDamageType(DMG_RADIATION)
		damageInfo:SetInflictor(self)
		damageInfo:SetAttacker(self.Owner)
	damageInfo:SetDamage(58)
	
	if (tr and tr.Hit and not tr.HitSky) then	
		for i, entity in ipairs( ents.FindInSphere(tr.HitPos, 42) ) do
			if entity and entity:IsValid() and ( entity != tr.Entity ) then
				
				local phys = entity:GetPhysicsObject()
				if phys:IsValid() then
					local dir = ( entity:GetPos() - tr.HitPos )
					dir:Normalize()
					phys:ApplyForceCenter( dir * ( 790 * ( phys:GetMass() / 2 ) ) )
				end
				
				local egc = entity:GetClass()
				if egc == "func_button" or egc == "func_rot_button" or egc == "momentary_rot_button" then
					entity:Fire("Use")
				else
					damageInfo:SetDamagePosition( entity:NearestPoint(tr.HitPos) )
					entity:TakeDamageInfo(damageInfo)
					if (entity:WaterLevel() == 0) and (not entity:IsPlayer() and not entity:IsWeapon() and not (entity:GetParent():IsValid())) then
						if (egc != "predicted_viewmodel" and egc != "info_particle_system") then
							entity:Ignite(1.5, 0)
						end
					end
				end
			end
		end
		
		local Trail = ents.Create("info_particle_system")
			Trail:SetPos(tr.HitPos)
			Trail:SetKeyValue("effect_name", "strider_impale_ground")
			Trail:SetKeyValue("start_active", "1")
			Trail:Spawn()
		Trail:Activate()
		timer.Simple(0.3, function()
			if Trail then 
				Trail:Remove()
			end
		end)
		
		if (tr.Entity and IsValid(tr.Entity) ) then
			local entity = tr.Entity
			local className = tr.Entity:GetClass()
			
			if (entity:WaterLevel() == 0) and (not entity:IsPlayer() and not entity:IsWeapon() and not (entity:GetParent():IsValid())) then
				if (entity:GetClass() != "predicted_viewmodel" and entity:GetClass() != "info_particle_system") then
					entity:Ignite(2.5, 0)
				end
			end
			local phys = entity:GetPhysicsObject()
			if( IsValid(phys) ) then
				phys:ApplyForceCenter(tr.Normal * (790 * (phys:GetMass() / 2.5) ), tr.HitPos)
			end
			
			if (className == "npc_turret_floor" or className == "npc_portalturret_floor") then
				if (not entity.IsDying) then
					entity.IsDying = true
					entity:Fire("SelfDestruct")
				end
				
			elseif (className == "ent_mad_c4") then
				entity.IonDefuse = true
				entity.Defuse = entity.Defuse + 0.8
				
			elseif (className == "prop_door_rotating" or className == "func_door" or className == "func_door_rotating") then
				entity:EmitSound(Sound("doors/vent_open"..math.random(1,3)..".wav"))
				timer.Simple(0.5, function()
					if entity and entity:IsValid() then
						entity:Fire("Unlock")
						entity:Fire("Toggle")
						
						if SACH and SACH.ACH_Ion then
							SACH.ACH_Ion(self.Owner)
						end
					end
				end)
				
			elseif (className == "func_button" or className == "func_rot_button" or className == "momentary_rot_button") then
				entity:Fire("Use")
				
			elseif (className == "func_breakable") then
				entity:Fire("Break")
				
			elseif (className == "item_suitcharger") then
				if( !entity.NextRecharge or CurTime() > entity.NextRecharge ) then
					entity:Fire("Recharge")
					entity.NextRecharge = CurTime() + 3
				end
			end
		end
	end
end


function SWEP:DoImpactEffects(tr)
	util.Decal("Scorch",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
	util.Decal("RedGlowFade",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)    
	
	for i = 1, 25 do
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetMagnitude(1)
			effectdata:SetScale(1)
			effectdata:SetRadius(4)
		util.Effect("Sparks", effectdata)
	end
end



function SWEP:ShootCallback( attacker, trace, dmginfo )

	local pOwner = self.Owner;

	if ( !pOwner ) then
		return;
	end

	local	vForward, vRight, vUp;

	vForward = pOwner:GetForward();
	vRight = pOwner:GetRight();
	vUp = pOwner:GetUp();

	local	muzzlePoint = pOwner:GetShootPos() + vForward * 12.0 + vRight * 3.5 + vUp * -3.0;

if ( !CLIENT ) then
	local PrimaryDelay = FrameTime() * 5

	local hEnd = ents.Create("info_particle_system")
		hEnd:SetKeyValue("effect_name", "Weapon_Combine_Ion_Cannon")
		local name = "info_particle_system".." ("..pOwner:EntIndex()..")"
		hEnd:SetName(name)
		hEnd:SetPos( trace.HitPos )
		hEnd:Spawn()
	hEnd:Activate()

	local hStart = ents.Create("info_particle_system")
		hStart:SetKeyValue("effect_name", "Weapon_Combine_Ion_Cannon")
		hStart:SetKeyValue("cpoint1", name)
		hStart:SetKeyValue("start_active", tostring( 1 ) )
		hStart:SetPos( muzzlePoint )
		hStart:Spawn()
		hStart:Activate()
	hStart:Fire("Kill", nil, PrimaryDelay)
	
	hEnd:Fire("Kill", nil, PrimaryDelay)
end

end

function SWEP:Holster( wep )

	if ( self.m_bInZoom ) then
		self:ToggleZoom();
	end

	return self.BaseClass:Holster( wep );

end

local PrimaryCone = SWEP.Primary.Cone

function SWEP:ToggleZoom()

	local pPlayer = self.Owner;

	if ( pPlayer == NULL ) then
		return;
	end

if ( !CLIENT ) then

	if ( self.m_bInZoom ) then
		pPlayer:SetCanZoom( true )
		pPlayer:SetFOV( 0, 0.2 )
		self.m_bInZoom = false;
		self.Primary.Cone = PrimaryCone;
	else
		pPlayer:SetCanZoom( false )
		pPlayer:SetFOV( 20, 0.1 )
		self.m_bInZoom = true;
		self.Primary.Cone = vec3_origin;
	end
else

	if ( self.m_bInZoom ) then
		self.m_bInZoom = false;
		self.Primary.Cone = PrimaryCone;
	else
		self.m_bInZoom = true;
		self.Primary.Cone = vec3_origin;
	end
end

end






if CLIENT then	
	killicon.AddFont("weapon_ioncannon", "HL2MPTypeDeath", "2", Color( 255, 128, 255, 255 ) )
	
	surface.CreateFont("hl2c_crosshair1", {
		font		= "HL2Cross",
		size 		= 44,
		weight		= 430,
		antialias	= true,
		additive	= false,
		}
	)
	
	
	function SWEP:DrawWorldModel()
		local pPlayer = self.Owner;
		
		if ( !IsValid( pPlayer ) ) then
			self:DrawModel();
			return;
		end
		
		if ( !self.m_hHands ) then
			self.m_hHands = pPlayer:LookupAttachment("anim_attachment_rh");
		end
		
		local hand = pPlayer:GetAttachment( self.m_hHands );
		if not hand then
			self:DrawModel()
			return
		end
		
		local offset = hand.Ang:Right() * self.HoldPos.x + hand.Ang:Forward() * self.HoldPos.y + hand.Ang:Up() * self.HoldPos.z;
		
		hand.Ang:RotateAroundAxis( hand.Ang:Right(),	self.HoldAng.x );
		hand.Ang:RotateAroundAxis( hand.Ang:Forward(),	self.HoldAng.y );
		hand.Ang:RotateAroundAxis( hand.Ang:Up(),		self.HoldAng.z );
		
		self:SetRenderOrigin( hand.Pos + offset )
		self:SetRenderAngles( hand.Ang )
		self:DrawModel()
	end
	
	
	local Green = Color(0, 255, 0, 255)
	local Red = Color(255, 0, 0, 255)
	local Yellow = Color( 255, 200, 0, 255 )
	local White = Color(255, 255, 255, 255)
	
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
	
	function SWEP:DrawHUD()
		local x = ScrW() / 2
		local y = ScrH() / 2
		
		draw.SimpleText("(", "hl2c_crosshair1", x - 15, y, Green, 2, 1)
		draw.SimpleText(")", "hl2c_crosshair1", x + 15, y, Green, 0, 1)
	end
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText("2", "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 255, 128, 255, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end
end




----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------


if SERVER then
	resource.AddFile("materials/VGUI/entities/weapon_ioncannon.vmt")
	resource.AddFile("materials/VGUI/entities/weapon_ioncannon.vtf")
	AddCSLuaFile("shared.lua")
end


game.AddParticles("particles/weapon_fx.pcf")
game.AddParticles("particles/choreo_dog_v_strider.pcf")

PrecacheParticleSystem("strider_impale_ground")
PrecacheParticleSystem("Weapon_Combine_Ion_Cannon")

sound.Add(
	{
		name 		= "NPC_Combine_Cannon.FireBullet",
		channel 	= CHAN_STATIC,
		volume 		= 1.0,
		pitchstart 	= 98,
		pitchend 	= 102,
		soundlevel 	= 120,
		
		sound 		= {
			"ambient/energy/ion_cannon_shot1.wav",
			"ambient/energy/ion_cannon_shot2.wav",
			"ambient/energy/ion_cannon_shot3.wav",
		},
	}
)




SWEP.Category                = "United Hosts"
SWEP.PrintName                = "Ion Cannon"
SWEP.Author                    = "Andrew McWatters + HeX"
SWEP.Purpose                = "Fire your laz0r"
SWEP.Instructions            = "Mouse1=Shoop Mouse2=Scope"
SWEP.IconLetter			= "2"
SWEP.HoldType			= "rpg"
SWEP.DrawCrosshair = true

SWEP.Base				= "swep_ar2"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

--SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
--SWEP.WorldModel			= "models/Combine_turrets/combine_cannon_gun.mdl"
SWEP.WorldModel		= "models/weapons/w_irifle.mdl"


SWEP.Primary.Sound			= Sound("NPC_Combine_Cannon.FireBullet")
SWEP.Primary.Damage			= 64
SWEP.Primary.Cone			= VECTOR_CONE_1DEGREES

SWEP.Primary.Delay			= 0.65 --0.35 --0.75
SWEP.Primary.Force			= 0 --2000
// SWEP.Primary.Ammo			= "CombineHeavyCannon"
SWEP.Primary.Tracer			= 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "None"

SWEP.HoldPos 			= Vector( -5, 2, -12 )
SWEP.HoldAng			= Vector( 17, -5, 60 )



function SWEP:SecondaryAttack()
	if ( !self:CanSecondaryAttack() ) then return end
	self:ToggleZoom()
end

function SWEP:ShootBullet( damage, num_bullets, aimcone )
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	self:SendWeaponAnim(ACT_VM_RELOAD)
	self:EmitSound( Sound("Weapon_AR2.Reload_Rotate") )
	
	
	local info = {}
	info.Num = num_bullets
	info.Src = self.Owner:GetShootPos()
	info.Force = self.Primary.Force
	info.Dir = self.Owner:GetAimVector()
	info.Spread = aimcone
	info.Damage = damage
	info.Tracer = self.Primary.Tracer
	info.TracerName = self.Primary.TracerName

	info.Owner = self.Owner
	info.Weapon = self.Weapon

	info.DoImpactEffect = self.DoImpactEffect
	info.ShootCallback = self.ShootCallback

	info.Callback = function( attacker, trace, dmginfo )
		return info:ShootCallback( attacker, trace, dmginfo )
	end
	self.Owner:gFireBullets(info)
	
	local trace = self.Owner:GetEyeTraceNoCursor()
	if SERVER then
		self:DoRadialDamage(trace)
	end
	self:DoImpactEffects(trace)
end


function SWEP:DoRadialDamage(tr)
    local damageInfo = DamageInfo()
		damageInfo:SetDamageType(DMG_RADIATION)
		damageInfo:SetInflictor(self)
		damageInfo:SetAttacker(self.Owner)
	damageInfo:SetDamage(58)
	
	if (tr and tr.Hit and not tr.HitSky) then	
		for i, entity in ipairs( ents.FindInSphere(tr.HitPos, 42) ) do
			if entity and entity:IsValid() and ( entity != tr.Entity ) then
				
				local phys = entity:GetPhysicsObject()
				if phys:IsValid() then
					local dir = ( entity:GetPos() - tr.HitPos )
					dir:Normalize()
					phys:ApplyForceCenter( dir * ( 790 * ( phys:GetMass() / 2 ) ) )
				end
				
				local egc = entity:GetClass()
				if egc == "func_button" or egc == "func_rot_button" or egc == "momentary_rot_button" then
					entity:Fire("Use")
				else
					damageInfo:SetDamagePosition( entity:NearestPoint(tr.HitPos) )
					entity:TakeDamageInfo(damageInfo)
					if (entity:WaterLevel() == 0) and (not entity:IsPlayer() and not entity:IsWeapon() and not (entity:GetParent():IsValid())) then
						if (egc != "predicted_viewmodel" and egc != "info_particle_system") then
							entity:Ignite(1.5, 0)
						end
					end
				end
			end
		end
		
		local Trail = ents.Create("info_particle_system")
			Trail:SetPos(tr.HitPos)
			Trail:SetKeyValue("effect_name", "strider_impale_ground")
			Trail:SetKeyValue("start_active", "1")
			Trail:Spawn()
		Trail:Activate()
		timer.Simple(0.3, function()
			if Trail then 
				Trail:Remove()
			end
		end)
		
		if (tr.Entity and IsValid(tr.Entity) ) then
			local entity = tr.Entity
			local className = tr.Entity:GetClass()
			
			if (entity:WaterLevel() == 0) and (not entity:IsPlayer() and not entity:IsWeapon() and not (entity:GetParent():IsValid())) then
				if (entity:GetClass() != "predicted_viewmodel" and entity:GetClass() != "info_particle_system") then
					entity:Ignite(2.5, 0)
				end
			end
			local phys = entity:GetPhysicsObject()
			if( IsValid(phys) ) then
				phys:ApplyForceCenter(tr.Normal * (790 * (phys:GetMass() / 2.5) ), tr.HitPos)
			end
			
			if (className == "npc_turret_floor" or className == "npc_portalturret_floor") then
				if (not entity.IsDying) then
					entity.IsDying = true
					entity:Fire("SelfDestruct")
				end
				
			elseif (className == "ent_mad_c4") then
				entity.IonDefuse = true
				entity.Defuse = entity.Defuse + 0.8
				
			elseif (className == "prop_door_rotating" or className == "func_door" or className == "func_door_rotating") then
				entity:EmitSound(Sound("doors/vent_open"..math.random(1,3)..".wav"))
				timer.Simple(0.5, function()
					if entity and entity:IsValid() then
						entity:Fire("Unlock")
						entity:Fire("Toggle")
						
						if SACH and SACH.ACH_Ion then
							SACH.ACH_Ion(self.Owner)
						end
					end
				end)
				
			elseif (className == "func_button" or className == "func_rot_button" or className == "momentary_rot_button") then
				entity:Fire("Use")
				
			elseif (className == "func_breakable") then
				entity:Fire("Break")
				
			elseif (className == "item_suitcharger") then
				if( !entity.NextRecharge or CurTime() > entity.NextRecharge ) then
					entity:Fire("Recharge")
					entity.NextRecharge = CurTime() + 3
				end
			end
		end
	end
end


function SWEP:DoImpactEffects(tr)
	util.Decal("Scorch",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
	util.Decal("RedGlowFade",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)    
	
	for i = 1, 25 do
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetMagnitude(1)
			effectdata:SetScale(1)
			effectdata:SetRadius(4)
		util.Effect("Sparks", effectdata)
	end
end



function SWEP:ShootCallback( attacker, trace, dmginfo )

	local pOwner = self.Owner;

	if ( !pOwner ) then
		return;
	end

	local	vForward, vRight, vUp;

	vForward = pOwner:GetForward();
	vRight = pOwner:GetRight();
	vUp = pOwner:GetUp();

	local	muzzlePoint = pOwner:GetShootPos() + vForward * 12.0 + vRight * 3.5 + vUp * -3.0;

if ( !CLIENT ) then
	local PrimaryDelay = FrameTime() * 5

	local hEnd = ents.Create("info_particle_system")
		hEnd:SetKeyValue("effect_name", "Weapon_Combine_Ion_Cannon")
		local name = "info_particle_system".." ("..pOwner:EntIndex()..")"
		hEnd:SetName(name)
		hEnd:SetPos( trace.HitPos )
		hEnd:Spawn()
	hEnd:Activate()

	local hStart = ents.Create("info_particle_system")
		hStart:SetKeyValue("effect_name", "Weapon_Combine_Ion_Cannon")
		hStart:SetKeyValue("cpoint1", name)
		hStart:SetKeyValue("start_active", tostring( 1 ) )
		hStart:SetPos( muzzlePoint )
		hStart:Spawn()
		hStart:Activate()
	hStart:Fire("Kill", nil, PrimaryDelay)
	
	hEnd:Fire("Kill", nil, PrimaryDelay)
end

end

function SWEP:Holster( wep )

	if ( self.m_bInZoom ) then
		self:ToggleZoom();
	end

	return self.BaseClass:Holster( wep );

end

local PrimaryCone = SWEP.Primary.Cone

function SWEP:ToggleZoom()

	local pPlayer = self.Owner;

	if ( pPlayer == NULL ) then
		return;
	end

if ( !CLIENT ) then

	if ( self.m_bInZoom ) then
		pPlayer:SetCanZoom( true )
		pPlayer:SetFOV( 0, 0.2 )
		self.m_bInZoom = false;
		self.Primary.Cone = PrimaryCone;
	else
		pPlayer:SetCanZoom( false )
		pPlayer:SetFOV( 20, 0.1 )
		self.m_bInZoom = true;
		self.Primary.Cone = vec3_origin;
	end
else

	if ( self.m_bInZoom ) then
		self.m_bInZoom = false;
		self.Primary.Cone = PrimaryCone;
	else
		self.m_bInZoom = true;
		self.Primary.Cone = vec3_origin;
	end
end

end






if CLIENT then	
	killicon.AddFont("weapon_ioncannon", "HL2MPTypeDeath", "2", Color( 255, 128, 255, 255 ) )
	
	surface.CreateFont("hl2c_crosshair1", {
		font		= "HL2Cross",
		size 		= 44,
		weight		= 430,
		antialias	= true,
		additive	= false,
		}
	)
	
	
	function SWEP:DrawWorldModel()
		local pPlayer = self.Owner;
		
		if ( !IsValid( pPlayer ) ) then
			self:DrawModel();
			return;
		end
		
		if ( !self.m_hHands ) then
			self.m_hHands = pPlayer:LookupAttachment("anim_attachment_rh");
		end
		
		local hand = pPlayer:GetAttachment( self.m_hHands );
		if not hand then
			self:DrawModel()
			return
		end
		
		local offset = hand.Ang:Right() * self.HoldPos.x + hand.Ang:Forward() * self.HoldPos.y + hand.Ang:Up() * self.HoldPos.z;
		
		hand.Ang:RotateAroundAxis( hand.Ang:Right(),	self.HoldAng.x );
		hand.Ang:RotateAroundAxis( hand.Ang:Forward(),	self.HoldAng.y );
		hand.Ang:RotateAroundAxis( hand.Ang:Up(),		self.HoldAng.z );
		
		self:SetRenderOrigin( hand.Pos + offset )
		self:SetRenderAngles( hand.Ang )
		self:DrawModel()
	end
	
	
	local Green = Color(0, 255, 0, 255)
	local Red = Color(255, 0, 0, 255)
	local Yellow = Color( 255, 200, 0, 255 )
	local White = Color(255, 255, 255, 255)
	
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
	
	function SWEP:DrawHUD()
		local x = ScrW() / 2
		local y = ScrH() / 2
		
		draw.SimpleText("(", "hl2c_crosshair1", x - 15, y, Green, 2, 1)
		draw.SimpleText(")", "hl2c_crosshair1", x + 15, y, Green, 0, 1)
	end
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText("2", "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 255, 128, 255, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end
end



