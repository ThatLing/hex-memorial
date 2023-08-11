local NewCube = ClientsideModel( 'models/props/smallcubetrt.mdl', RENDERGROUP_BOTH )
local NoGC = { NewCube }

NewCube:SetNoDraw( true )
NewCube:DrawShadow( false )

-- Using a single ClientsideModel as it's far faster to draw it multiple times than creating one for every entity.
-- There's a few quirks to this, but they're not as important as the speed difference.

local KeepTexture	= CreateClientConVar( 'ErrorCleanse_KeepTexture', 0, true, false )
local KeepColor		= CreateClientConVar( 'ErrorCleanse_KeepColor', 1, true, false )

local function DrawError( self )

	if !KeepTexture:GetBool() then SetMaterialOverride( 0 ) end
	if !KeepColor:GetBool() then render.SetBlend( 1 ); render.SetColorModulation( 1, 1, 1 ) end
	
		NewCube:SetRenderOrigin( self:LocalToWorld( self:OBBCenter() ) )
		NewCube:SetRenderAngles( self:GetAngles() )
		NewCube:SetModelScale( self.ErrorCleanse.OBB )
		
		NewCube:DrawModel()

	NewCube:SetRenderOrigin()
	NewCube:SetRenderAngles()
	
end

local function ValidError( Ent ) -- Oxymoron!

	if !ValidEntity( Ent ) then return end
	if !Ent:GetTable() then return end
	if Ent:GetModel() != 'models/error.mdl' then return end
	if Ent:GetPhysicsObjectCount() > 1 then return end -- This doesn't work well with ragdolls. :x
	if Ent:BoundingRadius() == 0 then Ent:SetNoDraw( true ) return end
	-- There's nothing we can do if we can't get its bounds. Simply disable it from drawing altogether as it's probably unimportant.
	
	return true
	
end

local function ApplyRenderOverride( Ent )

	Ent.RenderOverride = DrawError
	Ent.Draw = DrawError

end

local function Spawned( Ent )

	if !ValidError( Ent ) then return end

	local Mins = Ent:OBBMins()
	local Maxs = Ent:OBBMaxs()
	
	Ent.ErrorCleanse = {}
	Ent.ErrorCleanse.OBB = (Maxs - Mins)/2
	
	ApplyRenderOverride( Ent )
	
	Ent:DrawShadow( false )
	Ent:SetModelScale( vector_origin )
	Ent:SetRenderBounds( Mins, Maxs )
	
	-- HACK: The propspawn effect sometimes replaces RenderOverride, so run it again!
	timer.Create( 'ErrorCleanse.RO.'..Ent:EntIndex(), 0.5, 10, ApplyRenderOverride, Ent )

end

local function ReInitialize()

	for K, Ent in pairs( ents.GetAll() ) do
	
		Spawned( Ent )
		
	end
	
end

local function ReplaceMissingMat() -- This was an expirement to replace the purple&black material. It seems to also make effects invisible?

	Msg( 'NOTE: This feature is expiremental and causes some texture problems!\n' )

	local NewError = Material( 'turtle/newmissing' )
	local ErrorTex = Material('turtle/random_error_this/is/not/real-')
	
	ErrorTex:SetMaterialTexture( '$basetexture', NewError:GetMaterialTexture( '$basetexture' ) )
	
end

-- Apply everything!

hook.Add( 'OnEntityCreated', 'ErrorCleanse.Spawned', Spawned )
hook.Add( 'InitPostEntity', 'ErrorCleanse.InitPostEntity', InitPostEntity )

timer.Create( 'ErrorCleanse.AddErrors', 0.25, 0, ents.GetAll ) -- This fixes entities sometimes not getting OnEntityCreated spawned for them.
timer.Create( 'ErrorCleanse.ReInitialize', 15, 0, ReInitialize ) -- This shouldn't even be required -- but I feel I should include it incase something is missed first time.

concommand.Add( 'ErrorCleanse_ReInit', ReInitialize )
concommand.Add( 'ErrorCleanse_ReplaceMissingMat', ReplaceMissingMat )