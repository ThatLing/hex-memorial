
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------

function EFFECT:Init( data )
	local start = data:GetOrigin()
	local em = ParticleEmitter( start )
	for i=1, 356 do
		local part = em:Add("particle/particle_noisesphere", start ) --Shockwave
		if part then
			part:SetColor(255,255,195,255)
			part:SetVelocity(Vector(math.random(-10,10),math.random(-10,10),0):GetNormal() * math.random(1500,2000))
			part:SetDieTime(math.random(2,3))
			part:SetLifeTime(math.random(0.3,0.5))
			part:SetStartSize(60)
			part:SetEndSize(60)
			part:SetAirResistance(140)
			part:SetRollDelta(math.random(-2,2))
	   
		end
		local part1 = em:Add("effects/fire_cloud1", start ) --Fire cloud
		if part1 then
			part1:SetColor(255,255,255,255)
			part1:SetVelocity(Vector(math.random(-10,10),math.random(-10,10),math.random(5,20)):GetNormal() * math.random(100,2000))
			part1:SetDieTime(math.random(2,3))
			part1:SetLifeTime(math.random(0.3,0.5))
			part1:SetStartSize(80)
			part1:SetEndSize(50)
			part1:SetAirResistance(200)
			part1:SetRollDelta(math.random(-2,2))
		end
	end
	em:Finish()
end

function EFFECT:Think()
end

function EFFECT:Render() 
end




----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------

function EFFECT:Init( data )
	local start = data:GetOrigin()
	local em = ParticleEmitter( start )
	for i=1, 356 do
		local part = em:Add("particle/particle_noisesphere", start ) --Shockwave
		if part then
			part:SetColor(255,255,195,255)
			part:SetVelocity(Vector(math.random(-10,10),math.random(-10,10),0):GetNormal() * math.random(1500,2000))
			part:SetDieTime(math.random(2,3))
			part:SetLifeTime(math.random(0.3,0.5))
			part:SetStartSize(60)
			part:SetEndSize(60)
			part:SetAirResistance(140)
			part:SetRollDelta(math.random(-2,2))
	   
		end
		local part1 = em:Add("effects/fire_cloud1", start ) --Fire cloud
		if part1 then
			part1:SetColor(255,255,255,255)
			part1:SetVelocity(Vector(math.random(-10,10),math.random(-10,10),math.random(5,20)):GetNormal() * math.random(100,2000))
			part1:SetDieTime(math.random(2,3))
			part1:SetLifeTime(math.random(0.3,0.5))
			part1:SetStartSize(80)
			part1:SetEndSize(50)
			part1:SetAirResistance(200)
			part1:SetRollDelta(math.random(-2,2))
		end
	end
	em:Finish()
end

function EFFECT:Think()
end

function EFFECT:Render() 
end



