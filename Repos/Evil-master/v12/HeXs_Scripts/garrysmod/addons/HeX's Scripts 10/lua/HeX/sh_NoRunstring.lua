
--Fuck you toybox
if iface3 then return end


local Bad = {
	"RunString",
	"RunStringEx",
	"CompileString",
	"Compilestring",
	"CompileFile",
}


for k,v in pairs(Bad) do
	if not _G[v.."Crap"] then
		_G[v.."Crap"] = _G[v]
	end
	
	_G[v] = function()
		--print("bad '"..v.."' called: ", NotDGI(2).short_src)
	end
end


local function ResetAll()
	for k,v in pairs(Bad) do
		if _G[v.."Crap"] then
			_G[v] = _G[v.."Crap"]
			_G[v.."Crap"] = nil
		end
	end
	
	print("! fixed")
end

if (CLIENT) then
	concommand.Add("hex_toybox_reset_cl", ResetAll)
else
	concommand.Add("hex_toybox_reset_sv", ResetAll)
end





