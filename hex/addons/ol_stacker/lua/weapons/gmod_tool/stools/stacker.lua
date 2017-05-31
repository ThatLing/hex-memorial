
----------------------------------------
--         2014-07-12 20:33:12          --
------------------------------------------
TOOL.Category		= "Construction"
TOOL.Name			= "#Tool.stacker.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "freeze" ]	 	= "0"
TOOL.ClientConVar[ "weld" ]	 	= "0"
TOOL.ClientConVar[ "nocollide" ]	= "0"
TOOL.ClientConVar[ "mode" ] 		= "1"
TOOL.ClientConVar[ "dir" ] 		= "1"
TOOL.ClientConVar[ "count" ] 		= "1"
TOOL.ClientConVar[ "model" ] 		= ""
TOOL.ClientConVar[ "offsetx" ] 		= "0"
TOOL.ClientConVar[ "offsety" ] 		= "0"
TOOL.ClientConVar[ "offsetz" ] 		= "0"
TOOL.ClientConVar[ "rotp" ] 		= "0"
TOOL.ClientConVar[ "roty" ] 		= "0"
TOOL.ClientConVar[ "rotr" ] 		= "0"
TOOL.ClientConVar[ "recalc" ] 		= "0"
TOOL.ClientConVar[ "ghostall" ]		= "1"
TOOL.ClientConVar[ "halo" ]			= "0"

if SERVER then
	util.AddNetworkString("StackGhost")
	util.AddNetworkString("UnstackGhost")
end

if ( CLIENT ) then
	language.Add( "Tool.stacker.name", "Stacker" )
	language.Add( "Tool.stacker.desc", "Stacks Props Easily" )
	language.Add( "Tool.stacker.0", "Click To Stack The Prop You're Pointing At." )
	language.Add( "Undone_stacker", "Undone Stacked Prop(s)" )
end

function TOOL:Holster()
	self:ReleaseGhostStack()
end

function TOOL:Deploy()
//	self.StackedEnts = {}
end

function TOOL:LeftClick(trace)
	if !trace.Entity || !trace.Entity:IsValid() || trace.Entity:GetClass() != "prop_physics" then return false end
	if CLIENT then return true end

	local Freeze		= self:GetClientNumber( "freeze" ) == 1
	local Weld		= self:GetClientNumber( "weld" ) == 1
	local NoCollide		= self:GetClientNumber( "nocollide" ) == 1
	local Mode		= self:GetClientNumber( "mode" )
	local Dir		= self:GetClientNumber( "dir" )
	local Count		= self:GetClientNumber( "count" )
	local OffsetX		= self:GetClientNumber( "offsetx" )
	local OffsetY		= self:GetClientNumber( "offsety" )
	local OffsetZ		= self:GetClientNumber( "offsetz" )
	local RotP		= self:GetClientNumber( "rotp" )
	local RotY		= self:GetClientNumber( "roty" )
	local RotR		= self:GetClientNumber( "rotr" )
	local Recalc		= self:GetClientNumber( "recalc" ) == 1
	
	
	Dir 		= math.Clamp(Dir, 0, 5)
	Count 		= math.Clamp(Count, 1, 25)
	
	OffsetX 	= math.Clamp(OffsetX, -500, 500)
	OffsetY 	= math.Clamp(OffsetY, -500, 500)
	OffsetZ 	= math.Clamp(OffsetZ, -500, 500)
	
	RotP 		= math.Clamp(RotP, 0, 360)
	RotY 		= math.Clamp(RotY, 0, 360)
	RotR 		= math.Clamp(RotR, 0, 360)
	
	local Offset		= Vector(OffsetX, OffsetY, OffsetZ)
	local Rot		= Angle(RotP, RotY, RotR)

	local ply = self:GetOwner()
	local Ent = trace.Entity

	local NewVec = Ent:GetPos()
	local NewAng = Ent:GetAngles()
	local LastEnt = Ent

	//SimpleAdmin:Broadcast("COUNT IS " .. Count)
	if Count <= 0 then return false end
	
	undo.Create("stacker")
	for i=1, Count, 1 do
		if (!self:GetSWEP():CheckLimit("props")) then break end

		if i == 1 || (Mode == 2 && Recalc == true) then
			StackDir, Height, ThisOffset = self:StackerCalcPos(LastEnt, Mode, Dir, Offset)
		end
		
		NewVec = NewVec + StackDir * Height + ThisOffset
		NewAng = NewAng + Rot

		if !Ent:IsInWorld() then
			return false //Who put just break here? Seriously? Giving the player no hint he/she's not supposed to do that?
		end

	//	local EntList = ents.FindInSphere(NewVec, .2) //Searching in a sphere and find props
	//	local PropValid = true						//Flag if prop is found or not
	//	for k, v in pairs(EntList) do				//For loop
	//		if (v:IsValid() && v:GetClass() == "prop_physics" && (v == LastEnt )) then//|| v:GetPos() == NewVec)) then
	//			if (self:IsInGhostStack(v)) then continue end
	//			PropValid = false
	//		end
	//	end
	//	if !PropValid then return false end

		NewEnt = ents.Create("prop_physics")
			NewEnt:SetModel(Ent:GetModel())
			NewEnt:SetColor(Ent:GetColor())
			NewEnt:SetPos(NewVec)
			NewEnt:SetAngles(NewAng)
			NewEnt:Spawn()
			if Freeze then
				ply:AddFrozenPhysicsObject(NewEnt, NewEnt:GetPhysicsObject()) //Fix so you can mass-unfreeze
				NewEnt:GetPhysicsObject():EnableMotion(false)
			else
				NewEnt:GetPhysicsObject():Wake()
			end

		if Weld then
			local WeldEnt = constraint.Weld( LastEnt, NewEnt, 0, 0, 0 )
			undo.AddEntity(WeldEnt)
		end

		if NoCollide then
			local NoCollideEnt = constraint.NoCollide(LastEnt, NewEnt, 0, 0)
			undo.AddEntity(NoCollideEnt)
		end
		
		LastEnt = NewEnt
		undo.AddEntity(NewEnt)
		ply:AddCount("props", NewEnt)
		ply:AddCleanup("props", NewEnt)

		if PropDefender && PropDefender.Player && PropDefender.Player.Give then
			PropDefender.Player.Give(ply, NewEnt, false)
		end

		//table.insert(self.StackedEnts, NewEnt)
	end
	undo.SetPlayer(ply)
	undo.Finish()

	return true
