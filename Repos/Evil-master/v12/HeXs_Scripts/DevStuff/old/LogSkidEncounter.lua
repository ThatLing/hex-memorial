
local function LogSkidEncounter(ply,what,name)
	local LogName	= Format("SK/%s.txt", os.date("%d-%m-%Y_%A"))
	local SDate		= os.date("%d-%m-%y (%A) %I:%M%p")
	
	local ServerIP = "E.E.E.E"
	if client and client.GetIP then
		ServerIP = tostring( client.GetIP() )
	end
	
	local str = Format("[SK] %s @ ")
	
end
