
----------------------------------------
--         2014-07-12 20:33:12          --
------------------------------------------
TOOL.Category		= "Poser"
TOOL.Name			= "#Statue"
TOOL.Command		= nil
TOOL.ConfigName		= nil

if CLIENT then
language.Add("tool.statue.name", "Statue")
language.Add("tool.statue.desc", "Make a ragdoll solid")
language.Add("tool.statue.0", "Left click to turn a ragdoll into a statue. Right click to turn it back into a ragdoll.")
end

TOOL.ClientConVar[ "unfreeze" ] = "1"

function TOOL:LeftClick( trace )

	if (!trace.Entity) then return false end
	if (!trace.Entity:IsValid()) then return false end
	if (trace.Entity:IsPlayer()) then return false end	
	if (trace.Entity:GetClass() != "prop_ragdoll") then return false end
	
	if ( CLIENT ) then return true end
	
	if (trace.Entity:GetPhysicsObjectCount() < 2 ) then return false end
		
	local ent = trace.Entity
	local unfreeze = util.tobool( self:GetClientNumber("unfreeze") )
		
	// If it already has a StatueInfo table then it's already statued
	if ( ent.StatueInfo != nil )  then return false end
	
	ent.StatueInfo = {}
	ent.StatueInfo.Welds = {}
	
	local bones = ent:GetPhysicsObjectCount()
	
	local forcelimit = 0
	
	// Weld each physics object together
	for bone=1, bones do
	
		local bone1 = bone - 1
		local bone2 = bones - bone
		
		// Don't do identical two welds
		if ( !ent.StatueInfo.Welds[bone2] ) then
		
			local constraint1 = constraint.Weld( ent, ent, bone1, bone2, forcelimit )
			
			if ( constraint1 ) then
			
				ent.StatueInfo.Welds[bone1] = constraint1
				self:GetOwner():AddCleanup("constraints", constraint1 )
			
			end
			
		end
		
		local constraint2 = constraint.Weld( ent, ent, bone1, 0, forcelimit )
		
		if ( constraint2 ) then
		
			ent.StatueInfo.Welds[bone1+bones] = constraint2
			self:GetOwner():AddCleanup("constraints", constraint2 )
		
		end
		
		local effectdata = EffectData()
			 effectdata:SetOrigin( ent:GetPhysicsObjectNum( bone1 ):GetPos() )
			 effectdata:SetScale( 1 )
			 effectdata:SetMagnitude( 1 )
		util.Effect("GlassImpact", effectdata, true, true )
		
	end
	
	if ( unfreeze == true ) then
	
		for bone=1,bones do
		
			local bone1 = bone - 1

			ent:GetPhysicsObjectNum( bone1 ):EnableMotion( true )
			ent:GetPhysicsObjectNum( bone1 ):Wake()
			
		end
		
	end
	
	return true

end


function TOOL:RightClick( trace )

	if (!trace.Entity) then return end
	if (!trace.Entity:IsValid()) then return end
	if (trace.Entity:IsPlayer()) then return end	
	if (trace.Entity:GetClass() != "prop_ragdoll") then return false end
	
	if ( CLIENT ) then return true end
	
	if (trace.Entity:GetPhysicsObjectCount() < 2 ) then return false end
	if (trace.Entity.StatueInfo == nil )  then return false end
	
	local ent = trace.Entity

	
	// Remove each weld
	for key, val in pairs (ent.StatueInfo.Welds) do
	
		if ( val && val:IsValid() ) then val:Remove() end
		
	end
	
	// Delete the statue table - it's no longer a statue
	ent.StatueInfo = nil
	
	local bones = ent:GetPhysicsObjectCount()
	
	for bone=1, bones do
		local bone1 = bone - 1
		local effectdata = EffectData()
			 effectdata:SetOrigin( ent:GetPhysicsObjectNum( bone1 ):GetPos() )
			 effectdata:SetScale( 1 )
			 effectdata:SetMagnitude( 1 )
		util.Effect("WheelDust", effectdata, true, true )		
	end
	
	return true
	
end



