#pragma comment (linker, "/NODEFAULTLIB:libcmt")

#ifdef _LINUX
	#define VTABLE_OFFSET 1
	#define SERVER_LIB "server.so"
	#define ENGINE_LIB "engine.so"
#else
	#define VTABLE_OFFSET 0
	#define SERVER_LIB "server.dll"
	#define ENGINE_LIB "engine.dll"
#endif

#undef _UNICODE

#include <windows.h>

//String stuff
#include <string>
#include <sstream>

#include "gmod/CStateManager/vfnhook.h"

//Lua module interface
#include "interface.h"
#include "gmod/GMLuaModule.h"

//#include "iclient.h"
#include <inetmsghandler.h>
#include <inetchannel.h>
#include "eiface.h"
#include "tmpclient.h"

ILuaInterface *gLua = NULL;

IServerGameClients *g_IServerGameClients = NULL;
IVEngineServer *g_EngineServer = NULL;

bool isVFNHooked = false;

GMOD_MODULE( Init, Shutdown );

int getIndexFromSteamID( const char* pszNetworkID )
{
	int minplayers = 0;
	int maxplayers = 0;
	int defaultMaxPlayers = 0;
	g_IServerGameClients->GetPlayerLimits( minplayers, maxplayers, defaultMaxPlayers );
	for ( int i=1; i<=maxplayers; i++ )
	{
		edict_t *pEntity = g_EngineServer->PEntityOfEntIndex( i );
		if ( !pEntity->IsFree() )
		{
			const char* steamID = g_EngineServer->GetPlayerNetworkIDString(pEntity);
			if ( steamID == pszNetworkID )
				return i;
		}
	}
	return -1;
}

DEFVFUNC_( origNetworkIDValidated, void, ( IServerGameClients *ISrvGmCl, const char *pszUserName, const char *pszNetworkID ) );

void VFUNC newNetworkIDValidated( IServerGameClients *ISrvGmCl, const char *pszUserName, const char *pszNetworkID ) {
	
	int pEntIndex = getIndexFromSteamID( pszNetworkID );
	edict_t *pEntity = g_EngineServer->PEntityOfEntIndex( pEntIndex );

	if ( pEntity != NULL && !pEntity->IsFree() )
	{
		const char* steamID = g_EngineServer->GetPlayerNetworkIDString( pEntity );

		ILuaObject* hook = gLua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");

		gLua->Push(hookCall);
			gLua->Push("SteamIDValidated");
			gLua->PushNil();
			gLua->Push(pszUserName);
			gLua->Push(pszNetworkID);
			gLua->Push(steamID);
			gLua->Push((float)pEntIndex);
		gLua->Call(6, 1);

		hookCall->UnReference();
		hook->UnReference();

		ILuaObject* ret = gLua->GetReturn(0);

		INetChannel *pNetChan = static_cast<INetChannel *>(g_EngineServer->GetPlayerNetInfo(pEntIndex));

		if ( pNetChan != NULL )
		{
			IClient *pClient = static_cast<IClient *>(pNetChan->GetMsgHandler());
			if ( pClient != NULL )
			{
				if ( ret->GetType() == GLua::TYPE_STRING )
				{
					const char* reason = ret->GetString();
					ret->UnReference();
					pClient->Disconnect( reason );
				} else if ( ret->GetType() == GLua::TYPE_BOOL && ret->GetBool() == false )
					pClient->Disconnect( "Connection rejected by game" );
			} else
				gLua->ErrorNoHalt( "gmsv_fuckoff: IClient is null\n" );
		} else
			gLua->ErrorNoHalt( "gmsv_fuckoff: INetChannel is null\n" );
	} else
		gLua->ErrorNoHalt( "gmsv_fuckoff: edict is null\n" );

	return origNetworkIDValidated( ISrvGmCl, pszUserName, pszNetworkID );
}

