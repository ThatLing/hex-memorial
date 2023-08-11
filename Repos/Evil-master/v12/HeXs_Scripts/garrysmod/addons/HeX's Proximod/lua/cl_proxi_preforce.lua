////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//

function proxi_Panel(Panel)	
	Panel:AddControl("Checkbox", {
			Label = "Enable", 
			Description = "Enable", 
			Command = "proxi_core_enable" 
		}
	)
	Panel:AddControl("Button", {
			Label = "Open Menu (proxi_menu)", 
			Description = "Open Menu (proxi_menu)", 
			Command = "proxi_menu"
		}
	)
	
	Panel:Help("To trigger the menu in any gamemode, type proxi_menu in the console, or bind this command to any key.")
	
end

function proxi_AddPanel()
	spawnmenu.AddToolMenuOption("Options", "Player", PROXI_NAME, PROXI_NAME, "", "", proxi_Panel, {SwitchConVar = 'proxi_core_enable'})
	
end

function proxi_InitLoad()
	hook.Add( "PopulateToolMenu", "AddProxiPanel", proxi_AddPanel )
	
end

