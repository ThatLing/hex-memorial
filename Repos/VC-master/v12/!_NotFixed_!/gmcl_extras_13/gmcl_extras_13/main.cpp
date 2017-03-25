#pragma comment (lib, "tier0.lib")
#pragma comment (lib, "tier1.lib")
#pragma comment (linker, "/NODEFAULTLIB:libcmt")

#ifdef _LINUX
	#define SERVER_LIB "server.so"
	#define ENGINE_LIB "engine.so"
	#define CLIENT_LIB "client.so"
	#define MATERIAL_LIB "materialsystem.so"
	#define FILESYSTEM_LIB "filesystem_steam.so"
	#define VSTD_LIB "vstdlib.so"
	#define GAMEUI_LIB "gameui.so"
	#define STEAM_CLIENT_LIB "steamclient.so"
	#define VGUI2_LIB "vgui2.so"
#else
	#define SERVER_LIB "server.dll"
	#define ENGINE_LIB "engine.dll"
	#define CLIENT_LIB "client.dll"
	#define MATERIAL_LIB "materialsystem.dll"
	#define FILESYSTEM_LIB "filesystem_steam.dll"
	#define VSTD_LIB "vstdlib.dll"
	#define GAMEUI_LIB "gameui.dll"
	#define STEAM_CLIENT_LIB "steamclient.dll"
	#define VGUI2_LIB "vgui2.dll"
#endif

#define CLIENT_DLL
#define GMOD_BETA

#include <windows.h>

#undef _UNICODE

//String stuff
#include <string>
#include <sstream>

#include <vfnhook.h>

//Lua module interface
#include <GMLuaModule.h>


#ifdef CLIENT_DLL
	#include "icliententitylist.h"
#endif

//#include "cbase.h"
#include "mathlib/vector.h"

// File system
#include "filesystem.h"

// Material
//#include "engine/ivmodelinfo.h"
#include "materialsystem/imaterial.h"
#include "materialsystem/itexture.h"
#include "materialsystem/imaterialvar.h"

#include <IGameUI.h> // IGameUI interface
#include <IGameConsole_004.h> // IGameConsole interface
#include "IGameUIFuncs.h" // IGameUIFuncs interface
#include "public/game/client/IGameClientExports.h" // IGameClientExports
#include "cdll_client_int.h"
#include "modes.h" // Video mode struct
#include "game/server/iplayerinfo.h"

#include "vgui/IVGui.h"
#include "vgui/VGUI.h"
#include "vgui_controls/panel.h"
#include "ienginevgui.h"

// CVar
#include "tier1/iconvar.h"
#include "tier1/tier1.h"
#include "vstdlib/cvar.h"
#include "convar.h"

// NetChannel shit
#include "inetchannel.h"

#include "studio.h"

#include "steamworks.h"
ILuaObject* _G 			= NULL;

ISteamClient012 *g_SteamClient = NULL;
IClientEngine *g_ClientEngine = NULL;
ISteamFriends009* g_SteamFriends = NULL;

IVEngineClient *g_EngineClient = NULL;
IVEngineServer *g_EngineServer = NULL;
IEngineVGui *g_EngineVGUI = NULL;
IGameUI *g_GameUI = NULL;
IGameUIFuncs *g_GameUIFuncs = NULL;
IGameConsole *g_GameConsole = NULL;
ICvar *g_ICvar = NULL;
IBaseClientDLL *g_BaseClientDLL = NULL;
IGameClientExports *g_GameClientExports = NULL;
//IGameEvent *g_GameEvent = NULL;
IFileSystem *g_FileSystem = NULL;
IVModelInfoClient *g_IVModelInfoClient = NULL;
IMaterialSystem *g_MaterialSystem = NULL;
//IMatRenderContext *g_Render = NULL;
IClientEntityList *g_ClientEntityList = NULL;
ILuaInterface *menuLua = NULL;
//IGameResources *g_GameResorces = NULL;
vgui::IPanel *g_Panel = NULL;
vgui::IVGui *g_VGui = NULL;

inline const model_t* GetModel( lua_State* L, int i = 1 ) {
	const char* mdlName = Lua()->GetString( i );
	return g_IVModelInfoClient->FindOrLoadModel( mdlName );
}

inline int GetModelIndex( lua_State* L, int i = 1 ) {
	return g_IVModelInfoClient->GetModelIndex( Lua()->GetString(1) );
}

inline ILuaObject* NewVectorObject( lua_State* L, Vector& vec ) {
	ILuaObject* func = _G->GetMember( "Vector" );
	Lua()->Push( func );
	Lua()->Push( vec.x );
	Lua()->Push( vec.y );
	Lua()->Push( vec.z );
	if( !Lua()->Call( 3, 1 ) ) {
		func->UnReference();
		return NULL;
	}
	return Lua()->GetReturn( 0 );
}

inline void PushVector( lua_State* L, Vector& vec ) {
	ILuaObject* obj = NewVectorObject( L, vec );
	Lua()->Push( obj );
	obj->UnReference();
}

inline Vector& GetVector( lua_State* L, int i = 1 ) {
	return *reinterpret_cast<Vector*>( Lua()->GetUserData( i ) );
}

inline ILuaObject* NewAngleObject( lua_State* L, QAngle& vec ) {
	ILuaObject* func = _G->GetMember( "Angle" );
	Lua()->Push( func );
	Lua()->Push( vec.x );
	Lua()->Push( vec.y );
	Lua()->Push( vec.z );
	if( !Lua()->Call( 3, 1 ) ) {
		func->UnReference();
		return NULL;
	}
	return Lua()->GetReturn( 0 );
}

inline void PushAngle( lua_State* L, QAngle& ang ) {
	ILuaObject* obj = NewAngleObject( L, ang );
	Lua()->Push( obj );
	obj->UnReference();
}

inline QAngle& GetAngle( lua_State* L, int i = 1 ) {
	return *reinterpret_cast<QAngle*>( Lua()->GetUserData( i ) );
}

inline vgui::Panel* GetPanel( lua_State* L, int stackPos ) {
	return *(vgui::Panel **)Lua()->GetUserData( stackPos );
}

inline ILuaObject *NewMaterialObject( lua_State* L, const char* path ) {
	ILuaObject* func = _G->GetMember( "Material" );

	Lua()->Push( func );
	Lua()->Push( path );

	if( !Lua()->Call( 1, 1 ) ) {
		func->UnReference();
		return NULL;
	}

	return Lua()->GetReturn( 0 );
}

/*inline ILuaObject *NewEntityObject( lua_State* L, CBaseEntity *pEntity ) {
	ILuaObject* func = Lua()->GetGlobal( "Entity" );

	Lua()->Push( func );
	Lua()->Push( (float) pEntity->entindex() );

	if( !Lua()->Call( 1, 1 ) ) {
		func->UnReference();
		return NULL;
	}

	return Lua()->GetReturn( 0 );
}

inline void PushEntity( lua_State* L, CBaseEntity *ent ) {
	ILuaObject* obj = NewEntityObject( L, ent );
	Lua()->Push( obj );
	obj->UnReference();
}

inline CBaseEntity *GetEntity( lua_State* L, int i = 1 ) {
	
	int entIndex = Lua()->GetNumber( i );
	
	#ifdef CLIENT_DLL
		return g_ClientEntityList->GetClientNetworkable( entIndex )->GetIClientUnknown()->GetBaseEntity();
	#else
		edict_t *edtEdict = g_EngineServer->PEntityOfEntIndex( entIndex );
		
		if ( !edtEdict || edtEdict->IsFree() ) {
			Lua()->ErrorNoHalt( "Invalid edict for entity <%i>\n", entIndex );
			return NULL;
		}

		return g_ServerGameEnts->EdictToBaseEntity( edtEdict );
	#endif
}*/

static ConCommand *lua_run_mn = NULL;
static ConCommand *lua_openscript_mn = NULL;

GMOD_MODULE( Open, Close );

LUA_FUNCTION( SetMaxEntities )
{
	Lua()->CheckType(1, GLua::TYPE_NUMBER );
	g_ClientEntityList->SetMaxEntities( Lua()->GetInteger(1) );
	return 0;
}

LUA_FUNCTION( GetMaxEntities )
{
	Lua()->Push( (float) g_ClientEntityList->GetMaxEntities() );
	return 1;
}

LUA_FUNCTION( GetHighestEntityIndex )
{
	Lua()->Push( (float) g_ClientEntityList->GetHighestEntityIndex() );
	return 1;
}

