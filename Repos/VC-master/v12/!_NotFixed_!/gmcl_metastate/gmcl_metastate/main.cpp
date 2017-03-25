
#define _RETAIL 1
#define _WIN32 1
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN

#define LUAINTERFACE_META_ID 5450
#define LUAINTERFACE_META_NAME "LuaInterface"

#define CLIENT_STATE 0
#define SERVER_STATE 1
#define MENU_STATE 2


#include <GMLuaModule.h>
#include <CStateManager.h>
#include <vfnhook.h>

#include <winlite.h>
#include <cdll_int.h>

#undef GetObject
ILuaShared *lua_shared = NULL;


DEFVFUNC_(RunStringReal, bool, (ILuaInterface* liface, const char* filename, const char* path, const char* lua, bool run, bool showErrors));
DEFVFUNC_(CreateLuaInterfaceReal, void, ( ILuaCallback * a,unsigned char b ));
DEFVFUNC_(CloseLuaInterfaceReal, void, ( ILuaInterface *a ));
DEFVFUNC_(GetLuaInterfaceReal, ILuaInterface*, ( unsigned char *a ));


LUA_FUNCTION( HasInterfaceLoaded )
{
	//Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	if ( lua_shared->GetLuaInterface( 0 ) )
		Lua()->Push( true );
	else
		Lua()->Push( false );

	return 1;
}

LUA_FUNCTION( GetLuaInterface )
{
	//Lua()->CheckType( 1, GLua::TYPE_NUMBER );

	ILuaInterface *pLuaInterface = lua_shared->GetLuaInterface( 0 );

	if ( !pLuaInterface )
		return 0;

	ILuaObject *pLuaInterfaceMT = Lua()->GetMetaTable( LUAINTERFACE_META_NAME, LUAINTERFACE_META_ID );

	Lua()->PushUserData( pLuaInterfaceMT, pLuaInterface );

	pLuaInterfaceMT->UnReference();

	return 1;
}

LUA_FUNCTION( LuaInterface_FreeReference )
{
	Lua()->CheckType( 1, LUAINTERFACE_META_ID );
	Lua()->CheckType( 2, GLua::TYPE_NUMBER );

	ILuaInterface *pLuaInterface = (ILuaInterface *)Lua()->GetUserData( 1 );
	
	if ( !pLuaInterface )
		return 0;

	pLuaInterface->FreeReference( Lua()->GetInteger( 2 ) );

	return 0;
}

LUA_FUNCTION( LuaInterface_GetGlobalReference )
{
	Lua()->CheckType( 1, LUAINTERFACE_META_ID );
	Lua()->CheckType( 2, GLua::TYPE_STRING );

	ILuaInterface *pLuaInterface = (ILuaInterface *)Lua()->GetUserData( 1 );
	
	if ( !pLuaInterface )
		return 0;

	ILuaObject *pLuaObject = pLuaInterface->GetGlobal( Lua()->GetString( 2 ) );

	if ( !pLuaObject )
		return 0;

	pLuaObject->Push();

	int iRef = pLuaInterface->GetReference( -1, true );

	pLuaObject->UnReference();

	Lua()->PushLong( iRef );

	return 1;
}

LUA_FUNCTION( LuaInterface_CallReference )
{
	Lua()->CheckType( 1, LUAINTERFACE_META_ID );
	Lua()->CheckType( 2, GLua::TYPE_NUMBER );
	Lua()->CheckType( 3, GLua::TYPE_NUMBER );

	ILuaInterface *pLuaInterface = (ILuaInterface *)Lua()->GetUserData( 1 );
	
	if ( !pLuaInterface )
		return 0;

	if ( pLuaInterface == Lua() )
		return 0;

	pLuaInterface->PushReference( Lua()->GetInteger( 2 ) );

	for ( int i = 4; i <= Lua()->GetStackTop(); i++ )
	{
		ILuaObject *pArgObject = Lua()->GetObject( i );

		switch ( pArgObject->GetType() )
		{
			case GLua::TYPE_STRING:
				pLuaInterface->Push( pArgObject->GetString() );
				break;
			case GLua::TYPE_BOOL:
				pLuaInterface->Push( pArgObject->GetBool() );
				break;
			case GLua::TYPE_NUMBER:
				pLuaInterface->Push( (float)pArgObject->GetFloat() );
				break;
		}

		pArgObject->UnReference();
	}

	Lua()->Push( pLuaInterface->Call( Lua()->GetStackTop() - 3, Lua()->GetInteger( 3 ) ) );

	return 1;
}

