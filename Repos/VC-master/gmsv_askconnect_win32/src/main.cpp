/*
	Thabks Willox :)
*/

#include "GarrysMod/Lua/Interface.h"
#include "eiface.h"
#include "plugin.h"

using namespace GarrysMod;

IVEngineServer *server;
IServerPluginHelpers *helpers;

const int GetEntIndex(lua_State *state, int i) {
	LUA->CheckType(i, Lua::Type::ENTITY);

	LUA->GetField(i, "EntIndex");
	LUA->Push(i);
	LUA->Call(1, 1);

	const int ent_index = LUA->CheckNumber(-1);

	LUA->Pop();

	return ent_index;
}

int AskConnect(lua_State *state) {
	const int ent_index = GetEntIndex(state, 1);
	const char *address = LUA->CheckString(2);

	edict_t *pEntity = server->PEntityOfEntIndex(ent_index);
	
	KeyValues *kv = new KeyValues("");
	kv->SetFloat("time", 60);
	kv->SetString("title", address);

	helpers->CreateMessage(pEntity, DIALOG_ASKCONNECT, kv, &g_EmptyServerPlugin);

	return 0;
}

GMOD_MODULE_OPEN() {
	CreateInterfaceFn interfaceFactory = Sys_GetFactory("engine.dll");

	server = (IVEngineServer *)interfaceFactory(INTERFACEVERSION_VENGINESERVER, 0);
	helpers = (IServerPluginHelpers *)interfaceFactory(INTERFACEVERSION_ISERVERPLUGINHELPERS, 0);

	LUA->CreateMetaTableType("Player", Lua::Type::ENTITY);
		LUA->PushCFunction(AskConnect);
		LUA->SetField(-2, "AskConnect");
	LUA->Pop();
	
	return 0;
}

GMOD_MODULE_CLOSE() {
	return 0;
}