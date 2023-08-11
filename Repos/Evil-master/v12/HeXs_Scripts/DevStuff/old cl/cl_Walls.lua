
local walls = {} --Quicker than changing all the table stuff

local Enabled		= CreateClientConVar("l4d_enabled", 1, true, false)
local DoWeapons		= CreateClientConVar("l4d_weapons", 1, true, false)
local WepMaxDmg		= CreateClientConVar("l4d_wep_dmg", 43, true, false)
local WepHue		= CreateClientConVar("l4d_wep_hue", 160, true, false)
local WepHueEnd		= CreateClientConVar("l4d_wep_hue_end", 30, true, false)
local BlurSize		= CreateClientConVar("l4d_passes", 3, true, false)

local Vehicles = {
	prop_vehicle_jeep			= true,
	prop_vehicle_airboat		= true,
	prop_vehicle_prisoner_pod	= true,
}


local MaterialBlurX = Material("pp/blurx")
local MaterialBlurY = Material("pp/blury")

local MaterialWhite = CreateMaterial( "WhiteMaterial", "VertexLitGeneric", {
		["$basetexture"] = "color/white",
		["$vertexalpha"] = "1",
		["$model"] = "1",
	}
)
local MaterialComposite = CreateMaterial("CompositeMaterial", "UnlitGeneric", {
		["$basetexture"] = "_rt_FullFrameFB",
		["$additive"] = "1",
	}
)
local RT1 = GetRenderTarget("L4D1")
local RT2 = GetRenderTarget("L4D2")



walls.RenderToStencil = function(entity)
	-- tell the stencil buffer we're going to write a value of one wherever the model
	-- is rendered
	render.SetStencilEnable( true )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
	--STENCILOPERATION_INVERT
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilWriteMask( 1 )
	render.SetStencilReferenceValue( 1 )
	 
	-- this uses a small hack to render ignoring depth while not drawing color
	-- i couldn't find a function in the engine to disable writing to the color channels
	-- i did find one for shaders though, but I don't feel like writing a shader for this.
	cam.IgnoreZ(true)
		render.SetBlend(0)
			local weap = nil
			if entity:IsPlayer() then
				weap = entity:GetActiveWeapon()
			end
			
			SetMaterialOverride(MaterialWhite)
				entity:DrawModel()
				
				if ValidEntity(weap) then
					weap:DrawModel()
				end
			SetMaterialOverride()
		--render.SetBlend(1)
		render.SetBlend(1)
	cam.IgnoreZ(false)
	
	--don't need this for the next pass
	render.SetStencilEnable( false )
end




walls.RenderToGlowTexture = function(entity)
	if not Enabled:GetBool() then return end
	
	local w, h = ScrW(), ScrH()
	local fogmode = render.GetFogMode()
	render.FogMode(MATERIAL_FOG_NONE)
	-- draw into the white texture
	local oldRT = render.GetRenderTarget()
	render.SetRenderTarget( RT1 )
		render.SetViewPort( 0, 0, 512, 512 )
		
		cam.IgnoreZ( false )
			render.SuppressEngineLighting( true )
			local weap = nil
			
			if entity:IsPlayer() then
				local col = team.GetColor(entity:Team())
				if entity.StencilColor != nil then
					col = entity.StencilColor
				end
				render.SetColorModulation( col.r/255, col.g/255, col.b/255)
				
				weap = entity:GetActiveWeapon()
			else
				local col = Color(255,255,255)
				if entity.StencilColor != nil then
					col = entity.StencilColor
				end
				render.SetColorModulation( col.r/255, col.g/255, col.b/255)
			end
			
			SetMaterialOverride( MaterialWhite )
				entity:DrawModel(entity)
				if ValidEntity(weap) then
					weap:DrawModel()
				end
			SetMaterialOverride()
			
			render.SetColorModulation( 1, 1, 1 )
			render.SuppressEngineLighting( false )
			
		cam.IgnoreZ( false )
		
		render.SetViewPort( 0, 0, w, h )
	render.SetRenderTarget( oldRT )
	render.FogMode(fogmode)
end

walls.RenderScene = function( Origin, Angles )
	if not Enabled:GetBool() then return end
	
	local oldRT = render.GetRenderTarget()
	render.SetRenderTarget( RT1 )
	render.Clear( 0, 0, 0, 255, true )
	render.SetRenderTarget( oldRT )
end


walls.FakeModel = ClientsideModel("models/props_c17/canister02a.mdl", RENDERGROUP_OPAQUE)
walls.FakeModel:SetPos(Vector(0,0,-1000))


walls.SetupFakeModel = function(ent)
	walls.FakeModel:SetModel("models/props_c17/canister02a.mdl")
	local mdl = ent:GetModel()
	if mdl == nil then return end
	walls.FakeModel:SetModel(mdl)
	
	walls.FakeModel:SetPos( ent:GetPos() )
	walls.FakeModel:SetAngles( ent:GetAngles() )
	
	walls.FakeModel.StencilColor = ent.StencilColor
