

hook.Remove("Think", "MaulMoreDamageThink")
hook.Remove("PlayerSpawn", "ULXRagdollSpawnCheck")
hook.Remove("PhysgunPickup", "ulxPlayerPickup")

hook.Remove("PlayerDeath", "ULXCheckDeath")
hook.Remove("PlayerDeath", "ULXCheckMaulDeath")

hook.Remove("PlayerSay", "ULXGimpCheck")
hook.Remove("PlayerSay", "ulxPlayerSay")
hook.Remove("PlayerSay", "ULXMeCheck")
hook.Remove("PlayerSay", "ULXLogSay")

timer.Destroy("ULXJail")

_R.Entity.DisallowDeleting 	= nil
_R.Entity.DisallowMoving 	= nil

_R.Player.DisallowDeleting 	= nil
_R.Player.DisallowMoving 	= nil


ETable(ulx)
ETable(ULX)
ETable(ULib)

MsgAll("\nULX has reloaded\n\n")









