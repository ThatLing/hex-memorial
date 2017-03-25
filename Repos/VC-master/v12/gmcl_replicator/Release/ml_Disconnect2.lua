

if not replicator then
	require("replicator")
end
if not replicator then
	COLCON(RED, "Disconnect2", WHITE, ": Error 404, replicator not found!")
	return
end


local QuitTAB = {
	"With their pushin' and the poppin' and the hippin' and the hoppin' so they don't know what the stack is all about!",
	"Muddy Menu-driven Micromanagement motherfuckery!",
	"The only things we can't do are burn em, blow em up, or lose em",
	"A good attempt at something impossible",
	"Their world is in flames and we're giving them gasoline!",
	"Accidentally the whole disconnect",
	"Failure is always an option",
	"Please excuse me while I pickup all these bricks i just shat",
	"Base based base items",
	"RIGHT IN THE CORN, YEAH",
	"55-Gallon Drumroll, Please!",
	"WITHOUT GASOLINE SAUSAGE",
	"Way to blow the door of the hinges!",
	"If they don't like it they can suck on my Care Package",
	"Norberto fig awesome cat competition",
	"Whoops, I meant panties",
	"Whoops, I meant panties",
	"Whoops, I meant panties",
	"Whoops, I meant panties",
}



local function IsOnline()
	local Addr = client.GetIP()
	return client.IsConnected() and (Addr != "0.0.0.0" or Addr != "loopback")
end

local function SetupCVars()
	if D2_SetupCVars then return end
	D2_SetupCVars = true
	
	replicator.GetConCommand("disconnect"):SetName("disconnect_2")
	
	concommand.Add("disconnect", function(ply,cmd,args)
		HeXQuit()
		
		timer.Simple(1, function()
			if IsOnline() then --Didn't work
				RunConsoleCommand("disconnect_2")
			end
		end)
	end)
end
timer.Simple(1, SetupCVars)




function DisconnectWithMessage(what)
	if not IsOnline() then return end --Menu/Singleplayer
	
	if not package.loaded.sourcenet3 then
		require("sourcenet3") --Load here, less chance of crashing!
	end
	if not package.loaded.sourcenet3 then
		COLCON(RED, "Disconnect2", WHITE, ": Error 404, sourcenet3 not found!")
		return
	end
	
	local chan = CNetChan()
	if not chan then return end
	local buff = chan:GetReliableBuffer()
		buff:WriteUBitLong(net_Disconnect, 6)
		buff:WriteString(what)
	CNetChan():Transmit()
	
	COLCON(CMIColor, "Disconnect: ", RED, what)
end


function HeXQuit(ply,cmd,args)
	local NewMsg = table.Random(QuitTAB)
	
	if (args and #args > 0) then
		NewMsg = table.concat(args," ")
	end
	
	DisconnectWithMessage(NewMsg)
end
--concommand.Add("hex_quit", HeXQuit)















