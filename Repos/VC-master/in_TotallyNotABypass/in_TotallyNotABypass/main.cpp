
#undef _UNICODE
#define _RETAIL
#define GAME_DLL
#define CLIENT_DLL
#define WIN32_LEAN_AND_MEAN

#pragma once
#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment(lib, "vstdlib.lib")
#pragma comment(lib, "tier0.lib")
#pragma comment(lib, "tier1.lib")


//CVar2
#include <interface.h>
#include <bitbuf.h>

#include <windows.h>
#include <cbase.h>
#include <fstream>
#include <string>
#include <iostream>

//Replicator
#include <convar.h>
#include <icvar.h>
#include <tier1.h>

//Console
#include <Color.h>

using namespace std;


HANDLE EvilThreadHandle;
ICvar* g_ICvar = NULL;



Color Sexy(255,174,201,255);
Color Red(255,0,0,255);
Color Green(85,218,90,255);
Color Blue(0,162,232,255);


DWORD WINAPI EvilThread(LPVOID param) {
	ConColorMsg(Green, 	"[Totally");
	ConColorMsg(Red, 	"Not");
	ConColorMsg(Green, 	"ABypass] ");
	ConColorMsg(Sexy, 	"Loading..\n");
	
	CreateInterfaceFn VSTDLibFactory = Sys_GetFactory("vstdlib.dll");
	if (!VSTDLibFactory) {
		ConColorMsg(Red, 	"[TotallyNotABypass] ");
		ConColorMsg(Sexy, 	"Error getting vstdlib.dll factory\n");
		return true;
	}
	g_ICvar = (ICvar*)VSTDLibFactory(CVAR_INTERFACE_VERSION, NULL);
	if (!g_ICvar) {
		ConColorMsg(Red, 	"[TotallyNotABypass] ");
		ConColorMsg(Sexy, 	"Error getting ICvar " CVAR_INTERFACE_VERSION " interface\n");
		return true;
	}
	
	
	ConVar* sv_allowcslua = g_ICvar->FindVar("sv_allowcslua");
	if (!sv_allowcslua) {
		ConColorMsg(Red, 	"[TotallyNotABypass] ");
		ConColorMsg(Sexy, 	"Error getting sv_allowcslua\n");
		return true;
	}
	
	
	sv_allowcslua->m_nFlags 		= FCVAR_NONE;
	sv_allowcslua->SetValue(1);
	
	ConColorMsg(Green, 	"[Totally");
	ConColorMsg(Red, 	"Not");
	ConColorMsg(Green, 	"ABypass] ");
	ConColorMsg(Blue, 	"sv_allowcslua bypass'd :D\n");
	
	Sleep(100);
	return true;
}



int __stdcall DllMain(HINSTANCE ThisDLL, DWORD reason, void* lol) {
	if (reason == DLL_PROCESS_ATTACH) {
		DisableThreadLibraryCalls(ThisDLL);
		
		EvilThreadHandle = CreateThread(NULL, NULL, &EvilThread, NULL, NULL, NULL);
	}
	
	return 1;
}





















