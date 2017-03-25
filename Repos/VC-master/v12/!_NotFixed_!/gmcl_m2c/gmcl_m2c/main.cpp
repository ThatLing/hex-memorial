/*
	=== gmcl_menu2client ===
	*For loading dirty hax*
	
	Credits:
		. pollyzoid (New ILuaShared)
		. Blackops (gmcl_extras)
		. HeX (Combining these together)
*/

#undef _UNICODE
#define WIN32_LEAN_AND_MEAN
#define GAME_DLL

#pragma comment(linker, "/NODEFAULTLIB:libcmt")
#pragma comment(lib, "vstdlib.lib")
//#pragma comment(lib, "tier0.lib")
//#pragma comment(lib, "tier1.lib")


//GMod
#include <vfnhook.h>
#include <GMLuaModule.h>
#include <ILuaShared.h>

//Windows
#include <Windows.h>
#include <cdll_int.h>
#include <string>
#include <fstream>

//hIO
#include <interface.h>
#include <direct.h>
#include <stdio.h>
#include <stdarg.h>
#include <sys/stat.h>

//CVar
#include <convar.h>
#include <icvar.h>
#include <tier1.h>

//IGameUI
#include <IGameUI.h>

//Console
#include <Color.h>


Color Blue(0,162,232,255);
Color White(255,255,255,255);
Color Sexy(255,174,201,255);
Color Red(255,0,0,255);
Color Green(85,218,90,255);


HANDLE MenuClientThread;
int RunStringCount				= 0;
bool HasDoneThread				= false;
bool Done						= false;
const char* FileToWait			= "Startup"; //DAMN YOU BASE GAMEMODE

static ConCommand* lua_run_i	= NULL;
ICvar* g_pCVar					= NULL;

IGameUI* g_GameUI				= NULL;

ILuaShared* g_LuaShared 		= NULL;
ILuaInterface* cl_Lua			= NULL;
ILuaInterface* ml_Lua			= NULL;


DEFVFUNC_(RunStringReal, bool, (ILuaInterface* RSLua, const char* strFilename, const char* strPath, const char* strStringToRun, bool bRun, bool bShowErrors));





LUA_FUNCTION(RunStringCL) {
	if (cl_Lua == NULL) {
		ConColorMsg(Red, "[M2C]: ");
		ConColorMsg(White, "I accidently a thing (2), tell HeX!\n" );
		return 0;
	}
	cl_Lua->CheckType(1, GLua::TYPE_STRING);
	
	RunStringReal(cl_Lua, FileToWait, "", cl_Lua->GetString(1), true, true);
	
	return 0;
}