end

function TOOL:StackerCalcPos(lastent, mode, dir, offset)
	local forward = Vector(1,0,0):Angle()
	local pos = lastent:GetPos()
	local ang = lastent:GetAngles()

	local lower, upper = lastent:WorldSpaceAABB( )
	local glower = lastent:OBBMins()
	local gupper = lastent:OBBMaxs()
	
	local stackdir = Vector(0,0,1)
	local height = math.abs(upper.z - lower.z)

	if mode == 1 then // Relative to world
		if dir == 1 then
			stackdir = forward:Up()
			height = math.abs(upper.z - lower.z)
		elseif dir == 2 then
			stackdir = forward:Up() * -1
			height = math.abs(upper.z - lower.z)
		elseif dir == 3 then
			stackdir = forward:Forward()
			height = math.abs(upper.x - lower.x)
		elseif dir == 4 then
			stackdir = forward:Forward() * -1
			height = math.abs(upper.x - lower.x)
		elseif dir == 5 then
			stackdir = forward:Right()
			height = math.abs(upper.y - lower.y)
		elseif dir == 6 then
			stackdir = forward:Right() * -1
			height = math.abs(upper.y - lower.y)
		end
	elseif mode == 2 then // Relative to prop
		forward = ang
		if dir == 1 then
			stackdir = forward:Up()
			offset = forward:Up() * offset.X + forward:Forward() * -1 * offset.Z + forward:Right() * offset.Y
			height = math.abs(gupper.z - glower.z)
		elseif dir == 2 then
			stackdir = forward:Up() * -1
			offset = forward:Up() * -1 * offset.X + forward:Forward() * offset.Z + forward:Right() * offset.Y
			height = math.abs(gupper.z - glower.z)
		elseif dir == 3 then
			stackdir = forward:Forward()
			offset = forward:Forward() * offset.X + forward:Up() * offset.Z + forward:Right() * offset.Y
			height = math.abs(gupper.x - glower.x)
		elseif dir == 4 then
			stackdir = forward:Forward() * -1
			offset = forward:Forward() * -1 * offset.X + forward:Up() * offset.Z + forward:Right() * -1 * offset.Y
			height = math.abs(gupper.x - glower.x)
		elseif dir == 5 then
			stackdir = forward:Right()
			offset = forward:Right() * offset.X + forward:Up() * offset.Z + forward:Forward() * -1 * offset.Y
			height = math.abs(gupper.y - glower.y)
		elseif dir == 6 then
			stackdir = forward:Right() * -1
			offset = forward:Right() * -1 * offset.X + forward:Up() * offset.Z + forward:Forward() * offset.Y
			height = math.abs(gupper.y - glower.y)
		end
	end //offset = (stackdir:Angle():Up() * offset.Z) + (stackdir:Angle():Forward() * offset.X) + (stackdir:Angle():Right() * offset.Y)
	
	return stackdir, height, offset
