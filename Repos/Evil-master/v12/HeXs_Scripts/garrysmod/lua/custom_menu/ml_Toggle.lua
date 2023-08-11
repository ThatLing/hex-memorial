
if not IsMainGMod then return end


local VoiceToggle = false
local function togglevoicerecord()
	if not VoiceToggle then	
		RunConsoleCommand("+voicerecord")
	else
		RunConsoleCommand("-voicerecord")
	end
	VoiceToggle = not VoiceToggle
end
concommand.Add("togglevoice", togglevoicerecord)


/*
local togglecommands = {}
local function ToggleAPlusMinusCommand(ply,cmd,args)
	if not args[1] then print("enter an argument plz") return end
	if not togglecommands[args[1]] then togglecommands[args[1]] = false end
	if not togglecommands[args[1]] then
		RunConsoleCommand("+"..args[1])
	else
		RunConsoleCommand("-"..args[1])
	end
	togglecommands[args[1]] = not togglecommands[args[1]]
end
concommand.Add("ftoggle", ToggleAPlusMinusCommand)
*/