LUA_FUNCTION( LuaInterface_RunString )
{
	Lua()->CheckType( 1, LUAINTERFACE_META_ID );
	Lua()->CheckType( 2, GLua::TYPE_STRING );
	Lua()->CheckType( 3, GLua::TYPE_STRING );
	Lua()->CheckType( 4, GLua::TYPE_STRING );
	Lua()->CheckType( 5, GLua::TYPE_BOOL );
	Lua()->CheckType( 6, GLua::TYPE_BOOL );

	ILuaInterface *pLuaInterface = (ILuaInterface *)Lua()->GetUserData( 1 );
	
	if ( !pLuaInterface )
		return 0;

	bool ret = pLuaInterface->RunString( Lua()->GetString( 2 ), Lua()->GetString( 3 ), Lua()->GetString( 4 ), Lua()->GetBool( 5 ), Lua()->GetBool( 6 ) );
	Lua()->Push( ret );

	return 1;
}

LUA_FUNCTION( LuaInterface_FmtMsg )
{
	Lua()->CheckType( 1, LUAINTERFACE_META_ID );
	Lua()->CheckType( 2, GLua::TYPE_STRING );
	Lua()->CheckType( 3, GLua::TYPE_STRING );

	ILuaInterface *pLuaInterface = (ILuaInterface *)Lua()->GetUserData( 1 );
	
	if ( !pLuaInterface )
		return 0;

	pLuaInterface->Msg( Lua()->GetString( 2 ), Lua()->GetString( 3 ) );
	return 0;
}

LUA_FUNCTION( LuaInterface_Include )
{
	Lua()->CheckType( 1, LUAINTERFACE_META_ID );
	Lua()->CheckType( 2, GLua::TYPE_STRING );
	Lua()->CheckType( 3, GLua::TYPE_BOOL );
	Lua()->CheckType( 4, GLua::TYPE_BOOL );

	ILuaInterface *pLuaInterface = (ILuaInterface *)Lua()->GetUserData( 1 );
	
	if ( !pLuaInterface )
		return 0;

	bool ret = pLuaInterface->FindAndRunScript( Lua()->GetString( 2 ), Lua()->GetBool( 3 ), Lua()->GetBool( 4 ) );
	Lua()->Push( ret );

	return 1;
}

LUA_FUNCTION( LuaInterface_Require )
{
	Lua()->CheckType( 1, LUAINTERFACE_META_ID );
	Lua()->CheckType( 2, GLua::TYPE_STRING );

	ILuaInterface *pLuaInterface = (ILuaInterface *)Lua()->GetUserData( 1 );
	
	if ( !pLuaInterface )
		return 0;

	bool ret = pLuaInterface->RunModule( Lua()->GetString( 2 ) );
	Lua()->Push( ret );

	return 1;
}

int VectorMetaRef = -1;

ILuaObject* NewVectorObject(lua_State* L, Vector& vec)
{
        if(VectorMetaRef == -1)
        {
                // @azuisleet Get a reference to the function to survive past 510 calls!
                ILuaObject *VectorMeta = Lua()->GetGlobal("Vector");
                        VectorMeta->Push();
                        VectorMetaRef = Lua()->GetReference(-1, true);
                VectorMeta->UnReference();
        }

        Lua()->PushReference(VectorMetaRef);
        
        if(Lua()->GetType(-1) != GLua::TYPE_FUNCTION)
        {
                Lua()->Push(Lua()->GetGlobal("Vector"));
        }

                Lua()->Push(vec.x);
                Lua()->Push(vec.y);
                Lua()->Push(vec.z);
        Lua()->Call(3, 1);

        return Lua()->GetReturn(0);
}

void GMOD_PushVector(lua_State* L, Vector& vec)
{
        ILuaObject* obj = NewVectorObject(L, vec);
                Lua()->Push(obj);
        obj->UnReference();
}

Vector& GMOD_GetVector(lua_State* L, int stackPos)
{
        return *reinterpret_cast<Vector*>(Lua()->GetUserData(stackPos));
}


