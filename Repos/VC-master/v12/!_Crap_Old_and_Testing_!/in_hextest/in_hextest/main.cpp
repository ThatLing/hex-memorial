

#undef _UNICODE

#pragma comment (linker, "/NODEFAULTLIB:libcmt")


#include <stdio.h>
#include <windows.h>
#include <cdll_int.h>
#include <string>
#include <fstream>

#include <GMLuaModule.h>
//#include <CStateManager.h>

#include <ILuaShared_B10.h>


HANDLE hHacThread;
ILuaInterface* ml_Lua = NULL;

/*
DWORD WINAPI HacThread(LPVOID param) {
	ILuaInterface* m_Lua = NULL;
	
	while (m_Lua == NULL) {
		m_Lua = CStateManager::GetInterface(LuaStates::MENU);
		
		if (m_Lua) {
			ml_Lua = m_Lua;
			
			ml_Lua->Msg("Got ml_Lua!\n");
		}
	}
	
	return true;
}
*/


DWORD WINAPI HacThread(LPVOID param) {
	HMODULE hmLuaShared = GetModuleHandle("lua_shared.dll");
	CreateInterfaceFn fnLua = (CreateInterfaceFn)GetProcAddress(hmLuaShared, "CreateInterface");
	ILuaShared* g_LuaShared = (ILuaShared*)fnLua("LuaShared002", NULL);
	
	ILuaInterface* m_Lua = NULL;
	while (m_Lua == NULL) {
		m_Lua = g_LuaShared->GetLuaInterface(2);
		
		if (m_Lua != NULL) {
			m_Lua->Msg("Got ml_Lua!\n");
		}
	}
	
	return true;
}



BOOL APIENTRY DllMain(HMODULE hmDll, DWORD dwReason, LPVOID lpReserved) {
	if (dwReason == DLL_PROCESS_ATTACH)  {
		DisableThreadLibraryCalls(hmDll);
		hHacThread = CreateThread(NULL, 0, &HacThread, NULL, NULL, NULL);
	}
	
	return true;
}










