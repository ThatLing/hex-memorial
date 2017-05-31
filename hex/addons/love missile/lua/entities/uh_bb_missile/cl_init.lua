
----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------


include("shared.lua")

language.Add("uh_bb_missile", "Love Missile")


function ENT:Initialize()
end

function ENT:Draw()		
	self:DrawModel()
end

function ENT:Think()
end

function ENT:OnRemove()
end


local Text = "HOT LOVE INCOMMING" --"MISSILE LOCK"
surface.CreateFont("UH_BB_MISSILE", {
	font		= "Trebuchet MS",
	size 		= 50,
	weight		= 900,
	antialias	= true,
	additive	= false,
	}
)

hook.Add("HUDPaint", "UH_BB_MISSILE", function()
	if not LocalPlayer():GetNWBool("MissileLock") then return end
	
	surface.SetFont("UH_BB_MISSILE")
	surface.SetTextColor(255,0,0,255)
	
	
	local Size = surface.GetTextSize(Text)
	
	surface.SetTextPos( (ScrW() / 2) - 0.5*Size, ScrH() / 2.5)
	surface.DrawText(Text)
end)






----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------


include("shared.lua")

language.Add("uh_bb_missile", "Love Missile")


function ENT:Initialize()
end

function ENT:Draw()		
	self:DrawModel()
end

function ENT:Think()
end

function ENT:OnRemove()
end


local Text = "HOT LOVE INCOMMING" --"MISSILE LOCK"
surface.CreateFont("UH_BB_MISSILE", {
	font		= "Trebuchet MS",
	size 		= 50,
	weight		= 900,
	antialias	= true,
	additive	= false,
	}
)

hook.Add("HUDPaint", "UH_BB_MISSILE", function()
	if not LocalPlayer():GetNWBool("MissileLock") then return end
	
	surface.SetFont("UH_BB_MISSILE")
	surface.SetTextColor(255,0,0,255)
	
	
	local Size = surface.GetTextSize(Text)
	
	surface.SetTextPos( (ScrW() / 2) - 0.5*Size, ScrH() / 2.5)
	surface.DrawText(Text)
end)





