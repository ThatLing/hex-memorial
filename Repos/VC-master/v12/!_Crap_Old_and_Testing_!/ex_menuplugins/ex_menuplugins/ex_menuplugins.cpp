
#include "stdafx.h"

#undef _UNICODE

#include <windows.h>
#include <iostream>
#include <Tlhelp32.h>

#include <ILuaInterface_B19.h>
#include <ILuaShared_B13.h>

#include <Color.h>
#include <game/client/cdll_client_int.h>

#include <string>
#include <fstream>
#include <interface.h>
#include <direct.h>
#include <stdio.h>
#include <stdarg.h>
#include <sys/stat.h>

#pragma comment(lib, "user32.lib")

using namespace std;
HMODULE lua_shared 				= NULL;
ILuaShared* g_LuaShared 		= NULL;
ILuaInterface* ml_Lua			= NULL;

HANDLE hPLThread2;
HANDLE hPLThread;


DWORD GetProcessIDFromName(LPSTR szProcName)
{
	PROCESSENTRY32 procEntry;
	HANDLE hSnapshot;
	BOOL bFound;

	if(!(hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0))) return 0;	
	procEntry.dwSize = sizeof(PROCESSENTRY32);

	bFound = Process32First(hSnapshot, &procEntry);
	while(bFound) 
	{
		if(!lstrcmp(procEntry.szExeFile, szProcName)) 
		{
			CloseHandle(hSnapshot);
			return procEntry.th32ProcessID;
		}
		bFound = Process32Next(hSnapshot, &procEntry);
	}
	CloseHandle(hSnapshot);
	return 0;
}

HMODULE GetModuleHandleExtern( char *szModuleName, DWORD dwProcessId )
{
   if( !szModuleName || !dwProcessId ) { return NULL; }
   HANDLE hSnap = CreateToolhelp32Snapshot( TH32CS_SNAPMODULE, dwProcessId );
   if( hSnap == INVALID_HANDLE_VALUE ) { return NULL; }
   MODULEENTRY32 me;
   me.dwSize = sizeof( MODULEENTRY32 );
   if( Module32First( hSnap, &me ) )
   {
      while( Module32Next( hSnap, &me ) )
      {
         if( !strcmp( me.szModule, szModuleName ) )
         {
            CloseHandle( hSnap );
            return me.hModule;
         }
      }
   }
   CloseHandle( hSnap );
   return NULL;
}



DWORD WINAPI PLThread2(LPVOID param) {
	while (ml_Lua == NULL) {
		if (g_LuaShared) {
			ml_Lua = g_LuaShared->GetLuaInterface(2);
		}
		
		if (ml_Lua) {
			ml_Lua->Msg("\n!got ml_Lua!\n\n");
			
			Sleep(100);
			
			if (hPLThread2) {
				CloseHandle(hPLThread2);
			}
			ExitThread(1);
			return true;
		}
	}
	return true;
}


DWORD WINAPI PLThread(LPVOID param) {
	while (g_LuaShared == NULL) {
		
		if (lua_shared == NULL) {
			ExitThread(1);
			return true;
		}
		CreateInterfaceFn LuaSharedAddr = (CreateInterfaceFn)GetProcAddress(lua_shared, "CreateInterface");
		
		g_LuaShared = (ILuaShared*)LuaSharedAddr("LuaShared002", NULL);
		
		if (g_LuaShared) {
			hPLThread2 = CreateThread(NULL, 0, &PLThread2, NULL, NULL, NULL);
			
			ExitThread(1);
			return true;
		}
	}
	
	return true;
}


int main() {
	cout << "waiting for GMod...\n";
	
	while (FindWindowA(NULL, "Garry's Mod 13") == NULL) {
		Sleep(1000);
		cout << "No GMod..\n";
	}
	DWORD HL2 = GetProcessIDFromName("hl2.exe");
	
	cout << "Found @ ProcessID " << HL2 << "\n";
	
	cout << "Getting handle..\n";
	while (lua_shared == NULL) {
		lua_shared = GetModuleHandleExtern("lua_shared.dll", HL2);
		Sleep(20);
	}
	
	cout << "Found lua_shared @ " << lua_shared << "\n";
	Sleep(1);
	
	if (lua_shared) {
		hPLThread = CreateThread(NULL, 0, &PLThread, NULL, NULL, NULL);
		
		while (lua_shared) {
			Sleep(1000);
		}
	}
	return 0;
}








