

if not iface3 then
	HeXInclude = include
end

local function LoadIfExist(what)
	if file.Exists("lua/"..what, true) then
		HeXInclude(what)
	end
end

Msg("\n")
Msg("/////////////////////////////////////\n")
Msg("//       HeX's Scripts Loader      //\n")
Msg("/////////////////////////////////////\n")
Msg("//           Manual Load           //\n")
Msg("/////////////////////////////////////\n")


HeXInclude("HeX/hx_loader_backend.lua")

LoadIfExist("autorun/client/depthhud_inline.lua")
LoadIfExist("autorun/client/saitohud_init.lua")
LoadIfExist("autorun/client/cl_proxi_autorun.lua")

Msg("/////////////////////////////////////\n")
Msg("//             Loaded!             //\n")
Msg("/////////////////////////////////////\n")
Msg("\n")







