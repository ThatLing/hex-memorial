
#define CLIENT_DLL

#undef _UNICODE
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment (lib, "tier0.lib")
#pragma comment (lib, "tier1.lib")

#include <GMLuaModule.h>
#include <CStateManager.h>

#include <Windows.h>
#include <cdll_int.h>
#include <string>


GMOD_MODULE(Open, Close);

ILuaInterface *ml_Lua;


LUA_FUNCTION(Balls) {
	ml_Lua->Msg("! trying..\n");
	
	/*HMODULE hmLuaShared = GetModuleHandle("lua_shared.dll");
	CreateInterfaceFn fnLua = (CreateInterfaceFn)GetProcAddress(hmLuaShared, "CreateInterface");
	
	ILuaShared* g_LuaShared = (ILuaShared*)fnLua("LuaShared001", NULL);
	ILuaInterface* cl_Lua = g_LuaShared->GetLuaInterface(0);
	*/
	//ILuaInterface* cl_Lua = CStateManager::GetInterface(LuaStates::CLIENT);
	ILuaInterface* cl_Lua = CStateManager::GetByIndex(LuaStates::CLIENT);
	
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





