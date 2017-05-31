
----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------

include("shared.lua")

killicon.AddFont("obj_combine_bunker_gun", "HL2MPTypeDeath", "2", Color(192,0,192))


function ENT:Initialize()
	self.status = {}
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	local found = false
	local closest_d = 999999
	local closest_p = nil
	for k, v in pairs(ents.FindInSphere( self:GetPos(), 20 )) do
		if IsValid(v) and v:IsPlayer() then
			if v:Health() > 0 then
				local d = math.floor(v:GetPos():Distance( self:GetPos() ))
				if d < closest_d then
					closest_d = d
					closest_p = v
					found = true
				end
			end
		end
	end
	
	--==================================================================
	--==  An owner was found, let's get to the action!				  ==
	--==================================================================
	if found then
		self.status.owner = closest_p
		
		local pos = self.status.owner:GetEyeTrace().HitPos
		
		local ang1 = (pos - self:GetPos()):Angle()
		local ang2 = self:GetAngles()
		
		local nyaw = math.AngleDifference( ang1.yaw, ang2.yaw )
		local npitch = math.AngleDifference( ang1.pitch, ang2.pitch )
		
		local dist = math.floor(pos:Distance( self:GetPos() ))
		
		if dist > 50 then -- at least aim far away
			self:SetPoseParameter("aim_yaw", math.Clamp(nyaw,-60,60))
			self:SetPoseParameter("aim_pitch", math.Clamp(npitch,-35,30))
		end
	end
end










----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------

include("shared.lua")

killicon.AddFont("obj_combine_bunker_gun", "HL2MPTypeDeath", "2", Color(192,0,192))


function ENT:Initialize()
	self.status = {}
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	local found = false
	local closest_d = 999999
	local closest_p = nil
	for k, v in pairs(ents.FindInSphere( self:GetPos(), 20 )) do
		if IsValid(v) and v:IsPlayer() then
			if v:Health() > 0 then
				local d = math.floor(v:GetPos():Distance( self:GetPos() ))
				if d < closest_d then
					closest_d = d
					closest_p = v
					found = true
				end
			end
		end
	end
	
	--==================================================================
	--==  An owner was found, let's get to the action!				  ==
	--==================================================================
	if found then
		self.status.owner = closest_p
		
		local pos = self.status.owner:GetEyeTrace().HitPos
		
		local ang1 = (pos - self:GetPos()):Angle()
		local ang2 = self:GetAngles()
		
		local nyaw = math.AngleDifference( ang1.yaw, ang2.yaw )
		local npitch = math.AngleDifference( ang1.pitch, ang2.pitch )
		
		local dist = math.floor(pos:Distance( self:GetPos() ))
		
		if dist > 50 then -- at least aim far away
			self:SetPoseParameter("aim_yaw", math.Clamp(nyaw,-60,60))
			self:SetPoseParameter("aim_pitch", math.Clamp(npitch,-35,30))
		end
	end
end









