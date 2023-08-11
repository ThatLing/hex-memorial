

local Enabled = CreateClientConVar("hev_enabled", 1, true, false)

local ToTrack = {
	["ent_mad_c4"]			= {Name = "C4 Bomb", Owner = true, 								Always = true},
	["nuke_missile"]		= {Name = "Atomic bomb", Owner = true,							Always = true,		Color = RED},
	["uh_bb_missile"]		= {Name = "Heat-seeking missile",								Always = true, 		Color = ORANGE},
	["rpg_missile"]			= {Name = "Missile", 											Always = true},
	["npc_grenade_frag"]	= {Name = "Frag", 												Always = true},
	["grenade_ar2"]			= {Name = "SMG Grenade", 										Always = true},
	["npc_tripmine"]		= {Name = "Tripmine", Owner = true, NoFeet = true, NoMe = true,	Always = true},
	["crossbow_bolt"]		= {Name = "Crossbow Bolt", 										Always = true},
	["prop_combine_ball"]	= {Name = "High Energy Pellet", 								Always = true},
	["weapon_nuke"]			= {Name = "Nuke launcher",															Color = RED},
	
	["weapon_rpg"]			= {Name = "RPG",					NoFeet = true,									Color = GREEN2},
	["weapon_slam"]			= {Name = "SLAM",					NoFeet = true, 									Color = RED2},
}

for k,v in pairs(ToTrack) do
	CreateClientConVar("hev_show_"..k, 1, true, false)
end



local function Time(raw)
	if not raw then return "0:00" end
	
	local Time	= ""
	local Min = 0
	local Sec = 0
	raw = math.floor(raw)
	
	if raw < 0 then
		raw = -raw
	end
	
	if raw > 59 then
		Min = math.floor(raw/60)
		Sec = raw - ( math.floor(raw/60)*60 )
		
		if Sec < 10 then
			Sec = "0"..Sec
		end
		Time = Format("%s:%s", Min, Sec)
	else
		Time = raw.." Seconds"
	end
	
	return Time
end


local SetNick = false
local function GetOwnerNick(ent,NoMe)
	if not SetNick then
		SetNick = LocalPlayer():Nick() --Less lag calling all the time
	end
	
	local Nick	= "N/A"
	local Col	= YELLOW2
	local Owner = ent:GetNetworkedEntity("OwnerObj", false)
	
	if (ValidEntity(Owner) and Owner:IsPlayer()) then
		Nick = Owner:Nick()
		Col	 = Owner:TeamColor()
	else
		Owner = ent:GetNetworkedString("Owner", "N/A")
		
		if type(Owner) == "string" then
			Nick = Owner
			
		elseif (ValidEntity(Owner) and Owner:IsPlayer()) then
			Nick = Owner:Nick()
			Col	 = Owner:TeamColor()
		end
	end
	
	if (Nick == "N/A" or Nick == "World") then
		return false, Col
		
	elseif (Nick == SetNick and NoMe) then --No!
		return false, YELLOW2
	end
	
	return Nick, Col
end


local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
function HeX.ShowHEV()
	if not Enabled:GetBool() then return end
	
	for k,v in pairs( ents.GetAll() ) do
		if ValidEntity(v) then
			local egc = v:GetClass()
			local Tab = ToTrack[ egc ]
			
			if Tab then
				local CanMove = (v:GetMoveType() != 0)
				if (Tab.Always or false) then
					CanMove = true
				end
				
				if CanMove and GetConVar("hev_show_"..egc):GetBool() then
					local Pos		= v:LocalToWorld( v:OBBCenter() ):ToScreen()
					local Name		= Tab.Name
					local Col		= Tab.Color	or YELLOW2
					local Owner 	= Tab.Owner
					local NoFeet	= Tab.NoFeet
					local NoMe		= Tab.NoMe
					
					local XPos		= Pos.x
					local YPos		= Pos.y - 35 * ( ScrH() / ScrW() )
					local text_font	= "Marlett"
					surface.SetFont(text_font)		
					
					
					local Width,Height	= surface.GetTextSize("6") --Arrow
					draw.DrawText("6", text_font, XPos, YPos, Col, TEXT_ALIGN_CENTER)
					text_font		= "HudSelectionText"
					surface.SetFont(text_font)
					
					if not NoFeet then
						local DISTANCE	= math.Round(LocalPlayer():GetPos():Distance( v:GetPos() ) / 12).." ft"
						Width,Height	= surface.GetTextSize(DISTANCE) --DISTANCE
						YPos			= YPos - Height
						draw.DrawText(DISTANCE,	text_font, XPos, YPos, Col, TEXT_ALIGN_CENTER)
					end
					
					local C4Count = v.C4CountDown
					if (C4Count) then
						local C4Time	= 0
						local C4Color	= RED2
						
						if (C4Count >= 15) then
							C4Color	= GREEN
							C4Time	= Time(C4Count)
							
						elseif (C4Count != 0 and C4Count < 15) then
							C4Color = RED2
							C4Time	= C4Count.." Seconds"
							
						else
							C4Color = RED2
							C4Time	= "You're fucked!"
						end
						
						Width,Height	= surface.GetTextSize(C4Time) --C4
						YPos			= YPos - Height
						draw.DrawText(C4Time, text_font, XPos, YPos, C4Color, TEXT_ALIGN_CENTER)	
					end
					
					if Owner then
						local Own,TeamC = GetOwnerNick(v,NoMe)
						if Own then
							Width,Height	= surface.GetTextSize(Own) --Owner
							YPos			= YPos - Height
							draw.DrawText(Own, text_font, XPos, YPos, TeamC, TEXT_ALIGN_CENTER)	
						end
					end
					
					Width, Height	= surface.GetTextSize(Name) --Name
					YPos			= YPos - Height
					draw.DrawText(Name, text_font, XPos, YPos, color_white, TEXT_ALIGN_CENTER)
				end
			end
		end
	end
end



timer.Simple(1, function()
	if (HSP and HSP.ShowHEV) then
		hook.Remove("HUDPaint", "HSP.ShowHEV", HSP.ShowHEV)
		print("[HeX] Removed HSP.ShowHEV, loading custom")
	end
	
	hook.Add("HUDPaint", "HeX.ShowHEV", HeX.ShowHEV)
end)








