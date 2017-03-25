/*
	=== gmcl_sdef ===
	*ScriptDeforcer*
	
	Credits:
		. Blackops (gm_usermessages)
		. Stoned (Yay for Camtasia)
		. HeX (Combining these together)
*/

#undef _UNICODE
#define WIN32_LEAN_AND_MEAN
#define GAME_DLL

#define GModClient "VEngineClientGMod013"

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment (lib, "tier0.lib")
#pragma comment (lib, "tier1.lib")

//GMod
#include <GMLuaModule.h>
#include <vfnhook.h>

//SDK
#include <eiface.h>
#include <interface.h>
#include <cdll_int.h>
#include <networkstringtabledefs.h>

ILuaInterface *ml_Lua								= NULL;
IVEngineClient *EngineClient						= NULL;
INetworkStringTableContainer *NetworkStringTable	= NULL;
IBaseClientDLL *g_BaseClientDLL						= NULL;



bool RemoveSETable() {
	bool Done = false;
	
	if (!EngineClient->IsConnected()) {
		ml_Lua->Msg("[SDef]: Gotta be online!\n");
		return Done;
	}
	
	INetworkStringTable *netTbl = NetworkStringTable->FindTable("OgfGiyegPNbFOf");
	if (!netTbl) {
		ml_Lua->Msg("[SDef]: Fuck!, can't find OgfGiyegPNbFOf table :(\n");
		return Done;
	}
	
	bool* newBool = new bool(0);
	int size = netTbl->GetNumStrings();	
	
	for (int i = 0; i < size; i++) {
		int b = 0;
		
		netTbl->GetStringUserData(i, &b);
		if (strcmp(netTbl->GetString(i), "pfug__f") == 0) { //SE, go away!
			netTbl->SetStringUserData(i, b, newBool);
			Done = true;
		}
	}
	
	return Done;
}


void OnTableChanged( void *object, INetworkStringTable *stringTable, int stringNumber, const char *newString, void const *newData ) {
	if (strcmp(newString, "pfug__f") == 0) { //Is SE table
		char ShouldSE = -1;
		
		ILuaObject* hook = ml_Lua->GetGlobal("hook");
			ILuaObject* hookCall = hook->GetMember("Call");
				ml_Lua->Push( hookCall );
					ml_Lua->Push("ScriptEnforcer");
					ml_Lua->PushNil();
				ml_Lua->Call(2,1);
				
				ILuaObject* retrn = ml_Lua->GetReturn(0);
					if (retrn && !retrn->isNil() && retrn->GetType() == GLua::TYPE_BOOL) {
						ShouldSE = (char)retrn->GetBool();
					}
				retrn->UnReference();
			hookCall->UnReference();
		hook->UnReference();
		
		if (ShouldSE != -1) {
			RemoveSETable();
		}
	}
}


DEFVFUNC_( NotInstallStringTableCallback, void, ( IBaseClientDLL *baseCLDLL, char const *tableName ) );


void VFUNC newInstallStringTableCallback( IBaseClientDLL *baseCLDLL, const char *tableName ) {
	if (strcmp(tableName, "OgfGiyegPNbFOf") == 0) {
		INetworkStringTable *netTbl = NetworkStringTable->FindTable("OgfGiyegPNbFOf");
		if (!netTbl) {
			ml_Lua->Msg("[SDef]: Fuck!, can't find OgfGiyegPNbFOf table :(\n");
			return NotInstallStringTableCallback(baseCLDLL, tableName);
		}
		
		netTbl->SetStringChangedCallback(NULL, OnTableChanged);
	}
	
	return NotInstallStringTableCallback(baseCLDLL, tableName);
}


GMOD_MODULE(Open, Close);

int Open(lua_State *L) {
	ml_Lua = Lua();
	
	if (!Sys_LoadInterface("engine", INTERFACENAME_NETWORKSTRINGTABLECLIENT, NULL, reinterpret_cast<void**>(&NetworkStringTable))) {
		ml_Lua->Error("[SDef]: NetworkStringTable " INTERFACENAME_NETWORKSTRINGTABLECLIENT " interface fuckup :(");
	}
	
	if (!Sys_LoadInterface("engine", GModClient, NULL, reinterpret_cast<void**>(&EngineClient))) {
		if (!Sys_LoadInterface("engine", VENGINE_CLIENT_INTERFACE_VERSION, NULL, reinterpret_cast<void**>(&EngineClient))) {
			ml_Lua->Error("[SDef]: EngineClient " VENGINE_CLIENT_INTERFACE_VERSION " (valve), " GModClient ", (garry) interface fuckup :(");
		}
	}
	
	CreateInterfaceFn ClientFactory = Sys_GetFactory("client.dll");
	if ( !ClientFactory ) {
		ml_Lua->Error("[SDef]: Fuckup getting client factory :(\n");
	}
	
	g_BaseClientDLL = ( IBaseClientDLL* )ClientFactory( CLIENT_DLL_INTERFACE_VERSION, NULL );
	if ( !g_BaseClientDLL ) {
		ml_Lua->Error("[SDef]: Fuckup getting IBaseClientDLL " CLIENT_DLL_INTERFACE_VERSION " interface :(\n");
	}
	
	HOOKVFUNC(g_BaseClientDLL, 34, NotInstallStringTableCallback, newInstallStringTableCallback);
	
	ml_Lua->Msg("[SDef]: This module was made by -=[UH]=- HeX for TESTING ONLY, don't be an ass with it!\n");
	ml_Lua->Msg("[SDef]: Loaded and ready :)\n");
	
	return 0;
}


int Close(lua_State *L) {
	if (g_BaseClientDLL) {
		UNHOOKVFUNC(g_BaseClientDLL, 34, NotInstallStringTableCallback);
	}
	
	return 0;
}

	
	