bool VFUNC RunStringDetour(ILuaInterface* liface, const char* filename, const char* path, const char* lua, bool run, bool showErrors) {
	Msg( "FILENAME: %s\n", filename );
	Msg( "PATH: %s\n", path );
	return RunStringReal(liface, filename, path, lua, run, showErrors);
}

void VFUNC CreateLuaInterfaceDetour( ILuaCallback * a,unsigned char b ) {
	
	CreateLuaInterfaceReal( a, b );
}

void VFUNC CloseLuaInterfaceDetour( ILuaInterface *a ) {
	Msg( "SHUTDOWN2!!!!!!!!!!!!!!!\n" );
	return CloseLuaInterfaceReal( a );
}

ILuaInterface* VFUNC GetLuaInterfaceDetour( unsigned char *a ) {
	return GetLuaInterfaceReal( a );;
}

LUA_FUNCTION( LuaInterface_LoadHook ) {
	Lua()->CheckType( 1, LUAINTERFACE_META_ID );

	ILuaInterface *pLuaInterface = (ILuaInterface *)Lua()->GetUserData( 1 );
	
	if ( !pLuaInterface )
		return 0;

	HOOKVFUNC(pLuaInterface, 68, RunStringReal, RunStringDetour);

	return 0;
}

LUA_FUNCTION( LuaInterface_UnloadHook ) {
	Lua()->CheckType( 1, LUAINTERFACE_META_ID );

	ILuaInterface *pLuaInterface = (ILuaInterface *)Lua()->GetUserData( 1 );
	
	if ( !pLuaInterface )
		return 0;
	
	UNHOOKVFUNC(pLuaInterface, 68, RunStringReal);

	return 0;
}



GMOD_MODULE( Open, Close );

int Open(lua_State *L) {
	CreateInterfaceFn luaFactory = Sys_GetFactory("lua_shared.dll");
	lua_shared = (ILuaShared*)luaFactory(GMODLUASHAREDINTERFACE, NULL);
	
	HOOKVFUNC(lua_shared, 14, CreateLuaInterfaceReal, CreateLuaInterfaceDetour);
	HOOKVFUNC(lua_shared, 12, CloseLuaInterfaceReal, CloseLuaInterfaceDetour);
	HOOKVFUNC(lua_shared, 13, GetLuaInterfaceReal, GetLuaInterfaceDetour);
	
	Lua()->SetGlobal("HasInterfaceLoaded", HasInterfaceLoaded);
	Lua()->SetGlobal("GetLuaInterface", GetLuaInterface);
	
	ILuaObject* Metatable = Lua()->GetMetaTable( LUAINTERFACE_META_NAME, LUAINTERFACE_META_ID );
		ILuaObject* MetaState = Lua()->GetNewTable();
			MetaState->SetMember("FreeReference", LuaInterface_FreeReference );
			MetaState->SetMember("GetGlobalReference", LuaInterface_GetGlobalReference );
			MetaState->SetMember("CallReference", LuaInterface_CallReference );
			MetaState->SetMember("RunString", LuaInterface_RunString );
			MetaState->SetMember("Include", LuaInterface_Include );
			MetaState->SetMember("Require", LuaInterface_Require );
			MetaState->SetMember("FmtMsg", LuaInterface_FmtMsg );
			MetaState->SetMember("LoadHook", LuaInterface_LoadHook );
			MetaState->SetMember("UnloadHook", LuaInterface_UnloadHook );
			Metatable->SetMember("__index", MetaState );
		MetaState->UnReference();
	Metatable->UnReference();
	
	Lua()->SetGlobal( "STATE_CLIENT", (float)CLIENT_STATE );
	Lua()->SetGlobal( "STATE_SERVER", (float)SERVER_STATE );
	Lua()->SetGlobal( "STATE_MENU", (float)MENU_STATE );
	
	return 0;
}


int Close(lua_State *L) {
	UNHOOKVFUNC(lua_shared, 14, CreateLuaInterfaceReal);
	UNHOOKVFUNC(lua_shared, 12, CloseLuaInterfaceReal);
	UNHOOKVFUNC(lua_shared, 13, GetLuaInterfaceReal);
	
	return 0;
}



