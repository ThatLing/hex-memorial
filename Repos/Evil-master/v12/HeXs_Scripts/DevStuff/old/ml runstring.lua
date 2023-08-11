local RunStringML = _G["RunString"]

concommand.Add("lua_run_ml", function(ply,cmd,args)
	if not tobool(LocalPlayer) then
		if #args and #args != 0 then
			local strLua = table.concat(args," ")
			
			Msg("Running lua: \""..strLua.."\"\n")
			RunString(strLua)
			RunStringML(strLua)
		else
			Msg("Must contain code to run code\n")
		end
	else
		Msg("Damn you!, this is only for the menu env, use lua_openscript_cl!\n")
	end
end)


	if GetConVar("sv_scriptenforcer"):GetBool() and not string.find(table.concat(args," "),"/f") then
		print("[HeX] ScriptEnforcer on, can't load scripts. Run with /f to run anyway")
		return
	end
	
	
	Msg("  Including ./HeX\n")
local HeX = file.FindInLua("HeX/*.lua")
if #HeX > 0 then
	for _,v in ipairs(HeX) do
		Msg("  SH Module: ./HeX/"..v.."\n")
		include("HeX/"..v)
	end
end

