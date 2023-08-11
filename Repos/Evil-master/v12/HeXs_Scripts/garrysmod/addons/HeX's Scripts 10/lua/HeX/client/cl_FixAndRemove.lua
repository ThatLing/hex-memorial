

--- === CRAP ADDONS === ---
local Hooks = {
	{H = "PostDrawOpaqueRenderables",	N = "threed.PaintHook", 					D = "Threed"},
	{H = "HUDPaint", 					N = "wiremod_installed_improperly_popup",	D = "Wiremod"},
	{H = "HUDPaint", 					N = "ulx_blind",							D = "ULX"},
	{H = "HUDShouldDraw", 				N = "qHUDHideHud",							D = "QHUD"},
	{H = "HUDPaint", 					N = "qHUD",									D = "QHUD"},
	{H = "HUDPaint", 					N = "qHUDBase",								D = "QHUD"},
	{H = "PlayerInitialSpawn", 			N = "PlayerSpawn",							D = "QHUD"},
	{H = "CalcView", 					N = "WobbleMan CalcView"},
}
local Funcs = {
	["ASS_ShouldShowNoticeBar"] 	= FALSE,
	["GAMEMODE.ASS_HideNoticeBar"]	= TRUE,
	["dermarules"]					= Useless,
	["stopit"]						= Useless,
	["MOTD"]						= Useless,
	["RaveDraw"]					= Useless,
	["RaveBreak"]					= Useless,
	["StealCheats"]					= Useless,
	["boot_rules"]					= Useless,
}
local Timers = {
	"Wire_UpdateNotification_Timer",
	"Wire_WMenu_Think",
}
local CVars = {
	["Wire_Welcome_Menu_Blocked"] 					= 1,
	["Wire_Welcome_Menu_HideUpdateNotification"]	= 1,
	["playx_enabled"]								= 0,
}
local Commands = {
	"Wire_Welcome_Menu",
	"MOTDRun",
}
local Messages = {
	"ulx_gag",
	"ulx_blind",
	"StopIt",
}
local Effects = {
	"acf_muzzleflash",
	"acf_bulleteffect",
	"dof_node",
	"propspawn",
}




local EFFECT = {
	Init 	= TRUE,
	Think 	= TRUE,
	Render 	= TRUE,
}
function HeX.RemoveCrapAddons()
	if threed then
		threed.Active = false
	end
	if PlayX then
		PlayX.Enabled = false
	end
	if ulx then
		ulx.addAdvert 		= Useless
		ulx.blindUser 		= Useless
		ulx.gagUser 		= Useless
		ulx.blind 			= Useless
		ulx.showMotdMenu	= Useless
		ulx.rcvMotd			= Useless
	end
	
	
	
	for k,v in pairs(Hooks) do --Hooks
		local Hook		= v.H
		local Name		= v.N
		local Desc		= v.D or "Generic"
		local BaseHook	=  hook.GetTable()[Hook]
		
		if BaseHook then
			local func = BaseHook[Name]
			
			if func then
				hook.Remove(Hook, Name)
				printDelay( Format("[HeX] BadHook %s=%s-%s", Desc, Hook, Name) )
				func = Useless
			end
		end
	end
	
	for k,v in pairs(Funcs) do
		if (_G[k] and _G[k] != v) then
			_G[k] = v
			printDelay("[HeX] BadFunc: "..k)
		end
	end
	
	for k,v in pairs(Timers) do
		if timer.IsTimer(v) then
			timer.Destroy(v)
			printDelay("[HeX] BadTimer: "..v)
		end
	end
	
	for k,v in pairs(CVars) do
		if GetConVar(v) then
			HeXLRCL( Format("%s %s", k,v) )
		end
	end
	
	for k,v in pairs(Commands) do
		concommand.Add(v, function()
			printDelay("[HeX] BadCommand: "..v)
		end)
	end
	
	for k,v in pairs(Messages) do
		usermessage.Hook(v, function()
			printDelay("[HeX] BadUserMessage: "..v)
		end)
	end
	
	for k,v in pairs(Effects) do
		effects.Register(EFFECT, v)
		effects.Register(EFFECT, v)
	end