end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl("Header", { Text = "#Tool.stacker.name", Description	= "#Tool.stacker.desc" })
	
	CPanel:AddControl( "Checkbox", { Label = "Freeze Props", Command = "stacker_freeze" } )
	CPanel:AddControl( "Checkbox", { Label = "Weld Props", Command = "stacker_weld" } )	
	CPanel:AddControl( "Checkbox", { Label = "No Collide Props", Command = "stacker_nocollide" } )

	local params = {Label = "Relative To:", MenuButton = "0", Options = {}}
	params.Options["World"] = {stacker_mode = "1"}
	params.Options["Prop"] = {stacker_mode = "2"}
	CPanel:AddControl( "ComboBox", params )

	local params = {Label = "Stack Direction", MenuButton = "0", Options = {}}
	params.Options["Up"] = {stacker_dir = "1"}
	params.Options["Down"] = {stacker_dir = "2"}
	params.Options["Front"] = {stacker_dir = "3"}
	params.Options["Behind"] = {stacker_dir = "4"}
	params.Options["Right"] = {stacker_dir = "5"}
	params.Options["Left"] = {stacker_dir = "6"}
	CPanel:AddControl( "ComboBox", params )

	CPanel:AddControl( "Slider",  { Label	= "Count",
					Type	= "Integer",
					Min		= 1,
					Max		= 25,
					Command = "stacker_count",
					Description = "How many props to stack."}	 )

	CPanel:AddControl( "Header", { Text = "Advanced Options", Description	= "These options are for advanced users. Leave them all default (0) if you don't understand what they do." }  )
	CPanel:AddControl( "Button",  { Label	= "Reset Advanced Options",
					Command = "stacker_resetoffsets",
					Text = "Reset"}	 )
	CPanel:AddControl( "Slider",  { Label	= "Offset X (forward/back)",
					Type	= "Float",
					Min		= -1000,
					Max		= 1000,
					Value	= 0,
					Command = "stacker_offsetx"}	 )
	CPanel:AddControl( "Slider",  { Label	= "Offset Y (right/left)",
					Type	= "Float",
					Min		= -1000,
					Max		= 1000,
					Value	= 0,
					Command = "stacker_offsety"}	 )
	CPanel:AddControl( "Slider",  { Label	= "Offset Z (up/down)",
					Type	= "Float",
					Min		= -1000,
					Max		= 1000,
					Value	= 0,
					Command = "stacker_offsetz"}	 )
	CPanel:AddControl( "Slider",  { Label	= "Rotate Pitch",
					Type	= "Float",
					Min		= -360,
					Max		= 360,
					Value	= 0,
					Command = "stacker_rotp"}	 )
	CPanel:AddControl( "Slider",  { Label	= "Rotate Yaw",
					Type	= "Float",
					Min		= -360,
					Max		= 360,
					Value	= 0,
					Command = "stacker_roty"}	 )
	CPanel:AddControl( "Slider",  { Label	= "Rotate Roll",
					Type	= "Float",
					Min		= -360,
					Max		= 360,
					Value	= 0,
					Command = "stacker_rotr"}	 )
	CPanel:AddControl( "Checkbox", { Label = "Stack relative to new rotation", Command = "stacker_recalc", Description = "If this is checked, each item in the stack will be stacked relative to the previous item in the stack. This allows you to create curved stacks." } )
	CPanel:AddControl("Checkbox", {Label = "Ghost ALL of the props?", Command = "stacker_ghostall", Description = "Ghost all of the props specified by count"})
	CPanel:AddControl("Checkbox", {Label = "Give ghosted props halos?", Command = "stacker_halo", Description = "Give the ghost a halo"})
end

if (CLIENT) then
	local function ResetOffsets(ply, command, arguments)
		-- Reset all of the offset options to 0
		LocalPlayer():ConCommand("stacker_offsetx 0\n")
		LocalPlayer():ConCommand("stacker_offsety 0\n")
		LocalPlayer():ConCommand("stacker_offsetz 0\n")
		LocalPlayer():ConCommand("stacker_rotp 0\n")
		LocalPlayer():ConCommand("stacker_roty 0\n")
		LocalPlayer():ConCommand("stacker_rotr 0\n")
		LocalPlayer():ConCommand("stacker_recalc 0\n")
	end
	concommand.Add( "stacker_resetoffsets", ResetOffsets )
end

function TOOL:UpdateGhostStack(ent)
	if (!ent || !ent:IsValid() || !self:CheckGhostStack()) then return end

	local mode		= self:GetClientNumber( "mode" )
	local dir		= self:GetClientNumber( "dir" )
	local offsetx		= self:GetClientNumber( "offsetx" )
	local offsety		= self:GetClientNumber( "offsety" )
	local offsetz		= self:GetClientNumber( "offsetz" )
	local rotp		= self:GetClientNumber( "rotp" )
	local roty		= self:GetClientNumber( "roty" )
	local rotr		= self:GetClientNumber( "rotr" )
	local offset		= Vector(offsetx, offsety, offsetz)
	local rot		= Angle(rotp, roty, rotr)
	local count = self:GetClientNumber("count")
	local recalc		= self:GetClientNumber( "recalc" ) == 1
	
	dir 		= math.Clamp(dir, 0, 5)
	count 		= math.Clamp(count, 1, 25)
	
	offsetx 	= math.Clamp(offsetx, -500, 500)
	offsety 	= math.Clamp(offsety, -500, 500)
	offsetz 	= math.Clamp(offsetz, -500, 500)
	
	rotp 		= math.Clamp(rotp, 0, 360)
	roty 		= math.Clamp(roty, 0, 360)
	rotr 		= math.Clamp(rotr, 0, 360)
	
	
	local NewEnt = ent
	local NewVec = NewEnt:GetPos()
	local NewAng = NewEnt:GetAngles()
	
	local stackdir, height, thisoffset
	
	for k,v in pairs(self.GhostStack) do
		if k == 1 || (mode == 2 && recalc == true) then
			stackdir, height, thisoffset = self:StackerCalcPos(NewEnt, mode, dir, offset)
		end

		NewVec = NewVec + stackdir * height + thisoffset
		NewAng = NewAng + rot

		v:SetAngles(NewAng)
		v:SetPos(NewVec)
		v:SetNoDraw(false)
		NewEnt = v
		//SimpleAdmin:Broadcast(k .. ": " .. tostring(NewAng) .. " : " .. tostring(NewVec) .. " : " .. tostring(v) .. ".")
	end
