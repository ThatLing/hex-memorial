

local SOURCE_SDK = "D:/SourceSDK/source-sdk-2013/mp/src"


solution "hac_nukem"
language "C++"
location( os.get().."-".._ACTION )
targetdir("Release/")

flags {"StaticRuntime"}

includedirs {
	"D:/SourceSDK",
	"D:/SourceSDK/secretheaders",
	SOURCE_SDK.."/common",
	SOURCE_SDK.."/public/tier0",
	SOURCE_SDK.."/public/tier1",
	SOURCE_SDK.."/public"
}

libdirs {
	"D:/SourceSDK/secretheaders",
	SOURCE_SDK.."/lib/public"
}

links {
	"steamclient",
	"tier0",
	"tier1",
	"libcmt",
	"psapi",
	"winmm",
}

configurations { 
	"Release"
}

configuration "Release"
	defines { "NDEBUG" }
	optimize "On"

configuration "vs*"
	linkoptions {
		"/NODEFAULTLIB:libcmt",
	}

project "hac_nukem"
	defines { "GMMODULE" }
	kind "SharedLib"
	
	files {
		"src/**.cpp",
		"src/**.h"
	}