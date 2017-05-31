
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------

local PLUGIN = {}

PLUGIN.Name 			= "Rank"
PLUGIN.Author 			= "Frosty + HeX"
PLUGIN.CloseOnClick 	= true
PLUGIN.Server 			= true
PLUGIN.AllowSelf 		= false

PLUGIN.MenuFunction 	= "AllExceptLocal"
PLUGIN.RunFunction 		= function(Him,ply) end


PLUGIN.SubMenu 			= FSA.Ranks

PLUGIN.SubMenufunction 	= {}

for k,v in ipairs(FSA.Ranks) do --Auto list, get from ranks
	local func = function(Him,ply)
		if ply:IsSuperAdmin() then
			if (k == RANK_OWNER) then
				ply:FSACAT(FSA.PBLUE, "[FSA] ", FSA.GREY, "What are you doing!, you can't set owner ranks!")
				return
			end
			
			Him:SetLevel(k)
		end
	end
	
	table.insert(PLUGIN.SubMenufunction, func)
end


FSA.SetPlugin(PLUGIN)






----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------

local PLUGIN = {}

PLUGIN.Name 			= "Rank"
PLUGIN.Author 			= "Frosty + HeX"
PLUGIN.CloseOnClick 	= true
PLUGIN.Server 			= true
PLUGIN.AllowSelf 		= false

PLUGIN.MenuFunction 	= "AllExceptLocal"
PLUGIN.RunFunction 		= function(Him,ply) end


PLUGIN.SubMenu 			= FSA.Ranks

PLUGIN.SubMenufunction 	= {}

for k,v in ipairs(FSA.Ranks) do --Auto list, get from ranks
	local func = function(Him,ply)
		if ply:IsSuperAdmin() then
			if (k == RANK_OWNER) then
				ply:FSACAT(FSA.PBLUE, "[FSA] ", FSA.GREY, "What are you doing!, you can't set owner ranks!")
				return
			end
			
			Him:SetLevel(k)
		end
	end
	
	table.insert(PLUGIN.SubMenufunction, func)
end


FSA.SetPlugin(PLUGIN)