LUA_FUNCTION( NumberOfEntities )
{
	bool bIncludeNonNetworkable = Lua()->GetBool(1) != NULL ? Lua()->GetBool(1) : false;
	Lua()->Push( (float) g_ClientEntityList->NumberOfEntities( bIncludeNonNetworkable ) );
	return 1;
}

LUA_FUNCTION( WriteSaveGameScreenshotOfSize )
{
	Lua()->CheckType(1, GLua::TYPE_STRING );
	Lua()->CheckType(2, GLua::TYPE_NUMBER );
	Lua()->CheckType(3, GLua::TYPE_NUMBER );

	g_BaseClientDLL->WriteSaveGameScreenshotOfSize( Lua()->GetString(1), Lua()->GetNumber(2), Lua()->GetNumber(3) );
	return 0;
}

LUA_FUNCTION( IsSteamOverlayLoaded )
{
    char szEventName[ 256 ] = { 0 };
    
    sprintf( szEventName, "SteamOverlayRunning_%u", g_EngineClient->GetAppID() );

    HANDLE hEvent = OpenEventA( EVENT_ALL_ACCESS, FALSE, szEventName );
    
    bool bReturn = ((DWORD)hEvent > 0);

	Lua()->Push( (bool) bReturn );

    CloseHandle( hEvent );

    return 1;
}  

LUA_FUNCTION( GetNumTextures )
{	
	Lua()->CheckType(1, GLua::TYPE_STRING );
	studiohdr_t* sModel = g_IVModelInfoClient->GetStudiomodel( GetModel(L,1) );
	
	Lua()->Push( (float) sModel->numtextures );
	
	return 1;
}

LUA_FUNCTION( GetAllTextures )
{
	Lua()->CheckType(1, GLua::TYPE_STRING );

	studiohdr_t* pStudio = g_IVModelInfoClient->GetStudiomodel( GetModel(L,1) );
	
	ILuaObject* pTable = Lua()->GetNewTable();

	for( int i = 0; i < pStudio->numtextures; i++ ) {
		// materials are a dumb bitch
		mstudiotexture_t* pTexture = pStudio->pTexture( i );
		
		char* pszTextureName = pTexture->pszName();
		char* pszTexturePath = pStudio->pCdtexture( pTexture->used ); //"";
		
		char pszFullPath[ MAX_PATH ];
		strcpy( pszFullPath, pszTexturePath );
		
		strcat( pszFullPath, pszTextureName );
		
		Q_FixSlashes( pszFullPath, '/' );
		
		pTable->SetMember( i + 1, pszFullPath );
	}

	Lua()->Push( pTable );
	pTable->UnReference();

	return 1;
}

LUA_FUNCTION( PrintConsoleColor )
{
	Lua()->CheckType( 1, GLua::TYPE_TABLE );
	Lua()->CheckType( 2, GLua::TYPE_STRING );

	ILuaObject* MsgCol = Lua()->GetObject( 1 );
	
	Color ConsoleColor( MsgCol->GetMemberInt( "r" ), MsgCol->GetMemberInt( "g" ), MsgCol->GetMemberInt( "b" ), MsgCol->GetMemberInt( "a" ) );
	ConColorMsg( ConsoleColor, Lua()->GetString( 2 ) );

	MsgCol->UnReference();

	return 0;
}

LUA_FUNCTION( IsConsoleVisible )
{
	Lua()->Push( (bool) g_EngineClient->Con_IsVisible() );
	return 1;
}

LUA_FUNCTION( ConsoleClear )
{
	g_GameConsole->Clear();
	return 0;
}

LUA_FUNCTION( ConsoleHide )
{
	g_GameConsole->Hide();
	return 0;
}

LUA_FUNCTION( ConsolePopup )
{
	g_GameConsole->Activate();
	return 0;
}

LUA_FUNCTION( ConsoleSetParent )
{
	Lua()->CheckType( 1, GLua::TYPE_PANEL );
	vgui::Panel *pPanel = *(vgui::Panel **)Lua()->GetUserData( 1 );
	vgui::VPANEL pVPanel = pPanel->GetVPanel();
	g_GameConsole->SetParent( pVPanel );
	return 0;
}

LUA_FUNCTION( ServerCommand )
{
	Lua()->CheckType( 1, GLua::TYPE_STRING );
	g_EngineServer->ServerCommand( Lua()->GetString( 1 ) );
	return 0;
}

LUA_FUNCTION( ClientCmd )
{
	Lua()->CheckType( 1, GLua::TYPE_STRING );
	const char* CmdStr = Lua()->GetString( 1 );
	g_EngineClient->ClientCmd( ( CmdStr != NULL ? CmdStr : "" ) );
	return 0;
}

LUA_FUNCTION( ClientCmd_Unrestricted )
{
	Lua()->CheckType( 1, GLua::TYPE_STRING );
	const char* CmdStr = Lua()->GetString( 1 );
	g_EngineClient->ExecuteClientCmd( ( CmdStr != NULL ? CmdStr : "" ) );
	return 0;
}

LUA_FUNCTION ( GetAllPlayers )
{
	ILuaObject* AllPlayers = Lua()->GetNewTable();

	int MaxClients = g_EngineClient->GetMaxClients();

	int id = 1;
	int i = 1;
	for( i = 1; i <= MaxClients; i++ )
	{
		player_info_t plyinfo;
		g_EngineClient->GetPlayerInfo( i, &plyinfo );
		if( plyinfo.userID )
		{
			int userid = plyinfo.userID;
			AllPlayers->SetMember( id, (float) userid );
			id++;
		}
	}

	Lua()->Push( AllPlayers );

	AllPlayers->UnReference();

	return 1;
}

/*LUA_FUNCTION( GetAbsOrigin )
{
	Lua()->CheckType(1, GLua::TYPE_NUMBER );
	
	IClientEntity* pClient = g_ClientEntityList->GetClientEntity( Lua()->GetNumber(1) );
	const Vector &vec = pClient->GetAbsOrigin();
	Vector &newVec( vec.x, vec.y, vec.z );
	PushVector( L, newVec );
	return 1;
}

LUA_FUNCTION( GetAbsAngles )
{
	Lua()->CheckType(1, GLua::TYPE_NUMBER );
	
	IClientEntity* pClient = g_ClientEntityList->GetClientEntity( Lua()->GetNumber(1) );
	QAngle ang = pClient->GetAbsAngles();
	QAngle &newAng( ang.x, ang.y, ang.z );
	PushAngle( L, newAng );
	return 1;
}*/

LUA_FUNCTION( GetPlayerName )
{
	Lua()->CheckType(1, GLua::TYPE_NUMBER );
	
	player_info_t plyinfo;
	g_EngineClient->GetPlayerInfo( (int)g_EngineClient->GetPlayerForUserID( Lua()->GetNumber( 1 ) ), &plyinfo );
	
	const char* plname = plyinfo.name;
	Lua()->Push( (plname != NULL ? plname : "") );
	
	return 1;
}

LUA_FUNCTION( GetPlayerJingle )
{
	Lua()->CheckType(1, GLua::TYPE_NUMBER );

	int player = (int)g_EngineClient->GetPlayerForUserID( Lua()->GetNumber( 1 ) );

	player_info_t info;
	g_EngineClient->GetPlayerInfo( player, &info );

	// Doesn't have a jingle sound
	 if ( !info.customFiles[1] )	
		return 0;

	char soundhex[ 16 ];
	Q_binarytohex( (byte *)&info.customFiles[1], sizeof( info.customFiles[1] ), soundhex, sizeof( soundhex ) );

	// See if logo has been downloaded.
	char fullsoundname[ 512 ];
	Q_snprintf( fullsoundname, sizeof( fullsoundname ), "sound/temp/%s.wav", soundhex );

	if ( !g_FileSystem->FileExists( fullsoundname ) )
	{
		char custname[ 512 ];
		Q_snprintf( custname, sizeof( custname ), "downloads/%s.dat", soundhex );
		// it may have been downloaded but not copied under materials folder
		if ( !g_FileSystem->FileExists( custname ) )
			return 0; // not downloaded yet

		// copy from download folder to materials/temp folder
		// this is done since material system can access only materials/*.vtf files

		if ( !g_EngineServer->CopyFile( custname, fullsoundname) )
			return 0;
	}

	Q_snprintf( fullsoundname, sizeof( fullsoundname ), "temp/%s.wav", soundhex );

	Lua()->Push( ( fullsoundname != NULL ? fullsoundname : "" ) );

	return 1;
}

