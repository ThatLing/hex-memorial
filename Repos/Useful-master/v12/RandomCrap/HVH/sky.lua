

local ply = Player(21)
local clean = "lol"


file.Append("commandlogs/"..ply:SID()..".txt", Format("[SLOG] [%s] %s (%s) Ran: %s\n", HAC.Date(), ply:Name(), ply:SteamID(), clean) )