/*DEFVFUNC_( origClientConnect, bool, ( IServerGameClients *ISrvGmCl, edict_t *pEntity, const char *pszName, const char *pszAddress, char *reject, int maxrejectlen ) );

bool VFUNC newClientConnect( IServerGameClients *ISrvGmCl, edict_t *pEntity, const char *pszName, const char *pszAddress, char *reject, int maxrejectlen ) {
	int curIndex = g_EngineServer->IndexOfEdict(pEntity);
	const char* steamID = g_EngineServer->GetPlayerNetworkIDString(pEntity);

	ILuaObject* hook = gLua->GetGlobal("hook");
	ILuaObject* hookCall = hook->GetMember("Call");

	gLua->Push(hookCall);
		gLua->Push("ClientConnect");
		gLua->PushNil();
		gLua->Push(pszName);
		gLua->Push(steamID);
		gLua->Push(pszAddress);
		gLua->Push((float)curIndex);
	gLua->Call(6, 1);

	hookCall->UnReference();
	hook->UnReference();

	ILuaObject* ret = gLua->GetReturn(0);

	if ( ret->GetType() == GLua::TYPE_STRING )
	{
		const char* reason = ret->GetString();
		ret->UnReference();
		reject = (char*) reason; // Not exactly sure how you do the custom disconnect message here
		return false;
	} else if ( ret->GetType() == GLua::TYPE_BOOL )
	{
		bool b = ret->GetBool();
		ret->UnReference();
		return b;
	}

	return origClientConnect( ISrvGmCl, pEntity, pszName, pszAddress, reject, maxrejectlen );
}*/

LUA_FUNCTION( DropPlayer )
{
	gLua->CheckType( 1, GLua::TYPE_NUMBER );
	gLua->CheckType( 2, GLua::TYPE_STRING );

	int iDropIndex = Lua()->GetNumber( 1 );
	const char* pDropReason = Lua()->GetString( 2 );

	INetChannel *pNetChan = static_cast<INetChannel *>(g_EngineServer->GetPlayerNetInfo(iDropIndex));
	IClient *pClient = static_cast<IClient *>(pNetChan->GetMsgHandler());
	pClient->Disconnect( pDropReason );

	return 0;
}

int Init(lua_State *L) {

	gLua = Lua();

	CreateInterfaceFn ServerFactory = Sys_GetFactory( SERVER_LIB );
	if ( !ServerFactory )
		Lua()->Error( "gmsv_fuckoff: Error getting " SERVER_LIB " factory.\n" );

	g_IServerGameClients = ( IServerGameClients* )ServerFactory( INTERFACEVERSION_SERVERGAMECLIENTS, NULL );
	if ( !g_IServerGameClients )
		Lua()->Error( "gmsv_fuckoff: Error getting IServerGameClients interface.\n" );

	CreateInterfaceFn EngineFactory = Sys_GetFactory( ENGINE_LIB );
	if ( !EngineFactory )
		Lua()->Error( "gmsv_fuckoff: Error getting " ENGINE_LIB " factory.\n" );

	g_EngineServer = ( IVEngineServer* )EngineFactory( INTERFACEVERSION_VENGINESERVER, NULL );
	if ( !g_EngineServer )
		Lua()->Error( "gmsv_fuckoff: Error getting IVEngineServer interface.\n" );

	if ( !isVFNHooked && Lua()->IsServer() )
	{
		isVFNHooked = true;
		//HOOKVFUNC( g_IServerGameClients, 1 - VTABLE_OFFSET, origClientConnect, newClientConnect );
		HOOKVFUNC( g_IServerGameClients, 15 - VTABLE_OFFSET, origNetworkIDValidated, newNetworkIDValidated );
	}

	ILuaObject *fuckoff = gLua->GetNewTable();
	fuckoff->SetMember( "Drop", DropPlayer );
	gLua->SetGlobal( "fuckoff", fuckoff );
	fuckoff->UnReference();

	Lua()->Msg( "gmsv_fuckoff: Loaded!\n" );

	return 0;
}

int Shutdown(lua_State *L) {
	if ( Lua()->IsServer() )
	{
		isVFNHooked = false;
		//UNHOOKVFUNC( g_IServerGameClients, 1 + VTABLE_OFFSET, origClientConnect );
		UNHOOKVFUNC( g_IServerGameClients, 15 + VTABLE_OFFSET, origNetworkIDValidated );
	}
	return 0;
}