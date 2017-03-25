/*
	=== gmcl_hexapi ===
	*For loading dirty hax*
*/

#undef _UNICODE
#define WIN32_LEAN_AND_MEAN
#define GAME_DLL

#pragma comment(linker, "/NODEFAULTLIB:libcmt")
#pragma comment(lib, "vstdlib.lib")


//GMod
#include <GMLuaModule.h>
#include <ILuaShared.h>

//Random
#include <windows.h>

//CVar
#include <convar.h>
#include <icvar.h>
#include <tier1.h>

//Console
#include <Color.h>


#define RUN_AS	 "LuaCmd"
#define RUN_FROM ""

static ConCommand* lua_run_hx	= NULL;
ICvar* g_ICvar					= NULL;

HMODULE lua_shared				= NULL;
ILuaShared* g_LuaShared 		= NULL;
ILuaInterface* ml_Lua			= NULL;
ILuaInterface* cl_Lua			= NULL;

Color White(255,255,255,255);
Color Sexy(255,174,201,255);
Color Red(255,0,0,255);
Color Green(85,218,90,255);
Color Orange(255,153,0,255);



bool HasLuaCL() {
	if ( !(lua_shared && g_LuaShared) ) {
		lua_shared = GetModuleHandle("lua_shared.dll");
		
		if (!lua_shared) {
			ConColorMsg(Red, 	"[HeXAPI]: ");
			ConColorMsg(White,	"Can't get lua_shared handle :(\n" );
			return false;
		}
		
		CreateInterfaceFn LuaSharedAddr = (CreateInterfaceFn)GetProcAddress(lua_shared, "CreateInterface");
		g_LuaShared = (ILuaShared*)LuaSharedAddr("LuaShared001", NULL);
		
		if (!g_LuaShared) {
			ConColorMsg(Red,	"[HeXAPI]: ");
			ConColorMsg(White,	"Can't get LuaShared001 interface :(\n" );
			return false;
		}
	}
	
	
	if (!cl_Lua) {
		ConColorMsg(Orange,	"[HeXAPI]: ");
		ConColorMsg(White, 	"Re-aquireing..\n" );
		
		cl_Lua = g_LuaShared->GetLuaInterface(0);
		
		if (cl_Lua) {
			ConColorMsg(Green, 	"[HeXAPI]: ");
			ConColorMsg(White,	"Success!\n");
			return true;
			
		} else {
			ConColorMsg(Red, 	"[HeXAPI]: ");
			ConColorMsg(White,	"No interface!\n" );
			return false;
		}
	}
	
	return true;
}


LUA_FUNCTION(CL_RunString) {
	if ( !HasLuaCL() ) { return 0; }
	cl_Lua->CheckType(1, GLua::TYPE_STRING);
	
	cl_Lua->RunString(RUN_AS, RUN_FROM, cl_Lua->GetString(1), true, true);
	return 0;
}

void LuaRunAPI(const CCommand &command) {
	if ( !HasLuaCL() ) { return; }
	
	cl_Lua->RunString(RUN_AS, RUN_FROM, command.ArgS(), true, true);
}




LUA_FUNCTION(ML_RunString) {
	if ( !HasLuaCL() ) { return 0; }
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	cl_Lua->RunString(RUN_AS, RUN_FROM, ml_Lua->GetString(1), true, true);
	return 0;
}

LUA_FUNCTION(ML_SetGlobals) {
	if ( !HasLuaCL() ) { return 0; }
	
	cl_Lua->NewGlobalTable("hexapi");
	ILuaObject* hexapi = cl_Lua->GetGlobal("hexapi");
		hexapi->SetMember("RunString", CL_RunString);
	hexapi->UnReference();
	
	return 0;
}




GMOD_MODULE(Open, Close);

int Open(lua_State *L) {
	ILuaObject* maxPlayers = Lua()->GetGlobal("MaxPlayers");
	bool isMenuState = ( !maxPlayers || !maxPlayers->isFunction() );
	maxPlayers->UnReference();
	
	if (!isMenuState) {
		ConColorMsg(Red, 	"[HeXAPI]: ");
		ConColorMsg(White,	"Can't be used from here dumbass!\n" );
		return 0;
	}
	
	ml_Lua = Lua();
	
	
	CreateInterfaceFn VSTDLibFactory = Sys_GetFactory("vstdlib.dll");
	if (!VSTDLibFactory) {
		ConColorMsg(Red, 	"[HeXAPI]: ");
		ConColorMsg(White, 	"Can't get VSTDLibFactory factory :(\n");
		return 0;
	}
	
	g_ICvar = (ICvar*)VSTDLibFactory(CVAR_INTERFACE_VERSION, NULL);
	if (!g_ICvar) {
		ConColorMsg(Red, 	"[HeXAPI]: ");
		ConColorMsg(White, 	"Can't get ICvar " CVAR_INTERFACE_VERSION " interface :(\n");
		return 0;
	}
	
	
	lua_run_hx = new ConCommand("lua_run_hx", LuaRunAPI, "Run lua commands on the client", FCVAR_UNREGISTERED);
	g_ICvar->RegisterConCommand(lua_run_hx);
	
	ml_Lua->NewGlobalTable("hexapi");
	ILuaObject* hexapi = ml_Lua->GetGlobal("hexapi");
		hexapi->SetMember("RunString", ML_RunString);
		hexapi->SetMember("SetGlobals", ML_SetGlobals);
	hexapi->UnReference();
	
	//ConColorMsg(Green, "[HeXAPI]: ");
	//ConColorMsg(White, "Ready :D\n");
	
	return 0;
}


int Close(lua_State *L) {
	if (g_ICvar && lua_run_hx) {
		g_ICvar->UnregisterConCommand(lua_run_hx);
		delete lua_run_hx;
	}
	
	return 0;
}