end

function TOOL:CheckGhostStack() //Returns if stack is ok
	if !self.GhostStack then return false end
	local count = self:GetClientNumber("count")
	
	count = math.Clamp(count, 1, 25)
	
	for k,v in pairs(self.GhostStack) do
		if (!v || !v:IsValid()) then //if something in the table doesn't exist or it's a null entity tell em it's not ok
			return false
		end
	end
	if (table.Count(self.GhostStack) != count && (self:GetClientNumber("ghostall") == 1)) then
		return false
	elseif (table.Count(self.GhostStack) != 1 && (self:GetClientNumber("ghostall") == 0)) then
		return false
	end
	return true
end

function TOOL:IsInGhostStack(ent)
	if !self.GhostStack then return false end
	for k,v in pairs(self.GhostStack) do
		if (ent == v) then
			return true
		end
	end
	return false
end

function TOOL:CreateGhostStack(prop, pos, ang)
	if(self.GhostStack) then self:ReleaseGhostStack() end
	self.GhostStack = {}

	if (SERVER && !game.SinglePlayer()) then return false end
	if (CLIENT && game.SinglePlayer()) then return false end
	
	local Halo = self:GetClientNumber("halo") == 1
	local Count = self:GetClientNumber("count")
	local GhostAll = (self:GetClientNumber("ghostall") == 1)
	
	Count = math.Clamp(Count, 1, 25)
	
	if (!GhostAll && Count != 0) then
		Count = 1
	end

	for i = 1, Count, 1 do
		local Ghost

		if ( CLIENT ) then
			Ghost = ents.CreateClientProp(prop)
		else
			Ghost = ents.Create("prop_physics")
		end
		
		if (!Ghost:IsValid()) then
			Ghost = nil
			return
		end

		Ghost:SetModel(prop)
		Ghost:SetPos(pos)
		Ghost:SetAngles(ang)
		Ghost:Spawn()

		Ghost:SetSolid(SOLID_VPHYSICS)
		Ghost:SetMoveType(MOVETYPE_NONE)
		Ghost:SetNotSolid(true)
		Ghost:SetRenderMode(RENDERMODE_TRANSALPHA)
		Ghost:SetColor(Color(255, 255, 255, 150))

		table.insert(self.GhostStack, Ghost)
		if SERVER && Halo then
		net.Start("StackGhost")
			net.WriteTable({self.GhostStack})
		net.Send(self:GetOwner())
		end
	end
	return true
end

function TOOL:ReleaseGhostStack()
	if !self.GhostStack then return end
	for k,v in pairs(self.GhostStack) do
		if !v || !v:IsValid() then continue end
		v:Remove()
	end
	if SERVER then 
	net.Start("UnstackGhost")
		net.WriteDouble(1)
	net.Send(self:GetOwner())
	end
	table.Empty(self.GhostStack)
end

function TOOL:Think()
	local ply = self:GetOwner()
	local trace = ply:GetEyeTrace()
	local stacked = false
	if (IsValid(trace.Entity) && trace.Hit && trace.Entity:GetClass() == "prop_physics") then
		self.NewEnt = trace.Entity
		if (self.NewEnt:IsValid() && self.NewEnt != self.LastEnt) then
			//SimpleAdmin:Broadcast("Creating new stack.")
			stacked = self:CreateGhostStack(self.NewEnt:GetModel(), Vector(0,0,0), Angle(0,0,0))
			if stacked then self.LastEnt = self.NewEnt end
		end
		if (!self:CheckGhostStack()) then
			//SimpleAdmin:Broadcast("Releasing old stack.")
			self:ReleaseGhostStack()
			self.LastEnt = nil
		end
	elseif ((IsValid(trace.Entity) && trace.Entity:GetClass() != "prop_physics" && self.LastEnt != nil) || !IsValid(trace.Entity)) then
		//SimpleAdmin:Broadcast("Releasing old stack.")
		self:ReleaseGhostStack()
		self.LastEnt = nil
	end
	if (self.LastEnt != nil && self.LastEnt:IsValid()) then
		//SimpleAdmin:Broadcast("Updating old stack.")
		self:UpdateGhostStack(self.LastEnt)
	end
	if CLIENT then
		//MsgN(tostring(table.Count(self.GhostStack)) .. " : " .. tostring(table.Count(self)))
		if (!GhostStack || table.Count(GhostStack) <= 0) then return end
		--[[
		for k, v in pairs(GhostStack) do
			halo.Add({v}, Color(181, 0, 217))
		end
		]]
		halo.Add(GhostStack, Color(181, 0, 217))
	end
end

function StackGhost()
	local tbl = net.ReadTable()
	GhostStack = tbl[1]
end
net.Receive("StackGhost", StackGhost)

function UnstackGhost()
	if !GhostStack then return end
	table.Empty(GhostStack)
