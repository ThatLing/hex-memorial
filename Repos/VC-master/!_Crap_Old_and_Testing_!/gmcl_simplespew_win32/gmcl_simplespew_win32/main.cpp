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
#pragma comment(lib, "tier0.lib")
#pragma comment(lib, "tier1.lib")


#include <tier0/dbg.h>
#include <ILuaModuleManager.h>
#include <iostream>
#include <Windows.h>
#include <Color.h>


ILuaInterface* 		ml_Lua 	= NULL;
SpewOutputFunc_t 	OldSpew = NULL;
ILuaBase*			NewLUA	= NULL;

int Red, Green, Blue, Alpha = 0;

SpewRetval_t NewSpew(SpewType_t Type, const char *What) {
	if (!What) {
		return SPEW_CONTINUE;
	}
	
	Color tempColor = GetSpewOutputColor();
	tempColor.GetColor(Red,Green,Blue,Alpha);
	
	
	
	if (ml_Lua) {
		ILuaObject* GetSpew = ml_Lua->GetGlobal("GetSpew");
			ml_Lua->Push(GetSpew);
			ml_Lua->Push(What);
			ml_Lua->Call(1,0);
		GetSpew->UnReference();
	}
	
	
	/*
	if (ml_Lua) {
		ILuaObject* hook = ml_Lua->GetGlobal("hook");
			ILuaObject* hookCall = hook->GetMember("Call");
				ml_Lua->Push(hookCall);
				ml_Lua->Push("SimpleSpew");
				ml_Lua->PushNil();
				ml_Lua->Push( (float)Type );
				ml_Lua->Push(What);
				ml_Lua->Push( GetSpewOutputGroup() );
				ml_Lua->Push( (float)GetSpewOutputLevel() );
				ml_Lua->Push( (float)Red );
				ml_Lua->Push( (float)Green );
				ml_Lua->Push( (float)Blue );
				ml_Lua->Push( (float)Alpha );
				ml_Lua->Call(10,0);
			hookCall->UnReference();
		hook->UnReference();
	}
	*/
	
	if (OldSpew) {
		return OldSpew(Type, What);
	} else {
		return SPEW_CONTINUE;
	}
}



LUA_FUNCTION(RemoveSpew) {
	if (OldSpew) {
		SpewOutputFunc(OldSpew);
	}
	return 0;
}



GMOD_MODULE(Open,Close);

int Open(lua_State *L) {
	NewLUA = LUA;
	
	ml_Lua = Lua();
	
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
	
	
	ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookAdd = hook->GetMember("Add");
			ml_Lua->Push(hookAdd);
			ml_Lua->Push("ShutDown");
			ml_Lua->Push("SimpleSpew");
			ml_Lua->Push(RemoveSpew);
			ml_Lua->Call(3,0);
		hookAdd->UnReference();
	hook->UnReference();
	
	OldSpew = GetSpewOutputFunc();
	SpewOutputFunc(NewSpew);
	
	return 0;
}


int Close(lua_State *L) {
	if (OldSpew) {
		SpewOutputFunc(OldSpew);
	}
	return 0;
}













