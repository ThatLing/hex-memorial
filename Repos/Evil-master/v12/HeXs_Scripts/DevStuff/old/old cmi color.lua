	
	
	for k,v in pairs( file.FindInLua("custom_menu/ml_base_*.lua") ) do --include base modules
		include("custom_menu/"..v)
		table.insert(DontLoadAgain, v)
		COLCON( GREEN, "  CMI " , CMIColor, "Loaded ", PINK, "Base ", CMIColor, "Module", WHITE, ": "..v )
	end
	
	for k,v in pairs( file.FindInLua("custom_menu/ml_*.lua") ) do --include modules
		if not table.HasValue(DontLoadAgain, v) then
			include("custom_menu/"..v)
			COLCON( GREEN, "  CMI " , CMIColor, "Loaded Module", WHITE, ": "..v )
		end
	end
	
