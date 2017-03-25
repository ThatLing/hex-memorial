
#define GAME_DLL
#define CLIENT_DLL
#define WIN32_LEAN_AND_MEAN

#include <engine/iserverplugin.h>
#include <eiface.h>
#include <filesystem.h>
#include "Color.h"

#include <simplescan/csimplescan.h>
#include <simpledetours/csimpledetour.h>
#include <simpledetours/cdetour.h>

#include <eiface.h>
#include <stdlib.h>
#include <Windows.h>
#include <stdio.h>


IFileSystem* FileSys = NULL;

Color Blue(0,162,232,255);
Color White(255,255,255,255);
Color Sexy(255,174,201,255);
Color Red(255,0,0,255);


bool (CDetour:: *CDetour::CLuaInterface_FindAndRunScript_T)(const char *, bool, bool) = NULL;
SETUP_SIMPLE_DETOUR(CLuaInterface_FindAndRunScript_Detour, CDetour::CLuaInterface_FindAndRunScript_T, CDetour::CLuaInterface_FindAndRunScript_H);


bool CDetour::CLuaInterface_FindAndRunScript_H(const char* strFilename, bool bRun, bool bReportErrors) {
	if (!strcmp(strFilename, "includes/vgui_base.lua")) {
		FileFindHandle_t handle;
		
		for (const char *fname = FileSys->FindFirst("lua/menu_plugins/*", &handle);fname != NULL;fname = FileSys->FindNext(handle)) {
			char ext[32];
			V_ExtractFileExtension(fname, ext, 32);
			
			if (!strcmp(ext, "lua")) {
				char flua[MAX_PATH];
				*flua = '\0';
				
				strcat(flua, "menu_plugins/");
				strcat(flua, fname);
				
				ConColorMsg(Sexy, 	"[pl_MenuPlugins");
				ConColorMsg(Red, 	"2");
				ConColorMsg(Sexy, 	"]: ");
				char* str = new char[256];
					sprintf(str, "Loading %s..\n", flua);
					ConColorMsg(White, str);
				delete [] str;
				
				(this->*CLuaInterface_FindAndRunScript_T)("includes/vgui_base.lua", bRun, bReportErrors); //Load original!
				(this->*CLuaInterface_FindAndRunScript_T)(flua, bRun, bReportErrors);
			}
		}
		FileSys->FindClose(handle);
		
		return true;
	} else {
		return (this->*CLuaInterface_FindAndRunScript_T)(strFilename, bRun, bReportErrors);
	}
}



BOOL APIENTRY DllMain(HMODULE hmDll, DWORD dwReason, LPVOID lpReserved) {
	if (dwReason == DLL_PROCESS_ATTACH) {
		DisableThreadLibraryCalls(hmDll);
		
		CreateInterfaceFn filesystem = Sys_GetFactory("filesystem_steam.dll");
		FileSys = (IFileSystem*)filesystem(FILESYSTEM_INTERFACE_VERSION, NULL);
		if (!FileSys) {
			ConColorMsg(Red, "[pl_MenuPlugins2]: ");
			ConColorMsg(White, "Can't get IFileSystem " FILESYSTEM_INTERFACE_VERSION " interface :(\n");
			return true;
		}
		
		CSimpleScan luaInterface("lua_shared.dll");
		
		if (luaInterface.FindFunction("\x81\xEC\x08\x03\x00\x00\x8B\x84\x24\x0C\x03\x00\x00\x53\x56\x57\x68\x04\x01\x00\x00", "xxxxxxxxxxxxxxxxxxxxx", (void **)&CDetour::CLuaInterface_FindAndRunScript_T))
			CLuaInterface_FindAndRunScript_Detour.Attach();
		else {
			ConColorMsg(Red, "[pl_MenuPlugins2]: ");
			ConColorMsg(White, "SigScan of FindAndRunScript in lua_shared failed :(\n");
			return true;
		}
		
		
		ConColorMsg(Sexy, 	"[pl_MenuPlugins");
		ConColorMsg(White, 	"3");
		ConColorMsg(Sexy, 	"]: ");
		ConColorMsg(White,	"Made by");
		ConColorMsg(Blue,	" -=[UH]=- HeX");
		ConColorMsg(White,	" to auto-load menu_plugins, STOP FUCKING BREAKING IT!\n");
		
	} else if (dwReason == DLL_PROCESS_DETACH) {
		CLuaInterface_FindAndRunScript_Detour.Detach();
	}
	return true;
}







