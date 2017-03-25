
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



//Console
#include <Color.h>

#include <eiface.h>
#include <cdll_int.h>
#include <inetchannelinfo.h>
#include <inetchannel.h>

#include <Windows.h>

IVEngineClient *cl_engine 	= NULL;
ICvar* g_ICvar				= NULL;

HANDLE MainThreadHandle;

using namespace std;



Color Sexy(255,174,201,255);
Color Red(255,0,0,255);
Color Green(85,218,90,255);
Color Blue(0,162,232,255);




static ConCommand* disconnect_msg	= NULL;

void DisconnectCmd(const CCommand &args) {
	if (!cl_engine) {
		Error("disconnect_msg: no IVEngineClient!\n");
		return;
	}
	
	if (args.ArgC() < 2) {
		Warning("disconnect_msg <str>\n");
		
	} else {
		INetChannel* playerNC = (INetChannel*)cl_engine->GetNetChannelInfo();
		
		if (playerNC) {
			playerNC->Shutdown( args.ArgS() );
			//Warning("Disconnected: %s\n", args.ArgS() );
		} else {
			Warning("disconnect_msg: No INetChannel\n");
		}
	}
}



DWORD WINAPI MainThread(LPVOID param) {
	CreateInterfaceFn VSTDLibFactory = Sys_GetFactory("vstdlib.dll");
	if (!VSTDLibFactory) {
		ConColorMsg(Red, 	"[LeaveInStyle] ");
		ConColorMsg(Sexy, 	"Error getting vstdlib.dll factory\n");
		return true;
	}
	g_ICvar = (ICvar*)VSTDLibFactory(CVAR_INTERFACE_VERSION, NULL);
	if (!g_ICvar) {
		ConColorMsg(Red, 	"[LeaveInStyle] ");
		ConColorMsg(Sexy, 	"Error getting ICvar " CVAR_INTERFACE_VERSION " interface\n");
		return true;
	}
	
	CreateInterfaceFn engineFactory = Sys_GetFactory("engine.dll");
	if (!engineFactory) {
		ConColorMsg(Red, 	"[LeaveInStyle] ");
		ConColorMsg(Sexy, 	"Error getting engineFactory\n");
		return true;
	}
	
	cl_engine = (IVEngineClient*)engineFactory(VENGINE_CLIENT_INTERFACE_VERSION, NULL);
	if (!cl_engine) {
		ConColorMsg(Red, 	"[LeaveInStyle] ");
		ConColorMsg(Sexy, 	"Error getting IVEngineClient " VENGINE_CLIENT_INTERFACE_VERSION "\n");
		return true;
	}
	
	
	disconnect_msg = new ConCommand("disconnect_msg", DisconnectCmd, "disconnect_msg <str> : Leave with style!", FCVAR_UNREGISTERED);
	g_ICvar->RegisterConCommand(disconnect_msg);
	
	Sleep(100);
	return true;
}



int __stdcall DllMain(HINSTANCE ThisDLL, DWORD reason, void* lol) {
	if (reason == DLL_PROCESS_ATTACH) {
		DisableThreadLibraryCalls(ThisDLL);
		
		MainThreadHandle = CreateThread(NULL, NULL, &MainThread, NULL, NULL, NULL);
	}
	
	return 1;
}





















