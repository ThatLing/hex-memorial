
if SERVER then
	concommand.Add("savebarrels", function()
		local tab = {}
		
		for k,v in pairs(ents.FindByClass("prop_dynamic")) do
			table.insert(tab, v:GetPos())
			if v:IsValid() then
				v:Remove()
			end
		end
		
		file.Write("barrels.txt", glon.encode(tab))
	end)



	concommand.Add("loadbarrels", function(ply,cmd,args)
		local tab = glon.decode(file.Read("barrels.txt")) or {}
		
		for k,v in pairs(tab) do 
			local ent = ents.Create("prop_physics")
				ent:SetPos(v)
				ent:SetModel("models/props_c17/oildrum001_explosive.mdl")
			ent:Spawn()
			
			if #args > 0 then
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:EnableMotion(false)
					phys:Sleep()
				end
			end
		end
	end)

end