LUA_FUNCTION( GetPlayerLogo )
{
	Lua()->CheckType(1, GLua::TYPE_NUMBER );

	int player = (int)g_EngineClient->GetPlayerForUserID( Lua()->GetNumber( 1 ) );

	player_info_t info;
	g_EngineClient->GetPlayerInfo( player, &info );
	
	if ( !info.customFiles[0] ) {
		return 0;
	}

	/*
	char matname[ 512 ];
	Q_snprintf( matname, sizeof( matname ), "decals/playerlogo%2.2d", player );

	IMaterial *logo = g_MaterialSystem->FindMaterial( matname, TEXTURE_GROUP_DECAL, false );
	if ( IsErrorMaterial( logo ) ) {
		return 0;
	}
	*/

	char logohex[ 16 ];
	Q_binarytohex( (byte *)&info.customFiles[0], sizeof( info.customFiles[0] ), logohex, sizeof( logohex ) );

	// See if logo has been downloaded.
	char texname[ 512 ];
	Q_snprintf( texname, sizeof( texname ), "temp/%s", logohex );
	
	char fulltexname[ 512 ];
	Q_snprintf( fulltexname, sizeof( fulltexname ), "materials/temp/%s.vtf", logohex );

	if ( !g_FileSystem->FileExists( fulltexname ) )
	{
		char custname[ 512 ];
		Q_snprintf( custname, sizeof( custname ), "downloads/%s.dat", logohex );
		// it may have been downloaded but not copied under materials folder
		if ( !g_FileSystem->FileExists( custname ) ) {
			return 0; // not downloaded yet
		}

		// copy from download folder to materials/temp folder
		// this is done since material system can access only materials/*.vtf files

		if ( !g_EngineServer->CopyFile( custname, fulltexname) ) {
			return 0;
		}
	}

	/*
	ITexture *texture = g_MaterialSystem->FindTexture( texname, TEXTURE_GROUP_DECAL, false );
	if ( IsErrorTexture( texture ) ) {
		Lua()->ErrorNoHalt( "Texture not found.\n" );
		return 0; // not found
	}

	// Update the texture used by the material if need be.
	bool bFound = false;
	IMaterialVar *pMatVar = logo->FindVar( "$basetexture", &bFound );
	if ( bFound && pMatVar ) {
		if ( pMatVar->GetTextureValue() != texture ) {
			pMatVar->SetTextureValue( texture );
			logo->RefreshPreservingMaterialVars();
		}
	}

	ILuaObject* meta = Lua()->GetMetaTable( "IMaterial", GLua::TYPE_MATERIAL );
	Lua()->PushUserData( meta, logo ); // Would have liked to push the material, but it likes to crash me. Taken from gmcl_renderx <3
	meta->UnReference();
	//SAFE_UNREF( meta );
	*/

	Lua()->Push( ( texname != NULL ? texname : "" ) );

	return 1;

}

LUA_FUNCTION( GetPlayerIndex )
{
	Lua()->CheckType(1, GLua::TYPE_NUMBER );
	
	Lua()->Push( (float)g_EngineClient->GetPlayerForUserID( Lua()->GetNumber( 1 ) ) );
	
	return 1;
}

LUA_FUNCTION( GetPlayerSteamID )
{
	Lua()->CheckType(1, GLua::TYPE_NUMBER );
	
	player_info_t plyinfo;
	g_EngineClient->GetPlayerInfo( (int)g_EngineClient->GetPlayerForUserID( Lua()->GetNumber( 1 ) ), &plyinfo );
	
	unsigned int friendid = plyinfo.friendsID;
	unsigned int steamid = friendid / 2;

	std::stringstream formattedID;
	formattedID << "STEAM_0:";
	friendid % 2 == 1 ? formattedID << "1:" : formattedID << "0:";
	formattedID << steamid;

	Lua()->Push( formattedID.str().c_str() );

	return 1;
}

LUA_FUNCTION( GetLocalSteamID )
{
	HSteamPipe hPipe = g_SteamClient->CreateSteamPipe();
	HSteamUser hUser = g_SteamClient->ConnectToGlobalUser( hPipe );

	ISteamUser009 *SteamUser = ( ISteamUser009* )g_SteamClient->GetISteamUser( hUser, hPipe, STEAMUSER_INTERFACE_VERSION_009 );

	CSteamID steamid = SteamUser->GetSteamID();
	g_SteamClient->BReleaseSteamPipe(hPipe);

	Lua()->Push( steamid.Render() );

	return 1;
}

LUA_FUNCTION( GetFriendID )
{

	Lua()->CheckType(1, GLua::TYPE_NUMBER );
	
	player_info_t plyinfo;
	g_EngineClient->GetPlayerInfo( (int)g_EngineClient->GetPlayerForUserID( Lua()->GetNumber( 1 ) ), &plyinfo );
	
	unsigned int friendid = plyinfo.friendsID;

	std::stringstream formattedID;
	formattedID << friendid;

	Lua()->Push( formattedID.str().c_str() );

	return 1;
}

LUA_FUNCTION( LocalPlayerUserID )
{

	player_info_t plyinfo;
	g_EngineClient->GetPlayerInfo( (int)g_EngineClient->GetLocalPlayer(), &plyinfo );

	Lua()->Push( (float)plyinfo.userID );
	
	return 1;
}

LUA_FUNCTION( IsFakePlayer )
{
	Lua()->CheckType(1, GLua::TYPE_NUMBER );

	player_info_t plyinfo;
	g_EngineClient->GetPlayerInfo( (int)g_EngineClient->GetPlayerForUserID( Lua()->GetNumber( 1 ) ), &plyinfo );

	Lua()->Push( (bool)plyinfo.fakeplayer );
	return 1;
}

LUA_FUNCTION( GetKeyForBinding )
{
	Lua()->CheckType( 1, GLua::TYPE_STRING );
	Lua()->Push( g_EngineClient->Key_LookupBinding( Lua()->GetString( 1 ) ) );
	return 1;
}

LUA_FUNCTION( GetScreenAspectRatio )
{
	Lua()->Push( (float) g_EngineClient->GetScreenAspectRatio() );
	return 1;
}

LUA_FUNCTION( GetMaxPlayers )
{
	Lua()->Push( (float) g_EngineClient->GetMaxClients() );
	return 1;
}

LUA_FUNCTION( GetMapName )
{
	const char* strMap = g_EngineClient->GetLevelName();
	Lua()->Push( ( strMap ? strMap : "" ) );
	return 1;
}

LUA_FUNCTION( GetMapVersion )
{
	Lua()->Push( (float) g_EngineClient->GetLevelVersion() );
	return 1;
}

LUA_FUNCTION( GetIP )
{
	INetChannelInfo* NetChan = g_EngineClient->GetNetChannelInfo();
	if ( NetChan != NULL ) {
		const char* ipAdress = NetChan->GetAddress();
		Lua()->Push( ipAdress != NULL ? ipAdress : "0.0.0.0" );
	} else {
		Lua()->Push( "0.0.0.0" );
	}
	return 1;
}

LUA_FUNCTION( GetAppID )
{
	Lua()->Push( (float) g_EngineClient->GetAppID() );
	return 1;
}

LUA_FUNCTION( GetEngineBuildNumber )
{
	Lua()->Push( (float) g_EngineClient->GetEngineBuildNumber() );
	return 1;
}

LUA_FUNCTION( GetProductVersionString )
{
	const char* ProductVersion = g_EngineClient->GetProductVersionString();
	Lua()->Push( ProductVersion != NULL ? ProductVersion : "" );
	return 1;
}

LUA_FUNCTION( IsHammerRunning )
{
	Lua()->Push( (bool) g_EngineClient->IsHammerRunning() );
	return 1;
}

LUA_FUNCTION( SupportsHDR )
{
	Lua()->Push( (bool) g_EngineClient->SupportsHDR() );
	return 1;
}

LUA_FUNCTION( GetDXSupportLevel )
{
	Lua()->Push( (float) g_EngineClient->GetDXSupportLevel() );
	return 1;
}

LUA_FUNCTION( SetEyeAngles )
{
	Lua()->CheckType( 1, GLua::TYPE_ANGLE );	
	g_EngineClient->SetViewAngles( GetAngle(L,1));
	return 0;
}

