
----------------------------------------
--         2014-07-12 20:33:12          --
------------------------------------------
TOOL.Category		= "Construction"
TOOL.Name			= "#Prop Spawner"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "key" ]			= "0"
TOOL.ClientConVar[ "undo_key" ]		= "-1"
TOOL.ClientConVar[ "delay" ]		= "0"
TOOL.ClientConVar[ "undo_delay" ]	= "0"

// Add Default Language translation (saves adding it to the txt files)
if ( CLIENT ) then

	language.Add("tool.spawner.name", "Prop Spawner")
	language.Add("tool.spawner.desc", "Spawns a prop at a pre-defined location")
	language.Add("tool.spawner.0", "Click a prop to turn it into a prop spawner.")

	language.Add("Undone_spawner", "Undone Spawner")
	language.Add("Cleanup_spawner", "Spawners")
	language.Add("Cleaned_spawner", "Cleaned up all Spawners")

end

cleanup.Register("spawner")

function TOOL:LeftClick( trace, attach )

	local ent = trace.Entity
	
	// Has to be an entity
	if ( !ent || !ent:IsValid() ) then return false end
	
	// Has to be a prop - or a spawner..
	if ( ent:GetClass() != "prop_physics" && ent:GetClass() != "gmod_spawner") then return false end

	if (CLIENT) then return true end

	// If there's no physics object then we can't constraint it!
	if SERVER && !util.IsValidPhysicsObject( ent, trace.PhysicsBone ) then return false end

	local pl			= self:GetOwner()
	local key			= self:GetClientNumber("key", 0 )
	local undo_key 		= self:GetClientNumber("undo_key", 0 )
	local delay			= self:GetClientNumber("delay", 0 )
	local undo_delay	= self:GetClientNumber("undo_delay", 0 )
	
	// In multiplayer we clamp the delay to help prevent people being idiots
	if ( !game.SinglePlayer() && delay < 1 ) then
		delay = 1
	end

	if ( ent:GetClass() == "gmod_spawner" && ent.Player == pl ) then

		local spawner = ent

		spawner:SetCreationDelay( delay )
		spawner:SetDeletionDelay( undo_delay	)
		
		// Remove old binds
		numpad.Remove( spawner.CreateKey )
		numpad.Remove( spawner.UndoKey )
			
		// Add new binds
		spawner.CreateKey 	= numpad.OnDown( pl, key,		 	"SpawnerCreate", spawner, true )
		spawner.UndoKey 	= numpad.OnDown( pl, undo_key, 		"SpawnerUndo",	  spawner, true )

		return true
		
	end

	if ( !self:GetSWEP():CheckLimit("spawners") ) then return false end

	local EntTable = duplicator.CopyEntTable( trace.Entity )
	
	local spawner = MakeSpawner( pl, key, undo_key, delay, undo_delay, EntTable )
	if (!spawner:IsValid()) then return end

	//!!TODO!! copy existing constraints to the spawner
	ent:Remove()

	undo.Create("Spawner")
	undo.AddEntity( spawner )
	undo.SetPlayer( pl )
	undo.Finish()

	pl:AddCleanup("spawner", spawner )

	return true

end

function MakeSpawner( pl, key, undo_key, delay, undo_delay, Data )

	if ( !pl:CheckLimit("spawners") ) then return nil end

	local spawner = ents.Create("gmod_spawner")
		if (!spawner:IsValid()) then return end
		duplicator.DoGeneric( spawner, Data )
		spawner:SetRenderMode( 3 )
		spawner:SetColor(Color(255,255,255,050))
	spawner:Spawn()
	
	duplicator.DoGenericPhysics( spawner, pl, Data )

	spawner:SetCreationDelay( delay )
	spawner:SetDeletionDelay( undo_delay )

	// Controls
	spawner.CreateKey 	= numpad.OnDown( pl, key,		 	"SpawnerCreate", spawner, true )
	spawner.UndoKey 	= numpad.OnDown( pl, undo_key, 		"SpawnerUndo",	  spawner, true )

	spawner.Player 		= pl
	spawner.key			= key
	spawner.undo_key	= undo_key
	spawner.delay		= delay
	spawner.undo_delay	= undo_delay

	pl:AddCount("spawners", spawner )

	return spawner

end

duplicator.RegisterEntityClass("gmod_spawner", MakeSpawner, "key", "undo_key", "delay", "undo_delay", "Data")


function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl("Header", { Text = "#tool.spawner.name", Description	= "#tool.spawner.desc" }  )
	
	local params = { 
		Label = "#Presets", 
		MenuButton = 1, 
		Folder = "spawner", 
		Options = {
			default = {
				spawner_key			= 0,
				spawner_undo_key	= 1,
				spawner_delay		= 0,
				spawner_undo_delay	= 0,
			},
		}, 
		CVars = {	"spawner_key",
					"spawner_undo_key",
					"spawner_delay",
					"spawner_undo_delay",
				},
	}
	CPanel:AddControl("ComboBox", params )
	
	params = { 
		Label		= "#Spawn Key",
		Label2		= "#Undo Key",
		Command		= "spawner_key",
		Command2	= "spawner_undo_key",
		ButtonSize	= "22",
	}
	CPanel:AddControl("Numpad",  params )
	
	params = { 
		Label	= "#Spawn Delay",
		Type	= "Float",
		Min		= "0",
		Max		= "100",
		Command	= "spawner_delay",
	}
	CPanel:AddControl("Slider",  params )

	params = { 
		Label	= "#Automatic Undo Delay",
		Type	= "Float",
		Min		= "0",
		Max		= "100",
		Command	= "spawner_undo_delay",
	}
	CPanel:AddControl("Slider",  params )

end


