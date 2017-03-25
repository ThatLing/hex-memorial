/*
	=== gmsv_hideip ===
	*Hide the player_connect IP*
	
	Credits:
		. Python (iphax)
		. Chrisaster (gm_gevents)
		. HeX
*/

#undef _UNICODE
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")

#include <ILuaModuleManager.h>
#include <igameevents.h>
#include <string>

ILuaInterface	 	*sv_Lua = NULL;
IGameEventManager2	*Event  = NULL;

class CGameEventListener : public IGameEventListener2 {
	public: ~CGameEventListener() {
		Event->RemoveListener(this);
	};
	
	void FireGameEvent( IGameEvent* evt ) {
		 if ( strcmp(evt->GetName(), "player_connect") == 0 ) {
			ILuaObject* hook = sv_Lua->GetGlobal("hook");
				ILuaObject* hookCall = hook->GetMember("Call");
					sv_Lua->Push(hookCall);
					sv_Lua->Push("HideIP");
					sv_Lua->PushNil();
					sv_Lua->Push( evt->GetString("name") );
					sv_Lua->Push( (float)evt->GetInt("index") );
					sv_Lua->Push( (float)evt->GetInt("userid") );
					sv_Lua->Push( evt->GetString("networkid") );
					sv_Lua->Push( evt->GetString("address") );
					sv_Lua->Call(7,1);
					
					ILuaObject* ret = sv_Lua->GetReturn(0);
						if (ret->GetType() == GLua::TYPE_STRING) {
							evt->SetString("address", ret->GetString() );
						}
					ret->UnReference();
					
				hookCall->UnReference();
			hook->UnReference();
		}
	};
};

CGameEventListener CEventListener;



GMOD_MODULE(Open,Close);

int Open(lua_State *L) {
	sv_Lua = Lua();
	
	CreateInterfaceFn Engine = Sys_GetFactory("engine.dll");
	Event = (IGameEventManager2*)Engine(INTERFACEVERSION_GAMEEVENTSMANAGER2, NULL);
	
	if (!Event) {
		sv_Lua->Error("[gmsv_hideip]: Can't get Event " INTERFACEVERSION_GAMEEVENTSMANAGER2 " interface :(\n");
		return 0;
	}
	
	Event->AddListener(&CEventListener, "player_connect", true);
	
	return 0;
}


int Close(lua_State *L) {
	return 0;
}