LUA_FUNCTION( GetEyeAngles )
{
	QAngle viewAng;
	g_EngineClient->GetViewAngles( viewAng );
	PushAngle( L, viewAng );
	return 1;
}

/*LUA_FUNCTION( GetEyePos )
{
	Vector *camPos;
	g_Render->GetWorldSpaceCameraPosition( camPos );
	Vector &newVec( camPos->x, camPos->y, camPos->z );
	PushVector( newVec );
	return 1;
}*/

LUA_FUNCTION( Time )
{
	Lua()->Push( (float) g_EngineServer->Time() );
	return 1;
}

LUA_FUNCTION( IsDrawingLoadingImage )
{
	Lua()->Push( (bool) g_EngineClient->IsDrawingLoadingImage() );
	return 1;
}

LUA_FUNCTION( IsConnected )
{
	Lua()->Push( (bool) g_EngineClient->IsConnected() );
	return 1;
}

LUA_FUNCTION( IsInEditMode )
{
	Lua()->Push( (bool) g_EngineClient->IsInEditMode() );
	return 1;
}

LUA_FUNCTION( IsInGame )
{
	Lua()->Push( (bool) g_EngineClient->IsInGame() );
	return 1;
}

LUA_FUNCTION( IsDedicatedServer )
{
	Lua()->Push( (bool) g_EngineServer->IsDedicatedServer() );
	return 1;
}

LUA_FUNCTION( IsLowViolence )
{
	Lua()->Push( (bool) g_EngineClient->IsLowViolence() );
	return 1;
}

LUA_FUNCTION( IsPaused )
{
	Lua()->Push( (bool) g_EngineClient->IsPaused() );
	return 1;
}

LUA_FUNCTION( IsPlayingDemo )
{
	Lua()->Push( (bool) g_EngineClient->IsPlayingDemo() );
	return 1;
}

LUA_FUNCTION( IsPlayingTimeDemo )
{
	Lua()->Push( (bool) g_EngineClient->IsPlayingTimeDemo() );
	return 1;
}

LUA_FUNCTION( IsRecordingDemo )
{
	Lua()->Push( (bool) g_EngineClient->IsRecordingDemo() );
	return 1;
}

LUA_FUNCTION( IsTakingScreenshot )
{
	Lua()->Push( (bool) g_EngineClient->IsTakingScreenshot() );
	return 1;
}

/*
LUA_FUNCTION( GetLocalPlayerModel )
{
	C_BasePlayer *pPlayer = C_BasePlayer::GetLocalPlayer();
	if ( pPlayer )
		Lua()->Push( pPlayer->GetModel() );
	else
		Lua()->Push( "" );
}
*/

LUA_FUNCTION( SetLoadingBackgroundDialog )
{
	Lua()->CheckType( 1, GLua::TYPE_PANEL );

	vgui::Panel *pPanel = *(vgui::Panel **)Lua()->GetUserData( 1 );
	vgui::VPANEL pVPanel = pPanel->GetVPanel();
	g_GameUI->SetLoadingBackgroundDialog( pVPanel );

	return 0;
}

LUA_FUNCTION( SetMainMenuOverride )
{
	Lua()->CheckType( 1, GLua::TYPE_PANEL );

	vgui::Panel *pPanel = *(vgui::Panel **)Lua()->GetUserData( 1 );
	vgui::VPANEL pVPanel = pPanel->GetVPanel();
	g_GameUI->SetMainMenuOverride( pVPanel );

	return 0;
}

LUA_FUNCTION( GetPanel )
{
	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	Lua()->CheckType( 2, GLua::TYPE_PANEL );

	vgui::VPANEL root = g_EngineVGUI->GetPanel((VGuiPanel_t)Lua()->GetInteger(1));
	vgui::Panel *pPanel = *(vgui::Panel **)Lua()->GetUserData( 2 );
	//pPanel->SetParent( root );

	/*
	for(int i=0;i<vgui::ipanel()->GetChildCount(root);i++)
	{
		vgui::VPANEL child = vgui::ipanel()->GetChild(parent, i);
		if(Q_strcmp(name, vgui::ipanel()->GetName(child)) == 0) return
		child;
	}

	ILuaObject *pPanelMetaTable = Lua()->GetMetaTable( "Panel", GLua::TYPE_PANEL );
		Lua()->PushUserData( pPanelMetaTable, &pPanel );
	pPanelMetaTable->UnReference();
	return 1;
	*/
	return 0;
}

LUA_FUNCTION( IsMainMenuVisible )
{
	Lua()->Push( g_GameUI->IsMainMenuVisible() );
	return 1;
}

LUA_FUNCTION( SendMainMenuCommand )
{
	Lua()->CheckType( 1, GLua::TYPE_STRING );
	g_GameUI->SendMainMenuCommand( Lua()->GetString(1) );
	return 0;
}

LUA_FUNCTION( CloseMessageDialog )
{
	Lua()->CheckType( 1, GLua::TYPE_PANEL );

	vgui::Panel *pPanel = *(vgui::Panel **)Lua()->GetUserData( 1 );
	vgui::VPANEL pVPanel = pPanel->GetVPanel();
	g_GameUI->CloseMessageDialog( pVPanel );

	return 0;
}

LUA_FUNCTION( StartProgressBar )
{	
	g_GameUI->StartProgressBar();
	return 0;
}

LUA_FUNCTION( ContinueProgressBar )
{	
	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	g_GameUI->ContinueProgressBar( Lua()->GetNumber(1) );
	return 0;
}

LUA_FUNCTION( StopProgressBar )
{	
	Lua()->CheckType( 1, GLua::TYPE_BOOL );
	Lua()->CheckType( 2, GLua::TYPE_STRING );
	Lua()->CheckType( 3, GLua::TYPE_STRING );
	g_GameUI->StopProgressBar( Lua()->GetBool(1), Lua()->GetString(2), Lua()->GetString(3) );
	return 0;
}

LUA_FUNCTION( SetProgressBarStatusText )
{	
	Lua()->CheckType( 1, GLua::TYPE_STRING );
	g_GameUI->SetProgressBarStatusText( Lua()->GetString(1) );
	return 0;
}

LUA_FUNCTION( SetSecondaryProgressBar )
{	
	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	g_GameUI->SetSecondaryProgressBar( Lua()->GetNumber(1) );
	return 0;
}

LUA_FUNCTION( SetSecondaryProgressBarText )
{	
	Lua()->CheckType( 1, GLua::TYPE_STRING );
	g_GameUI->SetSecondaryProgressBarText( Lua()->GetString(1) );
	return 0;
}

LUA_FUNCTION( IsPlayerMuted )
{
	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	Lua()->Push( (bool) g_GameClientExports->IsPlayerGameVoiceMuted( Lua()->GetNumber( 1 ) ) );
	return 1;
}

LUA_FUNCTION( SetPlayerMuted )
{
	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	Lua()->CheckType( 2, GLua::TYPE_BOOL );

	int plyIndex = Lua()->GetNumber( 1 );
	bool muteState = Lua()->GetBool( 2 );

	if ( muteState )
		g_GameClientExports->MutePlayerGameVoice( plyIndex );
	else
		g_GameClientExports->UnmutePlayerGameVoice( plyIndex );

	return 0;
}

