#include "ILuaModuleManager.h"

void ILuaModuleManager::CreateInterface(lua_State* state)
{
	map_States[state] = new ILuaInterface(state);
}

void ILuaModuleManager::DestroyInterface(lua_State* state)
{
	ILuaInterface* gLua = GetLuaInterface(state);
	map_States.erase(state);
	delete gLua;
}

ILuaInterface* ILuaModuleManager::GetLuaInterface(lua_State* state)
{
	return map_States[state];
}

ILuaModuleManager* modulemanager = new ILuaModuleManager();