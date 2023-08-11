
timer.Simple(0.1, function()
	require("connect")
end)

local CustomMsg	= false
local NewMsg	= ""
local Done		= false


local QuitTAB = {
	"A good attempt at something impossible",
	"One-Man Cheeseburger Apocalypse",
	"The old trick, eh?",
	"Not the ducks again!",
	"Swallowed a fucking bee",
	"Cock'n'Balls Ice Cream Co",
	"Based on a real-life cube",
	"They stay crunchy even in milk! ^_^",
	"Toilet Connection Pipeline/International Plumbing",
	"Toilet Elementary Lid-down Network",
	"A revolution in duck design",
	"His head was all over the wall",
	"just a dick measuring contest",
	"Their world is in flames and we're giving them gasoline!",
	"Buggrit, millenium hand and shrimp",
	"Couldn't take it anymore",
	"Pissed in the sandbox",
	"Accidentally the whole disconnect",
	"Had it with these F'in snakes",
	"Revenge of the Propane",
	"Speak for yourself, Captain balls",
	"Failure is always an option",
	"Being led by an idiot with a crayon",
	"Shit for brains, sit on my interface",
	"Put a shark in it",
	"Like shooting fish in a helihopter",
	"Oh, Put a Cork in It!",
}


local OnlyTAB = {
	["Disconnect by user."] = true,
	["NetChannel removed."] = true,
}
local function HeXDisconnect(msg)
	if not OnlyTAB[ msg ] then return end
	if Done then return end --Called twice?!
	
	Done = true
	timer.Simple(1, function() Done = false end) --Quicker than another hook + extras
	
	local RandomMessage = table.Random(QuitTAB)
	if NewMsg != "" then
		RandomMessage = NewMsg
	end
	
	COLCON(GREEN,"[", BLUE,"HeX", GREEN,"]", CMIColor," Disconnect: ", RED, RandomMessage)
    return RandomMessage
end
hook.Add("DisconnectMsg", "HeXDisconnect", HeXDisconnect)


local function HeXQuit(ply,cmd,args)
	if (#args > 0) then
		NewMsg = table.concat(args," ")
	end
	
	timer.Simple(1, RunConsoleCommand, "disconnect")
end
concommand.Add("hex_quit", HeXQuit)








