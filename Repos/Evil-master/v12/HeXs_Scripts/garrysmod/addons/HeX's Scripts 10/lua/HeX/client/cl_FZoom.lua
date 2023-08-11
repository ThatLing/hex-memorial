

local FalcoZoom = false
local ZoomHowMuch = 1
local ZoomStep = 5
local Extrazoom = 0
local OldSensitivity = "8" --GetConVarString("sensitivity")

local function SetZoom(amt)
	LocalPlayer():ConCommand("sensitivity "..amt)
end


local function ZoomCalc(ply,origin,angles,fov)
	if FalcoZoom then
		local view = {} 
		view.origin = ply:GetShootPos() - LocalPlayer():GetAimVector():Angle():Forward() * - Extrazoom
		view.angles = LocalPlayer():EyeAngles() 
		view.fov = ZoomHowMuch
		
		return view
	end
end
hook.Add("CalcView", "ZoomCalc", ZoomCalc) 


local function ChangeSensitivity()
	if Extrazoom > 99 and Extrazoom < 1000 then
		SetZoom( tostring(1 -(((90 - ZoomHowMuch) + (Extrazoom/1000)) / 100)) )
	elseif Extrazoom > 999 and Extrazoom < 10000 then
		SetZoom( tostring( 1 -(((90 - ZoomHowMuch) + (Extrazoom/10000)) / 100)) )
	elseif Extrazoom > 9999 then 
		SetZoom("0.01")
	elseif Extrazoom < 99 then 
		SetZoom( tostring(1 -(((90 - ZoomHowMuch) + (Extrazoom/100)) / 100)) )
	end
end


local function FZoomToggle(ply,cmd,args)
	if cmd == "+fzoom" then
		if Extrazoom > 0 then
			ChangeSensitivity()
			surface.PlaySound("npc/sniper/reload1.wav")
		else
			surface.PlaySound("weapons/sniper/sniper_zoomin.wav")
			ChangeSensitivity()
		end
	else
		SetZoom(OldSensitivity)
	end
	FalcoZoom = not FalcoZoom
end
concommand.Add("+fzoom", FZoomToggle)
concommand.Add("-fzoom", FZoomToggle)


local function ChangeZoom(ply,bnd,pressed)
	if FalcoZoom and pressed then
		if string.find(bnd, "invprev") and pressed then 
			if ZoomHowMuch > 1 then
				ZoomHowMuch = ZoomHowMuch - ZoomStep
				ChangeSensitivity()
				surface.PlaySound("weapons/sniper/sniper_zoomin.wav")
			else
				Extrazoom = Extrazoom + ZoomStep*200
				ChangeSensitivity()
				surface.PlaySound("npc/sniper/reload1.wav")
			end
			return true
			
		elseif string.find(bnd, "invnext") and pressed then
			if ZoomHowMuch < 90 and Extrazoom > 0  then
				Extrazoom = Extrazoom - ZoomStep*200
				ChangeSensitivity()
				surface.PlaySound("npc/scanner/cbot_servoscared.wav")
			elseif ZoomHowMuch < 90 and Extrazoom == 0 then
				ZoomHowMuch = ZoomHowMuch + ZoomStep
				ChangeSensitivity()
				surface.PlaySound("weapons/sniper/sniper_zoomout.wav")
			end
			return true
			
		elseif string.find(bnd, "reload") and pressed then
			ZoomHowMuch = 11
			Extrazoom = 0
			ChangeSensitivity()
			surface.PlaySound("npc/sniper/reload1.wav")
			return true
			
		end
	end
end
hook.Add("PlayerBindPress", "ChangeZoom", ChangeZoom)



