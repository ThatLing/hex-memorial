


local DSCommands = {
	"__dsr",
	"__dsp",
	"__dse",
}

local function FuckDS()
	for k,v in pairs(DSCommands) do
		HeXLRCL("alias "..cmd.." echo 'Datastream: "..cmd.."' blocked!")
	end
end
concommand.Add("hex_fuckds", FuckDS)


