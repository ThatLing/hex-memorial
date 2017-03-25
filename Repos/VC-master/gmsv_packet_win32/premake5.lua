solution "gmsv_packet"
	language "C++"
targetdir("Release/")

	flags "StaticRuntime"
	
	configurations {
		"Release"
	}

	configuration "Release"
		optimize "On"

	project "gmsv_packet"
		kind "SharedLib"

		files {
			"src/**.cpp",
			"src/**.h"
		}

		include "SourceSDK/Tier0"
		include "SourceSDK/Tier1"
        include "LuaInterface"