end
net.Receive("UnstackGhost", UnstackGhost)

----------------------------------------
--         2014-07-12 20:33:12          --
------------------------------------------
TOOL.Category		= "Construction"
TOOL.Name			= "#Tool.stacker.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "freeze" ]	 	= "0"
TOOL.ClientConVar[ "weld" ]	 	= "0"
TOOL.ClientConVar[ "nocollide" ]	= "0"
TOOL.ClientConVar[ "mode" ] 		= "1"
TOOL.ClientConVar[ "dir" ] 		= "1"
TOOL.ClientConVar[ "count" ] 		= "1"
TOOL.ClientConVar[ "model" ] 		= ""
TOOL.ClientConVar[ "offsetx" ] 		= "0"
TOOL.ClientConVar[ "offsety" ] 		= "0"
TOOL.ClientConVar[ "offsetz" ] 		= "0"
TOOL.ClientConVar[ "rotp" ] 		= "0"
TOOL.ClientConVar[ "roty" ] 		= "0"
TOOL.ClientConVar[ "rotr" ] 		= "0"
TOOL.ClientConVar[ "recalc" ] 		= "0"
TOOL.ClientConVar[ "ghostall" ]		= "1"
TOOL.ClientConVar[ "halo" ]			= "0"

if SERVER then
	util.AddNetworkString("StackGhost")
	util.AddNetworkString("UnstackGhost")
end

if ( CLIENT ) then
	language.Add( "Tool.stacker.name", "Stacker" )
	language.Add( "Tool.stacker.desc", "Stacks Props Easily" )
	language.Add( "Tool.stacker.0", "Click To Stack The Prop You're Pointing At." )
	language.Add( "Undone_stacker", "Undone Stacked Prop(s)" )
end

function TOOL:Holster()
	self:ReleaseGhostStack()
end

function TOOL:Deploy()
//	self.StackedEnts = {}
end

function TOOL:LeftClick(trace)
	if !trace.Entity || !trace.Entity:IsValid() || trace.Entity:GetClass() != "prop_physics" then return false end
	if CLIENT then return true end

	local Freeze		= self:GetClientNumber( "freeze" ) == 1
	local Weld		= self:GetClientNumber( "weld" ) == 1
	local NoCollide		= self:GetClientNumber( "nocollide" ) == 1
	local Mode		= self:GetClientNumber( "mode" )
	local Dir		= self:GetClientNumber( "dir" )
	local Count		= self:GetClientNumber( "count" )
	local OffsetX		= self:GetClientNumber( "offsetx" )
	local OffsetY		= self:GetClientNumber( "offsety" )
	local OffsetZ		= self:GetClientNumber( "offsetz" )
	local RotP		= self:GetClientNumber( "rotp" )
	local RotY		= self:GetClientNumber( "roty" )
	local RotR		= self:GetClientNumber( "rotr" )
	local Recalc		= self:GetClientNumber( "recalc" ) == 1
	
	
	Dir 		= math.Clamp(Dir, 0, 5)
	Count 		= math.Clamp(Count, 1, 25)
	
	OffsetX 	= math.Clamp(OffsetX, -500, 500)
	OffsetY 	= math.Clamp(OffsetY, -500, 500)
	OffsetZ 	= math.Clamp(OffsetZ, -500, 500)
	
	RotP 		= math.Clamp(RotP, 0, 360)
	RotY 		= math.Clamp(RotY, 0, 360)
	RotR 		= math.Clamp(RotR, 0, 360)
	
	local Offset		= Vector(OffsetX, OffsetY, OffsetZ)
	local Rot		= Angle(RotP, RotY, RotR)

	local ply = self:GetOwner()
	local Ent = trace.Entity

	local NewVec = Ent:GetPos()
	local NewAng = Ent:GetAngles()
	local LastEnt = Ent

	//SimpleAdmin:Broadcast("COUNT IS " .. Count)
	if Count <= 0 then return false end
	
	undo.Create("stacker")
	for i=1, Count, 1 do
		if (!self:GetSWEP():CheckLimit("props")) then break end

		if i == 1 || (Mode == 2 && Recalc == true) then
			StackDir, Height, ThisOffset = self:StackerCalcPos(LastEnt, Mode, Dir, Offset)
		end
		
		NewVec = NewVec + StackDir * Height + ThisOffset
		NewAng = NewAng + Rot

		if !Ent:IsInWorld() then
			return false //Who put just break here? Seriously? Giving the player no hint he/she's not supposed to do that?
		end

	//	local EntList = ents.FindInSphere(NewVec, .2) //Searching in a sphere and find props
	//	local PropValid = true						//Flag if prop is found or not
	//	for k, v in pairs(EntList) do				//For loop
	//		if (v:IsValid() && v:GetClass() == "prop_physics" && (v == LastEnt )) then//|| v:GetPos() == NewVec)) then
	//			if (self:IsInGhostStack(v)) then continue end
	//			PropValid = false
	//		end
	//	end
	//	if !PropValid then return false end

		NewEnt = ents.Create("prop_physics")
			NewEnt:SetModel(Ent:GetModel())
			NewEnt:SetColor(Ent:GetColor())
			NewEnt:SetPos(NewVec)
			NewEnt:SetAngles(NewAng)
			NewEnt:Spawn()
			if Freeze then
				ply:AddFrozenPhysicsObject(NewEnt, NewEnt:GetPhysicsObject()) //Fix so you can mass-unfreeze
				NewEnt:GetPhysicsObject():EnableMotion(false)
			else
				NewEnt:GetPhysicsObject():Wake()
			end

		if Weld then
			local WeldEnt = constraint.Weld( LastEnt, NewEnt, 0, 0, 0 )
			undo.AddEntity(WeldEnt)
		end

		if NoCollide then
			local NoCollideEnt = constraint.NoCollide(LastEnt, NewEnt, 0, 0)
			undo.AddEntity(NoCollideEnt)
		end
		
		LastEnt = NewEnt
		undo.AddEntity(NewEnt)
		ply:AddCount("props", NewEnt)
		ply:AddCleanup("props", NewEnt)

		if PropDefender && PropDefender.Player && PropDefender.Player.Give then
			PropDefender.Player.Give(ply, NewEnt, false)
		end

		//table.insert(self.StackedEnts, NewEnt)
	end
	undo.SetPlayer(ply)
	undo.Finish()

	return true
