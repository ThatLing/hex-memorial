print("! HeXNoRecoil loaded")

local HeXNoRecoilEnabled = true

local function HeXNoRecoilToggle(ply,cmd,args)
	if HeXNoRecoilEnabled then
		HeXNoRecoilEnabled = false
		GAMEMODE:AddNotify("Recoil enabled", NOTIFY_GENERIC, 3)
		print("! Recoil enabled")
	else
		HeXNoRecoilEnabled = true
		GAMEMODE:AddNotify("Recoil disabled.", NOTIFY_GENERIC, 4)
		print("! Recoil disabled")
	end
end
concommand.Add("hex_togglerecoil", HeXNoRecoilToggle)

local function HeXNoRecoil()
	if HeXNoRecoilEnabled then
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
hook.Add("Think", "HeXNoRecoil", HeXNoRecoil)
