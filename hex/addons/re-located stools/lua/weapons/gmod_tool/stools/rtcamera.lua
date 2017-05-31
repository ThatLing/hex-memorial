
----------------------------------------
--         2014-07-12 20:33:12          --
------------------------------------------

TOOL.Category		= "Render"
TOOL.Name			= "#RT Camera"
TOOL.Command		= nil
TOOL.ConfigName		= nil

TOOL.ClientConVar[ "locked" ] 	= "0"
TOOL.ClientConVar[ "key" ] 		= "0"

cleanup.Register("cameras")

GAMEMODE.RTCameraList = GAMEMODE.RTCameraList or {}

TOOL.LeftClickAutomatic = true
TOOL.RightClickAutomatic = false
TOOL.RequiresTraceHit = false

// Global to hold the render target camera entity
RenderTargetCamera = nil
RenderTargetCameraProp = nil

function TOOL:LeftClick( trace )

	if (CLIENT) then return end
	
	local key		= self:GetClientNumber("key")
	if (key == -1) then return false end
	
	local ply 		= self:GetOwner()
	local locked	= self:GetClientNumber("locked")
	local pid 		= ply:UniqueID()

	GAMEMODE.RTCameraList[ pid ] 	= GAMEMODE.RTCameraList[ pid ] or {}
	local CameraList = GAMEMODE.RTCameraList[ pid ]
	
	local Pos = trace.StartPos// + trace.Normal * 16
	
	// If the camera already exists then just move it into position
	if (CameraList[ key ] && CameraList[ key ] != NULL ) then
	
		local ent = CameraList[ key ]
		
		// Remove all constraints
		constraint.RemoveAll( ent )
	
		ent:SetPos( Pos )
		ent:SetAngles( ply:EyeAngles() )
		
		local phys = ent:GetPhysicsObject()
		if (phys:IsValid()) then phys:Sleep() end
		
		ent:SetLocked( locked )
		ent:SetTracking( NULL,Vector(0))

		if !RenderTargetCamera then UpdateRenderTarget( camera ) end

		return false, ent
		
	end
	
	local camera = ents.Create("gmod_rtcameraprop")
	if (!camera:IsValid()) then return false end
		
		camera:SetAngles( ply:EyeAngles() )
		camera:SetPos( Pos )
		camera:Spawn()
		
		camera:SetKey( key )
		camera:SetPlayer( ply )
		camera:SetLocked( locked )

		numpad.OnDown(	ply,		key, 	"RTCamera_Use", 	camera )
		
		camera:SetTracking( NULL, Vector(0) )
	
	undo.Create("RT Camera")
		undo.AddEntity( camera )
		undo.SetPlayer( ply )
	undo.Finish()
	
	ply:AddCleanup("cameras", camera )

	
	CameraList[ key ] = camera

	if !RenderTargetCamera || #ents.FindByClass("gmod_rtcameraprop") == 1 then UpdateRenderTarget( camera ) end
	
	return false, camera
end


// Global Function to update the render target
function UpdateRenderTarget( Ent )

	if ( !Ent || !Ent:IsValid() ) then return end

	if ( !RenderTargetCamera || !RenderTargetCamera:IsValid() ) then
	
		RenderTargetCamera = ents.Create("point_camera")
		RenderTargetCamera:SetKeyValue("GlobalOverride", 1 )
		RenderTargetCamera:Spawn()
		RenderTargetCamera:Activate()
		RenderTargetCamera:Fire("SetOn", "", 0.0 )

	end
	Pos = Ent:LocalToWorld( Vector( 12,0,0) )
	RenderTargetCamera:SetPos(Pos)
	RenderTargetCamera:SetAngles(Ent:GetAngles())
	RenderTargetCamera:SetParent(Ent)

	RenderTargetCameraProp = Ent
	
end

function TOOL:RightClick( trace )

	_, camera = self:LeftClick( trace )
	
	if (CLIENT) then return false end

	if ( !camera || !camera:IsValid() ) then return end
	
	if ( trace.Entity:IsWorld() ) then
	
		trace.Entity = self:GetOwner()
		trace.HitPos = self:GetOwner():GetPos()
	
	end

	camera:SetTracking( trace.Entity, trace.Entity:WorldToLocal( trace.HitPos ))
	
	return false
	
end


if (CLIENT) then

local rtcamera_draw = CreateClientConVar("rtcamera_draw", "0", false, false )

local RTWindow = nil