end

function TOOL:StackerCalcPos(lastent, mode, dir, offset)
	local forward = Vector(1,0,0):Angle()
	local pos = lastent:GetPos()
	local ang = lastent:GetAngles()

	local lower, upper = lastent:WorldSpaceAABB( )
	local glower = lastent:OBBMins()
	local gupper = lastent:OBBMaxs()
	
	local stackdir = Vector(0,0,1)
	local height = math.abs(upper.z - lower.z)

	if mode == 1 then // Relative to world
		if dir == 1 then
			stackdir = forward:Up()
			height = math.abs(upper.z - lower.z)
		elseif dir == 2 then
			stackdir = forward:Up() * -1
			height = math.abs(upper.z - lower.z)
		elseif dir == 3 then
			stackdir = forward:Forward()
			height = math.abs(upper.x - lower.x)
		elseif dir == 4 then
			stackdir = forward:Forward() * -1
			height = math.abs(upper.x - lower.x)
		elseif dir == 5 then
			stackdir = forward:Right()
			height = math.abs(upper.y - lower.y)
		elseif dir == 6 then
			stackdir = forward:Right() * -1
			height = math.abs(upper.y - lower.y)
		end
	elseif mode == 2 then // Relative to prop
		forward = ang
		if dir == 1 then
			stackdir = forward:Up()
			offset = forward:Up() * offset.X + forward:Forward() * -1 * offset.Z + forward:Right() * offset.Y
			height = math.abs(gupper.z - glower.z)
		elseif dir == 2 then
			stackdir = forward:Up() * -1
			offset = forward:Up() * -1 * offset.X + forward:Forward() * offset.Z + forward:Right() * offset.Y
			height = math.abs(gupper.z - glower.z)
		elseif dir == 3 then
			stackdir = forward:Forward()
			offset = forward:Forward() * offset.X + forward:Up() * offset.Z + forward:Right() * offset.Y
			height = math.abs(gupper.x - glower.x)
		elseif dir == 4 then
			stackdir = forward:Forward() * -1
			offset = forward:Forward() * -1 * offset.X + forward:Up() * offset.Z + forward:Right() * -1 * offset.Y
			height = math.abs(gupper.x - glower.x)
		elseif dir == 5 then
			stackdir = forward:Right()
			offset = forward:Right() * offset.X + forward:Up() * offset.Z + forward:Forward() * -1 * offset.Y
			height = math.abs(gupper.y - glower.y)
		elseif dir == 6 then
			stackdir = forward:Right() * -1
			offset = forward:Right() * -1 * offset.X + forward:Up() * offset.Z + forward:Forward() * offset.Y
			height = math.abs(gupper.y - glower.y)
		end
	end //offset = (stackdir:Angle():Up() * offset.Z) + (stackdir:Angle():Forward() * offset.X) + (stackdir:Angle():Right() * offset.Y)
	
	return stackdir, height, offset
