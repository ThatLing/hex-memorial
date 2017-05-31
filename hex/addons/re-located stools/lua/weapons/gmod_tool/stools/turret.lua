
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

TOOL.Category		= "Construction"
TOOL.Name			= "#Turret"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "key" ] 		= "10"
TOOL.ClientConVar[ "delay" ] 		= "0.05"
TOOL.ClientConVar[ "toggle" ] 		= "0"
TOOL.ClientConVar[ "force" ] 		= "1"
TOOL.ClientConVar[ "sound" ] 		= "0"
TOOL.ClientConVar[ "damage" ] 		= "10"
TOOL.ClientConVar[ "spread" ] 		= "0"
TOOL.ClientConVar[ "numbullets" ]	= "1"
TOOL.ClientConVar[ "automatic" ]	= "1"
TOOL.ClientConVar[ "tracer" ] 		= "Tracer"
if SERVER then CreateConVar("sbox_maxturrets", "4") end
cleanup.Register("turrets")

// Precache these sounds..
Sound("ambient.electrical_zap_3")
Sound("NPC_FloorTurret.Shoot")

// Add Default Language translation (saves adding it to the txt files)
if ( CLIENT ) then

	language.Add("tool.turret.name", "Turret")
	language.Add("tool.turret.desc", "Throws bullets at things")
	language.Add("tool.turret.0", "Click somewhere to spawn an turret. Click on an existing turret to change it.")
	
	language.Add("tool.turret.desc", "Throws bullets at things")
	language.Add("tool.turret.spread", "Bullet Spread")
	language.Add("tool.turret.numbullets", "Bullets per Shot")
	language.Add("tool.turret.force", "Bullet Force")
	language.Add("tool.turret.sound", "Shoot Sound")
	
	language.Add("Undone_turret", "Undone Turret")
	
	language.Add("Cleanup_turrets", "Turret")
	language.Add("Cleaned_turrets", "Cleaned up all Turrets")
	language.Add("SBoxLimit_turrets", "You've reached the Turret limit!")
	
	language.Add("Floor Turret", "Floor Turret")
	language.Add("AR2", "AR2")
	language.Add("ZAP", "Zap")
	language.Add("SMG", "SMG")
	language.Add("Shotgun", "Shotgun")
	language.Add("Airboat Heavy", "Airboat Heavy")
	
	language.Add("AR2 Tracer", "AR2 Tracer")
	language.Add("Airboat Tracer", "Airboat Tracer")
	language.Add("Airboat Heavy", "Airboat Heavy")
	language.Add("Laser", "Laser")
	
end

