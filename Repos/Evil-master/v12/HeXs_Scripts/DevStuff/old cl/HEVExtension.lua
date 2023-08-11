
local HEVEnabled = CreateClientConVar("hev_drawhud", 1, true, false)

local Panel		= {}
Panel.FgColor	= Color(255, 220, 0, 200) --HEV yellow
Panel.BgColor	= Color(0, 0, 0, 76)
Panel.C4Red		= Color(255, 0, 0, 255)
Panel.C4Green	= Color(66, 255, 96) --HSP green

local HEVStuffToTrack = {
	["Grenade"] = "npc_grenade_frag",
	["Rocket"] = "rpg_missile",
	["C4 Bomb"] = "ent_mad_c4",
	["Tripmine"] = "npc_tripmine",
	["Gravestone"] = "gravestone",
	["Crossbow Bolt"] = "crossbow_bolt",
	["High Energy Pellet"] = "prop_combine_ball",
}

local function CHudProjectileIndicator()
	local ply = LocalPlayer()
	if not HEVEnabled:GetBool() then return end
	
	local text_font			= "Marlett"
	surface.SetFont(text_font)
	
	for k,v in pairs(ents.GetAll()) do
		if (v and v:IsValid()) then
			for NiceName,entclass in pairs(HEVStuffToTrack) do
				local EGC = v:GetClass():lower()
				if (EGC == entclass) then
					local EntName = NiceName --:upper()
					--[[
					local pos = v:LocalToWorld( v:OBBCenter() ):ToScreen()
					local text_xpos	= pos.x
					local text_ypos	= pos.y - 32 * ( ScrH() / 480.0 )
					]]
					
					local vheadpos, vheadang = v:GetPos()
					local vscreenpos = vheadpos:ToScreen()
					local text_xpos	= vscreenpos.x
					local text_ypos	= vscreenpos.y
					
					
					if (pos.visible) then
						local ARROW = "6"
						local Width, Height	= surface.GetTextSize(ARROW)
						
						draw.DrawText(ARROW, text_font, text_xpos, text_ypos, Panel.FgColor, TEXT_ALIGN_CENTER)
						text_font		= "HudSelectionText"
						surface.SetFont(text_font)
						
						local DISTANCE	= math.Round(ply:GetPos():Distance( v:GetPos() ) / 12).." ft"
						Width, Height	= surface.GetTextSize(DISTANCE)
						text_ypos		= text_ypos - Height
						draw.DrawText(DISTANCE,	text_font, text_xpos, text_ypos, Panel.FgColor, TEXT_ALIGN_CENTER)
						
						
						if EGC == HEVStuffToTrack["C4 Bomb"] and (v.C4CountDown) then
							local C4Time
							local C4Color
							
							if (v.C4CountDown >= 15) then
								C4Color = Panel.C4Green
								C4Time = v.C4CountDown.." Seconds"
							elseif (v.C4CountDown < 15) then
								C4Color = Panel.C4Red
								C4Time = v.C4CountDown.." Seconds"
							else
								C4Color = Panel.C4Red
								C4Time = "You're fucked!"
							end
							
							Width, Height	= surface.GetTextSize(C4Time)
							text_ypos		= text_ypos - Height
							draw.DrawText(C4Time, text_font, text_xpos, text_ypos, C4Color, TEXT_ALIGN_CENTER)	
						end
						
						Width, Height	= surface.GetTextSize(EntName)
						text_ypos		= text_ypos - Height
						draw.DrawText(EntName, text_font, text_xpos, text_ypos, color_white, TEXT_ALIGN_CENTER)
					end
				end
			end
		end
	end
end
hook.Add("HUDPaint", "CHudProjectileIndicator", CHudProjectileIndicator)


