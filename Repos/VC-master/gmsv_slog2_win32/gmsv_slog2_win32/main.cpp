/*
	=== gmsv_slog2_win32 ===
	*Hook all concommands*
*/


#undef _UNICODE
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")

#include <ILuaModuleManager.h>
#include <string>


#include "iclient_new.h"
#include <eiface.h>

#include <cdll_int.h>
#include <inetchannelinfo.h>
#include <inetchannel.h>

#include <windows.h>
#include <vfnhook.h>
#include <tier1.h>


ILuaInterface*	sv_Lua 		= NULL;
IVEngineServer*	sv_engine 	= NULL;
IClient* 		g_Client 	= NULL;
bool 			Hooked 		= false;



//FILE


//Requested
DEFVFUNC_( origFileRequested, void, (IClient* handler, const char* fileName, unsigned int transferID) );

void VFUNC newFileRequested(IClient* handler, const char* fileName, unsigned int transferID) {
	bool Block = false;
	
	ILuaObject* hook = sv_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
			sv_Lua->Push(hookCall);
			sv_Lua->Push("FileRequested");
				sv_Lua->PushNil();
				sv_Lua->Push(fileName);
				sv_Lua->Push( handler->GetNetworkIDString() );
			sv_Lua->Call(4,1);
			
			ILuaObject* Ret = sv_Lua->GetReturn(0);
				if (Ret && Ret->GetBool()) {
					Block = true;
				}
			Ret->UnReference();
		hookCall->UnReference();
	hook->UnReference();
	
	if (Block) {
		//Warning("! FileRequested, blocked: %s\n", fileName);
		return;
	}
	
	return origFileRequested(handler,fileName,transferID);
}


//Received
DEFVFUNC_( origFileReceived, void, (IClient* handler, const char* fileName, unsigned int transferID) );

void VFUNC newFileReceived(IClient* handler, const char* fileName, unsigned int transferID) {
	ILuaObject* hook = sv_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
			sv_Lua->Push(hookCall);
			sv_Lua->Push("FileReceived");
				sv_Lua->PushNil();
				sv_Lua->Push(fileName);
				sv_Lua->Push( handler->GetNetworkIDString() );
			sv_Lua->Call(4,0);
		hookCall->UnReference();
	hook->UnReference();
	
	return origFileReceived(handler,fileName,transferID);
}




//Execute String Command
DEFVFUNC_( origExecuteStringCommand, bool, (IClient* pClient, const char* cmd) );

bool VFUNC newExecuteStringCommand(IClient* pClient, const char* cmd) {
	bool Block = false;
	
	ILuaObject* hook = sv_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
			sv_Lua->Push(hookCall);
			sv_Lua->Push("ExecuteStringCommand");
				sv_Lua->PushNil();
				sv_Lua->Push(cmd);
				sv_Lua->Push( pClient->GetNetworkIDString() );
			sv_Lua->Call(4,1);
			
			ILuaObject* Ret = sv_Lua->GetReturn(0);
				if (Ret && Ret->GetBool()) {
					Block = true;
				}
			Ret->UnReference();
		hookCall->UnReference();
	hook->UnReference();
	
	if (Block) {
		return true;
	}
	
	return origExecuteStringCommand(pClient,cmd);
}



LUA_FUNCTION(AddHook) {
	if (Hooked) {
		sv_Lua->Push(false);
		sv_Lua->Push("DOUBLE HOOK");
		return 2;
	}
	
	
	sv_Lua->CheckType(1, GLua::TYPE_NUMBER);
	
	INetChannelInfo* pNetInfo = sv_engine->GetPlayerNetInfo( sv_Lua->GetNumber(1) );
	if (!pNetInfo) {
		sv_Lua->Push(false);
		sv_Lua->Push("No INetChannelInfo");
		return 2;
	}
	
	INetChannel* pNetChan = static_cast<INetChannel*>(pNetInfo);
	if (!pNetChan) {
		sv_Lua->Push(false);
		sv_Lua->Push("No INetChannel");
		return 2;
	}
	
	INetChannelHandler* pNetHandle = pNetChan->GetMsgHandler();
	if (!pNetHandle) {
		sv_Lua->Push(false);
		sv_Lua->Push("No INetChannelHandler");
		return 2;
	}
	
	IClient* pClient = static_cast<IClient*>(pNetHandle);
	if (!pClient) {
		sv_Lua->Push(false);
		sv_Lua->Push("No IClient");
		return 2;
	}
	
	g_Client = pClient;
		HOOKVFUNC(pClient, 6, origFileRequested, newFileRequested);
		HOOKVFUNC(pClient, 7, origFileReceived,	newFileReceived);
		
		HOOKVFUNC(pClient, 28, origExecuteStringCommand, newExecuteStringCommand);
	Hooked = true;
	
	sv_Lua->Push(true);
	return 1;
}







void RemoveHook() {
	if (g_Client) {
		UNHOOKVFUNC(g_Client, 6, origFileRequested);
		UNHOOKVFUNC(g_Client, 7, origFileReceived);
		
		UNHOOKVFUNC(g_Client, 28, origExecuteStringCommand);
		
		Hooked		= false;
		g_Client	= NULL;
	}
}

LUA_FUNCTION(Remove) {
	RemoveHook();
	
	return 0;
}



GMOD_MODULE(Open,Close);

int Open(lua_State *L) {
	sv_Lua = Lua();
	
	CreateInterfaceFn engineFactory = Sys_GetFactory("engine.dll");
	if (!engineFactory) {
		sv_Lua->ErrorNoHalt("[slog2]: Can't get engineFactory :(\n");
		return 0;
	}
	
	sv_engine = (IVEngineServer*)engineFactory(INTERFACEVERSION_VENGINESERVER, NULL);
	if (!sv_engine) {
		sv_Lua->ErrorNoHalt("[slog2]: Can't get IVEngineServer " INTERFACEVERSION_VENGINESERVER " :(\n");
		return 0;
	}
	
	
	sv_Lua->NewGlobalTable("slog2");
	ILuaObject* slog2 = sv_Lua->GetGlobal("slog2");
		slog2->SetMember("Add", 	AddHook);
		slog2->SetMember("Remove",	Remove);
	slog2->UnReference();
	
	return 0;
}


int Close(lua_State *L) {
	RemoveHook();
	
	return 0;
}