function TOOL:LeftClick( trace, worldweld )

	worldweld = worldweld or false

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	
	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()
	
	local key	 		= self:GetClientNumber("key") 
	local delay 		= self:GetClientNumber("delay") 
	local toggle 		= self:GetClientNumber("toggle") == 1
	local force 		= self:GetClientNumber("force")
	local sound 		= self:GetClientInfo("sound")
	local tracer 		= self:GetClientInfo("tracer")
	local damage	 	= self:GetClientNumber("damage")
	local spread	 	= self:GetClientNumber("spread")
	local numbullets 	= self:GetClientNumber("numbullets")
	
	if ( !game.SinglePlayer() ) then
	
		// Clamp stuff in multiplayer.. because people are idiots
		
		delay		= math.Clamp( delay, 0.05, 3600 )
		numbullets	= 1
		force		= math.Clamp( force, 0.01, 100 )
		spread		= math.Clamp( spread, 0, 1 )
		damage		= math.Clamp( damage, 0, 500 )
	
	end
	
	
	// We shot an existing turret - just change its values
	if ( trace.Entity:IsValid() && trace.Entity:GetClass() == "gmod_turret" && trace.Entity.pl == ply ) then

		trace.Entity:SetDamage( damage )
		trace.Entity:SetDelay( delay )
		trace.Entity:SetToggle( toggle )
		trace.Entity:SetNumBullets( numbullets )
		trace.Entity:SetSpread( spread )
		trace.Entity:SetForce( force )
		trace.Entity:SetSound( sound )
		trace.Entity:SetTracer( tracer )
		return true
		
	end
	
	if ( !self:GetSWEP():CheckLimit("turrets") ) then return false end

	if ( trace.Entity != NULL && (!trace.Entity:IsWorld() || worldweld) ) then
	
		trace.HitPos = trace.HitPos + trace.HitNormal * 2
	
	else
	
		trace.HitPos = trace.HitPos + trace.HitNormal * 2
	
	end


	local turret = MakeTurret( ply, trace.HitPos, nil, key, delay, toggle, damage, force, sound, numbullets, spread, tracer )
	/*
	local Angle = trace.HitNormal:Angle()
		Angle:RotateAroundAxis( Angle:Forward(), 90 )
		Angle:RotateAroundAxis( Angle:Forward(), 90 )
	*/
	turret:SetAngles( trace.HitNormal:Angle() )
	
	local weld
	
	// Don't weld to world
	if ( trace.Entity != NULL && (!trace.Entity:IsWorld() || worldweld) ) then
	
		weld = constraint.Weld( turret, trace.Entity, 0, trace.PhysicsBone, 0, 0, true )
		
		// Don't hit your parents or you will go to jail.
		
		turret:GetPhysicsObject():EnableCollisions( false )
		turret.nocollide = true
		
	end
	
	undo.Create("Turret")
		undo.AddEntity( turret )
		undo.AddEntity( weld )
		undo.SetPlayer( ply )
	undo.Finish()
	
	return true

end

function TOOL:RightClick( trace )
	return self:LeftClick( trace, true )
end

if (SERVER) then

	function MakeTurret( ply, Pos, Ang, key, delay, toggle, damage, force, sound, numbullets, spread, tracer, Vel, aVel, frozen, nocollide )
	
		if ( !ply:CheckLimit("turrets") ) then return nil end
	
		local turret = ents.Create("gmod_turret")
		if (!turret:IsValid()) then return false end

		turret:SetPos( Pos )
		if ( Ang ) then turret:SetAngles( Ang ) end
		turret:Spawn()
		
		turret:SetDamage( damage )
		turret:SetPlayer( ply )
		
		turret:SetSpread( spread )
		turret:SetForce( force )
		turret:SetSound( sound )
		turret:SetTracer( tracer )
		
		turret:SetNumBullets( numbullets )
		
		turret:SetDelay( delay )
		turret:SetToggle( toggle )

		numpad.OnDown( 	 ply, 	key, 	"Turret_On", 	turret )
		numpad.OnUp( 	 ply, 	key, 	"Turret_Off", 	turret )

		if ( nocollide == true ) then turret:GetPhysicsObject():EnableCollisions( false ) end

		local ttable = 
		{
			key		= key,
			delay 		= delay,
			toggle 		= toggle,
			damage 		= damage,
			pl			= ply,
			nocollide 	= nocollide,
			force		= force,
			sound		= sound,
			spread		= spread,
			numbullets	= numbullets,
			tracer		= tracer
		}

		table.Merge( turret:GetTable(), ttable )
		
		ply:AddCount("turrets", turret )
		ply:AddCleanup("turrets", turret )

		return turret
		
	end
	
	duplicator.RegisterEntityClass("gmod_turret", MakeTurret, "Pos", "Ang", "key", "delay", "toggle", "damage", "force", "sound", "numbullets", "spread", "tracer", "Vel", "aVel", "frozen", "nocollide")

end

