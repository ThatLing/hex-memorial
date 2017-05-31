
----------------------------------------
--         2014-07-12 20:32:44          --
------------------------------------------

function JS_Language( html )

	html:AddFunction( "language", "Update", function( phrase )

		return language.GetPhrase( phrase );

	end )

end

function JS_Utility( html )

	html:AddFunction( "util", "MotionSensorAvailable", function()

		return motionsensor.IsAvailable()

	end )

end

----------------------------------------
--         2014-07-12 20:32:44          --
------------------------------------------

function JS_Language( html )

	html:AddFunction( "language", "Update", function( phrase )

		return language.GetPhrase( phrase );

	end )

end

function JS_Utility( html )

	html:AddFunction( "util", "MotionSensorAvailable", function()

		return motionsensor.IsAvailable()

	end )

end
