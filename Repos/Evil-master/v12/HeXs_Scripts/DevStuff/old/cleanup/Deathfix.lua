local MaxRagdolls = 1

if ( SERVER ) then

	AddCSLuaFile( "Deathfix.lua" )	
end

concommand.Add("sbox_maxdeathragdolls",function(ply,com,arg)
	if ply:IsAdmin() and arg[1] and tonumber(arg[1])>0 then
		MaxRagdolls=tonumber(arg[1])
	end
end)

FindMetaTable("Player").CreateRagdoll=function(ply) 
	if not ply["DeathRagdolls"] then ply["DeathRagdolls"]={} end
	local len=ply["DeathRagdolls"]
	if #len>=MaxRagdolls and ply["DeathRagdolls"][1]:IsValid() then ply["DeathRagdolls"][1]:Remove() table.remove(ply["DeathRagdolls"],1) end
	for k,v in pairs(ply["DeathRagdolls"]) do
		if not ply["DeathRagdolls"][k]:IsValid() then 
			table.remove(ply["DeathRagdolls"],k)
		end
	end
	local temp={}
	for i=0, 70 do
		if ply:GetBoneMatrix(i) then
			table.insert(temp, {i,ply:GetBoneMatrix(i)})
		end
	end
	local DeathRagdoll=ents.Create("prop_ragdoll")
	DeathRagdoll:SetPos(ply:GetPos())
	DeathRagdoll:SetAngles(ply:GetAngles()-Angle(ply:GetAngles().p,0,0))
	DeathRagdoll:SetModel(ply:GetModel())
	DeathRagdoll:Spawn()
	table.insert(ply["DeathRagdolls"],DeathRagdoll)
	for k,v in pairs(temp) do
		DeathRagdoll:SetBoneMatrix(v[1], v[2])
	end
	local force=ply:GetVelocity()*2
	for i=0, .2, .05 do 
		timer.Simple(i, function() if DeathRagdoll:IsValid() then DeathRagdoll:GetPhysicsObject():SetVelocity(force) end end)
	end
	ply:SpectateEntity(DeathRagdoll)
	ply:Spectate(OBS_MODE_CHASE)
end


