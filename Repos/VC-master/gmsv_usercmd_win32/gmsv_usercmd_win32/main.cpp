
#undef _UNICODE
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment(lib, "vstdlib.lib")
#pragma comment(lib, "tier0.lib")
#pragma comment(lib, "tier1.lib")

#include <ILuaModuleManager.h>

#include "interface.h"
#include "eiface.h"

#include <windows.h>

#include "tier1.h"
#include "tier0/memdbgon.h"

ILuaInterface* sv_Lua = NULL;

//Thanks Leystryku
class CUserCmd
{
public:
	int header;
	int command_number;
	int tick_count;
	QAngle viewangles;
	float forwardmove;
	float sidemove;
	float upmove;
	int buttons;
	byte impulse;
	int weaponselect;
	int weaponsubtype;
	int random_seed;
	short mousex;
	short mousey;
	bool hasbeenpredicted;
	char padding[284];
};



LUA_FUNCTION(random_seed) {
	sv_Lua->CheckType(1, GLua::TYPE_USERCMD);
	
	CUserCmd* cmd = (CUserCmd*)sv_Lua->GetUserData(1);
	
	if (!cmd) {
		return 0;
	}
	
	sv_Lua->Push( cmd->random_seed );
	return 1;
}


LUA_FUNCTION(hasbeenpredicted) {
	sv_Lua->CheckType(1, GLua::TYPE_USERCMD);
	
	CUserCmd* cmd = (CUserCmd*)sv_Lua->GetUserData(1);
	if (!cmd) {
		return 0;
	}
	
	sv_Lua->Push( cmd->hasbeenpredicted );
	return 1;
}


LUA_FUNCTION(tick_count) {
	sv_Lua->CheckType(1, GLua::TYPE_USERCMD);
	
	CUserCmd* cmd = (CUserCmd*)sv_Lua->GetUserData(1);
	if (!cmd) {
		return 0;
	}
	
	sv_Lua->Push( cmd->tick_count );
	return 1;
}


LUA_FUNCTION(viewangles) {
	sv_Lua->CheckType(1, GLua::TYPE_USERCMD);
	
	CUserCmd* cmd = (CUserCmd*)sv_Lua->GetUserData(1);
	if (!cmd) {
		return 0;
	}
	
	
	QAngle This = cmd->viewangles;
	
	sv_Lua->Push( This.x );
	sv_Lua->Push( This.y );
	sv_Lua->Push( This.z );
	return 3;
}






GMOD_MODULE(Open, Close)

int Open(lua_State *L) {
	sv_Lua = Lua();
	
	sv_Lua->NewGlobalTable("usercmd");
	ILuaObject* usercmd = sv_Lua->GetGlobal("usercmd");
		usercmd->SetMember("random_seed", 		random_seed);
		usercmd->SetMember("hasbeenpredicted",	hasbeenpredicted);
		usercmd->SetMember("tick_count",		tick_count);
		usercmd->SetMember("viewangles",		viewangles);
	usercmd->UnReference();
	
	return 0;
}

int Close(lua_State *L) {
	return 0;
}




