/*
LUA_FUNCTION( GetPlayerHealth ) {

	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	
	CBasePlayer *pEntity = ( CBasePlayer* ) GetEntity(1);
	
	if ( pEntity != NULL )
		Lua()->Push( (float) pEntity->GetHealth() );
	else
		Lua()->Push( (float) -1 );

	return 1;
}

LUA_FUNCTION( GetPlayerTeam ) {

	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	
	CBasePlayer *pEntity = ( CBasePlayer* ) GetEntity(1);
	
	if ( pEntity != NULL )
		Lua()->Push( (float) pEntity->GetTeamNumber() );
	else
		Lua()->Push( (float) -1 );

	return 1;
}

LUA_FUNCTION( IsPlayerAlive ) {

	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	
	CBasePlayer *pEntity = ( CBasePlayer* ) GetEntity(1);
	
	if ( pEntity != NULL )
		Lua()->Push( (bool) pEntity->IsAlive() );
	else
		Lua()->Push( false );

	return 1;
}

LUA_FUNCTION( GetPlayerEyePos ) {

	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	
	CBasePlayer *pEntity = ( C_BasePlayer* ) GetEntity(1);
	
	if ( pEntity != NULL )
		PushVector( pEntity->EyePosition() );
	else
		PushVector( Vector(0,0,0) );

	return 1;
}

LUA_FUNCTION( GetPlayerEyeAngles ) {

	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	
	CBasePlayer *pEntity = ( C_BasePlayer* ) GetEntity(1);
	
	if ( pEntity != NULL )
	{
		QAngle eyeAng = pEntity->EyeAngles();
		PushAngle( eyeAng );
	}
	else
		PushAngle( QAngle(0,0,0) );

	return 1;
}

LUA_FUNCTION( IsPlayerConnected )
{
	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	Lua()->Push( (bool) g_GameResorces->IsConnected( Lua()->GetNumber( 1 ) ) );
	return 1;
}

LUA_FUNCTION( GetPlayerPing )
{
	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	Lua()->Push( (float) g_GameResorces->GetPing( Lua()->GetNumber( 1 ) ) );
	return 1;
}

LUA_FUNCTION( GetPlayerFrags )
{
	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	Lua()->Push( (float) g_GameResorces->GetFrags( Lua()->GetNumber( 1 ) ) );
	return 1;
}

LUA_FUNCTION( GetPlayerDeaths )
{
	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	Lua()->Push( (float) g_GameResorces->GetDeaths( Lua()->GetNumber( 1 ) ) );	
	return 1;
}

LUA_FUNCTION( GetPlayerTeam )
{
	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	Lua()->Push( (float) g_GameResorces->GetTeam( Lua()->GetNumber( 1 ) ) );
	return 1;
}

LUA_FUNCTION( GetPlayerHealth )
{
	Lua()->CheckType( 1, GLua::TYPE_NUMBER );
	Lua()->Push( (float) g_GameResorces->GetHealth( Lua()->GetNumber( 1 ) ) );
	return 1;
}*/

LUA_FUNCTION( IsConnectedToVACSecureServer )
{
	Lua()->Push( (bool) g_GameUIFuncs->IsConnectedToVACSecureServer() );
	return 1;
}

bool IsWideScreen ( int width, int height )
{
	// 16:9 or 16:10 is widescreen :)
	if ( (width * 9) == ( height * 16.0f ) || (width * 5.0) == ( height * 8.0 ))
		return true;

	return false;
}

LUA_FUNCTION( GetVideoModes )
{
	vmode_t *plist = NULL;
	int count = 0;

	g_GameUIFuncs->GetVideoModes( &plist, &count );

	int scrnW = 0;
	int scrnH = 0;

	g_EngineClient->GetScreenSize( scrnW, scrnH );
	bool areWeWide = IsWideScreen( scrnW, scrnH );

	ILuaObject* allVideoModes = Lua()->GetNewTable();

	int modeIndex = 0;

	for ( int i = 0; i < count; i++, plist++ )
	{
		bool isThisWide = IsWideScreen( plist->width, plist->height );
		if ( ( isThisWide && areWeWide ) || ( !isThisWide && !areWeWide ) )
		{
			modeIndex++;
			ILuaObject* widthHeight = Lua()->GetNewTable();
			widthHeight->SetMember( "width", (float) plist->width );
			widthHeight->SetMember( "height", (float) plist->height );
			allVideoModes->SetMember( modeIndex, widthHeight );
			widthHeight->UnReference();
		}
	}

	Lua()->Push( allVideoModes );
	allVideoModes->UnReference();

	return 1;
}

LUA_FUNCTION( LoadFilmmaker )
{
	//g_EngineClient->LoadFilmmaker();
	return 0;
}

LUA_FUNCTION( UnloadFilmmaker )
{
	//g_EngineClient->UnloadFilmmaker();
	return 0;
}

LUA_FUNCTION( GetLanguage )
{
	char uilanguage[ 64 ];
	g_EngineClient->GetUILanguage( uilanguage, sizeof( uilanguage ) );
	Lua()->Push( uilanguage );
	return 1;
}

LUA_FUNCTION( RunString )
{
	Lua()->CheckType( 1, GLua::TYPE_STRING );
	Lua()->Push( Lua()->RunString( "gmcl_extras", "", Lua()->GetString(1), true, false ) );
	return 1;
}

LUA_FUNCTION( HudText )
{
	Lua()->CheckType( 1, GLua::TYPE_STRING );
	g_BaseClientDLL->HudText( Lua()->GetString(1) );
	return 0;
}

//Friends
LUA_FUNCTION( GetPersonaName )
{
	HSteamPipe hPipe = g_SteamClient->CreateSteamPipe();
	HSteamUser hUser = g_SteamClient->ConnectToGlobalUser( hPipe );

	ISteamFriends009 *SteamFriends = ( ISteamFriends009* )g_SteamClient->GetISteamFriends( hUser, hPipe, STEAMFRIENDS_INTERFACE_VERSION_009 );

	Lua()->Push( SteamFriends->GetPersonaName() );

	g_SteamClient->BReleaseSteamPipe(hPipe);
	return 1;
}

LUA_FUNCTION( SetPersonaName )
{
	Lua()->CheckType( 1, GLua::TYPE_STRING );

	HSteamPipe hPipe = g_SteamClient->CreateSteamPipe();
	HSteamUser hUser = g_SteamClient->ConnectToGlobalUser( hPipe );

	ISteamFriends009 *SteamFriends = ( ISteamFriends009* )g_SteamClient->GetISteamFriends( hUser, hPipe, STEAMFRIENDS_INTERFACE_VERSION_009 );

	SteamFriends->SetPersonaName( Lua()->GetString(1) );

	g_SteamClient->BReleaseSteamPipe(hPipe);
	return 0;
}

LUA_FUNCTION( GetFriendCount )
{
	Lua()->CheckType( 1, GLua::TYPE_NUMBER );

	HSteamPipe hPipe = g_SteamClient->CreateSteamPipe();
	HSteamUser hUser = g_SteamClient->ConnectToGlobalUser( hPipe );

	ISteamFriends009 *SteamFriends = ( ISteamFriends009* )g_SteamClient->GetISteamFriends( hUser, hPipe, STEAMFRIENDS_INTERFACE_VERSION_009 );

	Lua()->Push( (float) SteamFriends->GetFriendCount( Lua()->GetInteger(1) ) );

	g_SteamClient->BReleaseSteamPipe(hPipe);
	return 1;
}

void RunLuaMenu( const CCommand &command ) {
	menuLua->RunString( "", "", command.ArgS(), true, true );
}

void OpenLuaMenu( const CCommand &command ) {
	const char* file = command.ArgS();
	ConMsg( "Running script %s...\n", file );
	menuLua->FindAndRunScript( file, true, true );
}

bool IsMenuState( lua_State *L ) {
	ILuaObject* maxPlayers = _G->GetMember( "MaxPlayers" );
	bool isMenuState = ( !maxPlayers || !maxPlayers->isFunction() );
	maxPlayers->UnReference();
	return isMenuState;
}

int GetStateIndex( lua_State *L ) {
	if ( IsMenuState( L ) )
		return 1;
	else
		return 2;
}

DEFVFUNC_( origOnConfirmQuit, void, ( IGameUI *gGUI ) );

void VFUNC newOnConfirmQuit( IGameUI *gGUI ) {
	ILuaObject* hook = _G->GetMember("hook");
	ILuaObject* hookCall = hook->GetMember("Call");

	menuLua->Push( hookCall );
		menuLua->Push("OnConfirmQuit");
		menuLua->PushNil();
	menuLua->Call(2, 0);

	hookCall->UnReference();
	hook->UnReference();
	return origOnConfirmQuit( gGUI );
}

DEFVFUNC_( origStartProgressBar, void, ( IGameUI *gGUI ) );

void VFUNC newStartProgressBar( IGameUI *gGUI ) {

	ILuaObject* hook = _G->GetMember("hook");
	ILuaObject* hookCall = hook->GetMember("Call");

	menuLua->Push( hookCall );
		menuLua->Push("OnLoadingStarted");
		menuLua->PushNil();
	menuLua->Call(2, 0);

	hookCall->UnReference();
	hook->UnReference();

	return origStartProgressBar( gGUI );
}

DEFVFUNC_( origStopProgressBar, void, ( IGameUI *gGUI, bool, const char*, const char* ) );

