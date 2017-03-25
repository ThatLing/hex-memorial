
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

#include "main.h"


IFileSystem* FileSys = NULL;

Color Blue(0,162,232,255);
Color White(255,255,255,255);
Color Sexy(255,174,201,255);
Color Red(255,0,0,255);

MLPlugins ServerPlugin;
EXPOSE_SINGLE_INTERFACE_GLOBALVAR(MLPlugins, IServerPluginCallbacks, INTERFACEVERSION_ISERVERPLUGINCALLBACKS, ServerPlugin);


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


bool MLPlugins::Load(CreateInterfaceFn interfaceFactory, CreateInterfaceFn gameServerFactory) {
	
	FileSys = (IFileSystem*)interfaceFactory(FILESYSTEM_INTERFACE_VERSION, NULL);
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
	ConColorMsg(Red, 	"2");
	ConColorMsg(Sexy, 	"]: ");
	ConColorMsg(White,	"Made by");
	ConColorMsg(Blue,	" -=[UH]=- HeX");
	ConColorMsg(White,	" to auto-load menu_plugins!\n");
	
	return true;
}

void MLPlugins::Unload() {
	CLuaInterface_FindAndRunScript_Detour.Detach();
}

const char *MLPlugins::GetPluginDescription(void) {
	return "HeX's menu_plugins loader";
}



void MLPlugins::Pause(void) {}
void MLPlugins::UnPause(void) {}

void MLPlugins::LevelInit(char const *pMapName) {}
void MLPlugins::ServerActivate(edict_t *pEdictList, int edictCount, int clientMax) {}
void MLPlugins::GameFrame(bool simulating) {}
void MLPlugins::LevelShutdown(void) {}
void MLPlugins::ClientActive(edict_t *pEntity) {}
void MLPlugins::ClientDisconnect(edict_t *pEntity) {}
void MLPlugins::ClientPutInServer(edict_t *pEntity, char const *playername) {}
void MLPlugins::SetCommandClient(int index) {}
void ClientPrint(edict_t *pEdict, char *format, ...) {}
void MLPlugins::ClientSettingsChanged(edict_t *pEdict) {}

void MLPlugins::OnEdictAllocated(edict_t *edict) {}
void MLPlugins::OnEdictFreed(const edict_t *edict ) {}
void MLPlugins::FireGameEvent(KeyValues * event) {}

void MLPlugins::OnQueryCvarValueFinished(QueryCvarCookie_t Cookie, edict_t *Ply, EQueryCvarValueStatus Status, const char *CName, const char *CVal) {}


PLUGIN_RESULT MLPlugins::ClientConnect(bool *Allow, edict_t *Ent, const char *Name, const char *IP, char *reject, int Len) {
	return PLUGIN_CONTINUE;
}
PLUGIN_RESULT MLPlugins::ClientCommand(edict_t *pEntity, const CCommand &args) {
	return PLUGIN_CONTINUE;
}
PLUGIN_RESULT MLPlugins::NetworkIDValidated(const char *pszUserName, const char *pszNetworkID) {
	return PLUGIN_CONTINUE;
}

