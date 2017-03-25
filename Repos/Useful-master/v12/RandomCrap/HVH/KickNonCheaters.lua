





hook.Add("PlayerInitialSpawn", "KickNonCheaters", function(ply)
	timer.Simple(65, function()
		if ValidEntity(ply) and not ply:IsBot() and not file.Exists(ply.HACLog) then
			ply:SendLua([[ LocalPlayer():ConCommand("connect gmod.game-host.org") ]])
			print("! non cheater, connected to DM", ply)
		end
	end)
	
end)



concommand.Add("tf", function()
	BroadcastLua([[ LocalPlayer():ConCommand("connect gmod.game-host.org") ]])
end)




















