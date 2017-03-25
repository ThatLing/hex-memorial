
SOURCE_SDK 		= "D:/SourceSDK/src/"
GMOD_HEADERS 	= "D:/SourceSDK/garrysmod"
THIS_DLL 		= "gmsv_lag_win32"

--Code
CodeDirs = {
	--GMod
	GMOD_HEADERS,
	
	--SDK
	SOURCE_SDK.."/common",
	SOURCE_SDK.."/public/tier0",
	SOURCE_SDK.."/public/tier1",
	SOURCE_SDK.."/public",
}

--Files
Code = {
	THIS_DLL.."/**.cpp",
	THIS_DLL.."/**.h"
}


--Libraries
LibDirs = {
	"deps",
	SOURCE_SDK.."/lib/public",
	GMOD_HEADERS,
}

Libs = {
	"tier0",
	"tier1",
}



--- MAIN ---

--Setup, make dirs
os.mkdir(THIS_DLL)


solution(THIS_DLL)
language("C++")
location("") --os.get().."-".._ACTION
targetdir("Release/")

includedirs(CodeDirs)

libdirs(LibDirs)

links(Libs)

configurations( {"Release"} )

configuration("Release")
defines( {"NDEBUG"} )
optimize("On")

configuration("vs*")
linkoptions( {
	"/NODEFAULTLIB:libcmt"
} )

project(THIS_DLL)
defines( {"GMMODULE"} )
kind("SharedLib")

files(Code)