function TOOL.BuildCPanel( CPanel )

	// HEADER
	CPanel:AddControl("Header", { Text = "#tool.turret.name", Description	= "#tool.turret.desc" }  )
	
	// Presets
	local params = { Label = "#Presets", MenuButton = 1, Folder = "turret", Options = {}, CVars = {} }
		
		params.Options.default = {
			turret_key			= 		3,
			turret_delay		=		0.2,
			turret_toggle		=		1,
			turret_force		=		1,
			turret_sound		=		"pistol",
			turret_damage		=		10,
			turret_spread		=		0,
			turret_numbullets	=		1,
		}
			
		table.insert( params.CVars, "turret_key")
		table.insert( params.CVars, "turret_delay")
		table.insert( params.CVars, "turret_toggle")
		table.insert( params.CVars, "turret_force")
		table.insert( params.CVars, "turret_sound")
		table.insert( params.CVars, "turret_damage")
		table.insert( params.CVars, "turret_spread")
		table.insert( params.CVars, "turret_numbullets")
		
	CPanel:AddControl("ComboBox", params )
	
	// Keypad
	CPanel:AddControl("Numpad", { Label = "#Turret Key", Command = "turret_key", ButtonSize = 22 } )
	
	// Shot sounds
	local weaponSounds = {Label = "#tool.turret.sound", MenuButton = 0, Options={}, CVars = {}}
		weaponSounds["Options"]["#No Weapon"]	= { turret_sound = "" }
		weaponSounds["Options"]["#Pistol"]		= { turret_sound = "Weapon_Pistol.Single" }
		weaponSounds["Options"]["#SMG"]			= { turret_sound = "Weapon_SMG1.Single" }
		weaponSounds["Options"]["#AR2"]			= { turret_sound = "Weapon_AR2.Single" }
		weaponSounds["Options"]["#Shotgun"]		= { turret_sound = "Weapon_Shotgun.Single" }
		weaponSounds["Options"]["#Floor Turret"]	= { turret_sound = "NPC_FloorTurret.Shoot" }
		weaponSounds["Options"]["#Airboat Heavy"]	= { turret_sound = "Airboat.FireGunHeavy" }
		weaponSounds["Options"]["#Zap"]	= { turret_sound = "ambient.electrical_zap_3" }
		
		
	CPanel:AddControl("ComboBox", weaponSounds )
	
	// Tracer
	local TracerType = {Label = "#Tracer", MenuButton = 0, Options={}, CVars = {}}
		TracerType["Options"]["#Default"]			= { turret_tracer = "Tracer" }
		TracerType["Options"]["#AR2 Tracer"]		= { turret_tracer = "AR2Tracer" }
		TracerType["Options"]["#Airboat Tracer"]	= { turret_tracer = "AirboatGunHeavyTracer" }
		TracerType["Options"]["#Laser"]				= { turret_tracer = "LaserTracer" }
		TracerType["Options"]["#None"]				= { turret_tracer = "" }
		
		
	CPanel:AddControl("ComboBox", TracerType )
	
	// Various controls that you should play with!
	
	if ( game.SinglePlayer() ) then
	
		CPanel:AddControl("Slider",  { Label	= "#tool.turret.numbullets",
									Type	= "Integer",
									Min		= 1,
									Max		= 10,
									Command = "turret_numbullets" }	 )
	end

	CPanel:AddControl("Slider",  { Label	= "#Damage",
									Type	= "Float",
									Min		= 0,
									Max		= 100,
									Command = "turret_damage" }	 )

	CPanel:AddControl("Slider",  { Label	= "#tool.turret.spread",
									Type	= "Float",
									Min		= 0,
									Max		= 1.0,
									Command = "turret_spread" }	 )

	CPanel:AddControl("Slider",  { Label	= "#tool.turret.force",
									Type	= "Float",
									Min		= 0,
									Max		= 500,
									Command = "turret_force" }	 )
									
	// The delay between shots.
	if ( game.SinglePlayer() ) then
	
		CPanel:AddControl("Slider",  { Label	= "#Delay",
									Type	= "Float",
									Min		= 0.01,
									Max		= 1.0,
									Command = "turret_delay" }	 )
									
	else
	
		CPanel:AddControl("Slider",  { Label	= "#Delay",
									Type	= "Float",
									Min		= 0.05,
									Max		= 1.0,
									Command = "turret_delay" }	 )
	
	end
	
	// The toggle switch.
	CPanel:AddControl("Checkbox", { Label = "#Toggle", Command = "turret_toggle" } )