----------------------------------------
--         2014-07-12 20:33:12          --
------------------------------------------
TOOL.Category		= "Poser"
TOOL.Name			= "#Statue"
TOOL.Command		= nil
TOOL.ConfigName		= nil

if CLIENT then
language.Add("tool.statue.name", "Statue")
language.Add("tool.statue.desc", "Make a ragdoll solid")
language.Add("tool.statue.0", "Left click to turn a ragdoll into a statue. Right click to turn it back into a ragdoll.")
end

TOOL.ClientConVar[ "unfreeze" ] = "1"

function TOOL:LeftClick( trace )

	if (!trace.Entity) then return false end
	if (!trace.Entity:IsValid()) then return false end
	if (trace.Entity:IsPlayer()) then return false end	
	if (trace.Entity:GetClass() != "prop_ragdoll") then return false end
	
	if ( CLIENT ) then return true end
	
	if (trace.Entity:GetPhysicsObjectCount() < 2 ) then return false end
		
	local ent = trace.Entity
	local unfreeze = util.tobool( self:GetClientNumber("unfreeze") )
		
	// If it already has a StatueInfo table then it's already statued
	if ( ent.StatueInfo != nil )  then return false end
	
	ent.StatueInfo = {}
	ent.StatueInfo.Welds = {}
	
	local bones = ent:GetPhysicsObjectCount()
	
	local forcelimit = 0
	
	// Weld each physics object together
	for bone=1, bones do
	
		local bone1 = bone - 1
		local bone2 = bones - bone
		
		// Don't do identical two welds
		if ( !ent.StatueInfo.Welds[bone2] ) then
		
			local constraint1 = constraint.Weld( ent, ent, bone1, bone2, forcelimit )
			
			if ( constraint1 ) then
			
				ent.StatueInfo.Welds[bone1] = constraint1
				self:GetOwner():AddCleanup("constraints", constraint1 )
			
			end
			
		end
		
		local constraint2 = constraint.Weld( ent, ent, bone1, 0, forcelimit )
		
		if ( constraint2 ) then
		
			ent.StatueInfo.Welds[bone1+bones] = constraint2
			self:GetOwner():AddCleanup("constraints", constraint2 )
		
		end
		
		local effectdata = EffectData()
			 effectdata:SetOrigin( ent:GetPhysicsObjectNum( bone1 ):GetPos() )
			 effectdata:SetScale( 1 )
			 effectdata:SetMagnitude( 1 )
		util.Effect("GlassImpact", effectdata, true, true )
		
	end
	
	if ( unfreeze == true ) then
	
		for bone=1,bones do
		
			local bone1 = bone - 1

			ent:GetPhysicsObjectNum( bone1 ):EnableMotion( true )
			ent:GetPhysicsObjectNum( bone1 ):Wake()
			
		end
		
	end
	
	return true

end


function TOOL:RightClick( trace )

	if (!trace.Entity) then return end
	if (!trace.Entity:IsValid()) then return end
	if (trace.Entity:IsPlayer()) then return end	
	if (trace.Entity:GetClass() != "prop_ragdoll") then return false end
	
	if ( CLIENT ) then return true end
	
	if (trace.Entity:GetPhysicsObjectCount() < 2 ) then return false end
	if (trace.Entity.StatueInfo == nil )  then return false end
	
	local ent = trace.Entity

	
	// Remove each weld
	for key, val in pairs (ent.StatueInfo.Welds) do
	
		if ( val && val:IsValid() ) then val:Remove() end
		
	end
	
	// Delete the statue table - it's no longer a statue
	ent.StatueInfo = nil
	
	local bones = ent:GetPhysicsObjectCount()
	
	for bone=1, bones do
		local bone1 = bone - 1
		local effectdata = EffectData()
			 effectdata:SetOrigin( ent:GetPhysicsObjectNum( bone1 ):GetPos() )
			 effectdata:SetScale( 1 )
			 effectdata:SetMagnitude( 1 )
		util.Effect("WheelDust", effectdata, true, true )		
	end
	
	return true
	
end


