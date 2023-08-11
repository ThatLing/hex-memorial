


hook.Add("PlayerSpawnedVehicle", "GUNS", function(p,e)
	e:SetKeyValue("EnableGun","1")
	e:Fire("SetCargoHopperVisibility",1,0)
	e:Fire("EnableRadar",1,0)
end)






