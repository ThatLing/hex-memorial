

#include "GMLuaModule.h"

#include <stdlib.h>

GMOD_MODULE( Open, Close );

LUA_FUNCTION( cmd_exec )
{
	Lua()->CheckType( 1, GLua::TYPE_STRING );

	Lua()->PushLong( system( Lua()->GetString( 1 ) ) );

	return 0;
}

int Open( lua_State *L )
{
	Lua()->NewGlobalTable( "cmd" );

	ILuaObject *cmdTable = Lua()->GetGlobal( "cmd" );
	
	cmdTable->SetMember( "exec", cmd_exec );

	cmdTable->UnReference();

	return 0;
}

int Close( lua_State *L )
{
	return 0;
}
