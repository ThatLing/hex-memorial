-- Lens Flare Post-Processing Effect
-- version 1.0
-- by mahalis <mahalis@gmail.com>
--
-- Feel free to learn from and reuse this code; if you release something that uses it,
-- please credit me as the original author.

local pp_lensflare = CreateClientConVar("pp_lensflare", "1", false, false)
local pp_lensflare_intensity = CreateClientConVar("pp_lensflare_intensity","1.0",false,false)

local glow = surface.GetTextureID("effects/lensflare/smoothring")
local ring = surface.GetTextureID("effects/lensflare/ring")
local circle = surface.GetTextureID("effects/lensflare/circle")

local function mulW(x,f)
	return (x - ScrW()/2) * f + ScrW()/2
end

local function mulH(y,f)
	return (y - ScrH()/2) * f + ScrH()/2
end

local function CenteredSprite(x,y,sz)
	surface.DrawTexturedRect(x - sz/2,y - sz/2,sz,sz)
end

local function DrawFlare()
	if !pp_lensflare:GetBool() then return end
	
	local sun = util.GetSunInfo()
	
	if !sun or sun.obstruction == 0 then return end
	
	local sunpos = (EyePos() + sun.direction * 4096):ToScreen()
	
	local dot = (sun.direction:Dot(EyeVector()) - 0.8) * 5
	
	local rSz = ScrW() * 0.15
	
	local aMul = math.Clamp((sun.direction:Dot(EyeVector()) - 0.4) * (1 - math.pow(1 - sun.obstruction,2)),0,1) * pp_lensflare_intensity:GetFloat()
	
	if aMul == 0 then return end
	
	surface.SetTexture(ring)
	surface.SetDrawColor(255,60,140,110 * aMul)
	CenteredSprite(sunpos.x,sunpos.y,rSz)
	
	surface.SetDrawColor(255,240,220,120 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-1),mulH(sunpos.y,-1),rSz*1.5)
	
	surface.SetTexture(glow)
	
	surface.SetDrawColor(80,90,220,140 * (1 - math.pow(1 - aMul,2)))
	CenteredSprite(mulW(sunpos.x,0.55),mulH(sunpos.y,0.55),rSz*0.5)
	
	surface.SetDrawColor(150,200,5,110 * aMul)
	CenteredSprite(mulW(sunpos.x,-0.7),mulH(sunpos.y,-0.7),rSz * 0.7)
	
	surface.SetDrawColor(150,90,40,140 * math.pow(aMul,2))
	CenteredSprite(mulW(sunpos.x,1.3),mulH(sunpos.y,1.3),rSz*2)
	
	surface.SetTexture(circle)
	surface.SetDrawColor(60,90,190,80 * aMul)
	CenteredSprite(mulW(sunpos.x,0.65),mulH(sunpos.y,0.65),rSz*0.8)
	
	surface.SetDrawColor(100,150,160,120 * aMul)
	CenteredSprite(mulW(sunpos.x,-1.2),mulH(sunpos.y,-1.2),rSz*0.4)
	
end

hook.Add("RenderScreenspaceEffects","LensFlare",DrawFlare)

local function BuildControlPanel( CPanel )
	CPanel:AddControl( "Header", { Text = "#Lens Flare", Description = "#Cinematic lens-flare effect" }  )
	CPanel:AddControl( "Slider", { Label = "#Intensity", Command = "pp_lensflare_intensity", Type = "Float", Min = "0", Max = "2" }  )
end

local function AddPostProcessMenu()
	spawnmenu.AddToolMenuOption( "PostProcessing", "PPSimple", "LensFlare", "#Lens Flare", "", "", BuildControlPanel, { SwitchConVar = "pp_lensflare" } )
end

hook.Add( "PopulateToolMenu", "AddPostProcessMenu_LensFlare", AddPostProcessMenu )