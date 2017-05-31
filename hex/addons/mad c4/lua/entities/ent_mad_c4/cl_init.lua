
----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
include("shared.lua")

language.Add("ent_mad_c4", "Explosive C4")

surface.CreateFont("DefaultC4", {
	font		= "Tahoma",
	size 		= 13,
	weight		= 500,
	antialias	= false,
	additive	= false,
	}
)


function ENT:Draw()
	self:DrawModel()

	local FixAngles = self:GetAngles()
	local FixRotation = Vector(0, 270, 0)

	FixAngles:RotateAroundAxis(FixAngles:Right(), 	FixRotation.x)
	FixAngles:RotateAroundAxis(FixAngles:Up(),		FixRotation.y)
	FixAngles:RotateAroundAxis(FixAngles:Forward(), FixRotation.z)

 	local TargetPos = self:GetPos() + (self:GetUp() * 9)
	
	local m,s = self:FormatTime(self.C4CountDown)
	self.Text = string.format("%02d", m)..":"..string.format("%02d", s)
	
	cam.Start3D2D(TargetPos, FixAngles, 0.15)
		surface.SetFont("DefaultC4")
		draw.SimpleText(self.Text, "DefaultC4", 31, -22, Color(255, 0, 0, 255), 1, 1)
	cam.End3D2D() 
end


function ENT:FormatTime(seconds)
	local m = seconds % 604800 % 86400 % 3600 / 60
	local s = seconds % 604800 % 86400 % 3600 % 60
	
	return math.floor(m), math.floor(s)
end








----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
include("shared.lua")

language.Add("ent_mad_c4", "Explosive C4")

surface.CreateFont("DefaultC4", {
	font		= "Tahoma",
	size 		= 13,
	weight		= 500,
	antialias	= false,
	additive	= false,
	}
)


function ENT:Draw()
	self:DrawModel()

	local FixAngles = self:GetAngles()
	local FixRotation = Vector(0, 270, 0)

	FixAngles:RotateAroundAxis(FixAngles:Right(), 	FixRotation.x)
	FixAngles:RotateAroundAxis(FixAngles:Up(),		FixRotation.y)
	FixAngles:RotateAroundAxis(FixAngles:Forward(), FixRotation.z)

 	local TargetPos = self:GetPos() + (self:GetUp() * 9)
	
	local m,s = self:FormatTime(self.C4CountDown)
	self.Text = string.format("%02d", m)..":"..string.format("%02d", s)
	
	cam.Start3D2D(TargetPos, FixAngles, 0.15)
		surface.SetFont("DefaultC4")
		draw.SimpleText(self.Text, "DefaultC4", 31, -22, Color(255, 0, 0, 255), 1, 1)
	cam.End3D2D() 
end


function ENT:FormatTime(seconds)
	local m = seconds % 604800 % 86400 % 3600 / 60
	local s = seconds % 604800 % 86400 % 3600 % 60
	
	return math.floor(m), math.floor(s)
end







