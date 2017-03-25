
#undef _UNICODE
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment(lib, "vstdlib.lib")
#pragma comment(lib, "tier0.lib")
#pragma comment(lib, "tier1.lib")
#pragma comment(lib, "detours.lib")


#include <ILuaModuleManager.h>

#include "simplescan\sigscan.h"
#include "simpledetours\detours.h"

#include "interface.h"
#include "eiface.h"

#include <windows.h>

#include "tier1.h"

#include "tier0/memdbgon.h"


ILuaInterface* sv_Lua = NULL;


#define SIG_ADDR "\x55\x8B\xEC\x81\xEC\x04\x01\x00\x00\x56\x8B\x75\x08\x85\xF6\x0F\x84\x4C\x02\x00\x00\x80\x3E\x00"
#define SIG_MASK "xxxxxxxxxxxxxxx??????xxx"


typedef bool (*IsValidFileFn)(const char* file);

IsValidFileFn validfile_trampoline = NULL;


bool Hook_IsValidFile(char* file) {
	if (file == NULL || V_strlen(file) == 0) {
		return false;
	}
	
	bool bSafe = validfile_trampoline(file);
	
	if (sv_Lua) {
		ILuaObject* hook = sv_Lua->GetGlobal("hook");
			ILuaObject* hookCall = hook->GetMember("Call");
				sv_Lua->Push(hookCall);
				sv_Lua->Push("IsValidFileForTransfer");
					sv_Lua->PushNil();
					sv_Lua->Push(file);
					sv_Lua->Push(bSafe);
				sv_Lua->Call(4,1);
				
				ILuaObject* Ret = sv_Lua->GetReturn(0);
					if (Ret && Ret->isType(GLua::TYPE_BOOL)) {
						bSafe = Ret->GetBool();
					}
				Ret->UnReference();
			hookCall->UnReference();
		hook->UnReference();
	}
	
	//Msg("! Hook_IsValidFile: %s - %i\n", file, (char)bSafe);
	
	return bSafe;
}





GMOD_MODULE(Open, Close)

int Open(lua_State *L) {
	sv_Lua = Lua();
	
	CreateInterfaceFn engineFactory = Sys_GetFactory("engine.dll");
	if (!engineFactory) {
		Error("[VFFT] engineFactory engine.dll not found!\n");
		return 0;
	}
	
	CSigScan::sigscan_dllfunc = engineFactory;
	
	if ( !CSigScan::GetDllMemInfo() ) {
		Error("[VFFT] GetDllMemInfo failed, engine.dll!\n");
		return 0;
	}
	
	CSigScan checkFileScan;
	
	checkFileScan.Init(reinterpret_cast<unsigned char*>( SIG_ADDR ), SIG_MASK, strlen(SIG_MASK) );
	
	if (!checkFileScan.sig_addr) {
		Error("[VFFT] Can't find IsValidFileForTransfer, sig failed!\n");
		return 0;
	}
	
	
	validfile_trampoline = reinterpret_cast<IsValidFileFn>(checkFileScan.sig_addr);
	
	DetourTransactionBegin();
		DetourUpdateThread( GetCurrentThread() );
		DetourAttach( &(PVOID&)validfile_trampoline, (PVOID)(&(PVOID&)Hook_IsValidFile ) );
	DetourTransactionCommit();
	
	return 0;
}

int Close(lua_State *L) {
	if (validfile_trampoline != NULL) {
		DetourTransactionBegin();
		DetourUpdateThread( GetCurrentThread() );
		DetourDetach( &(PVOID&)validfile_trampoline, (PVOID)(&(PVOID&)Hook_IsValidFile ) );
		DetourTransactionCommit();
	}
	
	return 0;
}




























