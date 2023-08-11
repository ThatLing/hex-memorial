//local PoKiRayOn = CreateClientConVar("PoKiRayOn", 0, false, true)
local RayOn = false
local AllMats = {}
local allcolors = {}
local FSetColor = _R.Entity.SetColor
local FSetMat = _R.Entity.SetMaterial


local function TogglePoKiRay()
	if RayOn then
		surface.PlaySound("items/nvg_off.wav")
		for k,v in pairs(ents.GetAll()) do
		if v and IsValid(v) then
			FSetMat(v, AllMats[v])
			local z = allcolors[v]
			if z and type(z) == "number" then 
				FSetColor(v, 255,255,255,255)
			elseif z and  type(z) == "table" then
				FSetColor(v, z.r, z.g, z.b, z.a)
			else 
				FSetColor(v, 255,255,255,255)
			end
		end
		end
	else
		for k,v in pairs(ents.GetAll()) do
			if v and IsValid(v) then
				allcolors[v] = v:GetColor()
			end
		end
		surface.PlaySound("items/nvg_off.wav") 
	end
	RayOn = not RayOn
end
concommand.Add("ToggleFRay", TogglePoKiRay)

function DoPoKiRay()
	if not RayOn then return end
	for k,v in pairs(ents.GetAll()) do
	if v and IsValid(v) then
		local r,g,b,a = v:GetColor()
		
		if v:IsPlayer() and (r ~= 255 or g ~= 0 or b ~= 0 or a ~= 255) then
			allcolors[v] = Color(r,g,b,a)
			FSetColor(v,255, 0, 0, 255)
		elseif v:IsNPC() and (r ~= 0 or g ~= 0 or b ~= 255 or a ~= 255) then
			allcolors[v] = Color(r,g,b,a)
			FSetColor(v, 0, 0, 255, 255) --0, 255, 0, 255 --also 255
		elseif v:GetClass() == "prop_physics" and (r ~= 50 or g ~= 255 or b ~= 50 or a ~= 35) then --40 --(r ~= 0 or g ~= 0 or b ~= 255 or a ~= 70)
			allcolors[v] = Color(r,g,b,a)
			FSetColor(v, 50, 255, 50, 35) --40 --0, 0, 255, 70
		elseif v:IsWeapon() and (r ~= 140 or g ~= 0 or b ~= 255 or a ~= 255) then
			allcolors[v] = Color(r,g,b,a)
			FSetColor(v, 140, 0, 255, 255)
		elseif v:GetClass() == "viewmodel" and (r ~= 0 or g ~= 0 or b ~= 0 or a ~= 50)  then --30
			allcolors[v] = Color(r,g,b,a)
			FSetColor(v, 0, 0, 0, 50) --30
		elseif (v:GetClass() == "prop_vehicle_jeep" or v:GetClass() == "prop_vehicle_airboat") and (r ~= 0 or g ~= 207 or b ~= 255 or a ~= 55) then --was 50
			allcolors[v] = Color(r,g,b,a)
			FSetColor(v, 0, 207, 255, 55) --50
		elseif (v:GetClass() == "ent_mad_c4" or v:GetClass() == "gravestone" or v:GetClass() == "npc_tripmine" or v:GetClass() == "npc_satchel") and (r ~= 255 or g ~= 0 or b ~= 0 or a ~= 255) then
			allcolors[v] = Color(r,g,b,a)
			FSetColor(v, 255, 0, 0, 255)
			
			
		elseif (v:GetClass() == "item_battery" or v:GetClass() == "item_healthkit") and (r ~= 255 or g ~= 0 or b ~= 100 or a ~= 255) then
			allcolors[v] = Color(r,g,b,a)
			FSetColor(v, 255, 0, 100, 255)
			
		
			
		--elseif (v:GetClass() == "drug_lab" or v:GetClass() == "money_printer") and (r ~= 66 or g ~= 179 or b ~= 247 or a ~= 150) then
		--allcolors[v] = Color(r,g,b,a)
		--FSetColor(v, 66, 179, 247, 150)
		
		
		--and v:GetClass() ~= "drug_lab" and v:GetClass() ~= "money_printer"
			
		elseif not v:IsPlayer() and not v:IsNPC() and v:GetClass() ~= "prop_physics" and v:GetClass() ~= "item_battery" and v:GetClass() ~= "item_healthkit" and v:GetClass() ~= "npc_satchel" and v:GetClass() ~= "npc_tripmine" and v:GetClass() ~= "gravestone" and v:GetClass() ~= "ent_mad_c4" and v:GetClass() ~= "prop_vehicle_jeep" and v:GetClass() ~= "prop_vehicle_airboat" and not v:IsWeapon() and v:GetClass() ~= "viewmodel" and ( r ~= 255 or g ~= 200 or b ~= 0 or a ~= 85) then --100
			allcolors[v] = Color(r,g,b,a)
			FSetColor(v, 255, 200, 0, 85) --100
		end
		
		if v:GetClass() ~= "viewmodel" and v:GetMaterial() ~= "PoKiRayMat" then
			AllMats[v] = v:GetMaterial()
			FSetMat(v, "PoKiRayMat")
		end
		
	end
	end
end
hook.Add( "RenderScene", "PoKiRay", DoPoKiRay)

--uncomment these if you want colormod to make the screen black ish (makes it more realistic)
--local ColorMod ={}
--ColorMod[ "$pp_colour_addr" ] = 0
--ColorMod[ "$pp_colour_addg" ] = 0
--ColorMod[ "$pp_colour_addb" ] = 0
--ColorMod[ "$pp_colour_brightness" ] = -0.1
--ColorMod[ "$pp_colour_contrast" ] = 1
--ColorMod[ "$pp_colour_colour" ] = 1
--ColorMod[ "$pp_colour_mulr" ] = 0
--ColorMod[ "$pp_colour_mulg" ] = 0
--ColorMod[ "$pp_colour_mulb" ] = 0

local function ChangeColours()
	if not RayOn then return end
	--DrawColorModify( ColorMod )
	--and the one above
end
hook.Add( "RenderScreenspaceEffects", "PoKiRayColour", ChangeColours)
//hook.Remove( "RenderScreenspaceEffects", "PoKiRayColour")