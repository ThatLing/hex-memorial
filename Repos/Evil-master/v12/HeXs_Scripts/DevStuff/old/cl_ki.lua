
usermessage.Hook( "PlayerKilled", function ( message )

	local victim 	= message:ReadEntity();
	local inflictor	= message:ReadString();
	local attacker 	= "#" .. message:ReadString();
	
	if (attacker == "#npc_turret_floor") then inflictor = "npc_turret_floor" end
	
	GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim:Name(), victim:Team() )

end )

usermessage.Hook( "NPCKilledNPC", function ( message )

	local victim 	= "#" .. message:ReadString();
	local inflictor	= message:ReadString();
	local tmp = message:ReadString();
	local attacker 	= "#" .. tmp;
	
	if (tmp == "combine_mine"         or
		tmp == "npc_antlion"          or
			tmp == "npc_turret_floor"          or
		tmp == "npc_antlionguard"     or
		tmp == "npc_barnacle"     or
	   (tmp == "npc_antlion_worker" and inflictor ~= "grenade_spit") or
	   (tmp == "npc_hunter" and inflictor ~= "hunter_flechette") or
	   (tmp == "npc_strider" and inflictor ~= "concussiveblast") or
		tmp == "npc_rollermine"       or
		tmp == "weapon_striderbuster" or
		tmp == "npc_manhack") then inflictor = tmp
	end
	
	GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim, -1 )

end )
