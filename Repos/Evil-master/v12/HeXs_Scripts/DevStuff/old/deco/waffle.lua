local function bcmove(cmd)	
	if state && angles!=Angle(0,0,0) then
		local MouseFixUp = AimSmooth:GetFloat() != 0 and Angle(cmd:GetMouseY() * GetConVarNumber("m_pitch"), cmd:GetMouseX() * -GetConVarNumber("m_yaw")) or Angle(0,0,0)
		angles = angles + MouseFixUp
		angles.r=0
		ucorrected = angles
		ucorrected.p = math.NormalizeAngle(ucorrected.p)
		ucorrected.y = math.NormalizeAngle(ucorrected.y)
		
		if NoSpreadHere and (cmd:GetButtons() & IN_ATTACK > 0) then
			local AntiSpread = PredictSpread(cmd,angles)
			AntiSpread.p = math.NormalizeAngle(AntiSpread.p)
			AntiSpread.y = math.NormalizeAngle(AntiSpread.y)
			
			SetViewAngles(cmd,AntiSpread)
		else
			SetViewAngles(cmd,angles)
		end
		
	else
	
		local correct = 1
		if iZoom != 0 then
			correct = ( 1 - ( iZoom / 100 ) )
		end
		
		if !(IsValid(LocalPlayer():GetActiveWeapon()) && LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" && (cmd:GetButtons() & IN_USE) > 0) then
			ucorrected.y = math.NormalizeAngle(ucorrected.y + (cmd:GetMouseX() * -0.022 * correct))
			ucorrected.p = math.Clamp(ucorrected.p + (cmd:GetMouseY() * 0.022 * correct), -89, 90)
		end
		

		if ghostpos == nil then
			if (cmd:GetButtons() & IN_ATTACK > 0) and not IsValid(LocalPlayer():GetVehicle()) then
				if NoSpreadHere and HeXNoSpread:GetBool() then
					local ang = PredictSpread(cmd, ucorrected)
					ang.p = math.NormalizeAngle(ang.p)
					ang.y = math.NormalizeAngle(ang.y)
					
					SetViewAngles(cmd, ang)
				else
					SetViewAngles(cmd, ucorrected)
				end
			else
				SetViewAngles(cmd, ucorrected)
			end
		end

	end
	
end



local function bcalcview( ply, origin, angl, fov )
	if IsValid(ply:GetVehicle()) then return end

	--[[if clientsidenoclip:GetBool() && ghostpos != nil then
		local view = {}
		view.origin = ghostpos
		return view
	end]]

	ghostpos = origin

	iZoom = math.Clamp( iZoom + ( iZoomAdd * 140 * FrameTime() ), 0, 80 )

	if state && angles!=Angle(0,0,0) then
		local view={}
		if iZoom > 0 then
			view.fov = 90 - iZoom
		end
		
		angles.r=0
		view.angles= angles
		return view
	end

	local view={}
	if iZoom > 0 then
		view.fov = 90 - iZoom
	end

	view.angles=ucorrected
	return view
end