bool VFUNC NotRunString(ILuaInterface* RSLua, const char* strFilename, const char* strPath, const char* strStringToRun, bool bRun, bool bShowErrors) {
	if (!RSLua) {
		return false;
	}
	
	ILuaObject* maxPlayers = RSLua->GetGlobal("MaxPlayers");
	bool isMenuState = ( !maxPlayers || !maxPlayers->isFunction() );
	maxPlayers->UnReference();
	
	if (isMenuState) {
		return RunStringReal(RSLua, strFilename, strPath, strStringToRun, bRun, bShowErrors);
	}
	
	RunStringCount++;
	if (RunStringCount == 1) { //First call to runstring
		ConColorMsg(Sexy, 	"[M2C] ");
		ConColorMsg(White,	"Got RSLua!\n");	
		
		cl_Lua = RSLua;
	}
	
	//DEBUG
	/*
	ConColorMsg(Sexy, 	"[M2C] ");
	ConColorMsg(Green,	strFilename);
	ConColorMsg(White,	"\n");
	*/
	
	if (!Done && (!strcmp(strFilename, FileToWait))) { //Wait for this
		Done = true;
		ConColorMsg(Sexy, 	"[M2C] ");
		ConColorMsg(White,	"Got FileToWait!\n");
		//RunStringReal(RSLua, FileToWait, "", "m2c = nil", true, true);
		
		RSLua->NewGlobalTable("m2c");
		ILuaObject* MTable = RSLua->GetGlobal("m2c");
			MTable->SetMember("RunString", RunStringCL);
		MTable->UnReference();
		
		
		//Load files
		char workingDir[MAX_PATH];
			_getcwd(workingDir, MAX_PATH);
		std::string Here = workingDir;
		Here += "\\garrysmod\\lua\\m2c\\";
		
		std::string fullPath = Here;
		fullPath += "*.lua";
		
		WIN32_FIND_DATA FindFileData;
		HANDLE Search = FindFirstFile( (LPCSTR)fullPath.c_str(), &FindFileData );
		
		if (Search != INVALID_HANDLE_VALUE) {
			do {
				const char* fname = FindFileData.cFileName;
				
				std::string FilePath = Here;
					FilePath += fname;
					
					std::ifstream ReadFile;
				ReadFile.open(FilePath.c_str(), std::ios::binary);
				
				char* str = new char[MAX_PATH];
					if (!ReadFile.is_open()) {
						sprintf(str, " Can't open %s, won't work from addons!\n", fname);
						ConColorMsg(Red, "[M2C]:");
						ConColorMsg(White, str);
						delete [] str;
						break;
					}
					
					ReadFile.seekg(0, std::ios::end);
						int length = ReadFile.tellg();
					ReadFile.seekg(0, std::ios::beg);
					
					char* buffer = new char[length+1];
						ReadFile.read(buffer,length);
						buffer[length] = 0;
						
						sprintf(str, "m2c/%s\n", fname);
						ConColorMsg(Green, "[M2C]");
						ConColorMsg(White, " Loading ");
						ConColorMsg(Blue, str);
						
						//RunStringReal(cl_Lua, FileToWait, "", buffer, true, true);
						RunStringReal(RSLua, strFilename, strPath, buffer, bRun, bShowErrors);
					delete [] buffer;
				delete [] str;
			}
			while (FindNextFile(Search, &FindFileData) != 0);
			FindClose(Search);
		}
		
		
		bool What = RunStringReal(RSLua, strFilename, strPath, strStringToRun, bRun, bShowErrors);
		UNHOOKVFUNC(RSLua, 68, RunStringReal);
		return What;
	}
	
	return RunStringReal(RSLua, strFilename, strPath, strStringToRun, bRun, bShowErrors);
}




DWORD WINAPI HacThreadTwo(LPVOID param) {
	while (cl_Lua == NULL) {
		if (g_LuaShared) {
			cl_Lua = g_LuaShared->GetLuaInterface(0);
		}
		
		if (cl_Lua) {
			ConColorMsg(Sexy, 	"[M2C] ");
			ConColorMsg(White,	"Got cl_Lua!\n");	
			
			HOOKVFUNC(cl_Lua, 68, RunStringReal, NotRunString);
			
			ExitThread(1);
			return true;
		}
	}
	
	return true;
}


DEFVFUNC_( origStartProgressBar, void, ( IGameUI *gGUI ) );

void VFUNC newStartProgressBar(IGameUI *gGUI) {
	if (!HasDoneThread) {
		HasDoneThread = true;
		
		MenuClientThread = CreateThread(NULL, 0, &HacThreadTwo, NULL, NULL, NULL);
	}
	
	ConColorMsg(Sexy, 	"[M2C] ");
	ConColorMsg(Green,	"Connected!\n");	
	
	return origStartProgressBar(gGUI);
}



DEFVFUNC_( origOnDisconnectFromServer, void, ( IGameUI *gGUI, uint8 eSteamLoginFailure ) );

void VFUNC newOnDisconnectFromServer( IGameUI *gGUI, uint8 eSteamLoginFailure ) {
	RunStringCount	= 0;
	cl_Lua			= NULL;
	Done			= false;
	
	CloseHandle(MenuClientThread);
	HasDoneThread	= false;
	
	ConColorMsg(Sexy, 	"[M2C] ");
	ConColorMsg(Red,	"Disconnected!\n");	
	
	return origOnDisconnectFromServer( gGUI, eSteamLoginFailure );
}





