/*
	=== gmcl_stuffloader ===
	*To load Sykranos' dirty hacks*
	
	Credits:
		. Helix Alioth (gm_hio)
		. HeX
*/

#undef _UNICODE
#define CLIENT_DLL
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment (lib,"tier0.lib")
#pragma comment (lib,"tier1.lib")

#include "GMLuaModule.h"

#include "Color.h"
#include <eiface.h>

#include <direct.h>
#include <stdarg.h>
#include <sys/stat.h>
#include <Windows.h>
#include <exception>
#include <fstream>
#include <string>
#include <sstream>
#include <stdio.h>

using namespace std;

ILuaInterface* cl_Lua		= NULL;

Color Blue(0,162,232,255);
Color White(255,255,255,255);
Color Sexy(255,174,201,255);
Color Red(255,0,0,255);
Color Green(85,218,90,255);


LUA_FUNCTION(Load) {
	cl_Lua->CheckType(1, GLua::TYPE_STRING);
	ConColorMsg(Sexy, "[gmcl_stuffloader]:");
	
	string fullPath;
	char* str = new char[256];
	
	if (cl_Lua->GetString(1)[1] == ':')
	{
		fullPath = cl_Lua->GetString(1);
	} else {
		char workingDir [256];
		_getcwd(workingDir, 256);
		
		fullPath = workingDir;
		//fullPath += "\\garrysmod\\";
		fullPath += "\\";
		fullPath += cl_Lua->GetString(1);
	}
	ifstream ReadFile;
	ReadFile.open(fullPath.c_str(), ios::binary);
	
	if ( !ReadFile.is_open() ) {
		sprintf(str, " Bad path for %s!\n", cl_Lua->GetString(1));
		ConColorMsg(Red, str);
		return 0;
	}
	
	ReadFile.seekg( 0, ios::end );
		int length = ReadFile.tellg();
	ReadFile.seekg( 0, ios::beg );
	char* buffer = new char[length+1];
	
	ReadFile.read(buffer, length);
	buffer[length] = 0;
	

	sprintf(str, " Loading %s..\n", cl_Lua->GetString(1));
	ConColorMsg(Green, str);
	
	cl_Lua->RunString("", "gmcl_stuffloader", buffer, true, true);
	
	delete [] str;
	delete [] buffer;
	return 0;
}



GMOD_MODULE(Open, Close);

int Open(lua_State* L) {
	cl_Lua = Lua();
	
	cl_Lua->NewGlobalTable("stuffloader");
	ILuaObject* stuffloader = cl_Lua->GetGlobal("stuffloader");
		stuffloader->SetMember("Load", Load);
	stuffloader->UnReference();
	
	ConColorMsg(Sexy, "[gmcl_stuffloader]:");
	ConColorMsg(White, " Made by");
	ConColorMsg(Blue, " -=[UH]=- HeX");
	ConColorMsg(White, " for");
	ConColorMsg(Red, " Sykranos");
	ConColorMsg(White, " to load his dirty hax\n");
	
	ConColorMsg(Sexy, "[gmcl_stuffloader]:");
	ConColorMsg(White, " stuffloader.Load is relative to the");
	ConColorMsg(Red, " FIRST");
	ConColorMsg(White, " garrysmod folder! (by request)\n");
	
	return 0;
}

int Close(lua_State* L) {
	return 0;
}


