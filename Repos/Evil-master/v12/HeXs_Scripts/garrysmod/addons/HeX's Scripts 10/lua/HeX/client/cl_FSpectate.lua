
local IsSpectating = false
local holding = {}
local SpectatePosition = Vector(0,0,0)
local CanMove = true // for if you're in an object you mustn't be able to move
local SaveAngles = Angle(0,0,0) // Only used when spectating an object
local SpecEnt = LocalPlayer()
local speed = 15
local SelfModel = nil
local SpecEntSaveAngle = Vector(0,0,0)
local camsdata = {}
local camsize = CreateClientConVar("FSpecScreenSize", 5, true, false)
local ThPDist = 100

local function fnotify(text)
	if GAMEMODE.IsSandboxDerived then // in some gamemodes GAMEMODE:AddNotify() doesn't exist
		GAMEMODE:AddNotify(tostring(text), 1, 5)
		surface.PlaySound( "ambient/water/drip2.wav") // I don't care about the other drips so no difficult concatenations or something
	end
end

local function FSpecSelectSomeone()//DONT SAY IT'S STOLEN FROM THE GODDAMN PLAYER POSSESSOR SWEP! I GODDAMN MAAAAADE THE PLAYER POSSESSOR SWEP!
	holding = {}
	if table.Count(player.GetAll()) <= 1  then
		fnotify("You're the only one in the server")
		return
	end
	local frame = vgui.Create("DFrame")
	local button = {}
	local PosSize = {}
	
	frame:SetSize( 200, 500 )
	frame:Center()
	frame:SetVisible(true)
	frame:MakePopup()
	frame:SetTitle("Choose a player")
	
	PosSize[0] = 5
	for k,v in pairs(player.GetAll()) do
		if v == LocalPlayer() then
			PosSize[k] = PosSize[k-1]
		elseif v!= LocalPlayer() then
			PosSize[k] = PosSize[k-1] + 30
			frame:SetSize(200, PosSize[k] + 40)
			button[k] = vgui.Create("DButton", frame)
			button[k]:SetPos( 20, PosSize[k])
			button[k]:SetSize( 160, 20 )
			button[k]:SetText( v:Nick())
			frame:Center()
			button[k]["DoClick"] = function()
				if not ValidEntity(v) then fnotify("Can't spectate him at the moment") return end
				CanMove = false
				SpecEnt = v
			end
		end
	end
end

local function ToggleSpectate()
	if IsSpectating then
		for k,v in pairs(ents.GetAll()) do 
			if v and IsValid(v) then
				if v:GetClass() == "viewmodel" then
					v:SetNoDraw(false)
				end 
			end
		end
		IsSpectating = false
		CanMove = true
		if ValidEntity(SpecEnt) then
			SpecEnt:SetNoDraw(false)
			SpecEnt = LocalPlayer()
		end
		speed = 15
		holding = {}
		if ValidEntity(SelfModel) then
			SelfModel:Remove()
		end
		SelfModel = nil
	else
		IsSpectating = true
		SpectatePosition = LocalPlayer():GetShootPos()
		SelfModel = ents.Create("prop_physics")
		SelfModel:SetModel( LocalPlayer():GetModel() )
		SelfModel:Spawn()
		SelfModel:SetPos(LocalPlayer():GetPos())
		
		for k,v in pairs(ents.GetAll()) do 
			if v and IsValid(v) then
				if v:GetClass() == "viewmodel" then 
					v:SetNoDraw(true)
				end
			end
		end
		
		local ang = LocalPlayer():EyeAngles()
		SelfModel:SetAngles(Angle(0, ang.y, 0))
		SelfModel:SetPlaybackRate( 1.0 )
	 	SelfModel:ResetSequence(SelfModel:SelectWeightedSequence( ACT_HL2MP_IDLE ) )
	 	SelfModel:SetCycle( 0 ) 
		--[[ if LocalPlayer():KeyDown(IN_FORWARD) then
			holding.forward = true
		end ]]
	end
end
concommand.Add("FSpectate", ToggleSpectate)

