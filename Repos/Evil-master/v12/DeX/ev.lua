

hook.Remove("PlayerSpawnedProp", "EV_SpawnHook")
hook.Remove("PlayerSpawnedSENT", "EV_SpawnHook")
hook.Remove("PlayerSpawnedNPC", "EV_SpawnHook")
hook.Remove("PlayerSpawnedVehicle", "EV_SpawnHook")
hook.Remove("PlayerSpawnedEffect", "EV_SpawnHook")
hook.Remove("PlayerSpawnedRagdoll", "EV_SpawnHook")
hook.Remove("PlayerSpawn", "EV_RankHook")
hook.Remove("PlayerConnect", "EV_LogConnect")
hook.Remove("PlayerDisconnected", "EV_LogDisconnect")
hook.Remove("PlayerDeath", "EV_LogDeath")
hook.Remove("PlayerSay", "EV_PlayerChat")


if evolve.CleanupAdd then
	cleanup.Add = evolve.CleanupAdd
end
if evolve.AddCount then
	_R.Player.AddCount = evolve.AddCount
end
if evolve.HookCall then
	hook.Call = evolve.HookCall
end


local function AlwaysTrue()
	return true
end
_R.Player.EV_IsOwner 		= AlwaysTrue
_R.Player.EV_IsSuperAdmin 	= AlwaysTrue
_R.Player.EV_IsAdmin 		= AlwaysTrue

_R.Entity.EV_IsOwner 		= AlwaysTrue
_R.Entity.EV_IsSuperAdmin 	= AlwaysTrue
_R.Entity.EV_IsAdmin 		= AlwaysTrue


ETable(evolve)
ETable(ev)



MsgAll("\nEV has reloaded\n\n")









