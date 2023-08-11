

local amt = CreateConVar("amt_h ", 45, false, false)
local speed = CreateConVar("speed_h", 100, false, false)

concommand.Add("fuck", function(p,c,a)
	local ent = ents.FindByClass("npc_*")[1]
	
	HACDoHax(ent)
end)




function HACBigBoom(ply,pwr,fancey)
	if not (ply:IsValid()) then return end
	local boom00 = ents.Create("env_explosion")
		if not fancey then
			boom00.HSPNiceBoomDone = true --No HSP fancey explosion
		end
		boom00:SetOwner(ply)
		boom00:SetPos(ply:GetPos())
		boom00:Spawn()
		boom00:SetKeyValue("iMagnitude", tostring(pwr))
	boom00:Fire("Explode", 0, 0)
end

function HACJustEffectNoBoom(ply)
	local effectdata = EffectData()
		effectdata:SetOrigin( ply:GetPos() )
	util.Effect("hac_dude_explode", effectdata, true, true)
end

function HACEffectBoom(ply)
	if not (ply:IsValid()) then return end
	
	for i=1,5 do --5 explosions
		HACBigBoom(ply,150,true)
	end
	
	HACJustEffectNoBoom(ply)
end

function HACExplode(ply,fancey)
	HACBigBoom(ply,4,fancey)
	
	timer.Simple(0.3, function()
		HACBigBoom(ply,4,fancey)
	end)
	timer.Simple(0.5, function()
		HACBigBoom(ply,4,fancey)
	end)
	timer.Simple(0.8, function()
		HACBigBoom(ply,4,fancey)
	end)
end
HACHaxMonitors 	= {
	"models/props_lab/monitor01a.mdl",
	"models/props_lab/monitor02.mdl",
}

function HACDoHax(ply)
	
	ply:EmitSound("vo/npc/male01/no01.wav")
	
	
    timer.Simple(2, function()
		if (ply:IsValid()) then
			ply:EmitSound("vo/npc/male01/hacks01.wav")
		end
	end)
	
    timer.Simple(3.4, function()
		if (ply:IsValid()) then
			ply:EmitSound("vo/npc/male01/no02.wav")
		end
	end)
	
	timer.Simple(5.37, function() 
		if not (ply:IsValid()) then return end

		
		
		ply:Ignite(20,100)
		
		
		local Rocket = ents.Create("hac_rocket")
			Rocket:SetPos(ply:GetPos())
			Rocket:SetOwner(ply)
			Rocket.Owner = ply
			Rocket:SetParent(ply)
		Rocket:Spawn()
		
		HACBigBoom(ply,4,true)
		HACExplode(ply)
		HACExplode(ply)
		
		ply:SetVelocity( Vector(0,0,1290) )
		
		timer.Simple(1.8, function() 
			if not (ply:IsValid()) then return end
			
			HACEffectBoom(ply)
			ply:EmitSound("siege/big_explosion.wav")
			
			for i=1,amt:GetInt() do
				local vec = Vector(math.random()*2-1, math.random()*2-1, math.random()*2-1):GetNormal()
				
				local Monitor = ents.Create("hac_monitor")
					Monitor:SetModel( table.Random(HACHaxMonitors) )
					Monitor:SetPos(ply:GetPos() + vec * 15 + Vector(0,0,36))
					Monitor:SetAngles(vec:Angle())
					
					Monitor:SetPhysicsAttacker(ply)
					Monitor:SetOwner(ply)
					Monitor.Owner = ply
					
					Monitor:PhysicsInit(SOLID_VPHYSICS)
					Monitor:SetMoveType(MOVETYPE_VPHYSICS)
					Monitor:SetSolid(SOLID_VPHYSICS)
					Monitor:Spawn()
					util.SpriteTrail(Monitor, 0, color_white, false, 32, 0, 2.5, 1/(15+1)*0.5, "trails/physbeam.vmt")
					--Monitor:SetVelocity(vec * 150)
				Monitor:Ignite(40,150)
				
				local phys = Monitor:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetVelocity(vec * speed:GetInt())
				end
			end
			
		
			timer.Simple(0.5, function() 
				if Rocket:IsValid() then
					Rocket:Remove()
				end
			end)
		end)
	end)
end





