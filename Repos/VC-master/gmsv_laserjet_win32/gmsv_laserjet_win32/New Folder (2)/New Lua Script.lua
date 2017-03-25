

local Print = {
	"  This HP printer   ",
	"   Is displaying    ",
	" the [United|Hosts] ",
	" deathmatch stats   ",
}




local Rep = string.rep(" ",(20-#What)/2)
local Send = Rep..What..Rep

local Bytes = laserjet.WriteString("192.168.0.20", Send)

print("! sending: "..#What.." >"..What.."< "..Bytes.." bytes")