end


----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

TOOL.Category		= "Construction"
TOOL.Name			= "#Turret"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "key" ] 		= "10"
TOOL.ClientConVar[ "delay" ] 		= "0.05"
TOOL.ClientConVar[ "toggle" ] 		= "0"
TOOL.ClientConVar[ "force" ] 		= "1"
TOOL.ClientConVar[ "sound" ] 		= "0"
TOOL.ClientConVar[ "damage" ] 		= "10"
TOOL.ClientConVar[ "spread" ] 		= "0"
TOOL.ClientConVar[ "numbullets" ]	= "1"
TOOL.ClientConVar[ "automatic" ]	= "1"
TOOL.ClientConVar[ "tracer" ] 		= "Tracer"
if SERVER then CreateConVar("sbox_maxturrets", "4") end
cleanup.Register("turrets")

// Precache these sounds..
Sound("ambient.electrical_zap_3")
Sound("NPC_FloorTurret.Shoot")

// Add Default Language translation (saves adding it to the txt files)
if ( CLIENT ) then

	language.Add("tool.turret.name", "Turret")
	language.Add("tool.turret.desc", "Throws bullets at things")
	language.Add("tool.turret.0", "Click somewhere to spawn an turret. Click on an existing turret to change it.")
	
	language.Add("tool.turret.desc", "Throws bullets at things")
	language.Add("tool.turret.spread", "Bullet Spread")
	language.Add("tool.turret.numbullets", "Bullets per Shot")
	language.Add("tool.turret.force", "Bullet Force")
	language.Add("tool.turret.sound", "Shoot Sound")
	
	language.Add("Undone_turret", "Undone Turret")
	
	language.Add("Cleanup_turrets", "Turret")
	language.Add("Cleaned_turrets", "Cleaned up all Turrets")
	language.Add("SBoxLimit_turrets", "You've reached the Turret limit!")
	
	language.Add("Floor Turret", "Floor Turret")
	language.Add("AR2", "AR2")
	language.Add("ZAP", "Zap")
	language.Add("SMG", "SMG")
	language.Add("Shotgun", "Shotgun")
	language.Add("Airboat Heavy", "Airboat Heavy")
	
	language.Add("AR2 Tracer", "AR2 Tracer")
	language.Add("Airboat Tracer", "Airboat Tracer")
	language.Add("Airboat Heavy", "Airboat Heavy")
	language.Add("Laser", "Laser")
	
end

function TOOL:LeftClick( trace, worldweld )

	worldweld = worldweld or false

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	
	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()
	
	local key	 		= self:GetClientNumber("key") 
	local delay 		= self:GetClientNumber("delay") 
	local toggle 		= self:GetClientNumber("toggle") == 1
	local force 		= self:GetClientNumber("force")
	local sound 		= self:GetClientInfo("sound")
	local tracer 		= self:GetClientInfo("tracer")
	local damage	 	= self:GetClientNumber("damage")
	local spread	 	= self:GetClientNumber("spread")
	local numbullets 	= self:GetClientNumber("numbullets")
	
	if ( !game.SinglePlayer() ) then
	
		// Clamp stuff in multiplayer.. because people are idiots
		
		delay		= math.Clamp( delay, 0.05, 3600 )
		numbullets	= 1
		force		= math.Clamp( force, 0.01, 100 )
		spread		= math.Clamp( spread, 0, 1 )
		damage		= math.Clamp( damage, 0, 500 )
	
	end
	
	
	// We shot an existing turret - just change its values
	if ( trace.Entity:IsValid() && trace.Entity:GetClass() == "gmod_turret" && trace.Entity.pl == ply ) then

		trace.Entity:SetDamage( damage )
		trace.Entity:SetDelay( delay )
		trace.Entity:SetToggle( toggle )
		trace.Entity:SetNumBullets( numbullets )
		trace.Entity:SetSpread( spread )
		trace.Entity:SetForce( force )
		trace.Entity:SetSound( sound )
		trace.Entity:SetTracer( tracer )
		return true
		
	end
	
	if ( !self:GetSWEP():CheckLimit("turrets") ) then return false end

	if ( trace.Entity != NULL && (!trace.Entity:IsWorld() || worldweld) ) then
	
		trace.HitPos = trace.HitPos + trace.HitNormal * 2
	
	else
	
		trace.HitPos = trace.HitPos + trace.HitNormal * 2
	
	end


	local turret = MakeTurret( ply, trace.HitPos, nil, key, delay, toggle, damage, force, sound, numbullets, spread, tracer )
	/*
	local Angle = trace.HitNormal:Angle()
		Angle:RotateAroundAxis( Angle:Forward(), 90 )
		Angle:RotateAroundAxis( Angle:Forward(), 90 )
	*/
	turret:SetAngles( trace.HitNormal:Angle() )
	
	local weld
	
	// Don't weld to world
	if ( trace.Entity != NULL && (!trace.Entity:IsWorld() || worldweld) ) then
	
		weld = constraint.Weld( turret, trace.Entity, 0, trace.PhysicsBone, 0, 0, true )
		
		// Don't hit your parents or you will go to jail.
		
		turret:GetPhysicsObject():EnableCollisions( false )
		turret.nocollide = true
		
	end
	
	undo.Create("Turret")
		undo.AddEntity( turret )
		undo.AddEntity( weld )
		undo.SetPlayer( ply )
	undo.Finish()
	
	return true

