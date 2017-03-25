
/*
	=== gmcl_connect ===
	
	Credits:
		. ColdFusion (gmcl_disconnect)
		. HeX (Combining these together)
*/


#include "gminterface/GMLuaModule.h"
#include "simplescan/csimplescan.h"
#include "simpledetours/csimpledetour.h"

#define GAME_DLL
#define CLIENT_DLL
#define WIN32_LEAN_AND_MEAN


#include <eiface.h>

#include <stdlib.h>
#include <Windows.h>

GMOD_MODULE(Open, Close);

ILuaInterface *gLua = NULL;




const char * CallLuaHook(const char* name, const char* disconnectstring){
	ILuaObject *hookT = gLua->GetGlobal("hook");
	ILuaObject *callM = hookT->GetMember("Call");
	gLua->Push(callM);
	gLua->Push(name);
	gLua->PushNil();
	gLua->Push(disconnectstring);
	callM->UnReference();
	hookT->UnReference();

	gLua->Call(3, 1);

	ILuaObject *retL = gLua->GetReturn(0);

	if(!retL->isNil()) {
		return gLua->GetString(0);
	}
	return disconnectstring;
}

class detours
{
public:
	void Disconnect_H(char const * a);
	static void (detours:: *Disconnect_T)(char const * a);
};
void (detours:: *detours::Disconnect_T)(char const * a) = NULL;

SETUP_SIMPLE_DETOUR(Disconnect_Detour, detours::Disconnect_T, detours::Disconnect_H);

void detours::Disconnect_H(char const * a)
{
	(this->*Disconnect_T)(CallLuaHook("DisconnectMsg", a));
}

int Open( lua_State *L )
{
	gLua = Lua();

	CSimpleScan engineInterface("engine.dll");
	if(engineInterface.FindFunction((const char *)"\x53\x56\x8B\xF1\x33\xDB\x39\x9E\x8C\x00\x00\x00\x0F\x8C\x29\x01\x00\x00\x8B\x06\x8B", "xxxxxxxxx???x?????xxx", (void **)&detours::Disconnect_T))
	{
		Disconnect_Detour.Attach();
		//gLua->Msg("gmcl_disconnect Succesfully Intalized.\nMade by ColdFusion 11/21/2010\n");
		return 0;
	}
	gLua->Msg("gmcl_disconnect: Sigscan failed\ngmcl_disconnect Failed to Intalize\n");
	return 0;
}

int Close( lua_State *L )
{
	Disconnect_Detour.Detach();
	return 0;
}