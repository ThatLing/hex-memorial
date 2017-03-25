

#undef _UNICODE

#pragma comment(lib,"tier0.lib")
#pragma comment(lib,"tier1.lib")
#pragma comment(lib,"vstdlib.lib")
#pragma comment(linker,"/NODEFAULTLIB:libcmt")


#define CLIENT_DLL

#include <GMLuaModule.h>
#include <ILuaShared_B13.h>

#include <Color.h>
//#include <filesystem.h>
#include <convar.h>
#include <game/client/cdll_client_int.h>

#include <windows.h>
#include <string>
#include <fstream>
#include <interface.h>
#include <direct.h>
#include <stdio.h>
#include <stdarg.h>
#include <sys/stat.h>
#include <cassert>


//IFileSystem* FileSys			= NULL;
ILuaInterface* ml_Lua			= NULL;
ILuaShared* g_LuaShared 		= NULL;
ICvar* g_ICvar					= NULL;
IVEngineClient* g_EngineClient	= NULL;

using namespace std;

HANDLE hPLThread;

static ConCommand *lua_run_mn			= NULL;

Color Blue(0,162,232,255);
Color White(255,255,255,255);
Color Sexy(255,174,201,255);
Color Red(255,0,0,255);


void RunLuaMenu(const CCommand &command) {
	if (!ml_Lua) {
		ConColorMsg(Sexy, 	"[in_MenuPlugins");
		ConColorMsg(White, 	"4");
		ConColorMsg(Sexy, 	"]: ");
		ConColorMsg(White, "Can't get ml_Lua :(\n");
		return;
	}
	
	ml_Lua->RunString("", "[in_MenuPlugins4]", command.ArgS(), true, true);
}


DWORD WINAPI PLThread(LPVOID param) {
	while (ml_Lua == NULL) {
		ml_Lua = g_LuaShared->GetLuaInterface(2);
		
		if (ml_Lua) {
			assert(ml_Lua);
			
			ConColorMsg(Sexy, 	"[in_MenuPlugins");
			ConColorMsg(White, 	"4");
			ConColorMsg(Sexy, 	"]: ");
			ConColorMsg(White,	"Got ml_Lua!\n");	
			
			Sleep(1000);
			g_EngineClient->ClientCmd("lua_run_in include('in_menuplugins.lua')");
			
			ExitThread(1);
			return true;
		}
	}
	
	return true;
}


BOOL APIENTRY DllMain(HMODULE hmDll, DWORD dwReason, LPVOID lpReserved) {
	if (dwReason == DLL_PROCESS_ATTACH) {
		DisableThreadLibraryCalls(hmDll);
		
		HMODULE hmLuaShared = GetModuleHandle("lua_shared.dll");
		CreateInterfaceFn fnLua = (CreateInterfaceFn)GetProcAddress(hmLuaShared, "CreateInterface");
		
		g_LuaShared = (ILuaShared*)fnLua("LuaShared002", NULL);
		if (!g_LuaShared) {
			ConColorMsg(Sexy, 	"[in_MenuPlugins");
			ConColorMsg(White, 	"4");
			ConColorMsg(Sexy, 	"]: ");
			ConColorMsg(White, "Can't get LuaShared002 interface :(\n");
			return true;
		}
		
		/*
		CreateInterfaceFn filesystem = Sys_GetFactory("filesystem_steam.dll");
		FileSys = (IFileSystem*)filesystem("VGModFileSystem019", NULL);
		if (!FileSys) {
			ConColorMsg(Sexy, 	"[in_MenuPlugins");
			ConColorMsg(White, 	"4");
			ConColorMsg(Sexy, 	"]: ");
			ConColorMsg(White, "Can't get IFileSystem VGModFileSystem019 interface :(\n");
			return true;
		}
		*/
		
		CreateInterfaceFn EngineFactory = Sys_GetFactory("engine.dll");
		if (!EngineFactory) {
			ConColorMsg(Sexy, 	"[in_MenuPlugins");
			ConColorMsg(White, 	"4");
			ConColorMsg(Sexy, 	"]: ");
			ConColorMsg(White, "Can't get EngineFactory :(\n");
			return true;
		}
		
		g_EngineClient = (IVEngineClient*)EngineFactory("VGMODEngineClient014", NULL);
		if (!g_EngineClient) {
			ConColorMsg(Sexy, 	"[in_MenuPlugins");
			ConColorMsg(White, 	"4");
			ConColorMsg(Sexy, 	"]: ");
			ConColorMsg(White, "Can't get IVEngineClient VGMODEngineClient014 :(\n");
			return true;
		}
		
		
		CreateInterfaceFn VSTDLibFactory = Sys_GetFactory("vstdlib.dll");
		if (!VSTDLibFactory) {
			ConColorMsg(Sexy, 	"[in_MenuPlugins");
			ConColorMsg(White, 	"4");
			ConColorMsg(Sexy, 	"]: ");
			ConColorMsg(White, "Can't get VSTDLibFactory vstdlib :(\n");
			return true;
		}
		
		g_ICvar = (ICvar*)VSTDLibFactory(CVAR_INTERFACE_VERSION, NULL);
		if (!g_ICvar) {
			ConColorMsg(Sexy, 	"[in_MenuPlugins");
			ConColorMsg(White, 	"4");
			ConColorMsg(Sexy, 	"]: ");
			ConColorMsg(White, "Can't get g_ICvar " CVAR_INTERFACE_VERSION " :(\n");
			return true;
		}
		lua_run_mn = new ConCommand("lua_run_in", RunLuaMenu, "Run a Lua command", FCVAR_UNREGISTERED);
		g_ICvar->RegisterConCommand(lua_run_mn);
		
		hPLThread = CreateThread(NULL, 0, &PLThread, NULL, NULL, NULL);
		
		ConColorMsg(Sexy, 	"[in_MenuPlugins");
		ConColorMsg(White, 	"4");
		ConColorMsg(Sexy, 	"]: ");
		ConColorMsg(White,	"Made by");
		ConColorMsg(Blue,	" -=[UH]=- HeX");
		ConColorMsg(White,	" to load menu_plugins, STOP FUCKING BREAKING IT GARRY >:(\n");
		return true;
		
	} else if (dwReason == DLL_PROCESS_DETACH) {
		if (hPLThread) {
			CloseHandle(hPLThread);
		}
		return true;
	}
	
	return true;
}