end

function TOOL:RightClick( trace )
	return self:LeftClick( trace, true )
end

if (SERVER) then

	function MakeTurret( ply, Pos, Ang, key, delay, toggle, damage, force, sound, numbullets, spread, tracer, Vel, aVel, frozen, nocollide )
	
		if ( !ply:CheckLimit("turrets") ) then return nil end
	
		local turret = ents.Create("gmod_turret")
		if (!turret:IsValid()) then return false end

		turret:SetPos( Pos )
		if ( Ang ) then turret:SetAngles( Ang ) end
		turret:Spawn()
		
		turret:SetDamage( damage )
		turret:SetPlayer( ply )
		
		turret:SetSpread( spread )
		turret:SetForce( force )
		turret:SetSound( sound )
		turret:SetTracer( tracer )
		
		turret:SetNumBullets( numbullets )
		
		turret:SetDelay( delay )
		turret:SetToggle( toggle )

		numpad.OnDown( 	 ply, 	key, 	"Turret_On", 	turret )
		numpad.OnUp( 	 ply, 	key, 	"Turret_Off", 	turret )

		if ( nocollide == true ) then turret:GetPhysicsObject():EnableCollisions( false ) end

		local ttable = 
		{
			key		= key,
			delay 		= delay,
			toggle 		= toggle,
			damage 		= damage,
			pl			= ply,
			nocollide 	= nocollide,
			force		= force,
			sound		= sound,
			spread		= spread,
			numbullets	= numbullets,
			tracer		= tracer
		}

		table.Merge( turret:GetTable(), ttable )
		
		ply:AddCount("turrets", turret )
		ply:AddCleanup("turrets", turret )

		return turret
		
	end
	
	duplicator.RegisterEntityClass("gmod_turret", MakeTurret, "Pos", "Ang", "key", "delay", "toggle", "damage", "force", "sound", "numbullets", "spread", "tracer", "Vel", "aVel", "frozen", "nocollide")

end