local function OpenRTWindow( player, command, arguments )

	LocalPlayer():ConCommand("rtcamera_draw 1")

	if (RTWindow) then
		RTWindow:SetVisible( true )
	return end

	// Close the window when it's clicked on
	local function RTAction( panel, message, param1, param2 )
		if (message == "MouseReleased") then
			RTWindow:SetVisible( false )
		end
	end
	
	// We override the paint function just so it doesn't draw anything
	local function RTPaint( panel )
		return true
	end
	
	RTWindow = vgui.Create("Frame")
	RTWindow:SetName("Render Target")
	RTWindow:SetPos( 25, 25 )
	RTWindow:SetSize( ScrW() * 0.25, ScrH() * 0.25 )
	RTWindow:SetMouseInputEnabled( true )
	RTWindow:SetKeyBoardInputEnabled( false )
	RTWindow:SetVisible( true )
	RTWindow:SetActionFunction( RTAction )
	RTWindow:SetPaintFunction( RTPaint )
	
	

end

concommand.Add("rtcamera_window", OpenRTWindow )


local rtTexture = surface.GetTextureID("pp/rt")
local rtSize = {}

local function DrawRTTexture()

	if ( !rtcamera_draw:GetBool() ) then

		if (RTWindow && RTWindow:IsVisible()) then
			RTWindow:SetVisible( false )
		end
	
	return end

	if (RTWindow) then 
	
		rtSize.set = true
		rtSize.x, rtSize.y = RTWindow:GetPos()
		rtSize.w, rtSize.h = RTWindow:GetSize()
	
	end
	
	if (!rtSize.set) then return end
	
	if (RTWindow && RTWindow:IsVisible()) then 
	
		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )
	
	end

	rtTexture = surface.GetTextureID("pp/rt")
	surface.SetTexture( rtTexture )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( rtSize.x , rtSize.y, rtSize.w, rtSize.h ) 
	
	
	if (RTWindow && RTWindow:IsVisible()) then 
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		
		surface.DrawOutlinedRect( rtSize.x , rtSize.y, rtSize.w, rtSize.h )
		surface.DrawOutlinedRect( rtSize.x , rtSize.y, rtSize.w, 28 )
		
		surface.SetDrawColor( 255, 255, 255, 50 )
		surface.DrawRect( rtSize.x , rtSize.y, rtSize.w, 28 )
		
	end
	
	surface.SetDrawColor( 0, 0, 0, 220 )
	surface.DrawOutlinedRect( rtSize.x-1 , rtSize.y-1, rtSize.w+2, rtSize.h+2 )

end

hook.Add("HUDPaint", "DrawRTTexture", DrawRTTexture )


function TOOL:DrawToolScreen( w, h )

	rtTexture = surface.GetTextureID("pp/rt")
	surface.SetTexture( rtTexture )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 26, w, h - 48 ) 
	
end

end


----------------------------------------
--         2014-07-12 20:33:12          --
------------------------------------------

TOOL.Category		= "Render"
TOOL.Name			= "#RT Camera"
TOOL.Command		= nil
TOOL.ConfigName		= nil

TOOL.ClientConVar[ "locked" ] 	= "0"
TOOL.ClientConVar[ "key" ] 		= "0"

cleanup.Register("cameras")

GAMEMODE.RTCameraList = GAMEMODE.RTCameraList or {}

TOOL.LeftClickAutomatic = true
TOOL.RightClickAutomatic = false
TOOL.RequiresTraceHit = false

// Global to hold the render target camera entity
RenderTargetCamera = nil
RenderTargetCameraProp = nil

function TOOL:LeftClick( trace )

	if (CLIENT) then return end
	
	local key		= self:GetClientNumber("key")
	if (key == -1) then return false end
	
	local ply 		= self:GetOwner()
	local locked	= self:GetClientNumber("locked")
	local pid 		= ply:UniqueID()

	GAMEMODE.RTCameraList[ pid ] 	= GAMEMODE.RTCameraList[ pid ] or {}
	local CameraList = GAMEMODE.RTCameraList[ pid ]
	
	local Pos = trace.StartPos// + trace.Normal * 16
	
	// If the camera already exists then just move it into position
	if (CameraList[ key ] && CameraList[ key ] != NULL ) then
	
		local ent = CameraList[ key ]
		
		// Remove all constraints
		constraint.RemoveAll( ent )
	
		ent:SetPos( Pos )
		ent:SetAngles( ply:EyeAngles() )
		
		local phys = ent:GetPhysicsObject()
		if (phys:IsValid()) then phys:Sleep() end
		
		ent:SetLocked( locked )
		ent:SetTracking( NULL,Vector(0))

		if !RenderTargetCamera then UpdateRenderTarget( camera ) end

		return false, ent
		
	end
	
	local camera = ents.Create("gmod_rtcameraprop")
	if (!camera:IsValid()) then return false end
		
		camera:SetAngles( ply:EyeAngles() )
		camera:SetPos( Pos )
		camera:Spawn()
		
		camera:SetKey( key )
		camera:SetPlayer( ply )
		camera:SetLocked( locked )

		numpad.OnDown(	ply,		key, 	"RTCamera_Use", 	camera )
		
		camera:SetTracking( NULL, Vector(0) )
	
	undo.Create("RT Camera")
		undo.AddEntity( camera )
		undo.SetPlayer( ply )
	undo.Finish()
	
	ply:AddCleanup("cameras", camera )

	
	CameraList[ key ] = camera

	if !RenderTargetCamera || #ents.FindByClass("gmod_rtcameraprop") == 1 then UpdateRenderTarget( camera ) end
	
	return false, camera
