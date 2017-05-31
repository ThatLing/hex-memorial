
----------------------------------------
--         2014-07-12 20:33:12          --
------------------------------------------
TOOL.Category		= "Construction"
TOOL.Name			= "#Keep Upright"
TOOL.Command		= nil
TOOL.ConfigName		= nil

if CLIENT then
language.Add("tool.keepupright.name", "Keep Upright Constraint")
language.Add("tool.keepupright.desc", "Attempts to keep a prop upright")
language.Add("tool.keepupright.0", "Click on a prop or a ragdoll")
language.Add("KeepUprightTool_angularlimit_desc", "How much force the prop resists")
language.Add("KeepUprightTool_angularlimit", "Angular Limit")
end

TOOL.ClientConVar[ "angularlimit" ] = 100000

function TOOL:LeftClick( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end

	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	if ( CLIENT ) then return true end

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	
	// Get client's CVars
	local angularlimit	= self:GetClientNumber("angularlimit")
	
	// Get information we're about to use
	local Ent  = trace.Entity
	local Bone = trace.PhysicsBone
	local Ang  = Phys:GetAngles()

	local constr = constraint.Keepupright( Ent, Ang, Bone, angularlimit )
	
		if (constr) then
		undo.Create("KeepUpright")
		undo.AddEntity( constr )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
	
		self:GetOwner():AddCleanup("constraints", constr )
	
	end
	
	return true
	
end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "Keepupright")
	return bool
	
end


----------------------------------------
--         2014-07-12 20:33:12          --
------------------------------------------
TOOL.Category		= "Construction"
TOOL.Name			= "#Keep Upright"
TOOL.Command		= nil
TOOL.ConfigName		= nil

if CLIENT then
language.Add("tool.keepupright.name", "Keep Upright Constraint")
language.Add("tool.keepupright.desc", "Attempts to keep a prop upright")
language.Add("tool.keepupright.0", "Click on a prop or a ragdoll")
language.Add("KeepUprightTool_angularlimit_desc", "How much force the prop resists")
language.Add("KeepUprightTool_angularlimit", "Angular Limit")
end

TOOL.ClientConVar[ "angularlimit" ] = 100000

function TOOL:LeftClick( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end

	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	if ( CLIENT ) then return true end

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	
	// Get client's CVars
	local angularlimit	= self:GetClientNumber("angularlimit")
	
	// Get information we're about to use
	local Ent  = trace.Entity
	local Bone = trace.PhysicsBone
	local Ang  = Phys:GetAngles()

	local constr = constraint.Keepupright( Ent, Ang, Bone, angularlimit )
	
		if (constr) then
		undo.Create("KeepUpright")
		undo.AddEntity( constr )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
	
		self:GetOwner():AddCleanup("constraints", constr )
	
	end
	
	return true
	
end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "Keepupright")
	return bool
	
end

