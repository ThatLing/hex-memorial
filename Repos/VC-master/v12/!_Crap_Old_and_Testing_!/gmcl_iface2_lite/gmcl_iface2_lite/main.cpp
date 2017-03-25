/*
	=== gmcl_interface2 ===
	*For the testing and development of HAC*
	
	Credits:
		. Gbps (CStateManager)
		. Discord (Original method + base)
		. Blackops (gmcl_extras)
		. Yakahughes (gm_preproc)
		. Helix Alioth (gm_hio)
		. HeX (Combining all these together)
*/


#undef _UNICODE

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment (lib,"tier0.lib")
#pragma comment (lib,"tier1.lib")
#pragma comment (lib,"vstdlib.lib")

#define VSTD_LIB "vstdlib.dll"
#define GAMEUI_LIB "gameui.dll"

#include <Windows.h>
#include <cdll_int.h>
#include <string>
#include <fstream>

#include "vfnhook.h"
#include "GMLuaModule.h"
#include "CStateManager.h"


//hIO
#include <interface.h> // Console Interface
#include <direct.h>
#include <stdio.h>
#include <stdarg.h>
#include <sys/stat.h>


HANDLE hHacThreadTwo;
int g_RSCount = 0;


//IGameUI
#include "IGameUI.h"
IGameUI* g_GameUI;


GMOD_MODULE(Open, Close);

ILuaInterface* ml_Lua;
ILuaInterface* cl_Lua;




DEFVFUNC_(RunStringReal, bool, (ILuaInterface* RSLua, const char* strFilename, const char* strPath, const char* strStringToRun, bool bRun, bool bShowErrors));

bool VFUNC NotRunString(ILuaInterface* RSLua, const char* strFilename, const char* strPath, const char* strStringToRun, bool bRun, bool bShowErrors) {
	
	ILuaObject* maxPlayers = RSLua->GetGlobal("MaxPlayers");
	bool isMenuState = ( !maxPlayers || !maxPlayers->isFunction() );
	maxPlayers->UnReference();
	
	if (isMenuState) {
		//ml_Lua->Msg("[iFace2]: RunString detour somehow ran menustate lua!\n");
		return RunStringReal(RSLua, strFilename, strPath, strStringToRun, bRun, bShowErrors);
	}
	
	g_RSCount++;
	if (g_RSCount == 1) { //on first call to runstring
		cl_Lua = RSLua;
		ml_Lua->Msg("[iFace2]: First call, cl_Lua @ %p\n", RSLua);
	}
	
	
	//From preproc
	if (ml_Lua != NULL && strPath != "interface.RunString") { //Don't call the hook for our own RunString!
		ILuaObject* hookTable = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = NULL;
		
		char retbool = -1;
		
		if (hookTable && hookTable->isTable()) {
			hookCall = hookTable->GetMember("Call");
			
			if (hookCall && hookCall->isFunction()) {
				ml_Lua->Push(hookCall);
				ml_Lua->Push("CanRunString");
					ml_Lua->PushNil();
					ml_Lua->Push(strFilename);
					ml_Lua->Push(strPath);
					ml_Lua->Push(strStringToRun);
				ml_Lua->Call(5, 1);
				
				ILuaObject* retrn = ml_Lua->GetReturn(0);
				
				if (retrn && retrn->GetType() == GLua::TYPE_STRING)
					strStringToRun = retrn->GetString();
				else if (retrn && retrn->GetType() == GLua::TYPE_BOOL)
					retbool = (char)retrn->GetBool();
			}
		}
		
		if (hookTable)
			hookTable->UnReference();
			
		if (hookCall)
			hookCall->UnReference();
			
		if (retbool != -1)
			return retbool;
	}
	
	return RunStringReal(RSLua, strFilename, strPath, strStringToRun, bRun, bShowErrors);
}



DWORD WINAPI HacThreadTwo(LPVOID param)
{
	ILuaInterface* c_Lua = NULL;
	
	while (c_Lua == NULL) {
		c_Lua = CStateManager::GetByIndex(LuaStates::CLIENT);
		
		if (c_Lua != NULL) {
			HOOKVFUNC(c_Lua, 68, RunStringReal, NotRunString);
			
			if (ml_Lua != NULL) {
				ml_Lua->Msg("[iFace2]: Loaded ILuaInterface* cl_Lua @ %p\n", c_Lua);
			}
		}
	}
	
	return true;
}


BOOL APIENTRY DllMain(HMODULE hmDll, DWORD dwReason, LPVOID lpReserved)
{
	if (dwReason == DLL_PROCESS_ATTACH) {
		DisableThreadLibraryCalls(hmDll);
		hHacThreadTwo = CreateThread(NULL, 0, &HacThreadTwo, NULL, NULL, NULL);
	}
	return true;
}



//gmcl_extras
DEFVFUNC_( origOnDisconnectFromServer, void, ( IGameUI *gGUI, uint8 eSteamLoginFailure ) );

