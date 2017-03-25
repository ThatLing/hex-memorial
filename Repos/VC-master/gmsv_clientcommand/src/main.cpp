/*
	Thanks Willox, without whom, tens of cheaters would still have their marbles.
*/

#include "GarrysMod/Lua/Interface.h"
#include "eiface.h"

using namespace GarrysMod;

IVEngineServer *server;

const int GetEntIndex(lua_State *state, int i) {
	LUA->CheckType(i, Lua::Type::ENTITY);

	LUA->GetField(i, "EntIndex");
	LUA->Push(i);
	LUA->Call(1, 1);

	const int ent_index = LUA->CheckNumber(-1);

	LUA->Pop();

	return ent_index;
}

int ClientCommand(lua_State *state) {
	const int ent_index = GetEntIndex(state, 1);
	const char *command = LUA->CheckString(2);

	edict_t *pEntity = server->PEntityOfEntIndex(ent_index);
	
	server->ClientCommand(pEntity, "%s", command);

	return 0;
}

GMOD_MODULE_OPEN() {
	CreateInterfaceFn interfaceFactory = Sys_GetFactory("engine.dll");

	server = (IVEngineServer *)interfaceFactory(INTERFACEVERSION_VENGINESERVER, 0);

	LUA->CreateMetaTableType("Player", Lua::Type::ENTITY);
		LUA->PushCFunction(ClientCommand);
		LUA->SetField(-2, "ClientCommand");
	LUA->Pop();
	
	return 0;
}

GMOD_MODULE_CLOSE() {
	return 0;
}