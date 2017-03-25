
//Win
#pragma comment (linker, "/NODEFAULTLIB:libcmt")

#define WIN32_LEAN_AND_MEAN
#include <Windows.h>

//SDK
#include "cdll_int.h"

//GMod
#include <ILuaModuleManager.h>





LUA_FUNCTION(Sleep) {
	int Delay = LUA->CheckNumber(1);
	
	Warning("! Sleep start: %d\n", Delay);
		Sleep(Delay);
	Warning("! Sleep end\n");
	return 0;
}





//Open
GMOD_MODULE_OPEN() {
	
	//Globals
	LUA->PushSpecial(0);
		LUA->CreateTable();
			LUA->PushCFunction(Sleep);
			LUA->SetField(-2, "Sleep");
			
		LUA->SetField(-2, "lag");
	LUA->Pop();
	
	return 0;
}

//Close
GMOD_MODULE_CLOSE() {
	return 0;
}









