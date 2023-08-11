


local CHair = CreateClientConVar("FESPCHair", 1, true, false)
local AimDotSize = CreateClientConVar("FESPAimDotSize", 4, true, false)
local AimDotBorder = CreateClientConVar("FESPAimDotBorder", 14, true, false)

local ESPOn = CreateClientConVar("FESP_TOGGLE", 1, true, false)
local MiddleAllign = CreateClientConVar("FESPMiddleAllign", 0, true, false)
local dotsize = CreateClientConVar("FESPDotSize", 10, true, false)
local bordersize = CreateClientConVar("FESPBorderSize", 1, true, false)
local FShowName = CreateClientConVar("FESPShowName", 1, true, false)
local FShowHealth = CreateClientConVar("FESPShowHealth", 1, true, false)
local FShowAdmin = CreateClientConVar("FESPShowAdmin", 1, true, false)
local FShowOwner = CreateClientConVar("FESPShowOwner", 1, true, false)
local FShowRPMoney = CreateClientConVar("FESPShowRPMoney", 1, true, false)
local FShowSpeed = CreateClientConVar("FESPShowSpeed", 0, true, false)
local FShowDistance = CreateClientConVar("FESPShowDistance", 1, true, false)
local FShowWeapon = CreateClientConVar("FESPShowWeapon", 1, true, false)
local FMirror = CreateClientConVar("FESPMirror", 0, true, false)
local FMirrorx = CreateClientConVar("FESPMirrorx", 0, true, false)
local FMirrory = CreateClientConVar("FESPMirrory", 0, true, false)
local FMirrorw = CreateClientConVar("FESPMirrorw", 300, true, false)
local FMirrorh = CreateClientConVar("FESPMirrorh", 300, true, false)

local CustomENTS = {}
local ESPPos = {}

local DingetjesLijst = CreateClientConVar("FESPAllHappyDingetjes", "", true, false)
local DrawLijst =  {}

local EntityShowTable = {}
if DingetjesLijst:GetString() ~= "" then
	EntityShowTable = string.Explode("|", DingetjesLijst:GetString())
end

local vector = FindMetaTable("Vector") 

 //THIS IS THE FIRST THING I HAVE EVER DONE WITH A METATABLE :D
function vector:IsInSight(v)
	local trace = {}
	trace.start = LocalPlayer():GetShootPos()
	trace.endpos = self	
	trace.filter = v
	trace.mask = -1
	local TheTrace = util.TraceLine(trace)
	if TheTrace.Hit then
		return false
	else
		return true
	end
end 

surface.CreateFont("ScoreboardText", 12, 1, false, true, "FALCO_TEST7")

