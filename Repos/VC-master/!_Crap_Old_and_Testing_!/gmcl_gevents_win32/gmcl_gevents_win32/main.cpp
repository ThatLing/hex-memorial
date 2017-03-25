

#undef _UNICODE
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")

#include <ILuaModuleManager.h>
#include <igameevents.h>
#include <string>

#define GEVENTS_NAME "IGameEvent"
#define GEVENTS_TYPE 125


ILuaInterface *cl_Lua = NULL;
IGameEventManager2 *gameeventmanager = NULL;

class CGameEventListener : public IGameEventListener2
{
	public:
		~CGameEventListener() { gameeventmanager->RemoveListener(this); };
		
		void FireGameEvent( IGameEvent *event )
		{
			cl_Lua->Push(cl_Lua->GetGlobal("hook")->GetMember("Call"));
			cl_Lua->Push(event->GetName());
			cl_Lua->PushNil();
			cl_Lua->PushUserData(cl_Lua->GetMetaTable(GEVENTS_NAME, GEVENTS_TYPE), event, GEVENTS_TYPE);
			
			cl_Lua->Call(3, 0);
		};
};


CGameEventListener CEventListener;

LUA_FUNCTION(Create)
{
	cl_Lua->CheckType(1, GLua::TYPE_STRING);

	IGameEvent *event = gameeventmanager->CreateEvent(cl_Lua->GetString(1));

	if (event)
		cl_Lua->PushUserData(cl_Lua->GetMetaTable(GEVENTS_NAME, GEVENTS_TYPE), event, GEVENTS_TYPE);
	else
		cl_Lua->PushNil();

	return 1;
}

LUA_FUNCTION(Name)
{
	cl_Lua->CheckType(1, GEVENTS_TYPE);

	IGameEvent *event = (IGameEvent*)cl_Lua->GetUserData(1);

	if (event)
		cl_Lua->Push(event->GetName());
	else
		cl_Lua->PushNil();

	return 1;
}

LUA_FUNCTION(Fire)
{
	cl_Lua->CheckType(1, GEVENTS_TYPE);

	IGameEvent *event = (IGameEvent*)cl_Lua->GetUserData(1);

	if (event)
		gameeventmanager->FireEvent(event);

	return 0;
}

LUA_FUNCTION(FireClientSide)
{
	cl_Lua->CheckType(1, GEVENTS_TYPE);

	IGameEvent *event = (IGameEvent*)cl_Lua->GetUserData(1);

	if (event)
		gameeventmanager->FireEventClientSide(event);
		
	return 0;
}

LUA_FUNCTION(GetBool)
{
	cl_Lua->CheckType(1, GEVENTS_TYPE);
	cl_Lua->CheckType(2, GLua::TYPE_STRING);
	
	IGameEvent *event = (IGameEvent*)cl_Lua->GetUserData(1);

	if (event)
		cl_Lua->Push(event->GetBool(cl_Lua->GetString(2)));
	else
		cl_Lua->PushNil();

	return 1;
}

LUA_FUNCTION(SetBool)
{
	cl_Lua->CheckType(1, GEVENTS_TYPE);
	cl_Lua->CheckType(2, GLua::TYPE_STRING);
	cl_Lua->CheckType(3, GLua::TYPE_BOOL);

	IGameEvent *event = (IGameEvent*)cl_Lua->GetUserData(1);

	if (event)
		event->SetBool(cl_Lua->GetString(2), cl_Lua->GetBool(3));

	return 0;
}

LUA_FUNCTION(GetString)
{
	cl_Lua->CheckType(1, GEVENTS_TYPE);
	cl_Lua->CheckType(2, GLua::TYPE_STRING);
	
	IGameEvent *event = (IGameEvent*)cl_Lua->GetUserData(1);

	if (event)
		cl_Lua->Push(event->GetString(cl_Lua->GetString(2)));
	else
		cl_Lua->PushNil();

	return 1;
}

