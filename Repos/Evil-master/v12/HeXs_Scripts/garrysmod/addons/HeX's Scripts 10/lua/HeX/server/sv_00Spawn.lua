


local function ShowTheSpawns()
	for k,v in pairs( ents.FindByClass("info_player_*") ) do
		local Where = v:GetPos()
		
		local ent = ents.Create("sent_ball")
			ent:SetPos( Where + Vector(0,0,60) )
			ent:Spawn()
		ent:GetPhysicsObject():Sleep()
		
		print("! spawnpoint at: ", Where)
	end
end
concommand.Add("00_BouncySpawnPoint", ShowTheSpawns)






