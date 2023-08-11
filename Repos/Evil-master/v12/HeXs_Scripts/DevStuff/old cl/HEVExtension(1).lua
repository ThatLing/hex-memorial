

if HSP_GlobalHEVInstalled then
	hook.Remove("HUDPaint", "HSPHudShow", HSPHudShow)
end


local HEVStuffToTrack = {
	["Frag"]				= "npc_grenade_frag",
	["Missile"]				= "rpg_missile",
	["C-4 Bomb"]			= "ent_mad_c4",
	["Tripmine"]			= "npc_tripmine",
	["SMG Grenade"]			= "grenade_ar2",
	["Crossbow Bolt"]		= "crossbow_bolt",
	["High Energy Pellet"]	= "prop_combine_ball",
}

local Enabled = CreateClientConVar("hev_enabled", 1, true, false)

local YELLOW	= Color(255,220,0,200) --HEV yellow
local RED		= Color(255,0,0,255)
local GREEN		= Color(66,255,96) --HSP green

for k,v in pairs(HEVStuffToTrack) do 
	CreateClientConVar("hev_show_"..v, 1, true, false)
end


local myMinutes = 0
local mySeconds = 0
local myTime = ""
local function Time(secs)
	if not secs then return "0:00" end
	secs = math.floor(secs)
	
	if secs < 0 then
		secs = -secs
	end
	
	if secs > 59 then
		myMinutes = math.floor(secs/60)
		mySeconds = secs-(math.floor(secs/60)*60)
		
		if mySeconds < 10 then
			mySeconds = "0"..mySeconds
		end
		myTime = Format("%s:%s", myMinutes, mySeconds)
	else
		myTime = secs.." Seconds"
	end
	return myTime
end



local ARROW = "6"
local function CHudProjectileIndicator()
	if not Enabled:GetBool() then return end
	
	for k,v in pairs(ents.GetAll()) do
		if ValidEntity(v) then
			for NiceName,egc in pairs(HEVStuffToTrack) do
				if (v:GetClass() == egc and GetConVar("hev_show_"..egc):GetBool() ) then
					
					local text_font	= "Marlett"
					surface.SetFont(text_font)
					
					local pos = v:LocalToWorld(v:OBBCenter()):ToScreen()
					local text_xpos	= pos.x
					local text_ypos	= pos.y - 35 * ( ScrH() / ScrW() )
					
					
					--if (pos.visible) then
						local Width, Height	= surface.GetTextSize(ARROW)
						
						draw.DrawText(ARROW, text_font, text_xpos, text_ypos, YELLOW, TEXT_ALIGN_CENTER)
						text_font		= "HudSelectionText"
						surface.SetFont(text_font)
						
						local DISTANCE	= math.Round(LocalPlayer():GetPos():Distance( v:GetPos() ) / 12).." ft"
						Width, Height	= surface.GetTextSize(DISTANCE)
						text_ypos		= text_ypos - Height
						draw.DrawText(DISTANCE,	text_font, text_xpos, text_ypos, YELLOW, TEXT_ALIGN_CENTER)
						
						
						if (v.C4CountDown) then
							local C4Time	= 0
							local C4Color	= RED
							
							if (v.C4CountDown >= 15) then
								C4Color = GREEN
								C4Time = Time(v.C4CountDown)
							elseif (v.C4CountDown != 0 and v.C4CountDown < 15) then
								C4Color = RED
								C4Time = v.C4CountDown.." Seconds"
							else
								C4Color = RED
								C4Time = "You're fucked!"
							end
							
							Width, Height	= surface.GetTextSize(C4Time)
							text_ypos		= text_ypos - Height
							draw.DrawText(C4Time, text_font, text_xpos, text_ypos, C4Color, TEXT_ALIGN_CENTER)	
						end
						
						Width, Height	= surface.GetTextSize(NiceName)
						text_ypos		= text_ypos - Height
						draw.DrawText(NiceName, text_font, text_xpos, text_ypos, color_white, TEXT_ALIGN_CENTER)
					--end
				end
			end
		end
	end
end
hook.Add("HUDPaint", "CHudProjectileIndicator", CHudProjectileIndicator)


