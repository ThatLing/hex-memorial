
----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------

local cl_drawcameras = CreateConVar("cl_drawcameras", "1")

include('shared.lua')

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.ShouldDrawInfo 	= false
	self.KeyTextures 		= {}

end


/*---------------------------------------------------------
   Name: Draw
---------------------------------------------------------*/
function ENT:Draw()

	if ( cl_drawcameras:GetBool() == 0 ) then return end

	// Don't draw the camera if we're taking pics
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if ( wep:IsValid() ) then 
		local weapon_name = wep:GetClass()
		if ( weapon_name == "gmod_camera") then return end
	end

	self:DrawModel()
	
	if ( !self.ShouldDrawInfo || !self.Texture ) then return end
	
	render.SetMaterial( self.Texture )
	render.DrawSprite( self:GetPos() + Vector( 0, 0, 32), 16, 16, color_white )

end


/*---------------------------------------------------------
   Name: Think
   Desc: Client Think - called every frame
---------------------------------------------------------*/
function ENT:Think()

	self:TrackEntity( self.dt.entTrack, self.dt.vecTrack )
	
	if ( cl_drawcameras:GetBool() == 0 ) then return end

	// Are we the owner of this camera?
	// If we are then draw the overhead text info
	if ( self.dt.Player == LocalPlayer() ) then
	
		self.ShouldDrawInfo = true
		local iKey = self:GetKey()
		
		if ( self.KeyTextures[ iKey ] == nil ) then
			self.KeyTextures[ iKey ] = Material("sprites/key_"..iKey )
		end
		
		self.Texture = self.KeyTextures[ iKey ]
		
	else
	
		self.ShouldDrawInfo = false
	
	end
	
end


----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------

local cl_drawcameras = CreateConVar("cl_drawcameras", "1")

include('shared.lua')

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.ShouldDrawInfo 	= false
	self.KeyTextures 		= {}

end


/*---------------------------------------------------------
   Name: Draw
---------------------------------------------------------*/
function ENT:Draw()

	if ( cl_drawcameras:GetBool() == 0 ) then return end

	// Don't draw the camera if we're taking pics
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if ( wep:IsValid() ) then 
		local weapon_name = wep:GetClass()
		if ( weapon_name == "gmod_camera") then return end
	end

	self:DrawModel()
	
	if ( !self.ShouldDrawInfo || !self.Texture ) then return end
	
	render.SetMaterial( self.Texture )
	render.DrawSprite( self:GetPos() + Vector( 0, 0, 32), 16, 16, color_white )

end


/*---------------------------------------------------------
   Name: Think
   Desc: Client Think - called every frame
---------------------------------------------------------*/
function ENT:Think()

	self:TrackEntity( self.dt.entTrack, self.dt.vecTrack )
	
	if ( cl_drawcameras:GetBool() == 0 ) then return end

	// Are we the owner of this camera?
	// If we are then draw the overhead text info
	if ( self.dt.Player == LocalPlayer() ) then
	
		self.ShouldDrawInfo = true
		local iKey = self:GetKey()
		
		if ( self.KeyTextures[ iKey ] == nil ) then
			self.KeyTextures[ iKey ] = Material("sprites/key_"..iKey )
		end
		
		self.Texture = self.KeyTextures[ iKey ]
		
	else
	
		self.ShouldDrawInfo = false
	
	end
	
end

