/*
	=== gmsv_simplespew ===
	*Like enginespew, but...better*
	
	Credits:
		. Python (gmsv_ansiterm)
		. Chrisaster (gm_enginespew)
		. HeX
*/

#undef _UNICODE
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")

#include <tier0/dbg.h>
#include <GMLuaModule.h>
#include <iostream>
#include <Windows.h>

ILuaInterface* 		sv_Lua = NULL;
SpewOutputFunc_t 	OldSpew = NULL;


SpewRetval_t NewSpew(SpewType_t Type, const char *What) {
	if (!What || !sv_Lua) {
		return SPEW_CONTINUE;
	}
	
	ILuaObject* hook = sv_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
			sv_Lua->Push(hookCall);
			sv_Lua->Push("SimpleSpew");
			sv_Lua->PushNil();
			sv_Lua->PushLong(Type);
			sv_Lua->Push(What);
			sv_Lua->Push( GetSpewOutputGroup() );
			sv_Lua->PushLong( GetSpewOutputLevel() );
			sv_Lua->Call(6,0);
		hookCall->UnReference();
	hook->UnReference();
	
	if (OldSpew) {
		return OldSpew(Type, What);
	}
}


LUA_FUNCTION(RemoveSpew) {
	SpewOutputFunc(OldSpew);
	return 0;
}

GMOD_MODULE(Open,Close);

int Open(lua_State *L) {
	sv_Lua = Lua();
	
	OldSpew = GetSpewOutputFunc();
	SpewOutputFunc(NewSpew);
	
	sv_Lua->SetGlobal("SPEW_MESSAGE", 		(float)SPEW_MESSAGE);
	sv_Lua->SetGlobal("SPEW_WARNING",		(float)SPEW_WARNING);
	sv_Lua->SetGlobal("SPEW_ASSERT", 		(float)SPEW_ASSERT);
	sv_Lua->SetGlobal("SPEW_ERROR", 		(float)SPEW_ERROR);
	sv_Lua->SetGlobal("SPEW_LOG", 			(float)SPEW_LOG);
	sv_Lua->SetGlobal("SPEW_TYPE_COUNT", 	(float)SPEW_TYPE_COUNT);
	sv_Lua->SetGlobal("SPEW_DEBUGGER", 		(float)SPEW_DEBUGGER);
	sv_Lua->SetGlobal("SPEW_CONTINUE", 		(float)SPEW_CONTINUE);
	sv_Lua->SetGlobal("SPEW_TYPE_COUNT", 	(float)SPEW_TYPE_COUNT);
	sv_Lua->SetGlobal("SPEW_ABORT", 		(float)SPEW_ABORT);
	
	sv_Lua->NewGlobalTable("simplespew");
	ILuaObject* simplespew = sv_Lua->GetGlobal("simplespew");
		simplespew->SetMember("Remove", RemoveSpew);
	simplespew->UnReference();
	
	//sv_Lua->RunString("", "simplespew", "hook.Add('ShutDown', 'SimpleSpew', function() simplespew.Remove() end)", true, true);
	
	ILuaObject* hook = sv_Lua->GetGlobal("hook");
		ILuaObject* hookAdd = hook->GetMember("Add");
			sv_Lua->Push(hookAdd);
			sv_Lua->Push("ShutDown");
			sv_Lua->Push("SimpleSpew");
			sv_Lua->Push(RemoveSpew);
			sv_Lua->Call(3,0);
		hookAdd->UnReference();
	hook->UnReference();
	
	return 0;
}

int Close(lua_State *L) {
	sv_Lua = NULL;
	return 0;
}













