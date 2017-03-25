
#define WIN32_LEAN_AND_MEAN
#include <GMLuaModule.h>

ILuaInterface* g_Lua;


LUA_FUNCTION(PrintSomething) {
	g_Lua->Msg( "Hello!\n" );
	
	return 0;
}


GMOD_MODULE(Open,Close);
 
int Open(lua_State *L) {
	g_Lua = Lua();
	
	g_Lua->Msg("Hello there!\n");
	
	g_Lua->SetGlobal("PrintSomething", PrintSomething);
	
	return 0;
}

int Close(lua_State *L) {
	return 0;
}


