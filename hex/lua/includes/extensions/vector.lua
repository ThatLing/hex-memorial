
----------------------------------------
--         2014-07-12 20:32:44          --
------------------------------------------
local meta = FindMetaTable( "Vector" )

-- Nothing in here, still leaving this file here just in case

--[[---------------------------------------------------------
	Converts Vector To Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor( )

	return Vector( self.x * 255, self.y * 255, self.z * 255, 255 )

end

----------------------------------------
--         2014-07-12 20:32:44          --
------------------------------------------
local meta = FindMetaTable( "Vector" )

-- Nothing in here, still leaving this file here just in case

--[[---------------------------------------------------------
	Converts Vector To Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor( )

	return Vector( self.x * 255, self.y * 255, self.z * 255, 255 )

end
