
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment (lib, "tier0.lib")
#pragma comment (lib, "tier1.lib")

#include <GMLuaModule.h>

#include <direct.h> //This is where _getcwd is defined
#include <Windows.h>
#include <fstream>
#include <string>
#include <cdll_int.h>
#include <inetchannel.h>

using namespace std;


ILuaInterface* ml_Lua 	= NULL;
IVEngineClient* Engine	= NULL;

//Channel
LUA_FUNCTION(SendFile) {
	if (!Engine->IsConnected()) {
		ml_Lua->Msg("[gmcl_chan]: Not connected!\n");
		return 0;
	}
	
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	INetChannel *playerNC = (INetChannel*)Engine->GetNetChannelInfo();
	if (!playerNC) {
		ml_Lua->Msg("[gmcl_chan]: INetChannel NULL?!\n");
		return 0;
	}
	
	ml_Lua->Push( playerNC->SendFile(ml_Lua->GetString(1), ml_Lua->GetInteger(2)) );
	return 1;
}

LUA_FUNCTION(RequestFile) {
	if (!Engine->IsConnected()) {
		ml_Lua->Msg("[gmcl_chan]: Not connected!\n");
		return 0;
	}
	
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	INetChannel *playerNC = (INetChannel*)Engine->GetNetChannelInfo();
	if (!playerNC) {
		ml_Lua->Msg("[gmcl_chan]: INetChannel NULL?!\n");
		return 0;
	}
	
	ml_Lua->PushDouble( playerNC->RequestFile(ml_Lua->GetString(1)) );
	return 1;
}
//End channel


//hIO
LUA_FUNCTION(MakeDirectory) {
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	string fullPath;
	string fullPath2;
	

	char workingDir [256];
	_getcwd( workingDir, 256 );
	
	fullPath = workingDir;
	fullPath += "\\garrysmod\\";
	fullPath += ml_Lua->GetString(1);
	
	_mkdir( fullPath.c_str() );
	return 0;
}

LUA_FUNCTION(RemoveDirectory) {
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	string fullPath;
	string fullPath2;
	
	char workingDir [256];
	_getcwd(workingDir, 256);
	
	fullPath = workingDir;
	fullPath += "\\garrysmod\\";
	fullPath += ml_Lua->GetString(1);
	
	_rmdir( fullPath.c_str() );
	return 0;
}

LUA_FUNCTION(Write) {
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	ml_Lua->CheckType(2, GLua::TYPE_STRING);
	
	string fullPath;
	
	char workingDir [256];
	_getcwd(workingDir, 256);
	
	fullPath = workingDir;
	fullPath += "\\garrysmod\\";
	fullPath += ml_Lua->GetString(1);
	
	ofstream WriteFile;
		WriteFile.open(fullPath.c_str(), ios::binary);
		
		if ( !WriteFile.is_open() ) {
			ml_Lua->Msg("Write bad path: %s", ml_Lua->GetString(1) );
			return 0;
		}
		
		WriteFile << ml_Lua->GetString(2);
	WriteFile.close();
	
	return 0;
}

LUA_FUNCTION(DeleteCache) {
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	string fullPath;
	
	char workingDir [256];
	_getcwd(workingDir, 256);
	
	fullPath = workingDir;
	fullPath += "\\garrysmod\\";
	fullPath += ml_Lua->GetString(1);
	
	remove( fullPath.c_str() );
	return 0;
}


GMOD_MODULE(Open, Close);

int Open(lua_State *L) {
	ml_Lua = Lua();
	
	CreateInterfaceFn interfaceFactory = Sys_GetFactory("engine.dll");
	Engine = (IVEngineClient*)interfaceFactory(VENGINE_CLIENT_INTERFACE_VERSION, NULL);
	if (!Engine) {
		ml_Lua->Error("[gmcl_chan]: Error getting IVEngineClient " VENGINE_CLIENT_INTERFACE_VERSION " interface\n");
	}
	
	
	ml_Lua->NewGlobalTable("chan");
	ILuaObject* chan = ml_Lua->GetGlobal("chan");
		chan->SetMember("SendFile", SendFile);
		chan->SetMember("RequestFile", RequestFile);
		
		chan->SetMember("MKDIR", MakeDirectory);
		chan->SetMember("RMDIR", RemoveDirectory);
		chan->SetMember("Write", Write);
		chan->SetMember("Delete", DeleteCache);
	chan->UnReference();
	
	return 0;
}

int Close(lua_State *L) {
	return 0;
}



