/*
	=== gmsv_simplespew ===
	*Like enginespew, but...better!*
	
	Credits:
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


ILuaInterface* 		sv_Lua = NULL;
SpewOutputFunc_t 	OldSpew = NULL;

Color SourceGrey(192,192,192,255);

int Red, Green, Blue, Alpha = 0;


SpewRetval_t NewSpew(SpewType_t Type, const char *What) {
	if (!What) {
		return SPEW_CONTINUE;
	}
	
	Color tempColor = GetSpewOutputColor();
	tempColor.GetColor(Red,Green,Blue,Alpha);
	
	if (sv_Lua) {
		ILuaObject* hook = sv_Lua->GetGlobal("hook");
			ILuaObject* hookCall = hook->GetMember("Call");
				sv_Lua->Push(hookCall);
				sv_Lua->Push("SimpleSpew");
				sv_Lua->PushNil();
				sv_Lua->Push(  (float)Type );
				sv_Lua->Push(What);
				sv_Lua->Push( GetSpewOutputGroup() );
				sv_Lua->Push( (float)GetSpewOutputLevel() );
				sv_Lua->Push( (float)Red );
				sv_Lua->Push( (float)Green );
				sv_Lua->Push( (float)Blue );
				sv_Lua->Push( (float)Alpha );
				sv_Lua->Call(10,0);
			hookCall->UnReference();
		hook->UnReference();
	}
	
	
	if (Red == 255 && Green == 255 && Blue == 255 && Alpha == 255) { //White
		ConColorMsg(SourceGrey, What);
		return SPEW_CONTINUE;
	}
	
	
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
	if (OldSpew) {
		SpewOutputFunc(OldSpew);
	}
	return 0;
}