function TOOL.BuildCPanel( CPanel )

	// HEADER
	CPanel:AddControl("Header", { Text = "#tool.turret.name", Description	= "#tool.turret.desc" }  )
	
	// Presets
	local params = { Label = "#Presets", MenuButton = 1, Folder = "turret", Options = {}, CVars = {} }
		
		params.Options.default = {
			turret_key			= 		3,
			turret_delay		=		0.2,
			turret_toggle		=		1,
			turret_force		=		1,
			turret_sound		=		"pistol",
			turret_damage		=		10,
			turret_spread		=		0,
			turret_numbullets	=		1,
		}
			
		table.insert( params.CVars, "turret_key")
		table.insert( params.CVars, "turret_delay")
		table.insert( params.CVars, "turret_toggle")
		table.insert( params.CVars, "turret_force")
		table.insert( params.CVars, "turret_sound")
		table.insert( params.CVars, "turret_damage")
		table.insert( params.CVars, "turret_spread")
		table.insert( params.CVars, "turret_numbullets")
		
	CPanel:AddControl("ComboBox", params )
	
	// Keypad
	CPanel:AddControl("Numpad", { Label = "#Turret Key", Command = "turret_key", ButtonSize = 22 } )
	
	// Shot sounds
	local weaponSounds = {Label = "#tool.turret.sound", MenuButton = 0, Options={}, CVars = {}}
		weaponSounds["Options"]["#No Weapon"]	= { turret_sound = "" }
		weaponSounds["Options"]["#Pistol"]		= { turret_sound = "Weapon_Pistol.Single" }
		weaponSounds["Options"]["#SMG"]			= { turret_sound = "Weapon_SMG1.Single" }
		weaponSounds["Options"]["#AR2"]			= { turret_sound = "Weapon_AR2.Single" }
		weaponSounds["Options"]["#Shotgun"]		= { turret_sound = "Weapon_Shotgun.Single" }
		weaponSounds["Options"]["#Floor Turret"]	= { turret_sound = "NPC_FloorTurret.Shoot" }
		weaponSounds["Options"]["#Airboat Heavy"]	= { turret_sound = "Airboat.FireGunHeavy" }
		weaponSounds["Options"]["#Zap"]	= { turret_sound = "ambient.electrical_zap_3" }
		
		
	CPanel:AddControl("ComboBox", weaponSounds )
	
	// Tracer
	local TracerType = {Label = "#Tracer", MenuButton = 0, Options={}, CVars = {}}
		TracerType["Options"]["#Default"]			= { turret_tracer = "Tracer" }
		TracerType["Options"]["#AR2 Tracer"]		= { turret_tracer = "AR2Tracer" }
		TracerType["Options"]["#Airboat Tracer"]	= { turret_tracer = "AirboatGunHeavyTracer" }
		TracerType["Options"]["#Laser"]				= { turret_tracer = "LaserTracer" }
		TracerType["Options"]["#None"]				= { turret_tracer = "" }
		
		
	CPanel:AddControl("ComboBox", TracerType )
	
	// Various controls that you should play with!
	
	if ( game.SinglePlayer() ) then
	
		CPanel:AddControl("Slider",  { Label	= "#tool.turret.numbullets",
									Type	= "Integer",
									Min		= 1,
									Max		= 10,
									Command = "turret_numbullets" }	 )
	end

	CPanel:AddControl("Slider",  { Label	= "#Damage",
									Type	= "Float",
									Min		= 0,
									Max		= 100,
									Command = "turret_damage" }	 )

	CPanel:AddControl("Slider",  { Label	= "#tool.turret.spread",
									Type	= "Float",
									Min		= 0,
									Max		= 1.0,
									Command = "turret_spread" }	 )

	CPanel:AddControl("Slider",  { Label	= "#tool.turret.force",
									Type	= "Float",
									Min		= 0,
									Max		= 500,
									Command = "turret_force" }	 )
									
	// The delay between shots.
	if ( game.SinglePlayer() ) then
	
		CPanel:AddControl("Slider",  { Label	= "#Delay",
									Type	= "Float",
									Min		= 0.01,
									Max		= 1.0,
									Command = "turret_delay" }	 )
									
	else
	
		CPanel:AddControl("Slider",  { Label	= "#Delay",
									Type	= "Float",
									Min		= 0.05,
									Max		= 1.0,
									Command = "turret_delay" }	 )
	
	end
	
	// The toggle switch.
	CPanel:AddControl("Checkbox", { Label = "#Toggle", Command = "turret_toggle" } )


end

