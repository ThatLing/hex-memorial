

#undef _UNICODE

#pragma comment(lib,"tier0.lib")
#pragma comment(lib,"tier1.lib")
#pragma comment(lib,"vstdlib.lib")
#pragma comment(linker,"/NODEFAULTLIB:libcmt")


#define CLIENT_DLL

#include <stdio.h>
#include <windows.h>
#include <math.h>

#include "Color.h"
#include "convar.h"

#include <GMLuaModule.h>
#include <CStateManager.h>

#include <engine/iserverplugin.h>
#include <igameevents.h>
#include <filesystem.h>

#include "main.h"

IFileSystem* FileSys	= NULL;
ICvar* g_ICvar			= NULL;
ILuaInterface* ml_Lua	= NULL;

static ConCommand *lua_run_mn			= NULL;
static ConCommand *lua_openscript_mn	= NULL;

HANDLE hPLThread;

Color Blue(0,162,232,255);
Color White(255,255,255,255);
Color Sexy(255,174,201,255);
Color Red(255,0,0,255);

MLPlugins ServerPlugin;
EXPOSE_SINGLE_INTERFACE_GLOBALVAR(MLPlugins, IServerPluginCallbacks, INTERFACEVERSION_ISERVERPLUGINCALLBACKS, ServerPlugin);

MLPlugins::MLPlugins() {}
MLPlugins::~MLPlugins() {}

void LoadMenuPlugins() {
	FileFindHandle_t handle;
	for (const char *fname = FileSys->FindFirst("lua/menu_plugins/*", &handle); fname != NULL; fname = FileSys->FindNext(handle)) {
		char ext[32];
		V_ExtractFileExtension(fname, ext, 32);
		
		if (!strcmp(ext, "lua")) {
			ConColorMsg(Sexy, "[pl_MenuPlugins]: ");
			
			char flua[MAX_PATH];
			*flua = '\0';
			
			strcat(flua, "menu_plugins/");
			strcat(flua, fname);
			
			char* str = new char[256];
				sprintf(str, "Loading %s..\n", flua);
				ConColorMsg(White, str);
			delete [] str;
			
			ml_Lua->Msg("! was about to load: %s!\n", flua);
			//ml_Lua->FindAndRunScript(flua, true, true);
		}
	}
	
	FileSys->FindClose(handle);
}



DWORD WINAPI PLThread(LPVOID param)
{
	ILuaInterface* m_Lua = NULL;
	
	while (m_Lua == NULL) {
		m_Lua = CStateManager::GetInterface(LuaStates::MENU);
		
		if (m_Lua) {
			ml_Lua = m_Lua;
			
			ConColorMsg(Sexy, "[pl_MenuPlugins]: ");
			ConColorMsg(White, "Got ml_Lua!\n");
			
			LoadMenuPlugins();
		}
	}
	
	return true;
}

BOOL APIENTRY DllMain(HMODULE hmDll, DWORD dwReason, LPVOID lpReserved)
{
	if (dwReason == DLL_PROCESS_ATTACH) {
		DisableThreadLibraryCalls(hmDll);
	}
	return true;
}




void RunLuaMenu(const CCommand &command) {
	if (!ml_Lua) {
		ConColorMsg(Red, "[pl_MenuPlugins]: ");
		ConColorMsg(White, "Can't get ml_Lua :(\n");
		return;
	}
	
	ml_Lua->RunString("", "", command.ArgS(), true, true);
}

void OpenLuaMenu(const CCommand &command) {
	if (!ml_Lua) {
		ConColorMsg(Red, "[pl_MenuPlugins]: ");
		ConColorMsg(White, "Can't get ml_Lua :(\n");
		return;
	}
	const char* file = command.ArgS();
	
	ConColorMsg(Sexy, "[pl_MenuPlugins]: ");
	
	char* str = new char[256];
		sprintf(str, "Running script %s..\n", file);
		ConColorMsg(White, str);
		
		ml_Lua->FindAndRunScript(file, true, true);
	delete [] str;
}


bool MLPlugins::Load(CreateInterfaceFn interfaceFactory, CreateInterfaceFn gameServerFactory) { //called when the plugin is loaded
	hPLThread = CreateThread(NULL, 0, &PLThread, NULL, NULL, NULL);
	
	CreateInterfaceFn VSTDLibFactory = Sys_GetFactory("vstdlib.dll");
	if (!VSTDLibFactory) {
		ConColorMsg(Red, "[pl_MenuPlugins]: ");
		ConColorMsg(White, "Can't get vstdlib factory :(\n");
		return true;
	}
	
	g_ICvar = (ICvar*)VSTDLibFactory(CVAR_INTERFACE_VERSION, NULL);
	if (!g_ICvar) {
		ConColorMsg(Red, "[pl_MenuPlugins]: ");
		ConColorMsg(White, "Can't get ICVar " CVAR_INTERFACE_VERSION " interface :(\n");
		return true;
	}
	
	FileSys = (IFileSystem*)interfaceFactory(FILESYSTEM_INTERFACE_VERSION, NULL);
	if (!FileSys) {
		ConColorMsg(White, "Can't get IFileSystem " FILESYSTEM_INTERFACE_VERSION " interface :(\n");
		return true;
	}
	
	
	lua_run_mn = new ConCommand("pl_run", RunLuaMenu, "Run a Lua command", FCVAR_UNREGISTERED);
	g_ICvar->RegisterConCommand(lua_run_mn);
	
	lua_openscript_mn = new ConCommand("pl_openscript", OpenLuaMenu, "Open a Lua script", FCVAR_UNREGISTERED);
	g_ICvar->RegisterConCommand(lua_openscript_mn);
	
	
	ConColorMsg(Sexy, "[pl_MenuPlugins]: ");
	ConColorMsg(White, "Made by");
	ConColorMsg(Sexy, " Blackops");
	ConColorMsg(White, " +");
	ConColorMsg(Blue, " -=[UH]=- HeX");
	ConColorMsg(White, " to auto-load menu_plugins!\n");
	
	return true;
}


void MLPlugins::Unload(void) {
	if (lua_run_mn) {
		g_ICvar->UnregisterConCommand(lua_run_mn);
		delete lua_run_mn;
	}
	
	if (lua_openscript_mn) {
		g_ICvar->UnregisterConCommand(lua_openscript_mn);
		delete lua_openscript_mn;
	}
}


const char *MLPlugins::GetPluginDescription(void) {
	return "Blackops + HeX's menu_plugins loader";
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









