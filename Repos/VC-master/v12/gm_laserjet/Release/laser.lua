

if not laserjet then
	require("laserjet")
end
laserjet.SetWidth(20,4) --20x4 LCD (20 chars/line, 4 lines), change if you have a different LCD
laserjet.IPAddress("192.168.0.20")


function laserjet.SetText(what)
	if type(what) == "string" then
		what = string.Explode("\n", what)
	end
	
	local New = ""
	for k,v in ipairs(what) do
		New = New..v..string.rep(" ", (laserjet.GetWide() - #v) ) --Width of LCD, set before
	end	
	
	return #New, laserjet.WriteString(New) --Raw WriteString, no formatting
end



laserjet.SetText("This string is\nOn two lines!") --String to display, will auto-fit to the screen

local Buff = {
	"Ply: 0/0 [8] E: 699",
	"Map: ASC Snipe Crazy",
	"Wep: BOOMSTICK!",
	"HAC: 0/0/0 K: 688/0",
}

local New,Bytes = laserjet.SetText(Buff) --Or table!

if Bytes then --Total bytes in the packet
	print("! sending: "..New.." chars ("..Bytes.." bytes)")
else
	print("! error :(")
end



print( laserjet.GetValue() ) --Current message on the LCD