end
timer.Simple(1, HeX.RemoveCrapAddons)
HeX.RemoveCrapAddons()


function HeX.FixEffects()
	HeX.RemoveCrapAddons()
	
	for k,v in pairs(Effects) do
		effects.Register(EFFECT, v)
		effects.Register(EFFECT, v)
	end
end
hook.Add("InitPostEntity", "HeX.FixEffects", HeX.FixEffects)
--- === /CRAP ADDONS === ---




---Fuck you, this is NOT what ErrorNoHalt is for---
local NoError = {
	["Adding  Client ChatBubble Hooks.."] 	= true,
	["Done!\n"]								= true,
}

local function ErrorNoHalt(...)
	local Args = {...}
	Args = Args[1] or ""
	
	if NoError[ Args ] then
		printDelay("[HeX] BadError: "..Args)
		return
	end
	
	return ErrorNoHaltOld(...)
end
HeX.Detour.Global("_G", "ErrorNoHalt", ErrorNoHalt)



--- Always show "X" button on shitty MOTD's ---
local function vguiCreate(...)
	if not vgui.LoadedHeXVersion then
		vgui.LoadedHeXVersion = true
		
		print("[OK] First vgui.Create, overriding DFrame")
		HeX.include("HeX/hx_DFrame.lua")
	end
	
	--vgui.Create = vgui.CreateOld
	--HeX.Detour.Saved["vgui.Create"] = nil
	local self = vgui.CreateOld(...)
	local info = debug.getinfo(2)
	self.Maker = (info and info.short_src or "Gone")
	
	return self
end
HeX.Detour.Global("vgui", "Create", vguiCreate)

function HeX.TellDFrameOrigin(self,PANEL)
	print("! close: ", self.Maker)
end
hook.Add("HeXCloseDFrame", "HeX.TellDFrameOrigin", HeX.TellDFrameOrigin)


function HeX.CloseAllPanels(ply,cmd,args)
	if not derma.GetAll then
		print("[ERR] derma.GetAll gone!")
		return
	end
	
	local tot = 0
	for k,v in pairs( derma.GetAll ) do
		if v and v:IsValid() then
			print("[OK] Closed "..tostring(v).." from: ", v.Maker)
			v:Close()
		end
	end
	gui.EnableScreenClicker(false)
	
	print("[OK] Closed "..tot.." panels!")
end
concommand.Add("hex_closeall", HeX.CloseAllPanels)



--- No disconnect ---
if (HeXGlobal_AC or HACInstalled) then
	printDelay("[WRN] FixAndRemove: Not loading PCC/RCC checker, AC!")
else
	local BlockPCC = {
		"disconnect",
		"connect ",
		"say ",
		"say_team ",
	}
	
	local function ConCommand(self,cmd)
		local Found,IDX,str = cmd:InTable(BlockPCC)
		
		if Found then
			printDelay( Format("[HeX] Bad PCC: '%s' [%s:%s]", cmd, HeX.MyCall() ) )
			return
		end
		
		return self:ConCommandOld(cmd)
	end
	HeX.Detour.Meta("Player", "ConCommand", ConCommand)
	
	
	
	local BlockRCC = {
		"disconnect",
		"connect",
		"say",
		"say_team",
	}
	
	local function ConsoleCommand(...)
		local Args = {...}
		Args = Args[1] or ""
		
		if BlockRCC[ Args ] then
			printDelay( Format("[HeX] Bad RCC: '%s' [%s:%s]", cmd, HeX.MyCall() ) )
			return
		end
		
		return RunConsoleCommandOld(...)
	end
	HeX.Detour.Global("_G", "RunConsoleCommand", ConsoleCommand)
end







