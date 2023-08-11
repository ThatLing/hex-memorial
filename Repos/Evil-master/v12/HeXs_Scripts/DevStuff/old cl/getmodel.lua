

local function EntityInformation()
	local trace = LocalPlayer():GetEyeTrace()
	print(trace.Entity:GetClass())
	if trace.Hit and trace.Entity:IsValid() and string.find(string.lower(trace.Entity:GetClass()), "prop") then 
		print(trace.Entity:GetModel())
		print(trace.Entity:GetOwner())
		print(trace.Entity:Health())
		PrintTable(trace.Entity:GetTable())
	elseif trace.Hit and trace.Entity:IsValid() and trace.Entity:GetClass() == "player" then
		print(trace.Entity:Nick())
		print(trace.Entity:Health())
		print(trace.Entity:GetActiveWeapon():GetPrintName())
		print("the guy you're looking at is admin:", trace.Entity:IsAdmin())
		
		//print(trace.Entity:GetTool())
		//print(trace.Entity:GetViewModel():GetModel()) //NULL!!!!
	end
end
concommand.Add("GetModel", EntityInformation)
