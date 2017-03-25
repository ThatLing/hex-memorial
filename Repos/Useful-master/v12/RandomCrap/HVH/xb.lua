hook.Add("Think", "BoltTrails", function()
	for k, v in pairs(ents.FindByClass("crossbow_bolt")) do
		if (v.SToolTrail) then return end
		
		local trail = util.SpriteTrail(
			v,
			0,
			Color(0, 255, 0),
			true,
			10,
			10,
			2,
			2/(10+10),
			"trails/laser.vmt"
		)
		
		v.SToolTrail = trail	
	end
end)