void VFUNC newStopProgressBar( IGameUI *gGUI, bool something1, const char* something2, const char* something3 ) {

	ILuaObject* hook = _G->GetMember("hook");
	ILuaObject* hookCall = hook->GetMember("Call");

	menuLua->Push(hookCall);
		menuLua->Push("OnLoadingStopped");
		menuLua->PushNil();
		menuLua->Push( something1 );
		menuLua->Push( something2 );
		menuLua->Push( something3 );
	menuLua->Call(5, 3);

	ILuaObject* LuaSomething1 = menuLua->GetReturn(0);

	if ( !LuaSomething1->isNil() && LuaSomething1->GetType() == GLua::TYPE_BOOL )
		something1 = LuaSomething1->GetBool();
		
	LuaSomething1->UnReference();

	ILuaObject* LuaSomething2 = menuLua->GetReturn(1);

	if ( !LuaSomething2->isNil() && LuaSomething2->GetType() == GLua::TYPE_STRING )
		something2 = LuaSomething2->GetString();
		
	LuaSomething2->UnReference();

	ILuaObject* LuaSomething3 = menuLua->GetReturn(2);

	if ( !LuaSomething3->isNil() && LuaSomething3->GetType() == GLua::TYPE_STRING )
		something2 = LuaSomething3->GetString();
		
	LuaSomething3->UnReference();

	hookCall->UnReference();
	hook->UnReference();

	return origStopProgressBar( gGUI, something1, something2, something3 );
}

int band( int x, int y ) {

	int z = 0;
	int i = 1;

	for ( int j = 0; j <= 31; j++ ) {

		if ( x % 2 == 1 && y % 2 == 1 )
			z += i;

		x = floor( (float) x/2 );
		y = floor( (float) y/2 );
		i *= 2;
	}

	return z;
}

DEFVFUNC_( origOnConnectToServer, void, ( IGameUI *gGUI, const char *game, int IP, int connectionPort, int queryPort ) );

void VFUNC newOnConnectToServer( IGameUI *gGUI, const char *game, int IP, int connectionPort, int queryPort ) {
	
	//char strIP[15];
	//sprintf( strIP, "%u.%u.%u.%u", band( IP / 2^24, 0xFF ), band( IP / 2^16, 0xFF ), band( IP / 2^8, 0xFF ), band( IP, 0xFF ) );
	ILuaObject* hook = _G->GetMember("hook");
	ILuaObject* hookCall = hook->GetMember("Call");

	menuLua->Push( hookCall );
		menuLua->Push("OnConnectToServer");
		menuLua->PushNil();
		menuLua->Push( (float) IP );
		//menuLua->Push( strIP );
		menuLua->Push( (float) connectionPort );
		menuLua->Push( (float) queryPort );
	menuLua->Call(5, 0);

	hookCall->UnReference();
	hook->UnReference();

	return origOnConnectToServer( gGUI, game, IP, connectionPort, queryPort );
}

DEFVFUNC_( origOnDisconnectFromServer, void, ( IGameUI *gGUI, uint8 eSteamLoginFailure ) );

void VFUNC newOnDisconnectFromServer( IGameUI *gGUI, uint8 eSteamLoginFailure ) {

	ILuaObject* hook = _G->GetMember("hook");
	ILuaObject* hookCall = hook->GetMember("Call");

	menuLua->Push(hookCall);
		menuLua->Push("OnDisconnectFromServer");
		menuLua->PushNil();
		menuLua->Push( (float) eSteamLoginFailure );
	menuLua->Call(3, 0);

	hookCall->UnReference();
	hook->UnReference();

	return origOnDisconnectFromServer( gGUI, eSteamLoginFailure );
}

DEFVFUNC_( origVoiceStatus, void, ( IBaseClientDLL *baseCLDLL, int entindex, qboolean bTalking ) );

void VFUNC newVoiceStatus( IBaseClientDLL *baseCLDLL, int entindex, qboolean bTalking ) {

	ILuaObject* hook = _G->GetMember("hook");
	ILuaObject* hookCall = hook->GetMember("Call");

	menuLua->Push(hookCall);
		menuLua->Push("VoiceStatus");
		menuLua->PushNil();
		menuLua->Push( (float) entindex );
		menuLua->Push( (bool) bTalking );
	menuLua->Call(4, 0);

	hookCall->UnReference();
	hook->UnReference();

	return origVoiceStatus( baseCLDLL, entindex, bTalking );
}