LUA_FUNCTION(SetString)
{
	cl_Lua->CheckType(1, GEVENTS_TYPE);
	cl_Lua->CheckType(2, GLua::TYPE_STRING);
	cl_Lua->CheckType(3, GLua::TYPE_STRING);

	IGameEvent *event = (IGameEvent*)cl_Lua->GetUserData(1);

	if (event)
		event->SetString(cl_Lua->GetString(2), cl_Lua->GetString(3));

	return 0;
}

LUA_FUNCTION(GetInt)
{
	cl_Lua->CheckType(1, GEVENTS_TYPE);
	cl_Lua->CheckType(2, GLua::TYPE_STRING);
	
	IGameEvent *event = (IGameEvent*)cl_Lua->GetUserData(1);

	if (event)
		cl_Lua->Push( (float)event->GetInt(cl_Lua->GetString(2)) );
	else
		cl_Lua->PushNil();

	return 1;
}

LUA_FUNCTION(SetInt)
{
	cl_Lua->CheckType(1, GEVENTS_TYPE);
	cl_Lua->CheckType(2, GLua::TYPE_STRING);
	cl_Lua->CheckType(3, GLua::TYPE_NUMBER);

	IGameEvent *event = (IGameEvent*)cl_Lua->GetUserData(1);

	if (event)
		event->SetInt(cl_Lua->GetString(2), cl_Lua->GetInteger(3));

	return 0;
}

LUA_FUNCTION(GetFloat)
{
	cl_Lua->CheckType(1, GEVENTS_TYPE);
	cl_Lua->CheckType(2, GLua::TYPE_STRING);
	
	IGameEvent *event = (IGameEvent*)cl_Lua->GetUserData(1);

	if (event)
		cl_Lua->Push(event->GetFloat(cl_Lua->GetString(2)));
	else
		cl_Lua->PushNil();
	
	return 1;
}

LUA_FUNCTION(SetFloat)
{
	cl_Lua->CheckType(1, GEVENTS_TYPE);
	cl_Lua->CheckType(2, GLua::TYPE_STRING);
	cl_Lua->CheckType(3, GLua::TYPE_NUMBER);

	IGameEvent *event = (IGameEvent*)cl_Lua->GetUserData(1);

	if (event)
		event->SetFloat(cl_Lua->GetString(2), cl_Lua->GetNumber(3));

	return 0;
}

LUA_FUNCTION(InitHook)
{
	cl_Lua->CheckType(1, GLua::TYPE_STRING);

	if (! gameeventmanager->FindListener(&CEventListener, cl_Lua->GetString(1)))
		//gameeventmanager->AddListener(&CEventListener, cl_Lua->GetString(1), cl_Lua->IsServer());
		gameeventmanager->AddListener(&CEventListener, cl_Lua->GetString(1), false);
	
	return 0;
}



GMOD_MODULE(Open, Close);


int Open(lua_State* L) {
	cl_Lua = Lua();
	
	CreateInterfaceFn engineI = Sys_GetFactory("engine.dll");
	gameeventmanager = (IGameEventManager2*)engineI(INTERFACEVERSION_GAMEEVENTSMANAGER2, NULL);
	
	ILuaObject *mevents = cl_Lua->GetMetaTable(GEVENTS_NAME, GEVENTS_TYPE);
		ILuaObject *__index = cl_Lua->GetNewTable();
			__index->SetMember("Name", Name);
			__index->SetMember("Fire", Fire);
			__index->SetMember("FireClientSide", FireClientSide);

			__index->SetMember("GetBool", GetBool);
			__index->SetMember("SetBool", SetBool);
			__index->SetMember("GetString", GetString);
			__index->SetMember("SetString", SetString);
			__index->SetMember("GetInt", GetInt);
			__index->SetMember("SetInt", SetInt);
			__index->SetMember("GetFloat", GetFloat);
			__index->SetMember("SetFloat", SetFloat);

			mevents->SetMember("__index", __index);
		__index->UnReference();
	mevents->UnReference();
	
	cl_Lua->NewGlobalTable("gevent");
	
	ILuaObject *gameeventsT = cl_Lua->GetGlobal("gevent");
		gameeventsT->SetMember("Create", Create);
		gameeventsT->SetMember("InitHook", InitHook);
	gameeventsT->UnReference();
	
	return 0;
}

int Close(lua_State* L) {
	return 0;
}