local function BindPresses(ply, bind, pressed)
	if IsSpectating and not LocalPlayer():KeyDown(IN_USE) then
		if string.find(bind, "forward") or string.find(bind, "moveleft") or string.find(bind, "moveright") or string.find(bind, "back") or string.find(bind, "jump") or string.find(bind, "duck") then
			holding[string.sub(bind, 2)] = pressed
			return true 
		elseif string.find(bind, "speed") then
			if speed <= 15 then speed = 50
			elseif speed == 50 then speed = 15
			end
		elseif string.find(bind, "walk") then
			if speed ~= 2 then speed = 2
			elseif speed == 2 then speed = 15
			end
		elseif string.find(bind, "attack2") and pressed then
			FSpecSelectSomeone()
			return true
		elseif string.find(bind, "menu") and not string.find(bind, "context") and pressed then
			if CanMove then
				table.insert(camsdata, {pos = SpectatePosition, ang = LocalPlayer():EyeAngles(), obj = false})
			elseif not CanMove then
				table.insert(camsdata, {obj = SpecEnt, dist = ThPDist, ang = SaveAngles})
			end
			fnotify("Screen made")
			return true
		elseif string.find(bind, "menu_context") and pressed then
			if #camsdata > 0 then
				table.remove(camsdata, #camsdata) // remove the last one in the table
				fnotify("Last screen removed")
			end
			return true
		elseif string.find(bind, "reload") and pressed then
			if CanMove then
				local Tracey = {}
				Tracey.start = SpectatePosition
				Tracey.endpos = SpectatePosition + LocalPlayer():GetAimVector() * 100000000
				Tracey.filter = LocalPlayer() // in case you're aiming at yourself... IF that's even possible but I can't be arsed to test that
				local trace = util.TraceLine(Tracey)
				
				if trace.Hit and trace.Entity and ValidEntity(trace.Entity) and not trace.Entity:IsPlayer() then
					CanMove = false
					SpectatePosition = trace.Entity:GetPos()
					SaveAngles = LocalPlayer():GetAimVector():Angle()
					SpecEntSaveAngle = trace.Entity:EyeAngles()
					SpecEnt = trace.Entity
					fnotify("Now spectating an entity")
				elseif trace.Hit and trace.Entity and ValidEntity(trace.Entity) and trace.Entity:IsPlayer() then
					CanMove = false
					SpectatePosition = trace.Entity:GetShootPos()
					SpecEnt = trace.Entity
					fnotify("Now spectating " .. trace.Entity:Name())
				end
			elseif not CanMove then
				CanMove = true
				if SpecEnt:IsPlayer() then
					SpecEnt:SetNoDraw(false)
					SpectatePosition = SpecEnt:GetShootPos()
					LocalPlayer():SetEyeAngles(SpecEnt:EyeAngles())
				else
					local ang = SpecEnt:EyeAngles()
					SpectatePosition = SpecEnt:GetPos() - (Angle(ang.p, ang.y, ang.r + 180) + SaveAngles ):Forward() * ThPDist
					LocalPlayer():SetEyeAngles((SpecEnt:GetPos() - SpectatePosition):Angle())
					SpectatePosition = SpecEnt:GetPos()
				end
				fnotify("Stopped spectating object")
			end
			return true
		end
	end
end
hook.Add("PlayerBindPress", "FSpectateBindPresses", BindPresses)

local function DoMove(what)
	if CanMove then
		if string.find(what, "forward") then // todo
			SpectatePosition = SpectatePosition + LocalPlayer():GetAimVector() * speed
		elseif string.find(what, "back") then
			SpectatePosition = SpectatePosition - LocalPlayer():GetAimVector() * speed
		elseif string.find(what, "moveleft") then
			SpectatePosition = SpectatePosition - LocalPlayer():GetAimVector():Angle():Right() * speed
		elseif string.find(what, "moveright") then
			SpectatePosition = SpectatePosition + LocalPlayer():GetAimVector():Angle():Right() * speed
		elseif string.find(what, "jump") then
			SpectatePosition = SpectatePosition + Vector(0,0,speed)
		elseif string.find(what, "duck") then
			SpectatePosition = SpectatePosition - Vector(0,0,speed)
		end
	elseif not CanMove then
		if string.find(what, "forward") then // todo
			SaveAngles = SaveAngles + Angle(0.1 * speed, 0, 0)
		elseif string.find(what, "back") then
			SaveAngles = SaveAngles - Angle(0.1 * speed, 0, 0)
		elseif string.find(what, "moveleft") then
			SaveAngles = SaveAngles - Angle(0, 0.1 * speed, 0)
		elseif string.find(what, "moveright") then
			SaveAngles = SaveAngles + Angle(0, 0.1 * speed, 0)
		elseif string.find(what, "jump") then
			ThPDist = ThPDist + 0.5 * speed
		elseif string.find(what, "duck") and ThPDist > 0 then
			ThPDist = ThPDist - 0.5 * speed
		end
	end
end

local function FSpecThink()
	if IsSpectating then
		if ValidEntity(SelfModel) then
			SelfModel:SetPos(LocalPlayer():GetPos())
			local ang = LocalPlayer():EyeAngles()
			SelfModel:SetAngles(Angle(0, ang.y, 0))
		end
		for k,v in pairs(holding) do
			if v then
				DoMove(k)
			end
		end
	end
end
hook.Add("Think", "FSpectateThink", FSpecThink)

local function FSpecCalcViewPosition(ply, origin, angles, fov)
	if IsSpectating then
		local view = {}
		if not CanMove and not ValidEntity(SpecEnt) then
			CanMove = true
		end
		if not CanMove and not SpecEnt:IsPlayer() then
			local ang = SpecEnt:EyeAngles()
			local pos = SpecEnt:GetPos() - (Angle(ang.p, ang.y, ang.r + 180) + SaveAngles ):Forward() * ThPDist
			view.angles = (SpecEnt:GetPos() - pos):Angle()
			view.origin = pos
		elseif not CanMove and SpecEnt:IsPlayer() then
			view.angles = SpecEnt:EyeAngles()
			view.origin = SpecEnt:GetShootPos()
			SpecEnt:SetNoDraw(true)
		elseif CanMove then
			view.angles = LocalPlayer():EyeAngles()
			view.origin = SpectatePosition
		end
		
		view.vm_origin = Vector(0,0,-13000)
		return view
	end
end
hook.Add("CalcView", "FSpectateCalcView", FSpecCalcViewPosition)

function FSpecScreens()
	local dat = {}
	for k,v in pairs(camsdata) do
		if not ValidEntity(v.obj) and v.obj == false then
			dat.origin = v.pos
			dat.angles = v.ang
			dat.y = 0
			dat.w = ScrW() / camsize:GetInt()
			dat.h = ScrH() / (0.75 * camsize:GetInt())
			if k <= camsize:GetInt() then
				dat.x = (k-1) * ScrW() / camsize:GetInt()
			elseif k > camsize:GetInt() and k <=2 * camsize:GetInt() then
				dat.y = ScrH() / (0.75 * camsize:GetInt())
				dat.x = (k - (camsize:GetInt() + 1)) * ScrW() / camsize:GetInt()
			elseif k > 2 * camsize:GetInt() then
				dat.y = 2 * (ScrH() / (0.75 * camsize:GetInt()))
				dat.x = (k - (2*camsize:GetInt()+1)) * ScrW() / camsize:GetInt()
			end
			render.RenderView( dat )
		elseif ValidEntity(v.obj) then
			dat.w = ScrW() / camsize:GetInt()
			dat.h = ScrH() / (0.75 * camsize:GetInt())
			dat.y = 0
			if k <= camsize:GetInt() then
				dat.x = (k-1) * ScrW() / camsize:GetInt()
			elseif k > camsize:GetInt() and k <=2 * camsize:GetInt() then
				dat.y = ScrH() / (0.75 * camsize:GetInt())
				dat.x = (k - (camsize:GetInt() + 1)) * ScrW() / camsize:GetInt()
			elseif k > 2 * camsize:GetInt() then
				dat.y = 2 * (ScrH() / (0.75 * camsize:GetInt()))
				dat.x = (k - (2*camsize:GetInt()+1)) * ScrW() / camsize:GetInt()
			end
			
			if v.obj:IsPlayer() then
				dat.origin = v.obj:GetShootPos()
				dat.angles = v.obj:EyeAngles()
				v.obj:SetNoDraw(true)
				render.RenderView( dat )
				v.obj:SetNoDraw(false)
			else
				local pos = v.obj:GetPos() - (v.obj:EyeAngles() + v.ang ):Forward() * v.dist
				dat.origin = pos
				dat.angles = (v.obj:GetPos() - pos):Angle()
				render.RenderView( dat )
			end
			
		elseif not ValidEntity(v.obj) and v.obj ~= false then
			local temp = {}
			camsdata[k] = nil
			for k,v in pairs(camsdata) do
				table.insert(temp, v)
			end
			camsdata = {}
			for k,v in pairs(temp) do
				table.insert(camsdata, v)
			end 
			dat[k] = nil
		end
	end
	if #camsdata > 0 then
		draw.RoundedBox(1, (ScrW() / 2) - 1.5, (ScrH() / 2) - 1.5, 3, 3, Color(255,255,255,255))
	end
	
	if IsSpectating then
		surface.SetFont("HUDNumber")
		surface.SetTextColor(255,255,255,255)
		if CanMove then
			surface.SetTextPos( (ScrW() / 2) - 0.5*surface.GetTextSize("Free spectating"), ScrH() - 80)
			surface.DrawText("Free spectating")
		elseif not CanMove and SpecEnt:IsPlayer() then
			surface.SetTextPos( (ScrW() / 2) - 0.5*surface.GetTextSize("Spectating " .. SpecEnt:Name()), ScrH() - 80)
			surface.DrawText("Spectating " .. SpecEnt:Name())
		elseif not CanMove and not SpecEnt:IsPlayer() then
			surface.SetTextPos( (ScrW() / 2) - 0.5*surface.GetTextSize("Spectating an entity"), ScrH() - 80)
			surface.DrawText("Spectating an entity")
		end
	end
end
hook.Add("HUDPaint", "FSpectateScreensonScreen", FSpecScreens)

