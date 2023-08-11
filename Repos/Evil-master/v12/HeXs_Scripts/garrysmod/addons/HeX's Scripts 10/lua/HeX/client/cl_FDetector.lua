
local RadiusMode = false
local detectors = {}

local FDetDoSay = CreateClientConVar("FDet_DoSay", 1, true, false)
local RunSomethingVar = "FDet_RunSomething"
CreateClientConVar(RunSomethingVar, "no", false, false)


surface.CreateFont( "coolvetica", 32, 500, true, false, "FdetectorFont1" )

local function MakeDetector(ply, cmd, args)
	local center = ents.Create("prop_physics")
	center:SetPos(LocalPlayer():GetShootPos()--[[  - Vector(0,0,32) ]])
	center:SetModel("models/Items/AR2_Grenade.mdl")
	center:Spawn()
	LocalPlayer():ChatPrint("Select radius(use mouse button)")
	RadiusMode = true
	table.insert(detectors, center)
	detectors[table.Count(detectors)].pozizion = LocalPlayer():GetShootPos() - Vector(0,0,32)
	detectors[table.Count(detectors)].Entities = {}
	detectors[table.Count(detectors)].DrawRadius = false
	detectors[table.Count(detectors)].detectmode = false
	
	hook.Add("HUDPaint", "RadiusFDetector", function() 
		local trace = LocalPlayer():GetEyeTrace()
		local distance = center:GetPos():Distance(trace.HitPos)
		draw.DrawText(tostring(math.floor(distance)), "FdetectorFont1", ScrW() / 2, ScrH() / 2, Color(255,255,255,255), 1)
	end)
	
	if args[1] ~= nil then
		detectors[table.Count(detectors)].Naam = tostring(table.concat(args, " "))
	else
		detectors[table.Count(detectors)].Naam = "your detector"
	end
end
concommand.Add("fdet_make",MakeDetector)

local function removedetectors()
	RadiusMode = false
	if detectors[table.Count(detectors)]:IsValid() then
		detectors[table.Count(detectors)]:Remove()
		table.remove(detectors, table.Count(detectors))
	end
	LocalPlayer():ChatPrint("Last detector removed")
end	
concommand.Add("fdet_remove",removedetectors)

local function RadiusSelection(ply, bind, pressed)
	if RadiusMode and ply == LocalPlayer() and pressed then
		if string.find(bind, "attack") then
			hook.Remove("HUDPaint", "RadiusFDetector")
			local trace = LocalPlayer():GetEyeTrace()
			detectors[table.Count(detectors)].radius = detectors[table.Count(detectors)]:GetPos():Distance(trace.HitPos)
			RadiusMode = false
			LocalPlayer():ChatPrint("Radius selected: " .. tostring(detectors[table.Count(detectors)].radius))
			detectors[table.Count(detectors)].detectmode = true
			return true
		end	
	end
end
hook.Add("PlayerBindPress", "Radiusselection", RadiusSelection)

local function DrawRadius()
	for k,v in pairs(detectors) do
		if v.DrawRadius == true then
			surface.SetDrawColor(255,0,0,255)
			local pos1_1 = (v:GetPos() + Vector(v.radius, 0,0)):ToScreen()
			local pos1_2 = (v:GetPos() - Vector(v.radius, 0,0)):ToScreen()
			
			local pos2_1 = (v:GetPos() + Vector(0, v.radius,0)):ToScreen()
			local pos2_2 = (v:GetPos() - Vector(0, v.radius,0)):ToScreen()
			
			local pos3_1 = (v:GetPos() + Vector(0,0,v.radius)):ToScreen()
			local pos3_2 = (v:GetPos() - Vector(0,0,v.radius)):ToScreen()
			surface.DrawLine(pos1_1.x, pos1_1.y, pos1_2.x, pos1_2.y )
			surface.DrawLine(pos2_1.x, pos2_1.y, pos2_2.x, pos2_2.y )
			surface.DrawLine(pos3_1.x, pos3_1.y, pos3_2.x, pos3_2.y )
		end
	end
end
hook.Add("HUDPaint", "DrawRadiusOfDetectors", DrawRadius)


