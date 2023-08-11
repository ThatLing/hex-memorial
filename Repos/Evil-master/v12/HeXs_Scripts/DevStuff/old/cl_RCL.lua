

local Enabled = false
local Force = CreateClientConVar("hex_recoil_force", 0, false, false)


local function HeXNoRecoil()
	if Enabled then
		if ValidEntity(LocalPlayer():GetActiveWeapon()) and (LocalPlayer():GetActiveWeapon().Primary and LocalPlayer():GetActiveWeapon().Primary.Recoil != 0) then
			LocalPlayer():GetActiveWeapon().OldRecoil = LocalPlayer():GetActiveWeapon().Recoil or (LocalPlayer():GetActiveWeapon().Primary and LocalPlayer():GetActiveWeapon().Primary.Recoil)
			LocalPlayer():GetActiveWeapon().Recoil = 0
			LocalPlayer():GetActiveWeapon().Primary.Recoil = 0
		end
	elseif ValidEntity(LocalPlayer():GetActiveWeapon()) and (LocalPlayer():GetActiveWeapon().Primary and LocalPlayer():GetActiveWeapon().Primary.Recoil == 0) and LocalPlayer():GetActiveWeapon().OldRecoil then
		LocalPlayer():GetActiveWeapon().Recoil = LocalPlayer():GetActiveWeapon().OldRecoil
		LocalPlayer():GetActiveWeapon().Primary.Recoil = LocalPlayer():GetActiveWeapon().OldRecoil
	end
end



local function RecoilToggle(ply,cmd,args)
	if Enabled then
		Enabled = false
		print("Recoil enabled")
	else
		Enabled = true
		print("Recoil disabled")
	end
end
concommand.Add("hex_recoil_toggle", RecoilToggle)



local function IsCSS()
	return HeX.MyCall(4):find("weapon_")
end

local function ViewPunch(self,ang)
	if IsCSS() then return end
	
	return self:ViewPunchOld(ang)
end
local function SetEyeAngles(self,ang)
	if IsCSS() then return end
	
	return self:SetEyeAnglesOld(ang)
end

local function RecoilEnabled(ply,cmd,args)
	if HACInstalled and not Force:GetBool() then
		print("! HAC is running, dangerous!, force enable to use")
		return
	end
	
	HeX.Detour.Player("ViewPunch", ViewPunch)
	HeX.Detour.Player("SetEyeAngles", SetEyeAngles)
	
	hook.Add("Think", "HeXNoRecoil", HeXNoRecoil)
end
concommand.Add("hex_recoil_enabled", RecoilEnabled)









