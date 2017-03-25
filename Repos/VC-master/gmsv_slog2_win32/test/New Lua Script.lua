


if not slog2 then require("slog2") end


Hooked = false

for k,v in pairs( player.GetHumans() ) do
	if Hooked then break end
	
	local Done,err = slog2.Add( v:EntIndex() )
	print(v, Done,err)
	
	if Done then
		Hooked = true
	end
end


local function ExecuteStringCommand(name,cmd)
	print("! name,cmd: ", name,cmd)
end
hook.Add("ExecuteStringCommand", "ExecuteStringCommand", ExecuteStringCommand)



concommand.Add("poo", function() end)

timer.Simple(1, function()
	BroadcastLua([[
		RunConsoleCommand("poo")
		RunConsoleCommand("asdf")
	]])
end)

