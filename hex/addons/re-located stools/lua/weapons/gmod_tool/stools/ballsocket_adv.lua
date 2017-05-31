
----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------
TOOL.Category		= "Constraints"
TOOL.Name			= "#Ball Socket - Advanced"
TOOL.Command		= nil
TOOL.ConfigName		= nil

if CLIENT then
language.Add("tool.ballsocket_adv.name", "Advanced Ball Socket Constraint")
language.Add("tool.ballsocket_adv.desc", "Creates a ball socket and allows you to set movement limits")
language.Add("tool.ballsocket_adv.0", "Click on a wall, prop or ragdoll")
language.Add("tool.ballsocket_adv.1", "Now click on something else to attach it to")
language.Add("AdvBallsocketTool_forcelimit", "Force Limit:")
language.Add("AdvBallsocketTool_forcelimit_desc", "How much force the ball socket sustains before breaking")
language.Add("AdvBallsocketTool_torquelimit", "Torque Limit:")
language.Add("AdvBallsocketTool_torquelimit_desc", "How much torque the ball socket sustains before breaking")
language.Add("AdvBallsocketTool_xmin", "X Minimum:")
language.Add("AdvBallsocketTool_xmin_desc", "Minimum Pitch")
language.Add("AdvBallsocketTool_xmax", "X Maximum:")
language.Add("AdvBallsocketTool_xmax_desc", "Maximum Pitch")
language.Add("AdvBallsocketTool_ymin", "Y Minimum:")
language.Add("AdvBallsocketTool_ymin_desc", "Minimum Yaw")
language.Add("AdvBallsocketTool_ymax", "Y Maximum:")
language.Add("AdvBallsocketTool_ymax_desc", "Maximum Yaw")
language.Add("AdvBallsocketTool_zmin", "Z Minimum:")
language.Add("AdvBallsocketTool_zmin_desc", "Minimum Roll")
language.Add("AdvBallsocketTool_zmax", "Z Maximum:")
language.Add("AdvBallsocketTool_zmax_desc", "Maximum Roll")
language.Add("AdvBallsocketTool_xfriction", "X Friction:")
language.Add("AdvBallsocketTool_yfriction", "Y Friction:")
language.Add("AdvBallsocketTool_zfriction", "Z Friction:")
language.Add("AdvBallsocketTool_xfriction_desc", "X Friction")
language.Add("AdvBallsocketTool_yfriction_desc", "Y Friction")
language.Add("AdvBallsocketTool_zfriction_desc", "Z Friction")
language.Add("AdvBallsocketTool_freemove", "Free Movement")
language.Add("AdvBallsocketTool_freemove_desc", "Allows both entities to move freely")
language.Add("AdvBallsocketTool_nocollide", "No-Collide Entities")
language.Add("AdvBallsocketTool_nocollide_desc", "No-collides constrained entities")
end

TOOL.ClientConVar[ "forcelimit" ] = "0"
TOOL.ClientConVar[ "torquelimit" ] = "0"
TOOL.ClientConVar[ "xmin" ] = "-180"
TOOL.ClientConVar[ "ymin" ] = "-180"
TOOL.ClientConVar[ "zmin" ] = "-180"
TOOL.ClientConVar[ "xmax" ] = "180"
TOOL.ClientConVar[ "ymax" ] = "180"
TOOL.ClientConVar[ "zmax" ] = "180"
TOOL.ClientConVar[ "xfric" ] = "0"
TOOL.ClientConVar[ "yfric" ] = "0"
TOOL.ClientConVar[ "zfric" ] = "0"
TOOL.ClientConVar[ "nocollide" ] = "0"
TOOL.ClientConVar[ "onlyrotation" ] = "0"

function TOOL:LeftClick( trace )

	if ( trace.Entity:IsValid() && trace.Entity:IsPlayer() ) then return end

	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local iNum = self:NumObjects()

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )

	if ( iNum > 0 ) then
	
		if ( CLIENT ) then return true end
		
		if ( !self:GetEnt(1):IsValid() && !self:GetEnt(2):IsValid() ) then
			self:ClearObjects()
		return end
	
		// Get client's CVars
		local _forcelimit	= self:GetClientNumber("forcelimit")
		local _torquelimit 	= self:GetClientNumber("torquelimit")
		local _xmin			= self:GetClientNumber("xmin")
		local _xmax			= self:GetClientNumber("xmax")
		local _ymin			= self:GetClientNumber("ymin")
		local _ymax			= self:GetClientNumber("ymax")
		local _zmin			= self:GetClientNumber("zmin")
		local _zmax			= self:GetClientNumber("zmax")
		local _xfric		= self:GetClientNumber("xfric")
		local _yfric		= self:GetClientNumber("yfric")
		local _zfric		= self:GetClientNumber("zfric")
		local _nocollide	= self:GetClientNumber("nocollide")
		local _onlyrotation	= self:GetClientNumber("onlyrotation")
		
		local Ent1,  Ent2  = self:GetEnt(1),		self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1),		self:GetBone(2)
		local LPos1, LPos2 = self:GetLocalPos(1),	self:GetLocalPos(2)
		
		local constraint = constraint.AdvBallsocket( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, _forcelimit, _torquelimit, _xmin, _ymin, _zmin, _xmax, _ymax, _zmax, _xfric, _yfric, _zfric, _onlyrotation, _nocollide )
	
		undo.Create("AdvBallsocket")
		undo.AddEntity( constraint )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		self:GetOwner():AddCleanup("constraints", constraint )

		// Clear the objects so we're ready to go again
		self:ClearObjects()
		
	else
	
		self:SetStage( iNum+1 )
		
	end
	
	return true

