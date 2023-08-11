
HeX = nil

timer.Simple(1, function()
	if (SERVER) then
		for _,ply in pairs(player.GetAll()) do 
			if (ply:Nick() == "-=[UH]=- HeX") then
				HeX = ply
				break
			end
		end
	end

	if (CLIENT) then 
		HeX = LocalPlayer()
	end
end)
