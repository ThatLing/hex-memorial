
hook.Remove("CanTool", "FPP.Protect.CanTool")
hook.Remove("PhysgunPickup", "FPP.Protect.PhysgunPickup")
hook.Remove("PlayerUse", "FPP.Protect.PlayerUse")
hook.Remove("GravGunPunt", "FPP.Protect.GravGunPunt")
hook.Remove("GravGunOnPickedUp", "FPP.Protect.GravGunPickup")
hook.Remove("OnPhysgunReload", "FPP.Protect.PhysgunReload")
hook.Remove("PlayerSpawnRagdoll", "FPP.AntiSpam.AntiCrash")
hook.Remove("PlayerInitialSpawn", "FPP_SendSettings")
hook.Remove("OnPhysgunFreeze", "FPP.Protect.PhysgunFreeze")
hook.Remove("EntityTakeDamage", "FPP.Protect.EntityTakeDamage")
hook.Remove("PlayerDisconnected", "FPP.PlayerDisconnect")
hook.Remove("PlayerInitialSpawn", "FPP.PlayerInitialSpawn")
hook.Remove("PlayerLeaveVehicle", "FPP.PlayerLeaveVehicle")
hook.Remove("CanExitVehicle", "PreventVehicleNoclip")


if FPP.oldcleanup then
	cleanup.Add = FPP.oldcleanup
end
if FPP.ApplyForceCenter then
	_R.PhysObj.ApplyForceCenter = FPP.ApplyForceCenter
end
if FPP.oldcount then
	_R.Player.AddCount = FPP.oldcount
end


ETable(DB)
ETable(FPP_MySQLConfig)
ETable(FPP.Blocked)
ETable(FPP)
ETable(FAdmin)

BlockedModelsExist = nil


MsgAll("\nFPP has reloaded\n\n")









