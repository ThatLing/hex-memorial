

local SOURCE_SDK = "D:/SourceSDK/source-sdk-2013/mp/src"

solution "gmsv_askconnect_win32"
	language "C++"
	
	targetdir ( "build/" .. os.get() .. "/" )

	includedirs {
		"include",
		SOURCE_SDK .. "/common",
		SOURCE_SDK .. "/public",
		SOURCE_SDK .. "/public/tier0",
		SOURCE_SDK .. "/public/tier1"
	}

	libdirs {
		"lib",
		SOURCE_SDK .. "/lib/public"
	}

	links {
		"tier0",
		"tier1",
		"vstdlib"
	}
	
	configurations { 
		"Release"
	}

	configuration "Release"
		defines { "GMMODULE" }
		optimize "On"

	configuration "vs*"
		linkoptions { "/NODEFAULTLIB:libcmt" }
	
	project "gmsv_askconnect_win32"
		kind "SharedLib"
		
		files {
			"src/**.cpp",
			"src/**.h"
		}

		if os.is "windows" then
			targetsuffix "_win32"
		elseif os.is "linux" then
			targetsuffix "_linux"
		elseif os.is "macosx" then
			targetsuffix "_osx"
		end