ELEMENT.Name = "Linebow Crosshair (BETA)"
ELEMENT.DefaultOff = true
ELEMENT.DefaultGridPosX = 8
ELEMENT.DefaultGridPosY = 6
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.STORmaxammo = {}
ELEMENT.tvars = {}

ELEMENT.traceLineData = {}
ELEMENT.traceLineRes = {}

ELEMENT.crosshair = surface.GetTextureID("depthhud/linebow_crosshair.vmt")
ELEMENT.crosshairDot = surface.GetTextureID("depthhud/X_CircleSolid.vmt")
ELEMENT.cBaseSize = 52
ELEMENT.minRate = 1.3
ELEMENT.maxRate = 1.0
ELEMENT.dotFrac = 0.07

function ELEMENT:Initialize( )
	self:CreateSmoother("chsize", self.cBaseSize, 0.1)
	self:CreateSmoother("chx", 0.5*ScrW(), 0.5)
	self:CreateSmoother("chy", 0.5*ScrH(), 0.5)
end

function ELEMENT:DrawFunction( )
	if LocalPlayer():InVehicle() then return false end
	local ephem_linebow, ephem_dot = self:GetMyGridPos()
	if (ephem_linebow <= 0) and (ephem_dot <= 0) then return false end

	self.traceLineData = util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetAimVector() )
	self.traceLineRes = util.TraceLine( self.traceLineData )
	
	local scrpos = self.traceLineRes.HitPos:ToScreen()
	self:ChangeSmootherTarget("chx", scrpos.x)
	self:ChangeSmootherTarget("chy", scrpos.y)
	local scrpos_smoothx = self:GetSmootherCurrent("chx")
	local scrpos_smoothy = self:GetSmootherCurrent("chy")
	
	local styleColor = dhinline_GetStyleData("color_base")
	
	local distdet = 1 - self.traceLineRes.Fraction
	local size_real = (self.cBaseSize * self.maxRate * distdet) + (self.cBaseSize * self.minRate * (1-distdet))
	self:ChangeSmootherTarget("chsize", size_real)
	
	
	local size_smooth = math.floor(self:GetSmootherCurrent("chsize"))
	
	
	
	surface.SetDrawColor(styleColor.r, styleColor.g, styleColor.b, styleColor.a)
	if (ephem_linebow > 0) then
		ephem_linebow = ephem_linebow / dhinline_GetGridDivideMax() * 2.0
		surface.SetTexture(self.crosshair)
		surface.DrawTexturedRectRotated(ScrW()*0.5, ScrH()*0.5, size_smooth*ephem_linebow, size_smooth*ephem_linebow, 0)
	end
	if (ephem_dot > 0) then
		ephem_dot     = ephem_dot     / dhinline_GetGridDivideMax() * 2.0
		surface.SetTexture(self.crosshairDot)
		surface.DrawTexturedRectRotated(scrpos_smoothx, scrpos_smoothy, self.cBaseSize*self.dotFrac*ephem_dot, self.cBaseSize*self.dotFrac*ephem_dot, 0)
	end
	
	return true
end
