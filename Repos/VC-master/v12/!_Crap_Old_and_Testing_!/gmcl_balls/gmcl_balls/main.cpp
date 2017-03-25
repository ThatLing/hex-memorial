
#define CLIENT_DLL

#undef _UNICODE
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment (lib, "tier0.lib")
#pragma comment (lib, "tier1.lib")

#include <windows.h>
#include <cdll_int.h>
#include "GMLuaModule.h"
//#include "CStateManager.h"

GMOD_MODULE(Open, Close);

ILuaInterface* ml_Lua;


LUA_FUNCTION(Balls) {
   //ILuaInterface* cl_Lua = CStateManager::GetByIndex(LuaStates::CLIENT);
	
	HMODULE hmLuaShared = GetModuleHandle("lua_shared.dll");
	CreateInterfaceFn fnLua = (CreateInterfaceFn)GetProcAddress(hmLuaShared, "CreateInterface");
	
	ILuaShared* pLuaSh = (ILuaShared*)fnLua("LuaShared001", NULL);
	
	ILuaInterface* cl_Lua = (ILuaInterface*) pLuaSh->GetInterfaceByState( L );
	
	
	if (!cl_Lua) {
		ml_Lua->Msg("! oh shit\n");
		return 0;
	}
	
	cl_Lua->Msg("! works!\n");
    return 0;
}


int Open(lua_State *L) {
	ml_Lua = Lua();
	
	ml_Lua->SetGlobal("Balls", Balls);
	
	ml_Lua->Msg("! loaded\n");
    return 0;
}

int Close(lua_State *L) {
    return 0;
}





