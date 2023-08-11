
local Enabled	= false
local WhatMat	= CreateClientConVar("falco_mat", "mat2", true, false)
local WhatAlpha = CreateClientConVar("falco_alpha", 25, true, false)
local NewA		= WhatAlpha:GetInt()

local Alpha		= 0
local AllMats	= {}
local allcolors = {}

local NotEqTab	= {
	["prop_physics"]				= true,
	["item_battery"]				= true,
	["item_healthkit"]				= true,
	["npc_satchel"]					= true,
	["npc_tripmine"]				= true,
	["gravestone"]					= true,
	["ent_mad_c4"]					= true,
	["viewmodel"]					= true,
	["prop_vehicle_jeep"]			= true,
	["prop_vehicle_airboat"]		= true,
	["prop_vehicle_prisoner_pod"]	= true,
	["weapon_slam"]					= true,
}

local function TogglePoKiRay()
	surface.PlaySound("items/nvg_off.wav")
	
	NewA = WhatAlpha:GetInt()
	if WhatMat:GetString() == "mat1" then
		Alpha = 170 + NewA
	else
		Alpha = 0 + NewA
	end
	
	if Enabled then
		for k,v in pairs(ents.GetAll()) do
			if ValidEntity(v) then
				v:SetMaterial(AllMats[v])
				local z = allcolors[v]
				if z and type(z) == "table" then
					v:SetColor(z.r, z.g, z.b, z.a)
				else 
					v:SetColor(255,255,255,255)
				end
			end
		end
		allcolors = {}
	end
	Enabled = not Enabled
end
concommand.Add("ToggleFRay", TogglePoKiRay)


local function DoPoKiRay()
	if not Enabled then return end
	
	for k,v in pairs( ents.GetAll() ) do
		if ValidEntity(v) then
			local r,g,b,a = v:GetColor()
			local egc = v:GetClass()
			NewA = WhatAlpha:GetInt()
			
			if v:IsPlayer()
			and (r != 255 or g != 0 or b != 0 or a != 255) then
				allcolors[v] = Color(r,g,b,a)
				v:SetColor(255, 0, 0, 255)
				
			elseif v:IsNPC()
			and (r != 0 or g != 0 or b != 255 or a != 255) then
				allcolors[v] = Color(r,g,b,a)
				v:SetColor(0, 0, 255, 255)
				
			elseif egc == "prop_physics"
			and (r != 50 or g != 255 or b != 50 or a != 35 + Alpha + NewA) then
				allcolors[v] = Color(r,g,b,a)
				v:SetColor(50, 255, 50, 35 + Alpha + NewA)
				
			elseif (v:IsWeapon() and egc != "weapon_slam")
			and (r != 140 or g != 0 or b != 255 or a != 255) then
				allcolors[v] = Color(r,g,b,a)
				v:SetColor(140, 0, 255, 255)
				
			elseif (v:IsVehicle() or egc == "prop_vehicle_jeep" or egc == "prop_vehicle_airboat" or egc == "prop_vehicle_prisoner_pod")
			and (r != 0 or g != 207 or b != 255 or a != 59 + Alpha + NewA) then
				allcolors[v] = Color(r,g,b,a)
				v:SetColor(0, 207, 255, 59 + Alpha + NewA)
				
			elseif egc == "viewmodel"
			and (r != 0 or g != 0 or b != 0 or a != 50)  then
				allcolors[v] = Color(r,g,b,a)
				v:SetColor(0, 0, 0, 50)
				
			elseif (egc == "ent_mad_c4" or egc == "gravestone" or egc == "npc_tripmine" or egc == "npc_satchel")
			and (r != 255 or g != 0 or b != 0 or a != 255) then
				allcolors[v] = Color(r,g,b,a)
				v:SetColor(255, 0, 0, 255)
				
				
			elseif (egc == "weapon_slam")
			and (r != 255 or g != 153 or b != 0 or a != 255) then
				allcolors[v] = Color(r,g,b,a)
				--v:SetColor(255, 255, 0, 255) --yellow
				v:SetColor(255, 153, 0, 255) --orange
				
				
			elseif (egc == "item_battery" or egc == "item_healthkit")
			and (r != 255 or g != 0 or b != 100 or a != 255) then
				allcolors[v] = Color(r,g,b,a)
				v:SetColor(255, 0, 100, 255)
				
				
			elseif not v:IsPlayer() and not v:IsNPC() and not v:IsWeapon() and not v:IsVehicle() and not NotEqTab[ egc ]
			and (r != 255 or g != 200 or b != 0 or a != 85 + Alpha + NewA) then
				allcolors[v] = Color(r,g,b,a)
				v:SetColor(255, 200, 0, 85 + Alpha + NewA)
			end
			
			if egc != "viewmodel" and v:GetMaterial() != WhatMat:GetString() then
				AllMats[v] = v:GetMaterial()
				v:SetMaterial(WhatMat:GetString())
			end
		end
	end
end
hook.Add("RenderScene", "NewXrayVision3", DoPoKiRay)






