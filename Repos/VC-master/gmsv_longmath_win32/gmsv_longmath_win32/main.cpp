
#undef _UNICODE
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN
#define GMMODULE

#pragma comment(linker, "/NODEFAULTLIB:libcmt")
#pragma comment(lib, "tier0.lib")
#pragma comment(lib, "tier1.lib")

#include <ILuaModuleManager.h>
#include <Windows.h>
#include <string>


using namespace std;

ILuaInterface* sv_Lua = NULL;


//Add
LUA_FUNCTION(Add) {
	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	sv_Lua->CheckType(2, GLua::TYPE_STRING);
	
	//Get
	__int64 SID 	= stoull( sv_Lua->GetString(1) );
	__int64 SID_2	= stoull( sv_Lua->GetString(2) );
	
	//Operation
	__int64 Out = SID + SID_2;
	
	//Check
	if (!Out || Out <= 0) {
		sv_Lua->Push(false);
		return 1;
	}
	
	sv_Lua->Push( to_string(Out).c_str() );
	
	return 1;
}

//Minus
LUA_FUNCTION(Minus) {
	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	sv_Lua->CheckType(2, GLua::TYPE_STRING);
	
	//Get
	__int64 SID 	= stoull( sv_Lua->GetString(1) );
	__int64 SID_2	= stoull( sv_Lua->GetString(2) );
	
	//Operation
	__int64 Out = SID - SID_2;
	
	//Check
	if (!Out || Out <= 0) {
		sv_Lua->Push(false);
		return 1;
	}
	
	sv_Lua->Push( to_string(Out).c_str() );
	
	return 1;
}



GMOD_MODULE(Open, Close);

int Open(lua_State* L) {
	sv_Lua = Lua();
	
	sv_Lua->NewGlobalTable("longmath");
	ILuaObject* longmath = sv_Lua->GetGlobal("longmath");
		longmath->SetMember("Add", 		Add);
		longmath->SetMember("Minus", 	Minus);
	longmath->UnReference();
	
	return 0;
}

int Close(lua_State* L) {
	return 0;
}























