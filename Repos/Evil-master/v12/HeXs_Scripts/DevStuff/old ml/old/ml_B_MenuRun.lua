if not require("hexstring") then	HeXString = function() print("[HeX] gm_hexstring.dll gone!") endendconcommand.Add("lua_run_ml", function(ply,cmd,args)	if #args == 0 then		print("You gotta have code to run code")		return	end		local cock = ""	for k,arg in ipairs(args) do		cock = cock..string.gsub(arg,'"',"'")	end	print("! cock: ", cock)		PrintTable(args)	local RawLua2Run = table.concat(args," ")	local Lua2Run = string.gsub(RawLua2Run,"'",'"')	print("Running lua: ",Lua2Run)		HeXString(Lua2Run)	returnend)