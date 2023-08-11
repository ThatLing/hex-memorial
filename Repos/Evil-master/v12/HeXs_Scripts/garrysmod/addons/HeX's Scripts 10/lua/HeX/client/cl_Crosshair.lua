

surface.CreateFont("HL2Cross", 44, 430, true, false, "hl2c_crosshair")

local function HL2Crosshair()
	local Width,Hight = ScrW(), ScrH()
	draw.SimpleText("(", "hl2c_crosshair", Width / 2 - 15, Hight / 2, YELLOW, 2, 1)
	draw.SimpleText(")", "hl2c_crosshair", Width / 2 + 15, Hight / 2, YELLOW, 0, 1)
end
hook.Add("HUDPaint", "HL2Crosshair", HL2Crosshair)




local Enabled	 	= CreateClientConVar("xs_crosshair", 1, true, false)

local TriEnabled	= CreateClientConVar("xs_tri_enabled", 1, true, false)
local start			= CreateClientConVar("xs_tri_start", 6, true, true)
local size			= CreateClientConVar("xs_tri_size", 8, true, true)
local rps			= CreateClientConVar("xs_tri_rps", 0, true, true)
local segments		= CreateClientConVar("xs_tri_segments", 3, true, true)


local col = RED2

local x = ScrW() / 2
local y = ScrH() / 2
local gap = -20
local length = gap + 5

hook.Add("HUDPaint","XS_CrossHair", function()
	if TriEnabled:GetBool() then
		local start		= start:GetInt()
		local size		= size:GetInt()
		local rps		= rps:GetInt()
		local segments	= segments:GetInt()
		
		local time			= -RealTime() * (math.pi * 2) * rps
		local segmentsize	= (math.pi * 2) / segments
		
		surface.SetDrawColor(LtGreen)
		
		for i = 0, segments - 1 do
			local timeoffset = segmentsize * i
			
			local sin = math.sin(time + timeoffset)
			local cos = math.cos(time + timeoffset)
			
			local startx	= sin * start
			local endx		= sin * (start + size)
			local starty	= cos * start
			local endy		= cos * (start + size)
			
			surface.DrawLine(x + startx, y + starty, x + endx, y + endy)
		end
		
		surface.DrawRect(x,y, 1, 1)
	end
	
	if Enabled:GetBool() then
		local ent = LocalPlayer():GetEyeTrace().Entity
		
		if ent:IsValid() then
			if ent:IsPlayer() then
				col = YELLOW
				length = gap + 5
			else
				col = GREEN2
				length = gap + 5
			end
		else
			return
		end
		
		surface.SetDrawColor(col)
		surface.DrawLine( x - length, y, x + gap, y )
		surface.DrawLine( x + length, y, x - gap, y )
		surface.DrawLine( x, y - length, x, y + gap )
		surface.DrawLine( x, y + length, x, y - gap )
	end
end)