local sound1 = Sound("ambient/alarms/siren.wav")
local function ThinkFunction()
	local sound = CreateSound(LocalPlayer(), sound1)
	for num, center in pairs(detectors) do
		if not center:IsValid() then return end
		center:SetPos(center.pozizion)
		if center.detectmode then
			local trace = {}
			trace.start = LocalPlayer():GetShootPos()
			trace.endpos = center.pozizion
			trace.filter = LocalPlayer()
			trace.mask = -1
			local TheTrace = util.TraceLine(trace)
			if TheTrace.Hit then
				center.DrawRadius = false
			else
				center.DrawRadius = true
			end
			
			for k,v in pairs(center.Entities) do
				if not table.HasValue(ents.FindInSphere( center:GetPos(), center.radius), v) then 
					table.remove(center.Entities, k)
				end
			end
			for k,v in pairs(ents.FindInSphere( center:GetPos(), center.radius)) do
				if v:GetClass() ==  "prop_physics" and not table.HasValue(center.Entities, v)  then
					table.insert(center.Entities, v)
					GAMEMODE:AddNotify(v:GetModel() .. " has entered " .. center.Naam, 1, 5 )
					
					
					sound:Play()
					timer.Simple(1, function() sound:Stop() end)
					local PropOwner = "player"
					
					if v:GetNetworkedString("Owner") ~= "" then
						GAMEMODE:AddNotify("Prop belongs to: " .. v:GetNetworkedString("Owner"), 1, 5)
						PropOwner = v:GetNetworkedString("Owner")
						
					elseif (ASS_PP_GetOwner and ASS_PP_GetOwner(v):IsValid()) then
						GAMEMODE:AddNotify("Prop belongs to: " .. ASS_PP_GetOwner(v):Nick(), 1, 5)
						PropOwner = ASS_PP_GetOwner(v)
					end
					
					
					--SayShit
					if FDetDoSay:GetBool() then
						chat.AddText(GREEN,"[", BLUE,"HeX", GREEN,"]", RED," FDet ", GREEN,PropOwner, WHITE, " prop ("..v:GetModel()..") is in "..center.Naam)
					end
					--RunShit
					if (GetConVarString(RunSomethingVar) != "no") then
						--print("! RunSomethingVar: ", GetConVarString(RunSomethingVar))
						LocalPlayer():ConCommand( GetConVarString(RunSomethingVar) )
					end
					
				elseif v:GetClass() == "player" and not table.HasValue(center.Entities, v) then
					table.insert(center.Entities, v)
					if v == LocalPlayer() then
						surface.PlaySound("buttons/button14.wav")
					else
						sound:Play()
						timer.Simple(1, function() sound:Stop() end)
						GAMEMODE:AddNotify(v:Nick() .. " has entered " ..  center.Naam, 1, 5 )
						
						
						--RunShit
						if (GetConVarString(RunSomethingVar) != "no") then
							--print("! RunSomethingVar: ", GetConVarString(RunSomethingVar))
							LocalPlayer():ConCommand( GetConVarString(RunSomethingVar) )
						end
						--SayShit
						if FDetDoSay:GetBool() then
							chat.AddText(GREEN,"[", BLUE,"HeX", GREEN,"]", RED," FDet ", v, WHITE, " is in "..center.Naam)
						end
						
						
					end
				elseif v:GetClass() ~= "player" and v:GetClass() ~= "worldspawn" and v:GetClass() ~= "prop_physics" and not v:IsWeapon() and v:GetClass() ~= "viewmodel"  and not table.HasValue(center.Entities, v) then
					table.insert(center.Entities, v)
					GAMEMODE:AddNotify(v:GetClass() .. " has entered " .. center.Naam, 1, 5)
					
					--SayShit
					if FDetDoSay:GetBool() then
						chat.AddText(GREEN,"[", BLUE,"HeX", GREEN,"]", RED," FDet ", GREEN, v:GetClass(), WHITE, " is in "..center.Naam)
					end						
					--RunShit
					if (GetConVarString(RunSomethingVar) != "no") then
						--print("! RunSomethingVar: ", GetConVarString(RunSomethingVar))
						LocalPlayer():ConCommand( GetConVarString(RunSomethingVar) )
					end

					timer.Simple(1, function() sound:Stop() end)
					sound:Play()
				end
			end
		end
	end

end
hook.Add("Think", "PlayerDetection", ThinkFunction)

