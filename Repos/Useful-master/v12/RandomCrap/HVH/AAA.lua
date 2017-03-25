


local NoAA = CreateConVar("no_aa", 1, true, false)

local function NoAntiAim()
	for k,v in pairs( player.GetAll() ) do
		if ValidEntity(v) and v:Alive() and not v.AA_DoneKick then
			local ang = v:EyeAngles().p
			
			if (ang < -91) or (ang > 91) then
				if NoAA:GetBool() then
					v.AA_DoneKick = true --No more tries
					v:Kick("Invalid EyeAngles(), ("..tostring(math.Round(ang)).."' of max 90)")
				end
			end
		end
	end
end
hook.Add("Think", "NoAntiAim", NoAntiAim)