BOOL APIENTRY DllMain(HMODULE hmDll, DWORD dwReason, LPVOID lpReserved) {
	if (dwReason == DLL_PROCESS_ATTACH) {
		DisableThreadLibraryCalls(hmDll);
		
	} else if (dwReason == DLL_PROCESS_DETACH) {
		if (MenuClientThread) {
			CloseHandle(MenuClientThread);
		}
	}
	
	return true;
}





void LuaRunHex(const CCommand &command) {
	if (cl_Lua == NULL) {
		ConColorMsg(Red, "[M2C]: ");
		ConColorMsg(White, "lua_run_m2 can only be used when connected!\n" );
		return;
	}
	
	RunStringReal(cl_Lua, FileToWait, "", command.ArgS(), true, true);
}




GMOD_MODULE(Open, Close);

int Open(lua_State *L) {
	ILuaObject* maxPlayers = Lua()->GetGlobal("MaxPlayers");
	bool isMenuState = ( !maxPlayers || !maxPlayers->isFunction() );
	maxPlayers->UnReference();
	
	if (!isMenuState) {
		ConColorMsg(Red, "[M2C]: ");
		ConColorMsg(White, "Can't be used from the client state dumbass!\n" );
		return 0;
	}
	
	ml_Lua = Lua();
	
	HMODULE hmLuaShared = GetModuleHandle("lua_shared.dll");
	CreateInterfaceFn fnLua = (CreateInterfaceFn)GetProcAddress(hmLuaShared, "CreateInterface");
	
	g_LuaShared = (ILuaShared*)fnLua("LuaShared001", NULL);
	if (!g_LuaShared) {
		ConColorMsg(Red, "[M2C]: ");
		ConColorMsg(White, "Can't get LuaShared001 interface :(\n" );
		return 0;
	}
	
	
	CreateInterfaceFn GameUIFactory = Sys_GetFactory("gameui.dll");
	if (!GameUIFactory) {
		ConColorMsg(Red, "[M2C]: ");
		ConColorMsg(White, "Can't get GameUIFactory GameUI\n" );
		return 0;
	}
	
	g_GameUI = ( IGameUI* )GameUIFactory( GAMEUI_INTERFACE_VERSION, NULL );
	if (!g_GameUI) {
		ConColorMsg(Red, "[M2C]: ");
		ConColorMsg(White, "Can't get IGameUI " GAMEUI_INTERFACE_VERSION " interface :(\n" );
		return 0;
	}
	
	
	g_pCVar = *(ICvar **)GetProcAddress( GetModuleHandleA("client.dll"), "cvar");
	if (!g_pCVar) {
		ConColorMsg(Red, "[M2C]: ");
		ConColorMsg(White, "Can't get ICvar interface :(\n");
		return 0;
	}
	
	lua_run_i = new ConCommand("lua_run_m2", LuaRunHex, "Run a Lua command on the client interface", FCVAR_UNREGISTERED);
	g_pCVar->RegisterConCommand(lua_run_i);
	
	HOOKVFUNC(g_GameUI, 33, origOnDisconnectFromServer, newOnDisconnectFromServer);
	HOOKVFUNC(g_GameUI, 39, origStartProgressBar, newStartProgressBar);
	
	CreateDirectoryA("garrysmod/lua/m2c", NULL);
	
	ConColorMsg(Sexy, "[M2C]: ");
	ConColorMsg(Green, "Ready :D\n");
	
	return 0;
}


int Close(lua_State *L) {
	UNHOOKVFUNC(g_GameUI, 39, origStartProgressBar);
	UNHOOKVFUNC(g_GameUI, 33, origOnDisconnectFromServer);
	
	if (g_pCVar && lua_run_i) {
		g_pCVar->UnregisterConCommand(lua_run_i);
		delete lua_run_i;
	}
	
	return 0;
}





