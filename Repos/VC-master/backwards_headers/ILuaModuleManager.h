#ifndef ILUAMODULEMANAGER_H
#define ILUAMODULEMANAGER_H

#include "Interface.h"
#include "ILuaInterface.h"
#include <map>

class ILuaModuleManager
{
public:
	void			CreateInterface( lua_State* state );
	void			DestroyInterface( lua_State* state );
	ILuaInterface*	GetLuaInterface( lua_State* state );

private:
	std::map<lua_State*, ILuaInterface*> map_States;
};

extern ILuaModuleManager* modulemanager;

#define GMOD_MODULE( _startfunction_, _closefunction_ ) \
	int _startfunction_( lua_State* L );\
	int _closefunction_( lua_State* L );\
	DLL_EXPORT int gmod13_open( lua_State* L ) \
	{ \
		modulemanager->CreateInterface(L);\
		return _startfunction_(L);\
	} \
	DLL_EXPORT int gmod13_close( lua_State* L ) \
	{ \
		int ret = _closefunction_(L);\
		modulemanager->DestroyInterface(L);\
		return ret;\
	} \

#define LUA_FUNCTION( _function_ ) int _function_( lua_State* L ) // Compatablity, also I find it neater

#define Lua() modulemanager->GetLuaInterface( L )

#endif