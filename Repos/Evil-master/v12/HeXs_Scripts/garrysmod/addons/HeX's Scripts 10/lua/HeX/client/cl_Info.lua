


local function ThatEnt()
	return LocalPlayer():GetEyeTrace().Entity
end



concommand.Add("propinfo", function()
	local ent = ThatEnt()
	if not ValidEntity(ent) then return end		
	
	print(ent)
	
	print("Model: ",	ent:GetModel() )
	print("Position: ", ent:GetPos() )
	print("Color: ",	ent:GetColor() )
	print("Material: ", ent:GetMaterial() )
	print("Angle: ",	ent:GetAngles() )
	print("Size: ",		ent:OBBMaxs() - ent:OBBMins() )
end )



concommand.Add("copymat", function()
	local ent = ThatEnt()
	if not ValidEntity(ent) then return end			
	local mat = ent:GetMaterial()
	
	print("Material: ", mat)
	SetClipboardText(mat)
	RunConsoleCommand("material_override", mat)
end)



