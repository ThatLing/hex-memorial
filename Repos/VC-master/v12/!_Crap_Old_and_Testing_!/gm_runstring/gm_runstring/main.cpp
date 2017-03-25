
#undef _UNICODE
#include "GMLuaModule.h"


GMOD_MODULE(Open, Close);

ILuaInterface* sh_Lua = NULL;

LUA_FUNCTION(RunString) {
	sh_Lua->CheckType(1 , GLua::TYPE_STRING);
	sh_Lua->RunString("gm_RunString" , "" , sh_Lua->GetString(1) , true , true);
	return 0;
}


int Open(lua_State *L) {
	sh_Lua = Lua();
	
	sh_Lua->NewGlobalTable("runstring");
	ILuaObject* runstring = sh_Lua->GetGlobal("runstring");
		runstring->SetMember("Run", RunString);
	runstring->UnReference();

	sh_Lua->Msg("gm_runstring by HeX loaded!");
	return 0;
}


int Close(lua_State *L) {
	return 0;
}



