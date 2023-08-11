--[[if !console then require("console") end

local EntityColor = Color( 151, 211, 255 )

function console.AddText( ... )
	
	local color = Color( 255, 255, 255 )
	
	for k, v in pairs( {...} ) do
		if ( type( v ) == "table" && v["b"] && v["g"] && v["r"] ) then
			color = v
		elseif ( type( v ) == "Player" and IsValid( v ) ) then
			console.Print( team.GetColor( v:Team() ), v:GetName() )
		elseif ( ( type( v ) == "Entity" or type( v ) == "Weapon" or type( v ) == "Vehicle" or type( v ) == "NPC" ) and IsValid( v ) ) then
			console.Print( EntityColor, v:GetClass() )
		else
			console.Print( color, tostring(v) )
		end
	end
	
	console.Print( color, "\n" )
end]]
