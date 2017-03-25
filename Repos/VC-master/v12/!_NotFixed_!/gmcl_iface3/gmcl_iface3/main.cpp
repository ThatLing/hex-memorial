/*
	=== gmcl_iface3 ===
	*For the testing and development of HAC*
	
	Credits:
		. pollyzoid / raBBish (New ILuaShared)
		. Gbps (CStateManager)
		. Discord (Original method)
		. Blackops (gmcl_extras)
		. Yakahughes (gm_preproc)
		. Helix Alioth (gm_hio)
		. HeX (Combining all these together)
*/

#undef _UNICODE
#define WIN32_LEAN_AND_MEAN
#define GAME_DLL

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment (lib,"tier0.lib")
#pragma comment (lib,"tier1.lib")
#pragma comment (lib,"vstdlib.lib")


//GMod
#include <vfnhook.h>
#include <GMLuaModule.h>
#include <CStateManager.h>

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
#include "tier1/iconvar.h"
#include "tier1/tier1.h"
#include "vstdlib/cvar.h"
#include "convar.h"

//IGameUI
#include <IGameUI.h>

using namespace std;

HANDLE hHacThreadTwo;
int g_RSCount					= 0;
const char* iFaceString			= "iface3.RunString";
bool HasDoneThread				= false;

static ConCommand* lua_run_i	= NULL;
ICvar* g_pCVar					= NULL;

IGameUI* g_GameUI				= NULL;

ILuaInterface* ml_Lua			= NULL; //Menu
ILuaInterface* cl_Lua			= NULL; //Client


DEFVFUNC_(RunStringReal, bool, (ILuaInterface* RSLua, const char* strFilename, const char* strPath, const char* strStringToRun, bool bRun, bool bShowErrors));

bool VFUNC NotRunString(ILuaInterface* RSLua, const char* strFilename, const char* strPath, const char* strStringToRun, bool bRun, bool bShowErrors) {
	if (!RSLua) {
		ml_Lua->Msg("[iFace3]: RunString's RSLua was NULL?!\n");
		return 0;
	}
	
	if (RSLua && strFilename && strPath && strStringToRun && strcmp(strPath,iFaceString) == 0) { //Don't call hook for my own RunString!
		return RunStringReal(RSLua, strFilename, strPath, strStringToRun, bRun, bShowErrors);
	}
	
	ILuaObject* maxPlayers = RSLua->GetGlobal("MaxPlayers");
	bool isMenuState = ( !maxPlayers || !maxPlayers->isFunction() );
	maxPlayers->UnReference();
	
	if (isMenuState) {
		//ml_Lua->Msg("[iFace3]: RunString somehow ran menustate lua!\n");
		return RunStringReal(RSLua, strFilename, strPath, strStringToRun, bRun, bShowErrors);
	}
	
	g_RSCount++;
	if (g_RSCount == 1) { //on first call to runstring
		cl_Lua = RSLua;
		RSLua->Msg("[iFace3]: Loaded, state 0 @ %p\n", RSLua);
	}
	
	char ShouldBlock = -1;
	
	ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
			ml_Lua->Push(hookCall);
			ml_Lua->Push("CanRunString");
				ml_Lua->PushNil();
				ml_Lua->Push(strFilename);
				ml_Lua->Push(strPath);
				ml_Lua->Push(strStringToRun);
			ml_Lua->Call(5, 1);
			
			ILuaObject* retrn = ml_Lua->GetReturn(0);
				if (retrn) {
					if (retrn->GetType() == GLua::TYPE_STRING) {
						strStringToRun = retrn->GetString();
					}
					else if (retrn->GetType() == GLua::TYPE_BOOL) {
						ShouldBlock = (char)retrn->GetBool();
					}
				}
			retrn->UnReference();
		hookCall->UnReference();
	hook->UnReference();
	
	if (ShouldBlock != -1) {
		return ShouldBlock;
	}
	
	return RunStringReal(RSLua, strFilename, strPath, strStringToRun, bRun, bShowErrors);
}



