
#define WIN32_LEAN_AND_MEAN
#include <GMLuaModule.h>

ILuaInterface* sh_Lua;


LUA_FUNCTION(RunModuleTest) {
	sh_Lua->CheckType(1, GLua::TYPE_STRING);
	
	sh_Lua->PushPath("includes/modules");
	sh_Lua->RunModule( sh_Lua->GetString(1) );
	
	return 0;
}


GMOD_MODULE(Open,Close);

int Open(lua_State *L) {
	sh_Lua = Lua();
	
	sh_Lua->Msg("Hello there!\n");
	
	sh_Lua->SetGlobal("RunModule", RunModuleTest);
	
	return 0;
}

int Close(lua_State *L) {
	return 0;
}


