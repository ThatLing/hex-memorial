

#undef _UNICODE
#pragma comment(linker,"/NODEFAULTLIB:libcmt")
#pragma comment(lib, "tier0.lib")
#pragma comment(lib, "tier1.lib")

#define CLIENT_DLL

#include <Windows.h>

#include <Color.h>
#include <game/client/cdll_client_int.h>
Color Blue(0,162,232,255);
Color White(255,255,255,255);
Color Green(85,218,90,255);
Color Sexy(255,174,201,255);
Color Red(255,0,0,255);

#define GMMODULE
#include <ILuaModuleManager.h>
ILuaInterface* ml_Lua = NULL;

using namespace std;


void Message(const char* str) {
	ConColorMsg(Blue, 	"[Delegate] ");
	ConColorMsg(Green, 	"Message: ");
	ConColorMsg(White, 	str);
	ConColorMsg(White, 	"\n");
	
	/*
	if (ml_Lua) {
		ILuaObject* print = ml_Lua->GetGlobal("print");
			ml_Lua->Push(print);
			ml_Lua->Push(str);
			ml_Lua->Call(1,0);
		print->UnReference();
	}
	*/
}


LUA_FUNCTION(Msg) {
	ml_Lua->CheckType(1, Type::STRING);
	
	Message( ml_Lua->GetString(1) );
	
	return 0;
}

LUA_FUNCTION(Get) {
	ml_Lua->Push("Exploded mouse");
	return 1;
}



GMOD_MODULE(Open, Close);

int Open(lua_State *L) {
	ml_Lua = Lua();
	Message("Hello there!\n");
	
	ILuaObject* delegate = ml_Lua->GetNewTable();
		delegate->SetMember("Msg", Msg);
		
		ml_Lua->SetGlobal("delegate", delegate);
	delegate->UnReference();
	
	return 0;
}

int Close(lua_State *L) {
	return 0;
}