----------------------------------------
--         2014-07-12 20:33:12          --
------------------------------------------
TOOL.Category		= "Construction"
TOOL.Name			= "#Prop Spawner"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "key" ]			= "0"
TOOL.ClientConVar[ "undo_key" ]		= "-1"
TOOL.ClientConVar[ "delay" ]		= "0"
TOOL.ClientConVar[ "undo_delay" ]	= "0"

// Add Default Language translation (saves adding it to the txt files)
if ( CLIENT ) then

	language.Add("tool.spawner.name", "Prop Spawner")
	language.Add("tool.spawner.desc", "Spawns a prop at a pre-defined location")
	language.Add("tool.spawner.0", "Click a prop to turn it into a prop spawner.")

	language.Add("Undone_spawner", "Undone Spawner")
	language.Add("Cleanup_spawner", "Spawners")
	language.Add("Cleaned_spawner", "Cleaned up all Spawners")

end

cleanup.Register("spawner")

function TOOL:LeftClick( trace, attach )

	local ent = trace.Entity
	
	// Has to be an entity
	if ( !ent || !ent:IsValid() ) then return false end
	
	// Has to be a prop - or a spawner..
	if ( ent:GetClass() != "prop_physics" && ent:GetClass() != "gmod_spawner") then return false end

	if (CLIENT) then return true end

	// If there's no physics object then we can't constraint it!
	if SERVER && !util.IsValidPhysicsObject( ent, trace.PhysicsBone ) then return false end

	local pl			= self:GetOwner()
	local key			= self:GetClientNumber("key", 0 )
	local undo_key 		= self:GetClientNumber("undo_key", 0 )
	local delay			= self:GetClientNumber("delay", 0 )
	local undo_delay	= self:GetClientNumber("undo_delay", 0 )
	
	// In multiplayer we clamp the delay to help prevent people being idiots
	if ( !game.SinglePlayer() && delay < 1 ) then
		delay = 1
	end

	if ( ent:GetClass() == "gmod_spawner" && ent.Player == pl ) then

		local spawner = ent

		spawner:SetCreationDelay( delay )
		spawner:SetDeletionDelay( undo_delay	)
		
		// Remove old binds
		numpad.Remove( spawner.CreateKey )
		numpad.Remove( spawner.UndoKey )
			
		// Add new binds
		spawner.CreateKey 	= numpad.OnDown( pl, key,		 	"SpawnerCreate", spawner, true )
		spawner.UndoKey 	= numpad.OnDown( pl, undo_key, 		"SpawnerUndo",	  spawner, true )

		return true
		
	end

	if ( !self:GetSWEP():CheckLimit("spawners") ) then return false end

	local EntTable = duplicator.CopyEntTable( trace.Entity )
	
	local spawner = MakeSpawner( pl, key, undo_key, delay, undo_delay, EntTable )
	if (!spawner:IsValid()) then return end

	//!!TODO!! copy existing constraints to the spawner
	ent:Remove()

	undo.Create("Spawner")
	undo.AddEntity( spawner )
	undo.SetPlayer( pl )
	undo.Finish()

	pl:AddCleanup("spawner", spawner )

	return true

end

function MakeSpawner( pl, key, undo_key, delay, undo_delay, Data )

	if ( !pl:CheckLimit("spawners") ) then return nil end

	local spawner = ents.Create("gmod_spawner")
		if (!spawner:IsValid()) then return end
		duplicator.DoGeneric( spawner, Data )
		spawner:SetRenderMode( 3 )
		spawner:SetColor(Color(255,255,255,050))
	spawner:Spawn()
	
	duplicator.DoGenericPhysics( spawner, pl, Data )

	spawner:SetCreationDelay( delay )
	spawner:SetDeletionDelay( undo_delay )

	// Controls
	spawner.CreateKey 	= numpad.OnDown( pl, key,		 	"SpawnerCreate", spawner, true )
	spawner.UndoKey 	= numpad.OnDown( pl, undo_key, 		"SpawnerUndo",	  spawner, true )

	spawner.Player 		= pl
	spawner.key			= key
	spawner.undo_key	= undo_key
	spawner.delay		= delay
	spawner.undo_delay	= undo_delay

	pl:AddCount("spawners", spawner )

	return spawner

end

duplicator.RegisterEntityClass("gmod_spawner", MakeSpawner, "key", "undo_key", "delay", "undo_delay", "Data")


function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl("Header", { Text = "#tool.spawner.name", Description	= "#tool.spawner.desc" }  )
	
	local params = { 
		Label = "#Presets", 
		MenuButton = 1, 
		Folder = "spawner", 
		Options = {
			default = {
				spawner_key			= 0,
				spawner_undo_key	= 1,
				spawner_delay		= 0,
				spawner_undo_delay	= 0,
			},
		}, 
		CVars = {	"spawner_key",
					"spawner_undo_key",
					"spawner_delay",
					"spawner_undo_delay",
				},
	}
	CPanel:AddControl("ComboBox", params )
	
	params = { 
		Label		= "#Spawn Key",
		Label2		= "#Undo Key",
		Command		= "spawner_key",
		Command2	= "spawner_undo_key",
		ButtonSize	= "22",
	}
	CPanel:AddControl("Numpad",  params )
	
	params = { 
		Label	= "#Spawn Delay",
		Type	= "Float",
		Min		= "0",
		Max		= "100",
		Command	= "spawner_delay",
	}
	CPanel:AddControl("Slider",  params )

	params = { 
		Label	= "#Automatic Undo Delay",
		Type	= "Float",
		Min		= "0",
		Max		= "100",
		Command	= "spawner_undo_delay",
	}
	CPanel:AddControl("Slider",  params )

end