local function NamesOnHeads()
	if ESPOn:GetInt() == 1 then
		for k,v in pairs(DrawLijst) do
			local pos = v.pos:ToScreen()
			if not v.IsLooking then
				draw.RoundedBox(1, pos.x - 0.5 * dotsize:GetInt(), pos.y - 0.5 * dotsize:GetInt() - #v.data * 20, dotsize:GetInt(),dotsize:GetInt(), Color(v.teamcolor.r,v.teamcolor.g,v.teamcolor.b))
			else
				draw.RoundedBox(1, pos.x - 0.5 * (dotsize:GetInt() + AimDotBorder:GetInt()), pos.y - 0.5 * dotsize:GetInt(), 0.5 * dotsize:GetInt() + AimDotSize:GetInt(), 0.5 * dotsize:GetInt() + AimDotSize:GetInt(), Color(v.teamcolor.r,v.teamcolor.g,v.teamcolor.b))
			end
			for a,b in pairs(v.data) do 
				if type(b) == "string" then
					local w = 1
					if MiddleAllign:GetInt() == 1 then
						w = string.len(b) * 2.3
					else 
						w = -0.5 * dotsize:GetInt() 
					end
					draw.WordBox(bordersize:GetInt(), pos.x - w - dotsize:GetInt() , (pos.y + (a-1) * (13 +  bordersize:GetInt()) + 0.5 * dotsize:GetInt()) - #v.data * 20 , b , "FALCO_TEST7", Color(0,0,0,50), Color(255, 255, 255, 255))
				end
			end
		end
		for k,v in pairs(ESPPos) do
			local pos = v:ToScreen()
			draw.RoundedBox(1, pos.x - 0.5 * dotsize:GetInt(), pos.y - 0.5 * dotsize:GetInt(), dotsize:GetInt(),dotsize:GetInt(), Color(255,0,0,255))
		end
	end
	if FMirror:GetInt() == 1 then
		local CamData = {} 
		local ang = LocalPlayer():EyeAngles()
		CamData.angles = Angle(ang.p - ang.p - ang.p, ang.y - 180, ang.r)
		CamData.origin = LocalPlayer():GetShootPos()
		CamData.x = FMirrorx:GetInt()
		CamData.y = FMirrory:GetInt()
		CamData.w = FMirrorw:GetInt()
		CamData.h = FMirrorh:GetInt()
		render.RenderView( CamData )
		draw.RoundedBox(1, (ScrW() / 2) - 1.5, (ScrH() / 2) - 1.5, 3, 3, Color(255,255,255,255))
	end
end
hook.Add("HUDPaint", "FESP2", NamesOnHeads)

local function FESPAddEnt(ent, id)
	CustomENTS[id or (#CustomENTS + 1)] = ent
end

local function FESPRemoveEnt(id)
	CustomENTS[id] = nil
end

local function FESPClearEnt()
	CustomENTS = {}
end

local function FESPAddPos(vector)
	table.insert(ESPPos, vector)
end

local function FESPClearPos()
	ESPPos = {}
end

local function AddEntityToShow(ply, cmd, args)
	table.insert(EntityShowTable, tostring(args[1]))
	local newstring = table.concat(EntityShowTable, "|")
	RunConsoleCommand("FESPAllHappyDingetjes", newstring)
end
concommand.Add("FESPAddEntity", AddEntityToShow)

local function RemoveEntityToShow(ply, cmd, args)
	for k,v in pairs(EntityShowTable) do 
		if string.lower(v) == string.lower(tostring(args[1])) then
			table.remove(EntityShowTable, k)
			local newstring = table.concat(EntityShowTable, "|")
			if table.Count(EntityShowTable) > 0 then
				RunConsoleCommand("FESPAllHappyDingetjes", newstring)
			else
				RunConsoleCommand("FESPAllHappyDingetjes", "")
			end
		end
	end
end
concommand.Add("FESPRemoveEntity", RemoveEntityToShow)

local function HeadPos(ent)
	if not ValidEntity(ent) then return Vector(0,0,0) end
	local head = ent:LookupAttachment("eyes")
	if not ent:GetAttachment(head) then
		return ent:GetShootPos()
	end
	return ent:GetAttachment(head).Pos
end	

local NoLookingAtWeapons = {"weapon_physgun", "weapon_physcannon", "gmod_camera", "keys", "pocket"}
local tick = 0
local function FESPThink()
	if ESPOn:GetInt() == 1 then
		for k,v in pairs(player.GetAll()) do 
			if v ~= LocalPlayer() and v:Alive() then
				local a = {}
				local teamcolor = team.GetColor(v:Team())
				local wep = v:GetActiveWeapon()
				a.data = {}
				if FShowName:GetInt() == 1 then
					table.insert(a.data, v:Nick())
				end
				if FShowHealth:GetInt() == 1 then
					table.insert(a.data, "Health: " .. tostring(v:Health()))
				end
				if FShowRPMoney:GetInt() == 1 and v:GetNetworkedInt("money") ~= 0 then
					table.insert(a.data, "Money: " .. tostring(v:GetNetworkedInt("money")))
				end
				local speed = math.floor(v:GetVelocity():Length())
				if FShowSpeed:GetInt() == 1 and speed > 0 then
					table.insert(a.data, "Speed: " .. tostring(speed))
				end
				if FShowWeapon:GetInt() == 1 and wep:IsValid() then
					table.insert(a.data, wep:GetPrintName())
				end
				
				a.pos = HeadPos(v)
				if FShowDistance:GetInt() == 1 then
					table.insert(a.data, "Distance: " .. tostring(math.floor(a.pos:Distance(LocalPlayer():GetPos()))))
				end
				
				a.teamcolor = {}
				if v:IsAdmin() and not v:IsSuperAdmin() then
					if FShowAdmin:GetInt() == 1 then
						table.insert(a.data,"Admin")
					end
					if teamcolor.r == 255 and teamcolor.g == 255 and teamcolor.b == 100 then
						a.teamcolor.r = 30 
						a.teamcolor.g = 200
						a.teamcolor.b = 50
					else
						a.teamcolor.r = teamcolor.r 
						a.teamcolor.g = teamcolor.g
						a.teamcolor.b = teamcolor.b
					end
				elseif v:IsSuperAdmin() then
					if FShowAdmin:GetInt() == 1 then
						table.insert(a.data, "Super Admin")
					end
					if teamcolor.r == 255 and teamcolor.g == 255 and teamcolor.b == 100 then
						a.teamcolor.r = 30 
						a.teamcolor.g = 200
						a.teamcolor.b = 50
					else
						a.teamcolor.r = teamcolor.r 
						a.teamcolor.g = teamcolor.g
						a.teamcolor.b = teamcolor.b
					end
				elseif not v:IsAdmin() then
					if teamcolor.r == 255 and teamcolor.g == 255 and teamcolor.b == 100 then
						a.teamcolor.r = 100 
						a.teamcolor.g = 150
						a.teamcolor.b = 245
					else
						a.teamcolor.r = teamcolor.r 
						a.teamcolor.g = teamcolor.g
						a.teamcolor.b = teamcolor.b
					end
				end
				
				DrawLijst[v:EntIndex()] = a
				
				--hex
				if CHair:GetInt() == 1 then
					local b = {}
					b.data = {}
					b.teamcolor = {}
					b.teamcolor.r = a.teamcolor.r 
					b.teamcolor.g = a.teamcolor.g
					b.teamcolor.b = a.teamcolor.b
					b.IsLooking = true
					local lookat1 = v:GetEyeTrace()
					local lookat = lookat1.HitPos
					b.pos = lookat
					if FShowName:GetInt() == 1 then
						table.insert(b.data, v:Nick())
					end
					DrawLijst[tostring(v:EntIndex()) .. "look"] = b
				end
				--/hex
				
				
			end
			

			if DingetjesLijst:GetString() ~= "" then
				for k,v in pairs(ents.GetAll()) do
					for a, b in pairs(EntityShowTable) do
						local a = {}
						if v:IsValid() and string.find(v:GetClass(), b)  then
							local pos = v:GetPos()
							a.data = {}
							if FShowName:GetInt() == 1 then
								table.insert(a.data, v:GetClass())
							end
							a.pos = pos
							a.teamcolor = Color(255,255,255,255)
							local owner = v:GetNWString("Owner")
							if FShowOwner:GetInt() == 1 and owner ~= "" then
								table.insert(a.data, owner)
							end
							local speed = math.floor(v:GetVelocity():Length())
							if FShowSpeed:GetInt() == 1 and speed > 0 then
								table.insert(a.data, "speed: " .. tostring(speed))
							end
							
							if FShowDistance:GetInt() == 1 then
								table.insert(a.data, "Distance: " .. tostring(math.floor(a.pos:Distance(LocalPlayer():GetPos()))))
							end
							DrawLijst[v:EntIndex()] = a
						end
					end 
				end
			end
			
			for k,v in pairs(CustomENTS) do
				if not ValidEntity(v) then CustomENTS[k] = nil return end
				local a = {}
				a.data = {}
				table.insert(a.data, v:GetClass())
				a.pos = v:GetPos()
				a.teamcolor = Color(255,0,0,255)
				local owner = v:GetNWString("Owner")
				if FShowOwner:GetInt() == 1 and owner ~= "" then
					table.insert(a.data, owner)
				end
				local speed = math.floor(v:GetVelocity():Length())
				if FShowSpeed:GetInt() == 1 and speed > 0 then
					table.insert(a.data, "speed: " .. tostring(speed))
				end
				if FShowDistance:GetInt() == 1 then
					table.insert(a.data, "Distance: " .. tostring(math.floor(a.pos:Distance(LocalPlayer():GetPos()))))
				end
				DrawLijst[v:EntIndex()] = a
			end
			tick = tick + 1
			if tick > 1000 then
				for k,v in pairs(DrawLijst) do
					DrawLijst = {}
				end
				tick = 0
			end
		end
	end
end
hook.Add("Think", "NamesOnHeads2_FESPThink", FESPThink)


function FESPVgui()
	local frame = vgui.Create( "DFrame" )
	frame:SetTitle( "FESP config" )
	--frame:SetSize(280,660)
	frame:SetSize(280,900)
	frame:Center()
	frame:SetVisible( true )
	frame:MakePopup()
	
	local Panel = vgui.Create( "DPanelList", frame )
	Panel:SetPos(20,30)
	Panel:SetSize(240, 850)
	Panel:SetSpacing(5)
	Panel:EnableHorizontal( false )
	Panel:EnableVerticalScrollbar( true )
	
	local ToggleEsp = vgui.Create( "DCheckBoxLabel", frame )
	ToggleEsp:SetText("Toggle FESP")
	ToggleEsp:SetConVar("FESP_TOGGLE")
	Panel:AddItem(ToggleEsp)
	
	local ShowName = vgui.Create( "DCheckBoxLabel", frame )
	ShowName:SetText("Show names")
	ShowName:SetConVar("FESPShowName")
	Panel:AddItem(ShowName)
	
	local ShowHealth = vgui.Create( "DCheckBoxLabel", frame )
	ShowHealth:SetText("Show health")
	ShowHealth:SetConVar("FESPShowHealth")
	Panel:AddItem(ShowHealth)
	
	local ShowAdmin = vgui.Create( "DCheckBoxLabel", frame )
	ShowAdmin:SetText("Show admin")
	ShowAdmin:SetConVar("FESPShowAdmin")
	Panel:AddItem(ShowAdmin)
	
	local ShowOwner = vgui.Create( "DCheckBoxLabel", frame )
	ShowOwner:SetText("Show owner")
	ShowOwner:SetConVar("FESPShowOwner")
	Panel:AddItem(ShowOwner)
	
	local ToggleChair = vgui.Create( "DCheckBoxLabel", frame )
	ToggleChair:SetText("Show what they're looking at")
	ToggleChair:SetConVar("FESPCHair")
	Panel:AddItem(ToggleChair)
	
	
	local AimDotSizeVGUI = vgui.Create("DNumSlider", frame)
	AimDotSizeVGUI:SetValue(AimDotSize:GetInt())
	AimDotSizeVGUI:SetConVar("FESPAimDotSize")
	AimDotSizeVGUI:SetMin(0)
	AimDotSizeVGUI:SetMax(50)
	AimDotSizeVGUI:SetText("Aim dot size")
	AimDotSizeVGUI:SetDecimals(0)
	Panel:AddItem(AimDotSizeVGUI)
	
	local AimDotBorderVGUI = vgui.Create("DNumSlider", frame)
	AimDotBorderVGUI:SetValue(AimDotBorder:GetInt())
	AimDotBorderVGUI:SetConVar("FESPAimDotBorder")
	AimDotBorderVGUI:SetMin(0)
	AimDotBorderVGUI:SetMax(50)
	AimDotBorderVGUI:SetText("Aim dot border")
	AimDotBorderVGUI:SetDecimals(0)
	Panel:AddItem(AimDotBorderVGUI)
	
	
	local ToggleRPMoney = vgui.Create( "DCheckBoxLabel", frame )
	ToggleRPMoney:SetText("Show their money(DarkRP)")
	ToggleRPMoney:SetConVar("FESPShowRPMoney")
	Panel:AddItem(ToggleRPMoney)
	
	local ToggleSpeed = vgui.Create( "DCheckBoxLabel", frame )
	ToggleSpeed:SetText("Show their speed")
	ToggleSpeed:SetConVar("FESPShowSpeed")
	Panel:AddItem(ToggleSpeed)
	
	local ToggleDistance = vgui.Create( "DCheckBoxLabel", frame )
	ToggleDistance:SetText("Show the Distance")
	ToggleDistance:SetConVar("FESPShowDistance")
	Panel:AddItem(ToggleDistance)

	local ToggleWeapon = vgui.Create( "DCheckBoxLabel", frame )
	ToggleWeapon:SetText("Show the Weapon")
	ToggleWeapon:SetConVar("FESPShowWeapon")
	Panel:AddItem(ToggleWeapon)
	
	local AllignMiddle = vgui.Create( "DCheckBoxLabel", frame )
	AllignMiddle:SetText("Allign in the middle")
	AllignMiddle:SetConVar("FESPMiddleAllign")
	Panel:AddItem(AllignMiddle)
	
	
	local mirrorbutton = vgui.Create( "DButton", frame)
	mirrorbutton:SetText( "Mirror" )
	mirrorbutton:SetSize(220, 20)
	function mirrorbutton:DoClick()
		frame:SetVisible(false)
		RunConsoleCommand("Falco_Mirror")
	end	
	Panel:AddItem(mirrorbutton)
	
	local dotsizeslider = vgui.Create( "DNumSlider", frame )
	dotsizeslider:SetValue(dotsize:GetInt())
	dotsizeslider:SetConVar("FESPDotSize")
	dotsizeslider:SetMin(0)
	dotsizeslider:SetMax(50)
	dotsizeslider:SetText("The size of the dots")
	dotsizeslider:SetDecimals(0)
	Panel:AddItem(dotsizeslider)
	
	local bordersizeslider = vgui.Create( "DNumSlider", frame )
	bordersizeslider:SetValue(bordersize:GetInt())
	bordersizeslider:SetConVar("FESPBorderSize")
	bordersizeslider:SetMin(0)
	bordersizeslider:SetMax(50)
	bordersizeslider:SetText("The size of the borders around the text")
	bordersizeslider:SetDecimals(0)
	Panel:AddItem(bordersizeslider)
	
	local EntList = vgui.Create("DListView", frame)
	--EntList:SetSize(260, 70)
	EntList:SetSize(260, 250)
	EntList:AddColumn("FESP shows these entities:")
	EntList:SetMultiSelect(false)
	for k,v in pairs(EntityShowTable) do
		EntList:AddLine(v)
	end
	function EntList:OnClickLine(line)
		line:SetSelected(true)
		RunConsoleCommand("FESPRemoveEntity", line:GetValue(1))
		EntList:RemoveLine(EntList:GetSelectedLine())
	end
	
	local AddEntLabel = vgui.Create( "DLabel", frame )
	AddEntLabel:SetText("\nSelect custom entities\nto make FESP show\nuse the ClassName of the ent(advanced)")
	AddEntLabel:SizeToContents()
	Panel:AddItem(AddEntLabel)
	
	local AddEntTextEntry = vgui.Create("DTextEntry", frame)
	local notagain = notagain or 0
	function AddEntTextEntry:OnEnter()
		if notagain < RealTime() then	
			local text = AddEntTextEntry:GetValue()
			EntList:AddLine(text)
			RunConsoleCommand("FESPAddEntity", text)
			AddEntTextEntry:SetText("")
			AddEntTextEntry:RequestFocus( )
			notagain = RealTime() + 0.1
		end
	end
	Panel:AddItem(AddEntTextEntry)
	
	
	local AddEntLabel2 = vgui.Create( "DLabel", frame )
	AddEntLabel2:SetText("\nLook at something\nClick the next button\nAnd FESP will detect all of his kind")
	AddEntLabel2:SizeToContents()
	Panel:AddItem(AddEntLabel2)
	
	local AddLookingAtButton = vgui.Create("DButton", frame)
	AddLookingAtButton:SetText("Add Looking at")
	function AddLookingAtButton:DoClick( ) 
		local trace = LocalPlayer():GetEyeTrace()
		if trace.Hit and trace.Entity:IsValid() then
			RunConsoleCommand("FESPAddEntity", trace.Entity:GetClass())
			EntList:AddLine(trace.Entity:GetClass())
		end
	end
	Panel:AddItem(AddLookingAtButton)
	Panel:AddItem(EntList)
end
concommand.Add("FESPConfig", FESPVgui)

local function fmirrorderma()
	local frame = vgui.Create( "DFrame" )
	frame:SetTitle( "FESP miror config" )
	frame:SetSize( 300, 300 ) 
	frame:Center()
	frame:SetVisible( true )
	frame:MakePopup( )
	
	local Panel = vgui.Create( "DPanelList", frame )
	Panel:SetPos(20,30)
	Panel:SetSize(260, 260)
	Panel:SetSpacing(5)
	Panel:EnableHorizontal( false )
	Panel:EnableVerticalScrollbar( true )
	
	local Mirror = vgui.Create( "DCheckBoxLabel", frame )
	Mirror:SetText("Enable mirror")
	Mirror:SetConVar("FESPMirror")
	Panel:AddItem(Mirror)
	
	local slidermirrorx = vgui.Create( "DNumSlider", frame )
	slidermirrorx:SetValue(FMirrorx:GetInt())
	slidermirrorx:SetConVar("FESPMirrorx")
	slidermirrorx:SetMin(0)
	slidermirrorx:SetMax(ScrW())
	slidermirrorx:SetText("Mirror X position")
	slidermirrorx:SetDecimals(0)
	Panel:AddItem(slidermirrorx)
	function slidermirrorx:Think()
		slidermirrorx:SetMax(ScrW() - FMirrorw:GetInt())
	end
	local slidermirrory = vgui.Create( "DNumSlider", frame )
	slidermirrory:SetValue(FMirrory:GetInt())
	slidermirrory:SetConVar("FESPMirrory")
	slidermirrory:SetMin(0)
	slidermirrory:SetMax(ScrH())
	slidermirrory:SetText("Mirror Y position")
	slidermirrory:SetDecimals(0)
	Panel:AddItem(slidermirrory)
	function slidermirrory:Think()
		slidermirrory:SetMax(ScrH() - FMirrorh:GetInt())
	end
	
	local slidermirrorw = vgui.Create( "DNumSlider", frame )
	slidermirrorw:SetValue(FMirrorw:GetInt())
	slidermirrorw:SetConVar("FESPMirrorw")
	slidermirrorw:SetMin(0)
	slidermirrorw:SetMax(ScrW())
	slidermirrorw:SetText("Mirror width")
	slidermirrorw:SetDecimals(0)
	Panel:AddItem(slidermirrorw)
	
	local slidermirrorh = vgui.Create( "DNumSlider", frame )
	slidermirrorh:SetValue(FMirrorh:GetInt())
	slidermirrorh:SetConVar("FESPMirrorh")
	slidermirrorh:SetMin(0)
	slidermirrorh:SetMax(ScrH())
	slidermirrorh:SetText("Mirror height")
	slidermirrorh:SetDecimals(0)
	Panel:AddItem(slidermirrorh)
end
concommand.Add("Falco_Mirror", fmirrorderma)



