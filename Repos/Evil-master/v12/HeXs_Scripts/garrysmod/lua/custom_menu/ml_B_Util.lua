

function HeXLRCL(str)
	--print("cmd >>"..str.."<<")
	console.Command(str)
end


local GameStarted	= nil
local GameEnded		= nil
local function IsInGame()
	local Game = client.IsInGame()
	
	if Game then
		if not GameStarted then
			GameStarted = true
			GameEnded = false
			hook.Call("StartGame", nil, nil)
		end
	else
		if not GameEnded then
			GameEnded = true
			GameStarted = false
			hook.Call("EndGame", nil, nil)
		end
	end
end
timer.Create("IsInGame", 1, 0, IsInGame)


local ConsoleOpen	= nil
local ConsoleClosed	= nil
local function IsConsoleOpen()
	local Open = console.IsVisible()
	
	if Open then
		if not ConsoleOpen then
			ConsoleOpen = true
			ConsoleClosed = false
			hook.Call("ConsoleOpen", nil, nil)
		end
	else
		if not ConsoleClosed then
			ConsoleClosed = true
			ConsoleOpen = false
			hook.Call("ConsoleClosed", nil, nil)
		end
	end
end
timer.Create("IsConsoleOpen", 0.5, 0, IsConsoleOpen)