int Open( lua_State *L ) {
	_G = Lua()->Global(); 
	
	ILuaObject* AddCSLuaFile = _G->GetMember("AddCSLuaFile");
		bool IsOnServer = ( !AddCSLuaFile || !AddCSLuaFile->isFunction() );
	AddCSLuaFile->UnReference();
	
	if (IsOnServer) {
		Lua()->Error( "gmcl_extras can only be loaded on the client/menu!" );
	}
	
	
	CreateInterfaceFn ServerFactory = Sys_GetFactory( SERVER_LIB );
	if ( !ServerFactory )
		Lua()->Error( "gmcl_extras: Error getting " SERVER_LIB " factory.\n" );
	
	CreateInterfaceFn EngineFactory = Sys_GetFactory( ENGINE_LIB );
	if ( !EngineFactory )
		Lua()->Error( "gmcl_extras: Error getting " ENGINE_LIB " factory.\n" );
	
	CreateInterfaceFn ClientFactory = Sys_GetFactory( CLIENT_LIB );
	if ( !ClientFactory )
		Lua()->Error( "gmcl_extras: Error getting " CLIENT_LIB " factory.\n" );
	
	CreateInterfaceFn MaterialFactory = Sys_GetFactory( MATERIAL_LIB );
	if ( !MaterialFactory )
		Lua()->Error( "gmcl_extras: Error getting " MATERIAL_LIB " factory.\n" );
	
	CreateInterfaceFn FileSystemFactory = Sys_GetFactory( FILESYSTEM_LIB );
	if ( !FileSystemFactory )
		Lua()->Error( "gmcl_extras: Error getting " FILESYSTEM_LIB " factory.\n" );
	
	CreateInterfaceFn VSTDLibFactory = Sys_GetFactory( VSTD_LIB );
	if ( !VSTDLibFactory )
		Lua()->Error( "gmcl_extras: Error getting " VSTD_LIB " factory.\n" );	

	CreateInterfaceFn GameUIFactory = Sys_GetFactory( GAMEUI_LIB );
	if ( !GameUIFactory )
		Lua()->Error( "gmcl_extras: Error getting " GAMEUI_LIB " factory.\n" );

	CreateInterfaceFn ClientEngineFactory = Sys_GetFactory( STEAM_CLIENT_LIB );
	if ( !ClientEngineFactory )
		Lua()->Error( "gmcl_extras: Error getting " STEAM_CLIENT_LIB " factory.\n" );

	CreateInterfaceFn VGUI2Factory = Sys_GetFactory( VGUI2_LIB );
	if ( !VGUI2Factory )
		Lua()->Error( "gmcl_extras: Error getting " VGUI2_LIB " factory.\n" );

	g_ClientEngine = ( IClientEngine* )ClientEngineFactory( CLIENTENGINE_INTERFACE_VERSION, NULL );
	if ( !g_ClientEngine )
		Lua()->Error( "gmcl_extras: Error getting IClientEngine interface.\n" );

	g_SteamClient = ( ISteamClient012* )ClientEngineFactory( STEAMCLIENT_INTERFACE_VERSION_012, NULL );
	if ( !g_ClientEngine )
		Lua()->Error( "gmcl_extras: Error getting ISteamClient012 interface.\n" );

	g_EngineServer = ( IVEngineServer* )EngineFactory( INTERFACEVERSION_VENGINESERVER, NULL );
	if ( !g_EngineServer )
	{
		g_EngineServer = ( IVEngineServer* )EngineFactory( "VEngineServerGMod021", NULL );
		if ( !g_EngineServer )
			Lua()->Error( "gmcl_extras: Error getting IVEngineServer interface. <BETA>\n" );
	}
	
	g_EngineClient = ( IVEngineClient* )EngineFactory( VENGINE_CLIENT_INTERFACE_VERSION, NULL );
	if ( !g_EngineClient )
	{
		g_EngineClient = ( IVEngineClient* )EngineFactory( "VGMODEngineClient013", NULL );
		if ( !g_EngineClient )
			Lua()->Error( "gmcl_extras: Error getting IVEngineClient interface. <BETA>\n" );
	}
	
	g_Panel = (vgui::IPanel*) VGUI2Factory( VGUI_PANEL_INTERFACE_VERSION, NULL );
	if ( !g_Panel )
		Lua()->Error( "gmcl_extras: Error getting vgui::IPanel interface.\n" );

	g_VGui = (vgui::IVGui*) VGUI2Factory( VGUI_IVGUI_INTERFACE_VERSION, NULL);
	if ( !g_VGui )
		Lua()->Error( "gmcl_extras: Error getting vgui::IVGui interface.\n" );

	/*
	g_MaterialSystem = (IMaterialSystem*)MaterialFactory( MATERIAL_SYSTEM_INTERFACE_VERSION, NULL );
	if ( !g_MaterialSystem )
		Lua()->Error( "gmcl_extras: Error getting IMaterialSystem interface.\n" );
	
	g_Render = g_MaterialSystem->GetRenderContext();
	if ( !g_Render )
		Lua()->Error( "gmcl_extras: Error getting IMatRenderContext interface.\n" );
	*/
	
	g_ICvar = ( ICvar* )VSTDLibFactory( CVAR_INTERFACE_VERSION, NULL );
	if ( !g_ICvar )
		Lua()->Error( "gmcl_extras: Error getting ICvar interface.\n" );

	g_GameConsole = ( IGameConsole* )GameUIFactory( GAMECONSOLE_INTERFACE_VERSION, NULL );
	if ( !g_GameConsole )
		Lua()->Error( "gmcl_extras: Error getting IGameConsole interface.\n" );

	g_GameUI = ( IGameUI* )GameUIFactory( GAMEUI_INTERFACE_VERSION, NULL );
	if ( !g_GameUI )
	{
		g_GameUI = ( IGameUI* )GameUIFactory( "GMODGameUI011", NULL );
		if ( !g_GameUI )
			Lua()->Error( "gmcl_extras: Error getting IGameUI interface. <BETA>\n" );
	}

	g_GameUIFuncs = ( IGameUIFuncs* )EngineFactory( VENGINE_GAMEUIFUNCS_VERSION, NULL );
	if ( !g_GameUIFuncs )
		Lua()->Error( "gmcl_extras: Error getting IGameUIFuncs interface.\n" );

	g_BaseClientDLL = ( IBaseClientDLL* )ClientFactory( CLIENT_DLL_INTERFACE_VERSION, NULL );
	if ( !g_BaseClientDLL )
	{
		g_BaseClientDLL = ( IBaseClientDLL* )ClientFactory( "VGMODClient016", NULL );
		if ( !g_BaseClientDLL )
			Lua()->Error( "gmcl_extras: Error getting IBaseClientDLL interface. <BETA>\n" );
	}

	g_GameClientExports = ( IGameClientExports* )ClientFactory( GAMECLIENTEXPORTS_INTERFACE_VERSION, NULL );
	if ( !g_BaseClientDLL )
		Lua()->Error( "gmcl_extras: Error getting IGameClientExports interface.\n" );
	
	g_FileSystem = ( IFileSystem* )FileSystemFactory( FILESYSTEM_INTERFACE_VERSION, NULL );
	if ( !g_FileSystem )
	{
		g_FileSystem = ( IFileSystem* )FileSystemFactory( "VGModFileSystem019", NULL );
		if ( !g_FileSystem )
			Lua()->Error( "gmcl_extras: Error getting IFileSystem interface. <BETA>\n" );
	}

	g_ClientEntityList = ( IClientEntityList* )ClientFactory( VCLIENTENTITYLIST_INTERFACE_VERSION, NULL );
	if ( !g_ClientEntityList )
		Lua()->Error( "gmcl_extras: Error getting IClientEntityList interface.\n" );

	g_IVModelInfoClient = ( IVModelInfoClient* )EngineFactory( VMODELINFO_CLIENT_INTERFACE_VERSION, NULL );
	if ( !g_IVModelInfoClient )
		Lua()->Error( "gmcl_extras: Error getting IVModelInfoClient interface.\n" );

	g_EngineVGUI = ( IEngineVGui* )EngineFactory( VENGINE_VGUI_VERSION, NULL );
	if ( !g_EngineVGUI )
		Lua()->Error( "gmcl_extras: Error getting IEngineVGui interface.\n" );
		
	Lua()->NewGlobalTable("console");
		ILuaObject *console = _G->GetMember("console");
		console->SetMember( "PrintColor", PrintConsoleColor );
		console->SetMember( "IsVisible", IsConsoleVisible );
		console->SetMember( "Clear", ConsoleClear );
		console->SetMember( "Hide", ConsoleHide );
		console->SetMember( "Popup", ConsolePopup );
		console->SetMember( "ServerCommand", ServerCommand );
		console->SetMember( "Command", ClientCmd );
		console->SetMember( "UnrestrictedCommand", ClientCmd_Unrestricted );
		//console->SetMember( "SetParent", ConsoleSetParent );
	console->UnReference();

	_G->SetMember( "STEAM_FRIENDS_ALL", (float) k_EFriendFlagAll );
	_G->SetMember( "STEAM_FRIENDS_IGNORED_FRIEND", (float) k_EFriendFlagIgnoredFriend );		
	_G->SetMember( "STEAM_FRIENDS_IGNORED", (float) k_EFriendFlagIgnored );
	_G->SetMember( "STEAM_FRIENDS_REQUESTING_INFO", (float) k_EFriendFlagRequestingInfo );		
	_G->SetMember( "STEAM_FRIENDS_REQUESTING_FRIENDSHIP", (float) k_EFriendFlagRequestingFriendship );		
	_G->SetMember( "STEAM_FRIENDS_ON_GAME_SERVER", (float) k_EFriendFlagOnGameServer );
	_G->SetMember( "STEAM_FRIENDS_CLAN_MEMBER", (float) k_EFriendFlagClanMember );		
	_G->SetMember( "STEAM_FRIENDS_FRIENDSHIP_REQUESTED", (float) k_EFriendFlagFriendshipRequested );		
	_G->SetMember( "STEAM_FRIENDS_BLOCKED", (float) k_EFriendFlagBlocked );
	_G->SetMember( "STEAM_FRIENDS_NONE", (float) k_EFriendFlagNone );

	Lua()->NewGlobalTable("friends");
		ILuaObject *friends = _G->GetMember("friends");

		friends->SetMember( "GetPersonaName", GetPersonaName );
		friends->SetMember( "SetPersonaName", SetPersonaName );
		friends->SetMember( "GetFriendCount", GetFriendCount );

	friends->UnReference();

	Lua()->NewGlobalTable("client");
		ILuaObject *client = _G->GetMember("client");

		client->SetMember( "IsDedicatedServer", IsDedicatedServer );
		//client->SetMember( "GetGameDescription", GetGameDescription );

		client->SetMember( "SetMaxEntities", SetMaxEntities );
		client->SetMember( "GetMaxEntities", GetMaxEntities );
		client->SetMember( "GetHighestEntityIndex", GetHighestEntityIndex );
		client->SetMember( "NumberOfEntities", NumberOfEntities );
		client->SetMember( "WriteSaveGameScreenshotOfSize", WriteSaveGameScreenshotOfSize );
		client->SetMember( "GetLocalSteamID", GetLocalSteamID );

		//client->SetMember( "GetAbsOrigin", GetAbsOrigin );
		//client->SetMember( "GetAbsAngles", GetAbsAngles );

		client->SetMember( "IsSteamOverlayLoaded", IsSteamOverlayLoaded );

		client->SetMember( "GetNumTextures", GetNumTextures );
		client->SetMember( "GetAllTextures", GetAllTextures );

		client->SetMember( "LoadFilmmaker", LoadFilmmaker );
		client->SetMember( "UnloadFilmmaker", UnloadFilmmaker );

		client->SetMember( "GetVideoModes", GetVideoModes );

		client->SetMember( "Time", Time );

		// Player Stuff
		client->SetMember( "GetPlayerName", GetPlayerName );
		client->SetMember( "GetPlayerLogo", GetPlayerLogo );
		client->SetMember( "GetPlayerJingle", GetPlayerJingle );
		client->SetMember( "GetAllPlayers", GetAllPlayers );
		client->SetMember( "GetPlayerIndex", GetPlayerIndex );
		client->SetMember( "GetPlayerSteamID", GetPlayerSteamID );
		client->SetMember( "GetFriendID", GetFriendID );
		client->SetMember( "LocalPlayerUserID", LocalPlayerUserID );
		client->SetMember( "IsFakePlayer", IsFakePlayer );

		client->SetMember( "IsPlayerMuted", IsPlayerMuted );
		client->SetMember( "SetPlayerMuted", SetPlayerMuted );

		//client->SetMember( "IsPlayerAlive", IsPlayerAlive );

		//client->SetMember( "IsPlayerConnected", IsPlayerConnected );
		//client->SetMember( "GetPlayerPing", GetPlayerPing );
		//client->SetMember( "GetPlayerFrags", GetPlayerFrags );
		//client->SetMember( "GetPlayerDeaths", GetPlayerDeaths );
		//client->SetMember( "GetPlayerTeam", GetPlayerTeam );
		//client->SetMember( "GetPlayerHealth", GetPlayerHealth );
		
		client->SetMember( "SetEyeAngles", SetEyeAngles );
		client->SetMember( "GetEyeAngles", GetEyeAngles );

		client->SetMember( "GetLanguage", GetLanguage );

		// Game stuff
		client->SetMember( "GetMapName", GetMapName );
		client->SetMember( "GetMapVersion", GetMapVersion );

		client->SetMember( "GetMaxPlayers", GetMaxPlayers );
		client->SetMember( "GetScreenAspectRatio", GetScreenAspectRatio );
		client->SetMember( "GetKeyForBinding", GetKeyForBinding );
		client->SetMember( "GetIP", GetIP );
		client->SetMember( "IsConnected", IsConnected );
		client->SetMember( "IsConnectedToVACSecureServer", IsConnectedToVACSecureServer );
		
		client->SetMember( "GetAppID", GetAppID );
		client->SetMember( "GetEngineBuildNumber", GetEngineBuildNumber );
		client->SetMember( "GetProductVersionString", GetProductVersionString ); //Crash?
		client->SetMember( "IsDrawingLoadingImage", IsDrawingLoadingImage );
		client->SetMember( "IsInEditMode", IsInEditMode ); //Crash?

		client->SetMember( "IsInGame", IsInGame );
		client->SetMember( "IsLowViolence", IsLowViolence ); //Crash?
		client->SetMember( "IsHammerRunning", IsHammerRunning ); //Crash?
		client->SetMember( "IsPaused", IsPaused );
		client->SetMember( "IsPlayingDemo", IsPlayingDemo );
		client->SetMember( "IsPlayingTimeDemo", IsPlayingTimeDemo );
		client->SetMember( "IsRecordingDemo", IsRecordingDemo );
		client->SetMember( "IsTakingScreenshot", IsTakingScreenshot );

		client->SetMember( "HudText", HudText );
		
		// Render stuff
		client->SetMember( "SupportsHDR", SupportsHDR );
		client->SetMember( "GetDXSupportLevel", GetDXSupportLevel );

	client->UnReference();

	/*_G->SetMember( "SetParent", GetPanel );

	_G->SetMember( "PANEL_ROOT", (float) PANEL_ROOT );		
	_G->SetMember( "PANEL_GAMEUIDLL", (float) PANEL_GAMEUIDLL );		
	_G->SetMember( "PANEL_CLIENTDLL", (float) PANEL_CLIENTDLL );		
	_G->SetMember( "PANEL_TOOLS", (float) PANEL_TOOLS );
	_G->SetMember( "PANEL_INGAMESCREENS", (float) PANEL_INGAMESCREENS );
	_G->SetMember( "PANEL_GAMEDLL", (float) PANEL_GAMEDLL );
	_G->SetMember( "PANEL_CLIENTDLL_TOOLS", (float) PANEL_CLIENTDLL_TOOLS );*/

	Color Blue( 0, 162, 232, 255 );
	Color White( 255, 255, 255, 255 );

	ConColorMsg( Blue, "gmcl_extras" );
	ConColorMsg( White, ": Loaded!\n" );

	bool isMenuState = IsMenuState( L ); // My shitty menu detection
	
	if ( isMenuState ) {
		
		//DumpVTable("IBaseClientDLL", CLIENT_LIB, g_BaseClientDLL );
		
		menuLua = Lua(); // Used for the menu commands
		
		_G->SetMember( "MENU", true );
		//_G->SetMember( "RunString", RunString );

		Lua()->NewGlobalTable("menu");
			ILuaObject *menu = _G->GetMember("menu");
			menu->SetMember( "SetPanelOverride", SetMainMenuOverride );
			menu->SetMember( "IsVisible", IsMainMenuVisible );
			menu->SetMember( "Command", SendMainMenuCommand );
			menu->SetMember( "CloseMessageDialog", CloseMessageDialog );
		menu->UnReference();

		Lua()->NewGlobalTable("loading");
			ILuaObject *loading = _G->GetMember("loading");
			loading->SetMember( "SetPanelOverride", SetLoadingBackgroundDialog );
			loading->SetMember( "IsVisible", IsDrawingLoadingImage );
			loading->SetMember( "StartProgressBar", StartProgressBar );
			loading->SetMember( "ContinueProgressBar", ContinueProgressBar );
			loading->SetMember( "StopProgressBar", StopProgressBar );
			loading->SetMember( "SetProgressBarStatusText", SetProgressBarStatusText );
			loading->SetMember( "SetSecondaryProgressBar", SetSecondaryProgressBar );
			loading->SetMember( "SetSecondaryProgressBarText", SetSecondaryProgressBarText );
		loading->UnReference();

		HOOKVFUNC( g_BaseClientDLL, 33, origVoiceStatus, newVoiceStatus );
		HOOKVFUNC( g_GameUI, 41, origStopProgressBar, newStopProgressBar );
		HOOKVFUNC( g_GameUI, 39, origStartProgressBar, newStartProgressBar );
		HOOKVFUNC( g_GameUI, 34, origOnConfirmQuit, newOnConfirmQuit );
		HOOKVFUNC( g_GameUI, 33, origOnDisconnectFromServer, newOnDisconnectFromServer );
		HOOKVFUNC( g_GameUI, 30, origOnConnectToServer, newOnConnectToServer );

		_G->SetMember( "STEAMLOGINFAILURE_NONE", (float) STEAMLOGINFAILURE_NONE );		
		_G->SetMember( "STEAMLOGINFAILURE_BADTICKET", (float) STEAMLOGINFAILURE_BADTICKET );		
		_G->SetMember( "STEAMLOGINFAILURE_NOSTEAMLOGIN", (float) STEAMLOGINFAILURE_NOSTEAMLOGIN );		
		_G->SetMember( "STEAMLOGINFAILURE_VACBANNED", (float) STEAMLOGINFAILURE_VACBANNED );		
		_G->SetMember( "STEAMLOGINFAILURE_LOGGED_IN_ELSEWHERE", (float) STEAMLOGINFAILURE_LOGGED_IN_ELSEWHERE );

		lua_run_mn = new ConCommand("lua_run_mn", RunLuaMenu, "Run a Lua command", FCVAR_UNREGISTERED );
		g_ICvar->RegisterConCommand( lua_run_mn );
		
		lua_openscript_mn = new ConCommand("lua_openscript_mn", OpenLuaMenu, "Open a Lua script", FCVAR_UNREGISTERED );
		g_ICvar->RegisterConCommand( lua_openscript_mn );
		
		ConColorMsg( Blue, "gmcl_extras" );
		ConColorMsg( White, ": Menu mode..\n" );

	} else {
		ConColorMsg( Blue, "gmcl_extras" );
		ConColorMsg( White, ": Client mode..\n" );
	}
	
	return 0;
}

int Close(lua_State *L)
{
	if ( menuLua && menuLua->GetLuaState() == L ) { // It's the menu state shutting down, remove the commands/hooks

		UNHOOKVFUNC( g_BaseClientDLL, 33, origVoiceStatus );
		UNHOOKVFUNC( g_GameUI, 41, origStopProgressBar );
		UNHOOKVFUNC( g_GameUI, 39, origStartProgressBar );
		UNHOOKVFUNC( g_GameUI, 34, origOnConfirmQuit );
		UNHOOKVFUNC( g_GameUI, 33, origOnDisconnectFromServer );
		UNHOOKVFUNC( g_GameUI, 30, origOnConnectToServer );

		if ( lua_run_mn ) {
			g_ICvar->UnregisterConCommand( lua_run_mn );
			delete lua_run_mn;
		}
		if ( lua_openscript_mn ) {
			g_ICvar->UnregisterConCommand( lua_openscript_mn );
			delete lua_openscript_mn;
		}
	}
	return 0;
}