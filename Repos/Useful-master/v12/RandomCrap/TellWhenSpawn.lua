

LtGreen	= Color(174,255,0)
PURPLE	= Color(149,102,255)	--ASK2 purple


local Active = false
timer.Simple(1, function()
	Active = true
end)

local function EntityCreated(ent)
	if Active and ValidEntity(ent) and ent:IsPlayer() and (ent != LocalPlayer()) then
		chat.AddText(LtGreen, "[", PURPLE, "P", LtGreen, "Join] ", ent, LtGreen, " Has spawned in the server!")
		surface.PlaySound( Sound("ambient/machines/thumper_shutdown1.wav") )
	end
end
hook.Add("OnEntityCreated", "EntityCreated", EntityCreated)



local function EntityRemoved(ent) --This might not work
	if Active and ValidEntity(ent) and ent:IsPlayer() and (ent != LocalPlayer()) then
		chat.AddText(LtGreen, "[", PURPLE, "P", LtGreen, "Join] ", ent, PURPLE, " Has left the server!")
		surface.PlaySound( Sound("ambient/machines/thumper_shutdown1.wav") )
	end
end
hook.Add("EntityRemoved", "EntityRemoved", EntityRemoved)




