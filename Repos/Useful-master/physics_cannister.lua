--[[
	Does this
	http://unitedhosts.org/bar/tmp/bbs_desert_drive0205.jpg
]]





local Temp = player.GetAll()[1]:GetEyeTrace().HitPos + Vector(0,0,40)



local function MakeCan(Offset)
	local Can = ents.Create("physics_cannister")
		Can:SetModel("models/props_c17/canister02a.mdl")
		Can:SetPos(Temp - Vector(0,Offset * 20,0) )
		
		//Angle
		local Ang = Can:GetAngles()
			Ang:RotateAroundAxis(Ang:Right(), 180) --math.random(150,200)
		Can:SetAngles(Ang)
		
		Can:SetKeyValue("thrust", 		"6000")
		Can:SetKeyValue("expdamage", 	"200")
		Can:SetKeyValue("expradius", 	"250")
		Can:SetKeyValue("expdamage", 	"2")
		Can:SetKeyValue("fuel", 		"5")
		Can:SetKeyValue("renderamt", 	"255") --Smoke
		--Can:SetKeyValue("gassound", 	"uhdm/splat.mp3")
	Can:Spawn()
	Can:Activate()
	
	util.SpriteTrail(Can, 0, color_white, false, 32, 0, 2.5, 1/(15+1)*0.5, "trails/physbeam.vmt")
	
	return Can
end


for i=1,30 do
	local Can = MakeCan(i)
	
	Can:GetPhysicsObject():Sleep()
	
	timer.Simple(i/10, function()
		if IsValid(Can) then
			Can:GetPhysicsObject():Wake()
			
			Can:Fire("Activate")
			
			--[[
			time..Simple(5, function()
				if IsValid(Can) then
					Can:Fire("Explode")
				end
			end)]]
		end
	end)
end





