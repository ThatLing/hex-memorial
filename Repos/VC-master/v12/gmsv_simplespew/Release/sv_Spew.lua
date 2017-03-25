--[[
	=== HSP plugin module ===
	sv_Spew, v1.2
	Log everything from the console
]]


function HSP.ProcessSpew(typ,spew,group,lev)
	local Date = os.date("%d-%m-%Y_%A")
	
	file.Append("spew/"..Date.."/"..Map..".txt", spew)
	
	if spew:find("L ") and spew:find("say") then
		file.Append("spew/"..Date.."_TALK/"..Map..".txt", spew)
	end
end
hook.Add("SimpleSpew", "HSP.ProcessSpew", HSP.ProcessSpew)





