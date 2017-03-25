
/*
	=== gmcl_saverestore ===
	*For the testing and development of HAC*
*/


#undef _UNICODE

#include <Windows.h>
#include <GMLuaModule.h>
#include <string>


GMOD_MODULE(Open, Close);


LUA_FUNCTION(LOLString) {
	Lua()->CheckType(1, GLua::TYPE_STRING);
	const char* lua = Lua()->GetString(1);
	
	Lua()->RunString("", "LOLString", lua, true, true);
	
	return 0;
}


int Open(lua_State *L) {
	
	Lua()->SetGlobal("LOLString", LOLString);
	//Lua()->RunString("", "LOLString", " timer.Simple(2, function() include = function(path) LOLString( file.Read('lua/'..path, true) ) end include('hexloader.lua') end) ", true, true);
	
	Lua()->Msg("\n\nLoaded\n\n");
	return 0;
}



int Close(lua_State *L) {
	return 0;
}





