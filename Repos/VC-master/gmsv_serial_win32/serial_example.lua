
//Arduino VFD BANBox control

require("serial")

print("! IsValid: ", serial.IsValid() )

serial.Close()
print("! IsValid: ", serial.IsValid() )

serial.Open("COM2", 1,1) --Read timeout, Write timeout, do not set too high, blocks main thread



//Ring buffer
local MaxCmdLen = 128
local buffer = {}

function buffer:Add(v)
  table.insert(self, 1, v)
  self[ MaxCmdLen + 1 ] = nil
end

function buffer:Top()
	return self[1]
end

function buffer:Bottom()
	return buffer[ #buffer ]
end

function buffer:Remove(k)
	for i=0,k do
		self[i] = nil
	end
end

function buffer:Reset()
	for i=0, #self do
		self[i] = nil
	end
end

//Will read 1 byte at a time from the serial buffer
hook.Add("Think", "Serial", function()
	local Got,Size = serial.Read(1)
	
	if Got then
		MsgC( Color(255,255,0), --[["("..Size..") "..]]Got)
		
		--print("! size: ", #Got, Got:byte())
		
		buffer:Add(Got)
		
		if Got == "\n" then
			print("! end command")
			
			local Cmd 	= ""
			for k = #buffer, 1, -1 do
				local v = buffer[k]
				if v == "\n" then continue end
				
				Cmd = Cmd..v
			end
			
			buffer:Reset()
			
			print("! whole Cmd >"..Cmd.."<")
		end
	end
end)





//Ring
local Events = {
	--Quick pulse
	--[[
	[1] = "1",
	[2] = "0",
	
	[9] = "1",
	[10] = "0",
	]]
	
	--Quick pulse 2
	--[[
	[1] = "1",
	[2] = "0",
	
	[7] = "1",
	[8] = "0",
	]]
	
	--Proper ring
	[1] = "1",
	[5] = "0",
	
	[9] = "1",
	[13] = "0",
}

local Ring = 1
timer.Create("Ringer", 0.1, 0, function()
	if Ring > 30 then
		Ring = 1
		--print("")
	end
	
	local This = Events[ Ring ]
	if This then
		serial.Command("r", "5", This)
		print("! CALL: ", Ring, This)
	end
	
	--print("! Ring: ", Ring)
	Ring = Ring + 1
end)





//Clear VFD display on arduino
serial.Write("c\n")

concommand.Add("w", function(p,c,a,s)
	print("<: ", s)
	serial.Write(s.."\n")
end)
concommand.Add("vfd", function(p,c,a,s)
	print("<: ", s)
	serial.Write("v;"..s..";1\n")
end)




local Long = "BAN @ [12.02.2015] 13:12 BURST ME BAGPIPES! (STEAM:0:0_13371337)"

local Upto = 0
local Max = 16

local Last = ""
timer.Create("VFD", 0.2, 0, function()
	local New = ""
	local Len = #Long
	
	if Len > 16 then
		if Upto == Len then
			Upto = 0
		end
		Upto = Upto + 1
		
		New = Long:sub(Upto)
		if #New < Max then
			New = New.." "..Long:sub(0,Upto) --Shitty, make proper text scroller
		end
		New = New:Left(16)
	else
		New = Long
	end
	
	print(">"..New.."<")
	
	if New != Last then --Stop the flicker by writing only changes!
		Last = New
		
		--serial.Write("v;"..New..";1\n")
		serial.Write("v;"..New..(Len < 16 and ";1" or "").."\n")
	end
end)












