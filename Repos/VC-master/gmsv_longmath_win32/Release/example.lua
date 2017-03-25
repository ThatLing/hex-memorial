
STEAM_ID_BASE = "103582791429521408"

function GID_64To32(GID64)
	if not longmath then ErrorNoHalt("sv_Group, GID_64To32: No longmath!\n") return "1337" end
	return longmath.Minus(GID64, STEAM_ID_BASE)
end
function GID_32To64(GID32)
	if not longmath then ErrorNoHalt("sv_Group, GID_32To64: No longmath!\n") return "1338" end
	return longmath.Add(GID32, STEAM_ID_BASE)
end




