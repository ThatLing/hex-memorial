

local MatRotate = Material("VGUI/loading-rotate")
local MatLogo = Material("VGUI/loading-logo")

PANEL.Base = "Panel"


function PANEL:Init()
end

function PANEL:Paint()
	local size = self:GetTall()
	local sqrdiag = size * math.sqrt(2) * 0.5
	
	surface.DrawTexturedRectRotated(size/2, size/2, sqrdiag, sqrdiag, 0)
	
	surface.SetMaterial(MatLogo)
	surface.SetDrawColor(255, 255, 255, 255)
	
	surface.DrawTexturedRectRotated(size/2, size/2, sqrdiag, sqrdiag, 0)
	
	surface.SetMaterial(MatRotate)
	surface.DrawTexturedRectRotated(size/2, size/2, sqrdiag, sqrdiag, SysTime() * 180)
end
