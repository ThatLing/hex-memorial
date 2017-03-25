/*
	=== in_sdef ===
	*ScriptDeforcer2*
	
	Credits:
		. Fr1kin (gm_cmd/hermes)
		. HeX (Combining these together)
*/

#define GAME_DLL
#define CLIENT_DLL
#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <algorithm>
#include <string.h>

#pragma once
#pragma comment(lib,"tier0.lib")
#pragma comment(lib,"tier1.lib")
#pragma comment(linker,"/NODEFAULTLIB:libcmt")

#include <Color.h>
#include <cdll_client_int.h>

#include <vmthook.h>
#include "IScriptEnforcer.h"

using namespace std;

Color Blue(0,162,232,255);
Color White(255,255,255,255);
Color Sexy(255,174,201,255);
Color Red(255,0,0,255);
Color Green(85,218,90,255);



CVMTHook gIsActive;
bool __stdcall IsActive() {
	return false; //Allow everything
}


CVMTHook gScriptAllowed;
bool __stdcall ScriptAllowed(char* strScript, unsigned char* data, int size, unsigned char* u1) {
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




BOOL APIENTRY DllMain(HMODULE hmDll, DWORD dwReason, LPVOID lpReserved) {
	if (dwReason == DLL_PROCESS_ATTACH) {
		DisableThreadLibraryCalls(hmDll);
		
		ConColorMsg(Sexy, "[SDef2]: ");
		ConColorMsg(White, "Made by");
		ConColorMsg(Blue, " -=[UH]=- HeX");
		ConColorMsg(White, " to bypass");
		ConColorMsg(Green, " ScriptEnforcer!\n");
		
		ConColorMsg(Sexy, "[SDef2]: ");
		if ( DoSEDetour() ) {
			ConColorMsg(Green, " Ready!\n");
		} else {
			ConColorMsg(Red, " Can't find SE functions!\n");
		}
	}
	
	return 0;
}







