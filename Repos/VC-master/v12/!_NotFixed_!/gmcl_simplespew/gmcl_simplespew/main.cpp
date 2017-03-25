/*
	=== gmcl_simplespew ===
	*Now with ConColorMsg support, thanks fangli*
	
	Credits:
		. fangli (GM13 console)
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
#include <Color.h>

ILuaInterface* 		ml_Lua 	= NULL;
SpewOutputFunc_t 	OldSpew = NULL;
bool Removed 				= false;


int Red, Green, Blue, Alpha = 0;

SpewRetval_t NewSpew(SpewType_t Type, const char *What) {
	if (Removed || (!What || !ml_Lua)) {
		return SPEW_CONTINUE;
	}
	
	Color tempColor = GetSpewOutputColor();
	tempColor.GetColor(Red,Green,Blue,Alpha);
	
	ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
			ml_Lua->Push(hookCall);
			ml_Lua->Push("SimpleSpew");
			ml_Lua->PushNil();
			ml_Lua->PushLong(Type);
			ml_Lua->Push(What);
			ml_Lua->Push( GetSpewOutputGroup() );
			ml_Lua->PushLong( GetSpewOutputLevel() );
			ml_Lua->PushLong(Red);
			ml_Lua->PushLong(Green);
			ml_Lua->PushLong(Blue);
			ml_Lua->PushLong(Alpha);
			ml_Lua->Call(10,0);
		hookCall->UnReference();
	hook->UnReference();
	
	
	if (OldSpew) {
		return OldSpew(Type, What);
	} else {
		return (SpewRetval_t)0;
	}
}

LUA_FUNCTION(RemoveSpew) {
	if (Removed) { return 0; }
	Removed = true;
	
	SpewOutputFunc(OldSpew);
	return 0;
}



void AddRemoveHook(const char* What) {
	ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookAdd = hook->GetMember("Add");
			ml_Lua->Push(hookAdd);
			ml_Lua->Push(What);
			ml_Lua->Push("SimpleSpew");
			ml_Lua->Push(RemoveSpew);
			ml_Lua->Call(3,0);
		hookAdd->UnReference();
	hook->UnReference();
}

GMOD_MODULE(Open,Close);

int Open(lua_State *L) {
	ml_Lua = Lua();
	
	OldSpew = GetSpewOutputFunc();
	SpewOutputFunc(NewSpew);
	
	ml_Lua->SetGlobal("SPEW_MESSAGE", 		(float)SPEW_MESSAGE);
	ml_Lua->SetGlobal("SPEW_WARNING",		(float)SPEW_WARNING);
	ml_Lua->SetGlobal("SPEW_ASSERT", 		(float)SPEW_ASSERT);
	ml_Lua->SetGlobal("SPEW_ERROR", 		(float)SPEW_ERROR);
	ml_Lua->SetGlobal("SPEW_LOG", 			(float)SPEW_LOG);
	ml_Lua->SetGlobal("SPEW_TYPE_COUNT", 	(float)SPEW_TYPE_COUNT);
	ml_Lua->SetGlobal("SPEW_DEBUGGER", 		(float)SPEW_DEBUGGER);
	ml_Lua->SetGlobal("SPEW_CONTINUE", 		(float)SPEW_CONTINUE);
	ml_Lua->SetGlobal("SPEW_TYPE_COUNT", 	(float)SPEW_TYPE_COUNT);
	ml_Lua->SetGlobal("SPEW_ABORT", 		(float)SPEW_ABORT);
	
	ml_Lua->NewGlobalTable("simplespew");
	ILuaObject* simplespew = ml_Lua->GetGlobal("simplespew");
		simplespew->SetMember("Remove", RemoveSpew);
	simplespew->UnReference();
	
	AddRemoveHook("ShutDown");
	AddRemoveHook("OnConfirmQuit"); //Extras
	
	return 0;
}

int Close(lua_State *L) {
	ml_Lua = NULL;
	return 0;
}













