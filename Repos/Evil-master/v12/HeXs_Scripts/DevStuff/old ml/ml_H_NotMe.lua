
if not file.Exists("addons/Name_Enable.dll", true) then return end


local SpamRate = CreateClientConVar("hex_spamname_rate", 5, false, false)
local StealRate = CreateClientConVar("hex_stealname_rate", 12, false, false)

local FakeNames = {
	"General Failure",
	"Colonel Panic",
	"Major Damage",
	"Old Iron Balls",
	"Touch of Orange",
	"Operation Coconut",
}

function GetName()
	return GetConVarString("name") or ""
end

function SetName(str)
	console.Command([[name "]]..str..[["]])
end



concommand.Add("hex_name_reset", function()
	SetName( friends.GetPersonaName() )
end)



local function RandomName(ply,cmd,args)
	local Rand = table.Random(FakeNames)
	print("! new name: ", Rand)
	SetName(Rand)
end
concommand.Add("hex_randomname", RandomName)

function ResetName()
	if GetName() != friends.GetPersonaName() then
		SetName(friends.GetPersonaName())
	end
	
	timer.Destroy("SpamName")
	timer.Destroy("StealName")
end
hook.Add("EndGame", "NotMe", ResetName)
concommand.Add("hex_resetname", ResetName)



local SpamEnabled = false
local function SpamName(ply,cmd,args)
	if not SpamEnabled then
		SpamEnabled = true
		print("! SpamName enabled")
		
		timer.Create("SpamName", SpamRate:GetInt(), 0, function()
			local Fake = table.Random(FakeNames)
			MsgN("! New name is: ", Fake)
			
			SetName(Fake)
		end)
	else
		SpamEnabled = false
		print("! SpamName disabled")
		
		timer.Destroy("SpamName")
		ResetName()
	end
end
concommand.Add("hex_spamname", SpamName)

local TakeEnabled = false
local function StealName(ply,cmd,args)
	local ClientNames = {}
	
	local OnePlayer
	if (#args > 0) then
		OnePlayer = player.GetByUserID( tonumber(args[1]) ) or nil
	end
	
	if not TakeEnabled then
		TakeEnabled = true
		
		if OnePlayer then
			local Name = OnePlayer:Nick()
			MsgN("! Stolen name is: ", Name)
			SetName( Format("%s ", Name) )
		else
			print("! StealName enabled")
			
			timer.Create("StealName", StealRate:GetInt(), 0, function()
				ClientNames = {}
				
				for k,v in pairs(player.GetAll()) do
					table.insert(ClientNames, v:Nick())
				end
				
				local ClientName = table.Random(ClientNames)
				
				MsgN("! Stolen name is: ", ClientName)
				SetName( Format("%s ", ClientName) )
			end)
		end
	else
		TakeEnabled = false
		print("! StealName disabled")
		
		if timer.IsTimer("StealName") then
			timer.Destroy("StealName")
		end
		ResetName()
	end
end
concommand.Add("hex_stealname", StealName)












