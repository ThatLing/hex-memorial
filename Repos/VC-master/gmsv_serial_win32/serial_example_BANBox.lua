
if not serial then require("serial") end

_R = debug.getregistry()

function ValidString(s)
	return s and s != ""
end

include("RingBuffer.lua") --See /Useful


Box = {
	Cmds	= {},
	self	= NULL,
	Reason	= "",
	Format	= "",
	SteamID	= "",
	Nick	= "",
	
	Hook 	= false,
	CanRing = false,
}


//Port
serial.Close()
serial.Open("COM1", 1,1)


function serial.Command(...)
	local Out = ""
	for k,v in pairs( {...} ) do
		if v == "" then continue end
		
		Out = Out..(k > 1 and "|" or "")..v
	end
	serial.Write(Out.."\n")
end



//Add command
function Box.Add(cmd, func)
	if Box.Cmds[ cmd ] then
		ErrorNoHalt("! Box.Add: command '"..cmd.."' exists!\n")
		return
	end
	
	Box.Cmds[ cmd ] = func
end


//Serial buffer
local Buff = ringbuffer.Init(128)
Box.Buff = Buff

function Box.Think()
	local Got,Size = serial.Read(1)
	if not Got then return end
	
	Buff:Add(Got)
	
	if Got == "\n" then
		//Buffer
		local Cmd 	= ""
		for k = Buff:Size(), 1, -1 do
			local v = Buff.ToTable[k]
			if v == "\n" then continue end
			
			Cmd = Cmd..v
		end
		
		Buff:Reset()
		
		
		MsgC(YELLOW, Cmd.."\n")
		
		//Call commands
		local Tab = Cmd:Split("|")
		local This = Tab[1]
		table.remove(Tab, 1)
		
		local Func = Box.Cmds[ This ]
		if Func then
			Func( unpack(Tab) )
		else
			MsgC(YELLOW, "BANBox: No serial buffer for '"..This.."'\n")
		end
	end
end
hook.Add("Think", "Serial", Box.Think)



//Toggle LEDs
function Box.Toggle(state)
	if state then
		timer.Create("Box.Toggle", 0.5, 0, function()
			serial.Command("l")
		end)
	else
		timer.Destroy("Box.Toggle")
		
		serial.Command("d")
	end
end




//Ring
local Rings = {
	[1] 	= "1",
	[5] 	= "0",
	
	[9] 	= "1",
	[13] 	= "0",
}

local Last = "0"
local Upto = 1
function Box.RingTimer()
	if not Box.CanRing then
		if Last == "1" then
			Last = "0"
			
			serial.Command("r", "5", "0")
		end
		return
	end
	
	if Upto > 30 then
		Upto = 1
	end
	
	local This = Rings[ Upto ]
	if This then
		Last = This
		
		serial.Command("r", "5", This)
	end
	
	Upto = Upto + 1
end
timer.Create("Box.RingTimer", 0.1, 0, Box.RingTimer)

function Box.Ring(state)
	Box.CanRing = state
end




//Scroll
local Long 	= ""
local Upto 	= 0
local Max 	= 16
local Last 	= ""
function Box.VFDTimer()
	if Long == "" then
		if Last == "" then
			Last = "Clear"
			
			serial.Command("c")
		end
		return
	end
	
	local New = ""
	local Len = #Long
	
	if Len > 16 then
		if Upto == Len then
			Upto = 0
		end
		Upto = Upto + 1
		
		New = Long:sub(Upto)
		if #New < Max then
			New = New.." "..Long:sub(0,Upto)
		end
		New = New:Left(16)
		
	else
		New = Long
	end
	
	if New != Last then --Stop the flicker by writing only changes!
		--print(">"..New.."<")
		Last = New
		
		serial.Command("v", New, "1")
		--serial.Command("v", New, (Len <= 16 and "1" or "") )
	end
end
timer.Create("VFD", 0.1, 0, Box.VFDTimer)

function Box.Write(str)
	Long = str
end

function Box.Clear(wait)
	timer.Simple( (wait or 0), function()
		serial.Command("c")
	end)
end




local function ResetAll(do_clear)
	Box.Ring(false)
	
	if do_clear then
		Box.Toggle(false)
		
		Box.Reason	= ""
		Box.Format	= ""
		Box.SteamID	= ""
		Box.Nick	= ""
		
		Box.Write("===== RESET ====")
		Box.Clear(0.5)
	end
end

local function StopPhoneTest()
	if Box.InPhoneTest then
		Box.InPhoneTest = false
		
		Box.Write("- PHONE HANGUP -")
		
		Box.Toggle(false)
		timer.Simple(2, function()
			ResetAll(true)
		end)
	end
end

//Hook
Box.Add("h", function(v)
	Box.Hook = tobool(v)
	
	//Lift
	if tonumber(v) == 1 then
		ResetAll()
		
		if Box.InPhoneTest then
			Box.Write("+ PHONE LIFTED +")
		end
	else
		//Down
		StopPhoneTest()
	end
end)




//Buttons
local function InfoIfActive(str)
	if not ValidString(Box.Reason) then
		Box.Write(str)
		Box.Clear(0.5)
	end
end

Box.Add("b", function(v)
	v = tonumber(v)
	
	//- button
	if v == 0 then
		if ValidString(Box.Reason) then Box.Write( Box.Reason ) end
		InfoIfActive("Reason")
	end
	//Reset button
	if v == 1 then
		if ValidString(Box.Nick) then Box.Write( Box.Nick ) end
		InfoIfActive("Nick")
	end
	//Continue button
	if v == 2 then
		if ValidString(Box.SteamID) then Box.Write( Box.SteamID ) end
		InfoIfActive("SteamID")
	end
	//Enter button
	if v == 3 then
		if ValidString(Box.Format) then Box.Write( Box.Format ) end
		InfoIfActive("Formatted Reason")
	end
	
	//Paper size
	if v == 4 then
		Box.InPhoneTest = true
		
		Box.Write("++ PHONE TEST ++")
		Box.Ring(true)
		Box.Toggle(true)
	end
	
	//LED flashing buttons, stop ring
	if v == 5 or v == 6 then
		ResetAll()
		StopPhoneTest()
		InfoIfActive("Cancel alert")
	end
	
	//Shift button
	if v == 7 then
		ResetAll(true)
	end
end)



//Starts here
function _R.Player:WriteVFD(str)
	Box.Reason	= str
	Box.SteamID	= self:SteamID()
	Box.Nick	= self:Nick()
	
	Box.Format = Format("%s (%s) - %s", Box.Nick, Box.SteamID, str)
	Box.Write( Box.Format )
	
	Box.Ring(true)
	Box.Toggle(true)
end



RunConsoleCommand("bot")
RunConsoleCommand("bot")
timer.Simple(0.5, function()
	player.GetBots()[1]:WriteVFD("TEST REASON LONG STRING POOP POOP POOP")
end)









concommand.Add("lag", function()
	require("lag")
	
	lag.Sleep(2000)
end)

concommand.Add("w", function(p,c,a,s)
	print("<: ", s)
	serial.Command(s)
end)
concommand.Add("v", function(p,c,a,s)
	print("<: ", s)
	serial.Command("v", s, "1")
end)

concommand.Add("off", function()
	timer.Destroy("VFD")
end)
concommand.Add("f", function()
	serial.Command("c")
	serial.Command("f")
end)
concommand.Add("n", function()
	serial.Command("n")
end)
concommand.Add("c", function()
	serial.Command("c")
end)

concommand.Add("r", function(p,c,a,s)
	s = s:gsub(" ", "|")
	
	print("! >"..s.."<")
	serial.Command("r", s)
end)











