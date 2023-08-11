
	for k,v in pairs( file.FindInLua("custom_menu/*.lua") ) do
		if v:sub(1,5) == "ml_B_" then --include base modules first
			COLCON( CMIColor, " Loading ", PINK, "Base", WHITE, ": "..v )
			include("custom_menu/"..v)
			
		elseif v:sub(1,5) == "ml_H_" then --include hack modules
			COLCON( CMIColor, " Loading ", RED, "Hack", WHITE, ": "..v )
			include("custom_menu/"..v)
			
			
		elseif v:sub(1,3) == "ml_" then --include modules
			COLCON( CMIColor, " Loading ", GREEN, "Module", WHITE, ": "..v )
			include("custom_menu/"..v)
		end
	end

	
	