end

walls.MoveFakeModel = function()
	walls.FakeModel:SetPos( Vector(0,0,-1000) )
	walls.FakeModel.StencilColor = nil
end

--[[
local AllEnts = {}
local function UpdateEnts()
	for k,v in pairs(ents.GetAll()) do
		if ValidEntity(v) and not AllEnts[v] then
			AllEnts[v] = v
		end
	end
	
	for k,v in pairs(AllEnts) do
		if not ValidEntity(v)
			AllEnts[k] = v
		end
	end
end
hook.Add("Think", "UpdateEnts", UpdateEnts)
]]

walls.CanDrawL4D = function(ent)
	if ent:IsNPC() then
		ent.StencilColor = Color(0,0,255)
		return 1
		
	elseif Vehicles[ ent:GetClass() ] then
		ent.StencilColor = Color(0,207,255)
		return 1
		
	elseif ent:IsWeapon() and DoWeapons:GetBool() then
		local col = Color(140,0,255)
		
		if not ValidEntity(ent.Owner) or ent.Owner == nil then
			if ent.Primary then
				local maxdmg	= WepMaxDmg:GetInt()
				local starthue	= WepHue:GetInt()
				local endhue	= WepHueEnd:GetInt()
				
				local dmg = ent.Primary.Damage or 0
				dmg = math.max(0, 1 - (dmg / maxdmg))
				dmg = dmg * (starthue - endhue) + endhue
				
				//print(dmg, ent.Primary.Damage)
				col = HSVToColor(dmg, 1, 1)
			end
			ent.StencilColor = col
			return 2
		end
	end
end


walls.DrawOtherStuff = function()
	if not Enabled:GetBool() then return end
	
	local entslist = ents.GetAll()
	for i=1, #entslist do
		local ent = entslist[i]
		
	--for k,ent in pairs(ents.GetAll()) do
		if ValidEntity(ent) and not ent:IsPlayer() and ent:GetModel() != "" then
			local Draw = walls.CanDrawL4D(ent)
			
			if Draw and Draw > 0 then
				if Draw > 1 then
					walls.SetupFakeModel(ent)
					walls.OUTLINING = true
					
					walls.RenderToStencil( walls.FakeModel )
					walls.RenderToGlowTexture( walls.FakeModel )
					
					walls.OUTLINING = false
					walls.MoveFakeModel()
				else
					walls.OUTLINING = true
					
					walls.RenderToStencil( ent )
					walls.RenderToGlowTexture( ent )
					
					walls.OUTLINING = false
				end
			end
		end
	end
end


walls.RenderScreenspaceEffects = function( )
	if not Enabled:GetBool() then return end
	
	MaterialBlurX:SetMaterialTexture( "$basetexture", RT1 )
	MaterialBlurY:SetMaterialTexture( "$basetexture", RT2 )
	
	local BSize = BlurSize:GetInt() or 2
	
	MaterialBlurX:SetMaterialFloat( "$size", BSize ) // 2
	MaterialBlurY:SetMaterialFloat( "$size", BSize )
	
	local oldRT = render.GetRenderTarget()
	
	-- blur horizontally
	render.SetRenderTarget( RT2 )
	render.SetMaterial( MaterialBlurX )
	render.DrawScreenQuad()
 
	-- blur vertically
	render.SetRenderTarget( RT1 )
	render.SetMaterial( MaterialBlurY )
	render.DrawScreenQuad()
 
	render.SetRenderTarget( oldRT )
	
	-- tell the stencil buffer we're only going to draw
	 -- where the player models are not.
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilTestMask( 1 )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	 
	-- composite the scene
	MaterialComposite:SetMaterialTexture( "$basetexture", RT1 )
	render.SetMaterial( MaterialComposite )
	render.DrawScreenQuad()
 
	 -- don't need this anymore
	render.SetStencilEnable( false )
end


walls.PostPlayerDraw = function( pl )
	if not Enabled:GetBool() then return end
	
	-- prevent recursion
	if( walls.OUTLINING ) then return end
	walls.OUTLINING = true
	walls.RenderToStencil( pl )
	walls.RenderToGlowTexture( pl )
	-- prevents recursion time
	walls.OUTLINING = false
	
	--if( ScrW() == ScrH() ) then return end
	--return false // Prevent gay GMs doing shit to players too (like hats)
end
--PostDrawOpaqueRenderables


hook.Add("RenderScene", "walls.RenderScene", walls.RenderScene)
hook.Add("RenderScreenspaceEffects", "walls.RenderScreenspaceEffects", walls.RenderScreenspaceEffects)
hook.Add("PostPlayerDraw", "walls.PostPlayerDraw", walls.PostPlayerDraw)
hook.Add("PostDrawTranslucentRenderables", "walls.PostDrawTranslucentRenderables", walls.DrawOtherStuff)