end


// Global Function to update the render target
function UpdateRenderTarget( Ent )

	if ( !Ent || !Ent:IsValid() ) then return end

	if ( !RenderTargetCamera || !RenderTargetCamera:IsValid() ) then
	
		RenderTargetCamera = ents.Create("point_camera")
		RenderTargetCamera:SetKeyValue("GlobalOverride", 1 )
		RenderTargetCamera:Spawn()
		RenderTargetCamera:Activate()
		RenderTargetCamera:Fire("SetOn", "", 0.0 )

	end
	Pos = Ent:LocalToWorld( Vector( 12,0,0) )
	RenderTargetCamera:SetPos(Pos)
	RenderTargetCamera:SetAngles(Ent:GetAngles())
	RenderTargetCamera:SetParent(Ent)

	RenderTargetCameraProp = Ent
	
end

function TOOL:RightClick( trace )

	_, camera = self:LeftClick( trace )
	
	if (CLIENT) then return false end

	if ( !camera || !camera:IsValid() ) then return end
	
	if ( trace.Entity:IsWorld() ) then
	
		trace.Entity = self:GetOwner()
		trace.HitPos = self:GetOwner():GetPos()
	
	end

	camera:SetTracking( trace.Entity, trace.Entity:WorldToLocal( trace.HitPos ))
	
	return false
	
end


if (CLIENT) then

local rtcamera_draw = CreateClientConVar("rtcamera_draw", "0", false, false )

local RTWindow = nil

local function OpenRTWindow( player, command, arguments )

	LocalPlayer():ConCommand("rtcamera_draw 1")

	if (RTWindow) then
		RTWindow:SetVisible( true )
	return end

	// Close the window when it's clicked on
	local function RTAction( panel, message, param1, param2 )
		if (message == "MouseReleased") then
			RTWindow:SetVisible( false )
		end
	end
	
	// We override the paint function just so it doesn't draw anything
	local function RTPaint( panel )
		return true
	end
	
	RTWindow = vgui.Create("Frame")
	RTWindow:SetName("Render Target")
	RTWindow:SetPos( 25, 25 )
	RTWindow:SetSize( ScrW() * 0.25, ScrH() * 0.25 )
	RTWindow:SetMouseInputEnabled( true )
	RTWindow:SetKeyBoardInputEnabled( false )
	RTWindow:SetVisible( true )
	RTWindow:SetActionFunction( RTAction )
	RTWindow:SetPaintFunction( RTPaint )
	
	

end

concommand.Add("rtcamera_window", OpenRTWindow )


local rtTexture = surface.GetTextureID("pp/rt")
local rtSize = {}

local function DrawRTTexture()

	if ( !rtcamera_draw:GetBool() ) then

		if (RTWindow && RTWindow:IsVisible()) then
			RTWindow:SetVisible( false )
		end
	
	return end

	if (RTWindow) then 
	
		rtSize.set = true
		rtSize.x, rtSize.y = RTWindow:GetPos()
		rtSize.w, rtSize.h = RTWindow:GetSize()
	
	end
	
	if (!rtSize.set) then return end
	
	if (RTWindow && RTWindow:IsVisible()) then 
	
		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )
	
	end

	rtTexture = surface.GetTextureID("pp/rt")
	surface.SetTexture( rtTexture )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( rtSize.x , rtSize.y, rtSize.w, rtSize.h ) 
	
	
	if (RTWindow && RTWindow:IsVisible()) then 
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		
		surface.DrawOutlinedRect( rtSize.x , rtSize.y, rtSize.w, rtSize.h )
		surface.DrawOutlinedRect( rtSize.x , rtSize.y, rtSize.w, 28 )
		
		surface.SetDrawColor( 255, 255, 255, 50 )
		surface.DrawRect( rtSize.x , rtSize.y, rtSize.w, 28 )
		
	end
	
	surface.SetDrawColor( 0, 0, 0, 220 )
	surface.DrawOutlinedRect( rtSize.x-1 , rtSize.y-1, rtSize.w+2, rtSize.h+2 )

end

hook.Add("HUDPaint", "DrawRTTexture", DrawRTTexture )


function TOOL:DrawToolScreen( w, h )

	rtTexture = surface.GetTextureID("pp/rt")
	surface.SetTexture( rtTexture )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 26, w, h - 48 ) 
	
end

end