void VFUNC newOnDisconnectFromServer( IGameUI *gGUI, uint8 eSteamLoginFailure ) {
	g_RSCount = 0;
	cl_Lua = NULL; //Crashes if you call functions once you disconnect, in menu state
	
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




LUA_FUNCTION(FindAndRunScript) {
	if (cl_Lua == NULL) {
		ml_Lua->Msg("[iFace2]: FindAndRunScript can only be used in/after the hook!\n");
		return 0;
	}
	
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	const char* file = ml_Lua->GetString(1);
	
	cl_Lua->FindAndRunScript(file, true, true); //No SE bypass
	
	return 0;
}

LUA_FUNCTION(RunString) {
	if (cl_Lua == NULL) {
		ml_Lua->Msg("[iFace2]: RunString can only be used in/after the hook!\n");
		return 0;
	}
	
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	const char* lua = ml_Lua->GetString(1);
	
	cl_Lua->RunString("", "interface.RunString", lua, true, true);
	
	return 0;
}


LUA_FUNCTION(NotRPF) {
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	std::string fullPath;
	char* workingDir = new char[256];
	
	_getcwd(workingDir, 256);
	
	fullPath = workingDir;
	fullPath += "\\garrysmod\\";
	fullPath += ml_Lua->GetString(1);
	delete [] workingDir;
	
	ml_Lua->Push( fullPath.c_str() );
	return 1;
}



//hIO
LUA_FUNCTION(FileWriteML) {
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );
	ml_Lua->CheckType( 2, GLua::TYPE_STRING );
	
	bool Done = false;
	std::string fullPath;
	
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
		ml_Lua->Msg("[iFace2]: FileWriteML bad write path: %s", ml_Lua->GetString(1) );
		ml_Lua->Push( (bool)Done );
	}
	
	WriteFile << ml_Lua->GetString( 2 );
	WriteFile.close();
	Done = true;
	
	ml_Lua->Push( (bool)Done );
	return 1;
}


LUA_FUNCTION(MakeDirML) {
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );

	std::string fullPath;
	std::string fullPath2;

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

	std::string fullPath;

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






LUA_FUNCTION(FileReadCL) {
	if (cl_Lua == NULL) {
		ml_Lua->Msg("[iFace2]: Read can only be used when connected!\n");
		return 0;
	}
	
	cl_Lua->CheckType( 1, GLua::TYPE_STRING );
	
	std::string fullPath;
	
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
		ml_Lua->Msg("[iFace2]: Bad read path: %s", cl_Lua->GetString(1) );
		cl_Lua->Push( false );
	}
	
	ReadFile.seekg( 0, std::ios::end );
		int length = ReadFile.tellg();
	ReadFile.seekg( 0, std::ios::beg );
	char* buffer = new char[length+1];
	
	ReadFile.read( buffer, length );
	buffer[length] = 0;
	
	cl_Lua->Push( buffer );
	
	delete [] buffer;
	return 1;
}



LUA_FUNCTION(RunStringCL) {
	if (cl_Lua == NULL) {
		cl_Lua->Msg("[iFace2]: cl_Lua == NULL!?\n");
		return 0;
	}
	
	cl_Lua->CheckType(1, GLua::TYPE_STRING);
	const char* lua = cl_Lua->GetString(1);
	
	cl_Lua->RunString("", "interface.RunString", lua, true, true);
	
	return 0;
}

//Make globals on the client state too!
LUA_FUNCTION(SetGlobals) {
	if (cl_Lua == NULL) {
		ml_Lua->Msg("[iFace2]: SetGlobals can only be used in/after the hook!\n");
		return 0;
	}
	
	cl_Lua->NewGlobalTable("interface");
	ILuaObject* ITable = cl_Lua->GetGlobal("interface");
		ITable->SetMember("RunString", RunStringCL);
		ITable->SetMember("Read", FileReadCL);
	ITable->UnReference();
	
	return 0;
}



int Open(lua_State *L) {
	ILuaObject* maxPlayers = Lua()->GetGlobal("MaxPlayers");
	bool isMenuState = ( !maxPlayers || !maxPlayers->isFunction() );
	maxPlayers->UnReference();
	
	if (!isMenuState) {
		Lua()->Error("[iFace2]: You can't use this from the client dumbass!\n");	
		return 0;
	}
	
	
	ml_Lua = Lua();
	
	CreateInterfaceFn GameUIFactory = Sys_GetFactory( GAMEUI_LIB );
	if ( !GameUIFactory )
		ml_Lua->Error("[iFace2]: Error getting " GAMEUI_LIB " factory.\n" );
		
	g_GameUI = ( IGameUI* )GameUIFactory( GAMEUI_INTERFACE_VERSION, NULL );
	if ( !g_GameUI )
		ml_Lua->Error("[iFace2]: Error getting IGameUI interface.\n" );
	
	
	HOOKVFUNC(g_GameUI, 33, origOnDisconnectFromServer, newOnDisconnectFromServer );
	HOOKVFUNC(g_GameUI, 41, origStopProgressBar, newStopProgressBar);
	
	ml_Lua->NewGlobalTable("interface");
	ILuaObject* hactest = ml_Lua->GetGlobal("interface");
		hactest->SetMember("FindAndRunScript", FindAndRunScript);
		hactest->SetMember("RunString", RunString);
		hactest->SetMember("SetGlobals", SetGlobals);
		//hIO
		hactest->SetMember("Write", FileWriteML);
		hactest->SetMember("RelativePathToFull", NotRPF);
		hactest->SetMember("MKDIR", MakeDirML);
		hactest->SetMember("IsDir", DirExistsML);		
	hactest->UnReference();
	
	ml_Lua->Msg("[iFace2]: Loaded ILuaInterface* ml_Lua @ %p\n", ml_Lua);
	return 0;
}


int Close(lua_State *L) {
	return 0;
}