end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl("Header", { Text = "#Tool.stacker.name", Description	= "#Tool.stacker.desc" })
	
	CPanel:AddControl( "Checkbox", { Label = "Freeze Props", Command = "stacker_freeze" } )
	CPanel:AddControl( "Checkbox", { Label = "Weld Props", Command = "stacker_weld" } )	
	CPanel:AddControl( "Checkbox", { Label = "No Collide Props", Command = "stacker_nocollide" } )

	local params = {Label = "Relative To:", MenuButton = "0", Options = {}}
	params.Options["World"] = {stacker_mode = "1"}
	params.Options["Prop"] = {stacker_mode = "2"}
	CPanel:AddControl( "ComboBox", params )

	local params = {Label = "Stack Direction", MenuButton = "0", Options = {}}
	params.Options["Up"] = {stacker_dir = "1"}
	params.Options["Down"] = {stacker_dir = "2"}
	params.Options["Front"] = {stacker_dir = "3"}
	params.Options["Behind"] = {stacker_dir = "4"}
	params.Options["Right"] = {stacker_dir = "5"}
	params.Options["Left"] = {stacker_dir = "6"}
	CPanel:AddControl( "ComboBox", params )

	CPanel:AddControl( "Slider",  { Label	= "Count",
					Type	= "Integer",
					Min		= 1,
					Max		= 25,
					Command = "stacker_count",
					Description = "How many props to stack."}	 )

	CPanel:AddControl( "Header", { Text = "Advanced Options", Description	= "These options are for advanced users. Leave them all default (0) if you don't understand what they do." }  )
	CPanel:AddControl( "Button",  { Label	= "Reset Advanced Options",
					Command = "stacker_resetoffsets",
					Text = "Reset"}	 )
	CPanel:AddControl( "Slider",  { Label	= "Offset X (forward/back)",
					Type	= "Float",
					Min		= -1000,
					Max		= 1000,
					Value	= 0,
					Command = "stacker_offsetx"}	 )
	CPanel:AddControl( "Slider",  { Label	= "Offset Y (right/left)",
					Type	= "Float",
					Min		= -1000,
					Max		= 1000,
					Value	= 0,
					Command = "stacker_offsety"}	 )
	CPanel:AddControl( "Slider",  { Label	= "Offset Z (up/down)",
					Type	= "Float",
					Min		= -1000,
					Max		= 1000,
					Value	= 0,
					Command = "stacker_offsetz"}	 )
	CPanel:AddControl( "Slider",  { Label	= "Rotate Pitch",
					Type	= "Float",
					Min		= -360,
					Max		= 360,
					Value	= 0,
					Command = "stacker_rotp"}	 )
	CPanel:AddControl( "Slider",  { Label	= "Rotate Yaw",
					Type	= "Float",
					Min		= -360,
					Max		= 360,
					Value	= 0,
					Command = "stacker_roty"}	 )
	CPanel:AddControl( "Slider",  { Label	= "Rotate Roll",
					Type	= "Float",
					Min		= -360,
					Max		= 360,
					Value	= 0,
					Command = "stacker_rotr"}	 )
	CPanel:AddControl( "Checkbox", { Label = "Stack relative to new rotation", Command = "stacker_recalc", Description = "If this is checked, each item in the stack will be stacked relative to the previous item in the stack. This allows you to create curved stacks." } )
	CPanel:AddControl("Checkbox", {Label = "Ghost ALL of the props?", Command = "stacker_ghostall", Description = "Ghost all of the props specified by count"})
	CPanel:AddControl("Checkbox", {Label = "Give ghosted props halos?", Command = "stacker_halo", Description = "Give the ghost a halo"})
end

if (CLIENT) then
	local function ResetOffsets(ply, command, arguments)
		-- Reset all of the offset options to 0
		LocalPlayer():ConCommand("stacker_offsetx 0\n")
		LocalPlayer():ConCommand("stacker_offsety 0\n")
		LocalPlayer():ConCommand("stacker_offsetz 0\n")
		LocalPlayer():ConCommand("stacker_rotp 0\n")
		LocalPlayer():ConCommand("stacker_roty 0\n")
		LocalPlayer():ConCommand("stacker_rotr 0\n")
		LocalPlayer():ConCommand("stacker_recalc 0\n")
	end
	concommand.Add( "stacker_resetoffsets", ResetOffsets )
end

function TOOL:UpdateGhostStack(ent)
	if (!ent || !ent:IsValid() || !self:CheckGhostStack()) then return end

	local mode		= self:GetClientNumber( "mode" )
	local dir		= self:GetClientNumber( "dir" )
	local offsetx		= self:GetClientNumber( "offsetx" )
	local offsety		= self:GetClientNumber( "offsety" )
	local offsetz		= self:GetClientNumber( "offsetz" )
	local rotp		= self:GetClientNumber( "rotp" )
	local roty		= self:GetClientNumber( "roty" )
	local rotr		= self:GetClientNumber( "rotr" )
	local offset		= Vector(offsetx, offsety, offsetz)
	local rot		= Angle(rotp, roty, rotr)
	local count = self:GetClientNumber("count")
	local recalc		= self:GetClientNumber( "recalc" ) == 1
	
	dir 		= math.Clamp(dir, 0, 5)
	count 		= math.Clamp(count, 1, 25)
	
	offsetx 	= math.Clamp(offsetx, -500, 500)
	offsety 	= math.Clamp(offsety, -500, 500)
	offsetz 	= math.Clamp(offsetz, -500, 500)
	
	rotp 		= math.Clamp(rotp, 0, 360)
	roty 		= math.Clamp(roty, 0, 360)
	rotr 		= math.Clamp(rotr, 0, 360)
	
	
	local NewEnt = ent
	local NewVec = NewEnt:GetPos()
	local NewAng = NewEnt:GetAngles()
	
	local stackdir, height, thisoffset
	
	for k,v in pairs(self.GhostStack) do
		if k == 1 || (mode == 2 && recalc == true) then
			stackdir, height, thisoffset = self:StackerCalcPos(NewEnt, mode, dir, offset)
		end

		NewVec = NewVec + stackdir * height + thisoffset
		NewAng = NewAng + rot

		v:SetAngles(NewAng)
		v:SetPos(NewVec)
		v:SetNoDraw(false)
		NewEnt = v
		//SimpleAdmin:Broadcast(k .. ": " .. tostring(NewAng) .. " : " .. tostring(NewVec) .. " : " .. tostring(v) .. ".")
	end
