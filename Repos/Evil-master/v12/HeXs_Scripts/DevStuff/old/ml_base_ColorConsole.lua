
--[[

also add to all other ml scripts
]]


if not console or package.loaded.console then
	require("console")
	console.RunCommand = nil --you better don't
	console.LogPrint = nil --leave these functions enabled :O
end

local col = Color(255,255,255)
local txt = ""
function COLCON(...)
    for _,v in pairs({...}) do
        txt = type(v)
        if txt == "table" then
            col = v
        elseif txt == "string" then
            console.Print(col,v)
        end
    end
    console.Print(col,"\n")
end








