

local GoodEnts = {
	"prop_physics",
	"prop_physics_multiplayer",
	"prop_physics_override",
	"gmod_thruster",
	"gmod_hoverball",
	"gmod_turret",
	"npc_turret_floor",
	"prop_vehicle_prisoner_pod",
	"prop_vehicle_jeep",
}

local DumpFile = "mapdump-"..game.GetMap():lower().."-"

DumpTAB = {}

if (CLIENT) then
	function TakeDump(p,c,a)
		local Name = a[1] or "Fuck"
		local DumpFile = DumpFile..Name..".txt"
		
		DumpTAB = {}
		
		local i = 0
		for k,v in pairs(ents.GetAll()) do
			if ValidEntity(v) and not v:IsPlayer() and table.HasValue(GoodEnts, v:GetClass()) then
				
				local Tab = {
					egc = v:GetClass(),
					mdl = v:GetModel(),
					skn = v:GetSkin(),
					mat = v:GetMaterial(),
					col = v:GetColor(),
					pos = v:GetPos(),
					ang = v:GetAngles(),
				}
				table.insert(DumpTAB, Tab)
				i = i + 1
			end
		end
		
		file.Write(DumpFile, glon.encode(DumpTAB) )
		print("! saved: ", i, " entities as: ", DumpFile)
	end
	concommand.Add("hex_dump_map", TakeDump)
end


if (SERVER) then
	function LoadDump(p,c,a)
		local Name = a[1] or "Fuck"
		local DumpFile = DumpFile..Name..".txt"
		
		if not file.Exists(DumpFile) then
			error("! fuckup, DumpFile gone!")
		end
		
		_G["DumpTAB"] = glon.decode( file.Read(DumpFile) )
		
		local i = 0
		for k,v in ipairs(DumpTAB) do
			local egc = v.egc
			local mdl = v.mdl
			local skn = v.skn
			local mat = v.mat
			local col = v.col
			local pos = v.pos
			local ang = v.ang
			
			local ent = ents.Create(egc)
				ent:SetModel(mdl)
				ent:SetSkin(skn)
				ent:SetMaterial(mat)
				--ent:SetColor(col)
				ent:SetPos(pos)
				ent:SetAngles(ang)
			ent:Spawn()
			
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion(false)
			end
			i = i + 1
		end
		
		DumpTAB = {}
		
		print("! loaded: ", i, " entities from: ", DumpFile)
	end
	concommand.Add("hex_load_map", LoadDump)
end























