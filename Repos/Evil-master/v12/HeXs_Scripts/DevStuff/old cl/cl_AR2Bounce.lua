
local Enabled	= CreateClientConVar("ar2_enabled", 1, true, false)
local Max		= CreateClientConVar("ar2_max", 8, true, false)
local Done = false
local Good = {
	["weapon_ar2"]		= true,
	["plasma_rifle"]	= true,
}


local function AR2Bounce()
	if not SaitoHUD then return end
	if not Enabled:GetBool() then return end
	
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	
	if ValidEntity(ply) and ValidEntity(wep) then
		if Good[ wep:GetClass() ] then
			RunConsoleCommand("reflect_trace", Max:GetInt() )
			Done = true
		else
			if Done then
				Done = false
				RunConsoleCommand("reflect_trace_clear")
			end
		end
	end
end
hook.Add("Think", "AR2Bounce", AR2Bounce)