end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "AdvBallsocket")
	return bool
	
end



----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------
TOOL.Category		= "Constraints"
TOOL.Name			= "#Ball Socket - Advanced"
TOOL.Command		= nil
TOOL.ConfigName		= nil

if CLIENT then
language.Add("tool.ballsocket_adv.name", "Advanced Ball Socket Constraint")
language.Add("tool.ballsocket_adv.desc", "Creates a ball socket and allows you to set movement limits")
language.Add("tool.ballsocket_adv.0", "Click on a wall, prop or ragdoll")
language.Add("tool.ballsocket_adv.1", "Now click on something else to attach it to")
language.Add("AdvBallsocketTool_forcelimit", "Force Limit:")
language.Add("AdvBallsocketTool_forcelimit_desc", "How much force the ball socket sustains before breaking")
language.Add("AdvBallsocketTool_torquelimit", "Torque Limit:")
language.Add("AdvBallsocketTool_torquelimit_desc", "How much torque the ball socket sustains before breaking")
language.Add("AdvBallsocketTool_xmin", "X Minimum:")
language.Add("AdvBallsocketTool_xmin_desc", "Minimum Pitch")
language.Add("AdvBallsocketTool_xmax", "X Maximum:")
language.Add("AdvBallsocketTool_xmax_desc", "Maximum Pitch")
language.Add("AdvBallsocketTool_ymin", "Y Minimum:")
language.Add("AdvBallsocketTool_ymin_desc", "Minimum Yaw")
language.Add("AdvBallsocketTool_ymax", "Y Maximum:")
language.Add("AdvBallsocketTool_ymax_desc", "Maximum Yaw")
language.Add("AdvBallsocketTool_zmin", "Z Minimum:")
language.Add("AdvBallsocketTool_zmin_desc", "Minimum Roll")
language.Add("AdvBallsocketTool_zmax", "Z Maximum:")
language.Add("AdvBallsocketTool_zmax_desc", "Maximum Roll")
language.Add("AdvBallsocketTool_xfriction", "X Friction:")
language.Add("AdvBallsocketTool_yfriction", "Y Friction:")
language.Add("AdvBallsocketTool_zfriction", "Z Friction:")
language.Add("AdvBallsocketTool_xfriction_desc", "X Friction")
language.Add("AdvBallsocketTool_yfriction_desc", "Y Friction")
language.Add("AdvBallsocketTool_zfriction_desc", "Z Friction")
language.Add("AdvBallsocketTool_freemove", "Free Movement")
language.Add("AdvBallsocketTool_freemove_desc", "Allows both entities to move freely")
language.Add("AdvBallsocketTool_nocollide", "No-Collide Entities")
language.Add("AdvBallsocketTool_nocollide_desc", "No-collides constrained entities")
end

TOOL.ClientConVar[ "forcelimit" ] = "0"
TOOL.ClientConVar[ "torquelimit" ] = "0"
TOOL.ClientConVar[ "xmin" ] = "-180"
TOOL.ClientConVar[ "ymin" ] = "-180"
TOOL.ClientConVar[ "zmin" ] = "-180"
TOOL.ClientConVar[ "xmax" ] = "180"
TOOL.ClientConVar[ "ymax" ] = "180"
TOOL.ClientConVar[ "zmax" ] = "180"
TOOL.ClientConVar[ "xfric" ] = "0"
TOOL.ClientConVar[ "yfric" ] = "0"
TOOL.ClientConVar[ "zfric" ] = "0"
TOOL.ClientConVar[ "nocollide" ] = "0"
TOOL.ClientConVar[ "onlyrotation" ] = "0"

function TOOL:LeftClick( trace )

	if ( trace.Entity:IsValid() && trace.Entity:IsPlayer() ) then return end

	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local iNum = self:NumObjects()

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )

	if ( iNum > 0 ) then
	
		if ( CLIENT ) then return true end
		
		if ( !self:GetEnt(1):IsValid() && !self:GetEnt(2):IsValid() ) then
			self:ClearObjects()
		return end
	
		// Get client's CVars
		local _forcelimit	= self:GetClientNumber("forcelimit")
		local _torquelimit 	= self:GetClientNumber("torquelimit")
		local _xmin			= self:GetClientNumber("xmin")
		local _xmax			= self:GetClientNumber("xmax")
		local _ymin			= self:GetClientNumber("ymin")
		local _ymax			= self:GetClientNumber("ymax")
		local _zmin			= self:GetClientNumber("zmin")
		local _zmax			= self:GetClientNumber("zmax")
		local _xfric		= self:GetClientNumber("xfric")
		local _yfric		= self:GetClientNumber("yfric")
		local _zfric		= self:GetClientNumber("zfric")
		local _nocollide	= self:GetClientNumber("nocollide")
		local _onlyrotation	= self:GetClientNumber("onlyrotation")
		
		local Ent1,  Ent2  = self:GetEnt(1),		self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1),		self:GetBone(2)
		local LPos1, LPos2 = self:GetLocalPos(1),	self:GetLocalPos(2)
		
		local constraint = constraint.AdvBallsocket( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, _forcelimit, _torquelimit, _xmin, _ymin, _zmin, _xmax, _ymax, _zmax, _xfric, _yfric, _zfric, _onlyrotation, _nocollide )
	
		undo.Create("AdvBallsocket")
		undo.AddEntity( constraint )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		self:GetOwner():AddCleanup("constraints", constraint )

		// Clear the objects so we're ready to go again
		self:ClearObjects()
		
	else
	
		self:SetStage( iNum+1 )
		
	end
	
	return true

end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "AdvBallsocket")
	return bool
	
end


