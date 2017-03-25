/*
	=== gmcl_sdef ===
	*ScriptDeforcer2*
	
	Credits:
		. Fr1kin (gm_cmd/hermes)
		. HeX (Combining these together)
*/

#define GAME_DLL
#define CLIENT_DLL
#define WIN32_LEAN_AND_MEAN

#pragma once
#pragma comment(lib, "tier0.lib")
#pragma comment(lib, "tier1.lib")

#include <GMLuaModule.h>
#include <vmthook.h>
#include "IScriptEnforcer.h"

#include <windows.h>
#include <algorithm>
#include <string.h>

GMOD_MODULE(Open, Close);
ILuaInterface* ml_Lua;



CVMTHook gIsActive;
bool __stdcall IsActive() {
	ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
			ml_Lua->Push(hookCall);
				ml_Lua->Push("SEIsActive");
				ml_Lua->PushNil();
			ml_Lua->Call(2,1);
			
			ILuaObject* ShouldBeActive = ml_Lua->GetReturn(0);
			
			if (!ShouldBeActive->isNil() && ShouldBeActive->GetType() == GLua::TYPE_BOOL) {
				return ShouldBeActive->GetBool();
			}
			ShouldBeActive->UnReference();
		hookCall->UnReference();
	hook->UnReference();
	
	return false; //Allow everything
}

CVMTHook gScriptAllowed;
bool __stdcall ScriptAllowed(char* strScript, unsigned char* data, int size, unsigned char* u1) {
	ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
			ml_Lua->Push(hookCall);
				ml_Lua->Push("ScriptAllowed");
				ml_Lua->PushNil();
				ml_Lua->Push(strScript);
				ml_Lua->Push( (char*)data );
				ml_Lua->Push( (float)size );
			ml_Lua->Call(5,1);
			
			ILuaObject* ShouldAllow = ml_Lua->GetReturn(0);
			
			if (!ShouldAllow->isNil() && ShouldAllow->GetType() == GLua::TYPE_BOOL) {
				return ShouldAllow->GetBool();
			}
			ShouldAllow->UnReference();
		hookCall->UnReference();
	hook->UnReference();
	
	return true;
}




BOOL DataCompare( BYTE* pData, BYTE* bMask, char * szMask ) {
	for ( ; *szMask; ++szMask, ++pData, ++bMask ) {
		if ( *szMask == 'x' && *pData != *bMask ) {
			return FALSE;
		}
	}
	return (*szMask == NULL);
}
DWORD FindPattern( DWORD dwAddress, DWORD dwLen, BYTE *bMask, char * szMask ) {
	for (DWORD i = 0; i < dwLen; i++) {
		if ( DataCompare( (BYTE*)( dwAddress + i ), bMask, szMask ) ) {
			return (DWORD)( dwAddress + i );
		}
	}
	return 0;
}


ScriptEnforcer_VTable* GHookTable;

bool DoSEDetour() {
	HMODULE hClient = NULL;

	while (hClient == NULL) {
		hClient = GetModuleHandleA("client.dll");
		Sleep(100);
	}
	
	BYTE ScriptEnforcerSig[] = { 0x8B, 0x15, 0x00, 0x00, 0x00, 0x00, 0x8B, 0x42, 0x44, 0x83, 0xC4, 0x18 };
	DWORD dwAddressOfScriptEnforcer = FindPattern((DWORD)GetModuleHandle("client.dll"), 0x00FFFFFF, ScriptEnforcerSig, "xx????xxxxxx" );
	
	if (dwAddressOfScriptEnforcer == NULL) {
		return false;
	}
	
	dwAddressOfScriptEnforcer += 2;
	IScriptEnforcer* pScriptEnforcer = (IScriptEnforcer*)*(DWORD*)dwAddressOfScriptEnforcer;
	
	PDWORD* pdwScriptEnforcer = (PDWORD*)pScriptEnforcer;
	while (pdwScriptEnforcer == NULL || *pdwScriptEnforcer == NULL) {
		Sleep(100);
	}
	
	GHookTable = (ScriptEnforcer_VTable*) *pdwScriptEnforcer;
	
	gIsActive.Hook( (DWORD)&IsActive, (PDWORD)pdwScriptEnforcer, 17);
	gScriptAllowed.Hook( (DWORD)&ScriptAllowed, (PDWORD)pdwScriptEnforcer, 18);
	
	return true;
}




int Open(lua_State* L) {
	ml_Lua = Lua();
	
	ILuaObject *maxply = ml_Lua->GetGlobal("MaxPlayers");
		bool InMenu = maxply->isNil();
	maxply->UnReference();
	
	if (!InMenu) {
		ml_Lua->Msg("[SDef2]: Not in menustate dumbass!\n");
		return 0;
	}
	
	if ( DoSEDetour() ) {
		ml_Lua->Msg("[SDef2]: Loaded and ready :)\n");
	} else {
		ml_Lua->Msg("[SDef2]: Can't detour SE functions, damn!\n");
	}
	
	return 0;
}


int Close(lua_State* L) {
	return 0;
}