DWORD WINAPI HacThreadTwo(LPVOID param)
{
	ILuaInterface* c_Lua = NULL;
	
	while (c_Lua == NULL) {
		c_Lua = CStateManager::GetByIndex(LuaStates::CLIENT);
		
		if (c_Lua) {
			HOOKVFUNC(c_Lua, 68, RunStringReal, NotRunString);
			
			if (ml_Lua) {
				ml_Lua->Msg("[iFace3]: Got cl_Lua @ %p\n", c_Lua);
			}
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




DEFVFUNC_( origStartProgressBar, void, ( IGameUI *gGUI ) );

void VFUNC newStartProgressBar(IGameUI *gGUI) {
	if (!HasDoneThread) {
		HasDoneThread = true;
		
		hHacThreadTwo = CreateThread(NULL, 0, &HacThreadTwo, NULL, NULL, NULL);
	}
	
	ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
			ml_Lua->Push( hookCall );
				ml_Lua->Push("LoadingStarted");
				ml_Lua->PushNil();
			ml_Lua->Call(2,0);
		hookCall->UnReference();
	hook->UnReference();
	
	return origStartProgressBar(gGUI);
}


DEFVFUNC_( origOnDisconnectFromServer, void, ( IGameUI *gGUI, uint8 eSteamLoginFailure ) );

void VFUNC newOnDisconnectFromServer( IGameUI *gGUI, uint8 eSteamLoginFailure ) {
	g_RSCount = 0; //Reset, wait for another join!
	cl_Lua = NULL;
	
	ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
			ml_Lua->Push(hookCall);
				ml_Lua->Push("DisconnectFromServer");
				ml_Lua->PushNil();
			ml_Lua->Call(2,0);
		hookCall->UnReference();
	hook->UnReference();
	
	return origOnDisconnectFromServer( gGUI, eSteamLoginFailure );
}


DEFVFUNC_( origStopProgressBar, void, ( IGameUI *gGUI, bool, const char*, const char* ) );

void VFUNC newStopProgressBar( IGameUI *gGUI, bool something1, const char* something2, const char* something3 ) {
	ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
			ml_Lua->Push(hookCall);
				ml_Lua->Push("LoadingComplete");
				ml_Lua->PushNil();
			ml_Lua->Call(2,0);
		hookCall->UnReference();
	hook->UnReference();
	
	return origStopProgressBar(gGUI, something1, something2, something3);
}





void LuaRunHex(const CCommand &command) {
	if (cl_Lua == NULL) {
		ml_Lua->Msg("[iFace3]: lua_run_i can only be used when connected!\n");
		return;
	}
	
	//cl_Lua->RunString("", iFaceString, command.ArgS(), true, true);
	RunStringReal(cl_Lua, "", iFaceString, command.ArgS(), true, true);
}


LUA_FUNCTION(RunString) {
	if (cl_Lua == NULL) {
		ml_Lua->Msg("[iFace3]: RunString can only be used in/after the hook!\n");
		return 0;
	}
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	//cl_Lua->RunString("", iFaceString, ml_Lua->GetString(1), true, true);
	//cl_Lua->Push( RunStringReal(cl_Lua, "", iFaceString, ml_Lua->GetString(1), true, true) );
	RunStringReal(cl_Lua, "", iFaceString, ml_Lua->GetString(1), true, true);
	
	return 0;
}

LUA_FUNCTION(RunStringCL) {
	if (cl_Lua == NULL) {
		ml_Lua->Msg("[iFace3]: cl_Lua == NULL!?\n");
		return 0;
	}
	cl_Lua->CheckType(1, GLua::TYPE_STRING);
	
	//cl_Lua->RunString("", iFaceString, cl_Lua->GetString(1), true, true);
	//cl_Lua->Push( RunStringReal(cl_Lua, "", iFaceString, cl_Lua->GetString(1), true, true) );
	RunStringReal(cl_Lua, "", iFaceString, cl_Lua->GetString(1), true, true);
	
	return 0;
}



//hIO
LUA_FUNCTION(FileReadCL) {
	if (cl_Lua == NULL) {
		ml_Lua->Msg("[iFace3]: Read can only be used when connected!\n");
		return 0;
	}
	cl_Lua->CheckType(1, GLua::TYPE_STRING);
	
	string fullPath;
	
	if ( cl_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = cl_Lua->GetString( 1 );
	} else {
		char* workingDir = new char[256];
		_getcwd( workingDir, 256 );
		
		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += cl_Lua->GetString( 1 );
		
		delete [] workingDir;
	}
	std::ifstream ReadFile;
	ReadFile.open( fullPath.c_str(), std::ios::binary );

	if ( !ReadFile.is_open() )
	{
		ml_Lua->Msg("[iFace3]: Bad read path: %s", cl_Lua->GetString(1) );
		cl_Lua->Push(false);
	}
	
	ReadFile.seekg( 0, std::ios::end );
		int length = ReadFile.tellg();
	ReadFile.seekg( 0, std::ios::beg );
	char* buffer = new char[length+1];
	
	ReadFile.read( buffer, length );
	buffer[length] = 0;
	
	cl_Lua->Push(buffer);
	
	delete [] buffer;
	return 1;
}


LUA_FUNCTION(FileReadML) {
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );
	
	string fullPath;
	
	if ( ml_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = ml_Lua->GetString( 1 );
	} else {
		char workingDir [256];
		_getcwd( workingDir, 256 );
		
		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += ml_Lua->GetString( 1 );
	}
	ifstream ReadFile;
	ReadFile.open( fullPath.c_str(), ios::binary );
	
	if ( !ReadFile.is_open() ) {
		ml_Lua->Msg("[iFace3]: FileReadML bad read path: %s", ml_Lua->GetString(1) );
		ml_Lua->Push(false);
	}
	
	ReadFile.seekg( 0, ios::end );
		int length = ReadFile.tellg();
	ReadFile.seekg( 0, ios::beg );
	char* buffer = new char[length+1];
	
	ReadFile.read( buffer, length );
	buffer[length] = 0;
	
	ml_Lua->Push( buffer );
	
	delete [] buffer;
	return 1;
}

LUA_FUNCTION(FileWriteML) {
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	ml_Lua->CheckType(2, GLua::TYPE_STRING);
	
	string fullPath;
	
	if ( ml_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = ml_Lua->GetString( 1 );
	} else {
		char* workingDir = new char[256];
		_getcwd( workingDir, 256 );
		
		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += ml_Lua->GetString( 1 );
		
		delete [] workingDir;
	}
	std::ofstream WriteFile;
	WriteFile.open( fullPath.c_str(), std::ios::binary );
	
	if ( !WriteFile.is_open() )
	{
		ml_Lua->Msg("[iFace3]: FileWriteML bad write path: %s", ml_Lua->GetString(1) );
		ml_Lua->Push(false);
	}
	
	WriteFile << ml_Lua->GetString( 2 );
	WriteFile.close();
	
	ml_Lua->Push(true);
	return 1;
}


LUA_FUNCTION(MakeDirML) {
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	string fullPath;
	string fullPath2;
	
	if ( ml_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = ml_Lua->GetString( 1 );
	} else {
		char* workingDir = new char[256];
		_getcwd( workingDir, 256 );
		
		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += ml_Lua->GetString( 1 );
		
		delete [] workingDir;
	}
	
	_mkdir( fullPath.c_str() );
	return 0;
}


LUA_FUNCTION(DirExistsML) {
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );

	string fullPath;

	if ( ml_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = ml_Lua->GetString( 1 );
	} else {
		char* workingDir = new char[256];
		_getcwd( workingDir, 256 );

		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += ml_Lua->GetString( 1 );

		delete [] workingDir;
	}
	struct stat chk;
	if ( stat( fullPath.c_str( ), &chk ) == 0 )
	{
		ml_Lua->Push( true );
	} else {
		ml_Lua->Push( false );
	}

	return 1;
}

LUA_FUNCTION(FileExistsML) {
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	string fullPath;
	
	if ( ml_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = ml_Lua->GetString( 1 );
	} else {
		char workingDir [256];
		_getcwd( workingDir, 256 );
		
		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += ml_Lua->GetString( 1 );
	}
	ifstream ReadFile;
	ReadFile.open( fullPath.c_str(), ios::binary );
	
	ml_Lua->Push( ReadFile.is_open() );
	return 1;
}


LUA_FUNCTION(NotRPF) {
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	string fullPath;
	char* workingDir = new char[256];
	
	_getcwd(workingDir, 256);
	
	fullPath = workingDir;
	fullPath += "\\garrysmod\\";
	fullPath += ml_Lua->GetString(1);
	delete [] workingDir;
	
	ml_Lua->Push( fullPath.c_str() );
	return 1;
}


LUA_FUNCTION(SetRunString) {
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	iFaceString = ml_Lua->GetString(1);
	return 0;
}
LUA_FUNCTION(GetRunString) {
	ml_Lua->Push(iFaceString);
	return 1;
}


LUA_FUNCTION(SetRunStringCL) {
	if (cl_Lua == NULL) {
		ml_Lua->Msg("[iFace3]: SetRunStringCL, cl_Lua NULL!\n");
		return 0;
	}
	cl_Lua->CheckType(1, GLua::TYPE_STRING);
	
	iFaceString = cl_Lua->GetString(1);
	return 0;
}
LUA_FUNCTION(GetRunStringCL) {
	if (cl_Lua == NULL) {
		ml_Lua->Msg("[iFace3]: GetRunStringCL, cl_Lua NULL!\n");
		return 0;
	}
	
	cl_Lua->Push(iFaceString);
	return 1;
}


LUA_FUNCTION(SetGlobals) { //Make globals on the client state too!
	if (cl_Lua == NULL) {
		ml_Lua->Msg("[iFace3]: SetGlobals, cl_Lua NULL!\n");
		ml_Lua->Push(false);
		return 1;
	}
	
	RunStringReal(cl_Lua, "", iFaceString, " iface3 = nil ", true, true); //Maybe now?
	
	cl_Lua->NewGlobalTable("iface3");
	ILuaObject* ITable = cl_Lua->GetGlobal("iface3");
		ITable->SetMember("RunString", RunStringCL);
		ITable->SetMember("Read", FileReadCL);
		ITable->SetMember("SetRunString", SetRunStringCL);
		ITable->SetMember("GetRunString", GetRunStringCL);
	ITable->UnReference();
	
	ml_Lua->Push(true);
	return 1;
}



GMOD_MODULE(Open, Close);

int Open(lua_State *L) {
	ILuaObject* maxPlayers = Lua()->GetGlobal("MaxPlayers");
	bool isMenuState = ( !maxPlayers || !maxPlayers->isFunction() );
	maxPlayers->UnReference();
	
	if (!isMenuState) {
		Lua()->Error("[iFace3]: Can't be used from the client dumbass!\n");	
		return 0;
	}
	
	ml_Lua = Lua();
	
	CreateInterfaceFn GameUIFactory = Sys_GetFactory("gameui.dll");
	if ( !GameUIFactory )
		ml_Lua->Error("[iFace3]: Can't get GameUIFactory GameUI\n" );
		
	g_GameUI = ( IGameUI* )GameUIFactory( GAMEUI_INTERFACE_VERSION, NULL );
	if ( !g_GameUI )
		ml_Lua->Error("[iFace3]: Can't get IGameUI " GAMEUI_INTERFACE_VERSION " interface.\n" );
		
	g_pCVar = *(ICvar **)GetProcAddress( GetModuleHandleA("client.dll"), "cvar");
	if ( !g_pCVar )
		ml_Lua->Error("[iFace3]: Can't get ICvar " CVAR_INTERFACE_VERSION " interface :(\n");
	
	lua_run_i = new ConCommand("lua_run_i", LuaRunHex, "Run a Lua command on the client interface", FCVAR_UNREGISTERED);
	g_pCVar->RegisterConCommand(lua_run_i);
	
	HOOKVFUNC(g_GameUI, 33, origOnDisconnectFromServer, newOnDisconnectFromServer);
	HOOKVFUNC(g_GameUI, 41, origStopProgressBar, newStopProgressBar);
	HOOKVFUNC(g_GameUI, 39, origStartProgressBar, newStartProgressBar);
	
	ml_Lua->NewGlobalTable("iface3");
	ILuaObject* hactest = ml_Lua->GetGlobal("iface3");
		hactest->SetMember("RunString", RunString);
		hactest->SetMember("SetRunString", SetRunString);
		hactest->SetMember("GetRunString", GetRunString);
		hactest->SetMember("SetGlobals", SetGlobals);
		//hIO
		hactest->SetMember("Read", FileReadML);
		hactest->SetMember("Write", FileWriteML);
		hactest->SetMember("RelativePathToFull", NotRPF);
		hactest->SetMember("MKDIR", MakeDirML);
		hactest->SetMember("IsDir", DirExistsML);
		hactest->SetMember("Exists", FileExistsML);
	hactest->UnReference();
	
	ml_Lua->SetGlobal("MENU", true);
	
	ml_Lua->Msg("[iFace3]: Loaded, state 2 @ %p\n", ml_Lua);
	return 0;
}


int Close(lua_State *L) {
	UNHOOKVFUNC(g_GameUI, 39, origStartProgressBar);
	UNHOOKVFUNC(g_GameUI, 41, origStopProgressBar);
	UNHOOKVFUNC(g_GameUI, 33, origOnDisconnectFromServer);
	
	/*
	if (lua_run_i) {
		g_pCVar->UnregisterConCommand(lua_run_i);
		delete lua_run_i;
	}
	*/
	return 0;
}