end

function TOOL:CheckGhostStack() //Returns if stack is ok
	if !self.GhostStack then return false end
	local count = self:GetClientNumber("count")
	
	count = math.Clamp(count, 1, 25)
	
	for k,v in pairs(self.GhostStack) do
		if (!v || !v:IsValid()) then //if something in the table doesn't exist or it's a null entity tell em it's not ok
			return false
		end
	end
	if (table.Count(self.GhostStack) != count && (self:GetClientNumber("ghostall") == 1)) then
		return false
	elseif (table.Count(self.GhostStack) != 1 && (self:GetClientNumber("ghostall") == 0)) then
		return false
	end
	return true
end

function TOOL:IsInGhostStack(ent)
	if !self.GhostStack then return false end
	for k,v in pairs(self.GhostStack) do
		if (ent == v) then
			return true
		end
	end
	return false
end

function TOOL:CreateGhostStack(prop, pos, ang)
	if(self.GhostStack) then self:ReleaseGhostStack() end
	self.GhostStack = {}

	if (SERVER && !game.SinglePlayer()) then return false end
	if (CLIENT && game.SinglePlayer()) then return false end
	
	local Halo = self:GetClientNumber("halo") == 1
	local Count = self:GetClientNumber("count")
	local GhostAll = (self:GetClientNumber("ghostall") == 1)
	
	Count = math.Clamp(Count, 1, 25)
	
	if (!GhostAll && Count != 0) then
		Count = 1
	end

	for i = 1, Count, 1 do
		local Ghost

		if ( CLIENT ) then
			Ghost = ents.CreateClientProp(prop)
		else
			Ghost = ents.Create("prop_physics")
		end
		
		if (!Ghost:IsValid()) then
			Ghost = nil
			return
		end

		Ghost:SetModel(prop)
		Ghost:SetPos(pos)
		Ghost:SetAngles(ang)
		Ghost:Spawn()

		Ghost:SetSolid(SOLID_VPHYSICS)
		Ghost:SetMoveType(MOVETYPE_NONE)
		Ghost:SetNotSolid(true)
		Ghost:SetRenderMode(RENDERMODE_TRANSALPHA)
		Ghost:SetColor(Color(255, 255, 255, 150))

		table.insert(self.GhostStack, Ghost)
		if SERVER && Halo then
		net.Start("StackGhost")
			net.WriteTable({self.GhostStack})
		net.Send(self:GetOwner())
		end
	end
	return true
end

function TOOL:ReleaseGhostStack()
	if !self.GhostStack then return end
	for k,v in pairs(self.GhostStack) do
		if !v || !v:IsValid() then continue end
		v:Remove()
	end
	if SERVER then 
	net.Start("UnstackGhost")
		net.WriteDouble(1)
	net.Send(self:GetOwner())
	end
	table.Empty(self.GhostStack)
end

function TOOL:Think()
	local ply = self:GetOwner()
	local trace = ply:GetEyeTrace()
	local stacked = false
	if (IsValid(trace.Entity) && trace.Hit && trace.Entity:GetClass() == "prop_physics") then
		self.NewEnt = trace.Entity
		if (self.NewEnt:IsValid() && self.NewEnt != self.LastEnt) then
			//SimpleAdmin:Broadcast("Creating new stack.")
			stacked = self:CreateGhostStack(self.NewEnt:GetModel(), Vector(0,0,0), Angle(0,0,0))
			if stacked then self.LastEnt = self.NewEnt end
		end
		if (!self:CheckGhostStack()) then
			//SimpleAdmin:Broadcast("Releasing old stack.")
			self:ReleaseGhostStack()
			self.LastEnt = nil
		end
	elseif ((IsValid(trace.Entity) && trace.Entity:GetClass() != "prop_physics" && self.LastEnt != nil) || !IsValid(trace.Entity)) then
		//SimpleAdmin:Broadcast("Releasing old stack.")
		self:ReleaseGhostStack()
		self.LastEnt = nil
	end
	if (self.LastEnt != nil && self.LastEnt:IsValid()) then
		//SimpleAdmin:Broadcast("Updating old stack.")
		self:UpdateGhostStack(self.LastEnt)
	end
	if CLIENT then
		//MsgN(tostring(table.Count(self.GhostStack)) .. " : " .. tostring(table.Count(self)))
		if (!GhostStack || table.Count(GhostStack) <= 0) then return end
		--[[
		for k, v in pairs(GhostStack) do
			halo.Add({v}, Color(181, 0, 217))
		end
		]]
		halo.Add(GhostStack, Color(181, 0, 217))
	end
end

function StackGhost()
	local tbl = net.ReadTable()
	GhostStack = tbl[1]
end
net.Receive("StackGhost", StackGhost)

function UnstackGhost()
	if !GhostStack then return end
	table.Empty(GhostStack)
end
net.Receive("UnstackGhost", UnstackGhost)
