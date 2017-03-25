
#define CLIENT_DLL

#undef _UNICODE
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment (lib, "tier0.lib")
#pragma comment (lib, "tier1.lib")

#include <GMLuaModule.h>

#include <Windows.h>
#include <cdll_int.h>
#include <string>

ILuaInterface* gm_Lua = NULL;

typedef int (*GMod_CloseFunc) (lua_State *l);
typedef int (*GMod_OpenFunc) (lua_State *l);

using namespace std;



LUA_FUNCTION(ReReq) {
	gm_Lua->CheckType(1, GLua::TYPE_STRING);
	
	
	if (!LoadLibrary( gm_Lua->GetString(1) )) {
		gm_Lua->Error("[unrequire] LoadLibrary() failed!");
	}
	
	
	GMod_OpenFunc Open;
	
	HMODULE hModule = GetModuleHandleA( gm_Lua->GetString(1) );
	if (!hModule) {
		gm_Lua->Error("[unrequire] GetModuleHandleA() failed!");
	}
	
	
	Open = (GMod_OpenFunc)GetProcAddress(hModule, "gmod_open");
	if (!Open) {
		gm_Lua->Error("[unrequire] GetProcAddress() failed!");
	}
	Open( (lua_State*)gm_Lua->GetLuaState() );
	
	gm_Lua->Msg("[unrequire] Unrequired\n");
	return 0;
}


LUA_FUNCTION(UnReq) {
	gm_Lua->CheckType(1, GLua::TYPE_STRING);
	
	string oname( gm_Lua->GetString(1) );
	
	
	string ename;
	while (true) {
		if ( GetModuleHandleA(("gm_"+oname+".dll").c_str()) ) {
			ename = "gm_"+oname+".dll";
			break;
		}
		
		if ( GetModuleHandleA(("gmcl_"+oname+".dll").c_str()) ) {
			ename = "gmcl_"+oname+".dll";
			break;
		}
		
		if ( GetModuleHandleA(("gmsv_"+oname+".dll").c_str()) ) {
			ename = "gmsv_"+oname+".dll";
			break;
		}
		
		break;
	}
	
	if ( ename.empty() ) {
		gm_Lua->Error("[unrequire] Module not found!");
	}
	
	GMod_CloseFunc Close;
	
	HMODULE hModule = GetModuleHandleA( ename.c_str() );
	if (!hModule) {
		gm_Lua->Error("[unrequire] GetModuleHandleA() failed!");
	}
	
	
	Close = (GMod_CloseFunc)GetProcAddress(hModule, "gmod_close");
	if (!Close) {
		gm_Lua->Error("[unrequire] GetProcAddress() failed!");
	}
	Close( (lua_State*)gm_Lua->GetLuaState() );
	
	if (!FreeLibrary(hModule)) {
		gm_Lua->Error("[unrequire] FreeLibrary() failed!");
	}
	
	gm_Lua->Msg("[unrequire] Unrequired %s\n", ename.c_str());
	
	ILuaObject *package = gm_Lua->GetGlobal("package");
		ILuaObject *loaded = package->GetMember("loaded");
			loaded->SetMember(oname.c_str(), (ILuaObject*)NULL);
		package->UnReference();
	loaded->UnReference();
	
	return 0;
}





GMOD_MODULE(Open, Close);

int Open(lua_State *L) {
	gm_Lua = Lua();
	
	gm_Lua->NewGlobalTable("rereq");
	ILuaObject* rereq = gm_Lua->GetGlobal("rereq");
		rereq->SetMember("require", 	ReReq);
		rereq->SetMember("unrequire", 	UnReq);
	rereq->UnReference();
	
	gm_Lua->Msg("! loaded\n");
    return 0;
}

int Close(lua_State *L) {
    return 0;
}





