
----------------------------------------
--         2014-07-12 20:33:08          --
------------------------------------------
--thanks, SmartSnap


surface.CreateFont("HL2KillIcons", {
	font		= "halflife2",
	size 		= ScreenScale(30),
	weight		= 500,
	antialias	= true,
	additive	= true,
	}
)

surface.CreateFont("HL2SelectIcons", {
	font		= "halflife2",
	size 		= ScreenScale(60),
	weight		= 500,
	antialias	= true,
	additive	= true,
	}
)




--[[



local condefs = {
	twitch_tracerfreq 	     = 1,
	twitch_aimsensitivity      = 1,
	twitch_recoilmul   = 0.2,
	twitch_damagemul     = 1,
	twitch_quickdraw    = 0,
	twitch_aim_bullettime  = 0,
	twitch_aim_bullettime_onjump   = 0,
	twitch_aim_bullettime_tracers   = 1,
	twitch_aim_bullettime_timescale  = 0.2,
	twitch_aim_bullettime_colourdrain     = 1,
	twitch_aim_infiniteammo = 0,
	twitch_hidehud    = 0,
	twitch_aim_hidehud     = 1,
	twitch_aim_hidecrosshair    = 0,
}

local convars = {}

for key,value in pairs(condefs) do
	convars[#convars + 1] = key
end

local function OnPopulateToolPanel(panel)
 	panel:AddControl("ComboBox", {
		Options = { ["default"] = condefs },
		CVars = convars,
		Label = "",
		MenuButton = "1",
		Folder = "twitch_weaponry"
	}) 
	
	panel:AddControl("Label", {Text = ""})
	
	panel:AddControl("Label", {
		Text = "Clientside:"
	})
	
	panel:AddControl("Slider", {
		Label = "Tracer frequency (0 to disable)",
		Command = "twitch_tracerfreq",
		Type = "Integer",
		Min = "0",
		Max = "4",
	})
	
	panel:AddControl("CheckBox", {
		Label = "Hide HUD always",
		Command = "twitch_hidehud",
	})
	
	panel:AddControl("CheckBox", {
		Label = "Hide HUD when aiming",
		Command = "twitch_aim_hidehud",
	})
	
	panel:AddControl("CheckBox", {
		Label = "Hide crosshair when aiming",
		Command = "twitch_aim_hidecrosshair",
	})
	
	panel:AddControl("Slider", {
		Label = "Aim mode mouse sensitivity",
		Command = "twitch_aim_sensitivity",
		Type = "Float",
		Min = "0.1",
		Max = "2",
	})

	panel:AddControl("Label", {Text = ""})
	
	panel:AddControl("Label", {
		Text = "Serverside:"
	})
	
	panel:AddControl("CheckBox", {
		Label = "Draw weapons rapidly",
		Command = "twitch_quickdraw",
	})

	panel:AddControl("CheckBox", {
		Label = "Infinite ammo when aiming",
		Command = "twitch_aim_infiniteammo",
	})

	panel:AddControl("Slider", {
		Label = "Recoil multiplier",
		Command = "twitch_recoilmul",
		Type = "Float",
		Min = "0",
		Max = "4",
	})

	panel:AddControl("Slider", {
		Label = "Damage multiplier",
		Command = "twitch_damagemul",
		Type = "Float",
		Min = "0.25",
		Max = "5",
	})
	
	panel:AddControl("Label", {Text = ""})
	
	panel:AddControl("Label", {
		Text = "Slowmo (REQUIRES SV_CHEATS 1):"
	})
	
	panel:AddControl("CheckBox", {
		Label = "Enable slowmo when aiming",
		Command = "twitch_aim_bullettime",
	})

	panel:AddControl("CheckBox", {
		Label = "Enable slowmo colour drain",
		Command = "twitch_aim_bullettime_colourdrain",
	})
	
	panel:AddControl("CheckBox", {
		Label = "All bullets are tracers in slowmo",
		Command = "twitch_aim_bullettime_tracers",
	})

	panel:AddControl("CheckBox", {
		Label = "Enable slowmo when in midair",
		Command = "twitch_aim_bullettime_onjump",
	})

	panel:AddControl("Slider", {
		Label = "Slowmo timescale",
		Command = "twitch_aim_bullettime_timescale",
		Type = "Float",
		Min = "0.1",
		Max = "0.75",
	})
end

function TW2ToolMenu()
	spawnmenu.AddToolMenuOption("Options", "Addons", "Twitch Weaponry", "Twitch Weaponry", "", "", OnPopulateToolPanel)
end

hook.Add("PopulateToolMenu", "TW2ToolMenu", TW2ToolMenu)
]]




----------------------------------------
--         2014-07-12 20:33:08          --
------------------------------------------
--thanks, SmartSnap


surface.CreateFont("HL2KillIcons", {
	font		= "halflife2",
	size 		= ScreenScale(30),
	weight		= 500,
	antialias	= true,
	additive	= true,
	}
)

surface.CreateFont("HL2SelectIcons", {
	font		= "halflife2",
	size 		= ScreenScale(60),
	weight		= 500,
	antialias	= true,
	additive	= true,
	}
)




--[[



local condefs = {
	twitch_tracerfreq 	     = 1,
	twitch_aimsensitivity      = 1,
	twitch_recoilmul   = 0.2,
	twitch_damagemul     = 1,
	twitch_quickdraw    = 0,
	twitch_aim_bullettime  = 0,
	twitch_aim_bullettime_onjump   = 0,
	twitch_aim_bullettime_tracers   = 1,
	twitch_aim_bullettime_timescale  = 0.2,
	twitch_aim_bullettime_colourdrain     = 1,
	twitch_aim_infiniteammo = 0,
	twitch_hidehud    = 0,
	twitch_aim_hidehud     = 1,
	twitch_aim_hidecrosshair    = 0,
}

local convars = {}

for key,value in pairs(condefs) do
	convars[#convars + 1] = key
end

local function OnPopulateToolPanel(panel)
 	panel:AddControl("ComboBox", {
		Options = { ["default"] = condefs },
		CVars = convars,
		Label = "",
		MenuButton = "1",
		Folder = "twitch_weaponry"
	}) 
	
	panel:AddControl("Label", {Text = ""})
	
	panel:AddControl("Label", {
		Text = "Clientside:"
	})
	
	panel:AddControl("Slider", {
		Label = "Tracer frequency (0 to disable)",
		Command = "twitch_tracerfreq",
		Type = "Integer",
		Min = "0",
		Max = "4",
	})
	
	panel:AddControl("CheckBox", {
		Label = "Hide HUD always",
		Command = "twitch_hidehud",
	})
	
	panel:AddControl("CheckBox", {
		Label = "Hide HUD when aiming",
		Command = "twitch_aim_hidehud",
	})
	
	panel:AddControl("CheckBox", {
		Label = "Hide crosshair when aiming",
		Command = "twitch_aim_hidecrosshair",
	})
	
	panel:AddControl("Slider", {
		Label = "Aim mode mouse sensitivity",
		Command = "twitch_aim_sensitivity",
		Type = "Float",
		Min = "0.1",
		Max = "2",
	})

	panel:AddControl("Label", {Text = ""})
	
	panel:AddControl("Label", {
		Text = "Serverside:"
	})
	
	panel:AddControl("CheckBox", {
		Label = "Draw weapons rapidly",
		Command = "twitch_quickdraw",
	})

	panel:AddControl("CheckBox", {
		Label = "Infinite ammo when aiming",
		Command = "twitch_aim_infiniteammo",
	})

	panel:AddControl("Slider", {
		Label = "Recoil multiplier",
		Command = "twitch_recoilmul",
		Type = "Float",
		Min = "0",
		Max = "4",
	})

	panel:AddControl("Slider", {
		Label = "Damage multiplier",
		Command = "twitch_damagemul",
		Type = "Float",
		Min = "0.25",
		Max = "5",
	})
	
	panel:AddControl("Label", {Text = ""})
	
	panel:AddControl("Label", {
		Text = "Slowmo (REQUIRES SV_CHEATS 1):"
	})
	
	panel:AddControl("CheckBox", {
		Label = "Enable slowmo when aiming",
		Command = "twitch_aim_bullettime",
	})

	panel:AddControl("CheckBox", {
		Label = "Enable slowmo colour drain",
		Command = "twitch_aim_bullettime_colourdrain",
	})
	
	panel:AddControl("CheckBox", {
		Label = "All bullets are tracers in slowmo",
		Command = "twitch_aim_bullettime_tracers",
	})

	panel:AddControl("CheckBox", {
		Label = "Enable slowmo when in midair",
		Command = "twitch_aim_bullettime_onjump",
	})

	panel:AddControl("Slider", {
		Label = "Slowmo timescale",
		Command = "twitch_aim_bullettime_timescale",
		Type = "Float",
		Min = "0.1",
		Max = "0.75",
	})
end

function TW2ToolMenu()
	spawnmenu.AddToolMenuOption("Options", "Addons", "Twitch Weaponry", "Twitch Weaponry", "", "", OnPopulateToolPanel)
end

hook.Add("PopulateToolMenu", "TW2ToolMenu", TW2ToolMenu)
]]



