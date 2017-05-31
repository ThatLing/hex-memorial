
----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------

include('shared.lua')

ENT.Mat = Material("sprites/light_glow02_add")


killicon.AddFont("plasma_grenade_grenade", "HL2MPTypeDeath", "4", Color( 0,200,255, 255 ) )

language.Add("plasma_grenade_grenade", "Plasma Grenade")


function ENT:Draw()
	self:DrawModel()
	--self:SetModelScale( Vector(0.50, 0.50, 0.50))
	self:SetModelScale(0.50, 0)
	
	render.SetMaterial(self.Mat)
	render.DrawSprite(self:GetPos(), 72+(16*math.sin(CurTime()*5)), 72+(16*math.sin(CurTime()*5)), Color(50,150,255,255))
	render.DrawSprite(self:GetPos(), 64+(16*math.sin(CurTime()*5)), 64+(16*math.sin(CurTime()*5)), Color(50,255,255,255))
end



----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------

include('shared.lua')

ENT.Mat = Material("sprites/light_glow02_add")


killicon.AddFont("plasma_grenade_grenade", "HL2MPTypeDeath", "4", Color( 0,200,255, 255 ) )

language.Add("plasma_grenade_grenade", "Plasma Grenade")


function ENT:Draw()
	self:DrawModel()
	--self:SetModelScale( Vector(0.50, 0.50, 0.50))
	self:SetModelScale(0.50, 0)
	
	render.SetMaterial(self.Mat)
	render.DrawSprite(self:GetPos(), 72+(16*math.sin(CurTime()*5)), 72+(16*math.sin(CurTime()*5)), Color(50,150,255,255))
	render.DrawSprite(self:GetPos(), 64+(16*math.sin(CurTime()*5)), 64+(16*math.sin(CurTime()*5)), Color(50,255,255,255))
end


