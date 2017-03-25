--[[
	=== Nice debug traces ===
]]


function debug.Trace(Res, is_err)
	Res = Res or "Trace"
	local Lev = 2
	
	local Out = ""
	while true do
		local Tab = debug.getinfo(Lev)
		if not Tab then break end
		
		//First call
		if Lev == 2 then
			Out = Out..Format("[%s] %s - [%s:%d-%d]\n", Res, Tab.name, Tab.short_src, Tab.linedefined, Tab.lastlinedefined)
		end
		
		//Tab
		local Sep = string.rep(" ", Lev - 1)
		Out = Out..Format(" %s%d. %s - %s:%d\n", Sep, Lev, (Tab.name or "unknown"), Tab.short_src, Tab.currentline)
		
		Lev = Lev + 1
	end
	Out = Out.."\n\n"
	
	if is_err then
		ErrorNoHalt(Out)
	else
		print(Out)
	end
end







