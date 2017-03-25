

#pragma comment (lib, "tier0.lib")
#pragma comment (lib, "tier1.lib")
#pragma comment (linker, "/NODEFAULTLIB:libcmt")

#define SERVER_LIB "server.dll"
#define ENGINE_LIB "engine.dll"
#define CLIENT_LIB "client.dll"
#define MATERIAL_LIB "materialsystem.dll"
#define FILESYSTEM_LIB "FileSystem_Stdio.dll" //"filesystem_steam.dll"
#define VSTD_LIB "vstdlib.dll"
#define GAMEUI_LIB "gameui.dll"
#define STEAM_CLIENT_LIB "steamclient.dll"
#define VGUI2_LIB "vgui2.dll"

#undef _UNICODE
#define CLIENT_DLL
#include <windows.h>

#include <ILuaModuleManager.h>

//String stuff
#include <string>
#include <sstream>

#include <vfnhook.h>



#include "icliententity.h"
#include "icliententitylist.h"

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


// NetChannel shit
#include "inetchannel.h"

#include "studio.h"

#include "steamworks.h"


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
//IGameResources *g_GameResorces = NULL;
vgui::IPanel *g_Panel = NULL;
vgui::IVGui *g_VGui = NULL;

ILuaInterface* ml_Lua = NULL;

Color Blue( 0, 162, 232, 255 );
Color White( 255, 255, 255, 255 );




inline const model_t* GetModel( lua_State* L, int i = 1 ) {
	const char* mdlName = ml_Lua->GetString( i );
	return g_IVModelInfoClient->FindOrLoadModel( mdlName );
}

inline int GetModelIndex( lua_State* L, int i = 1 ) {
	return g_IVModelInfoClient->GetModelIndex( ml_Lua->GetString(1) );
}

/*
inline ILuaObject* NewAngleObject( lua_State* L, QAngle& vec ) {
	ILuaObject* func = ml_Lua->GetGlobal("Angle");
	ml_Lua->Push( func );
	ml_Lua->Push( vec.x );
	ml_Lua->Push( vec.y );
	ml_Lua->Push( vec.z );
	
	//if( !ml_Lua->Call( 3, 1 ) ) {
	//	func->UnReference();
	//	return NULL;
	//}
	
	
	ml_Lua->Call(3,1);
	func->UnReference();
	
	return ml_Lua->GetReturn( 0 );
}

inline void PushAngle( lua_State* L, QAngle& ang ) {
	ILuaObject* obj = NewAngleObject( L, ang );
	ml_Lua->Push( obj );
	obj->UnReference();
}
*/


inline QAngle& GetAngle(int i = 1 ) {
	return *reinterpret_cast<QAngle*>( ml_Lua->GetUserData( i ) );
}

inline vgui::Panel* GetPanel( lua_State* L, int stackPos ) {
	return *(vgui::Panel **)ml_Lua->GetUserData( stackPos );
}

/*
inline ILuaObject *NewMaterialObject( lua_State* L, const char* path ) {
	ILuaObject* func = ml_Lua->GetGlobal("Material");

	ml_Lua->Push( func );
	ml_Lua->Push( path );
	
	
	//if( !ml_Lua->Call( 1, 1 ) ) {
	//	func->UnReference();
	//	return NULL;
	//}
	
	ml_Lua->Call(1,1);
	func->UnReference();
	
	return ml_Lua->GetReturn( 0 );
}
*/

/*inline ILuaObject *NewEntityObject( lua_State* L, CBaseEntity *pEntity ) {
	ILuaObject* func = ml_Lua->GetGlobal("Entity");

	ml_Lua->Push( func );
	ml_Lua->Push( (float) pEntity->entindex() );

	if( !ml_Lua->Call( 1, 1 ) ) {
		func->UnReference();
		return NULL;
	}

	return ml_Lua->GetReturn( 0 );
}

inline void PushEntity( lua_State* L, CBaseEntity *ent ) {
	ILuaObject* obj = NewEntityObject( L, ent );
	ml_Lua->Push( obj );
	obj->UnReference();
}


inline C_BaseEntity* GetEntity(int i = 1) {
	int entIndex = ml_Lua->GetNumber(i);
	
	return g_ClientEntityList->GetClientNetworkable( entIndex )->GetIClientUnknown()->GetBaseEntity();
}
*/


LUA_FUNCTION( SetMaxEntities )
{
	ml_Lua->CheckType(1, GLua::TYPE_NUMBER );
	g_ClientEntityList->SetMaxEntities( ml_Lua->GetInteger(1) );
	return 0;
}

LUA_FUNCTION( GetMaxEntities )
{
	ml_Lua->Push( (float) g_ClientEntityList->GetMaxEntities() );
	return 1;
}

LUA_FUNCTION( GetHighestEntityIndex )
{
	ml_Lua->Push( (float) g_ClientEntityList->GetHighestEntityIndex() );
	return 1;
}

LUA_FUNCTION( NumberOfEntities )
{
	bool bIncludeNonNetworkable = ml_Lua->GetBool(1) != NULL ? ml_Lua->GetBool(1) : false;
	ml_Lua->Push( (float) g_ClientEntityList->NumberOfEntities( bIncludeNonNetworkable ) );
	return 1;
}

LUA_FUNCTION( WriteSaveGameScreenshotOfSize )
{
	ml_Lua->CheckType(1, GLua::TYPE_STRING );
	ml_Lua->CheckType(2, GLua::TYPE_NUMBER );
	ml_Lua->CheckType(3, GLua::TYPE_NUMBER );

	g_BaseClientDLL->WriteSaveGameScreenshotOfSize( ml_Lua->GetString(1), ml_Lua->GetNumber(2), ml_Lua->GetNumber(3) );
	return 0;
}

LUA_FUNCTION( IsSteamOverlayLoaded )
{
    char szEventName[ 256 ] = { 0 };
    
    sprintf( szEventName, "SteamOverlayRunning_%u", g_EngineClient->GetAppID() );

    HANDLE hEvent = OpenEventA( EVENT_ALL_ACCESS, FALSE, szEventName );
    
    bool bReturn = ((DWORD)hEvent > 0);

	ml_Lua->Push( (bool) bReturn );

    CloseHandle( hEvent );

    return 1;
}  

LUA_FUNCTION( GetNumTextures )
{
	ml_Lua->CheckType(1, GLua::TYPE_STRING );
	studiohdr_t* sModel = g_IVModelInfoClient->GetStudiomodel( GetModel(L,1) );
	
	ml_Lua->Push( (float) sModel->numtextures );
	
	return 1;
}

LUA_FUNCTION( GetAllTextures )
{
	ml_Lua->CheckType(1, GLua::TYPE_STRING );

	studiohdr_t* pStudio = g_IVModelInfoClient->GetStudiomodel( GetModel(L,1) );
	
	ILuaObject* pTable = ml_Lua->GetNewTable();

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

	ml_Lua->Push( pTable );
	pTable->UnReference();

	return 1;
}

LUA_FUNCTION( IsConsoleVisible )
{
	ml_Lua->Push( (bool) g_EngineClient->Con_IsVisible() );
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
	ml_Lua->CheckType( 1, GLua::TYPE_PANEL );
	vgui::Panel *pPanel = *(vgui::Panel **)ml_Lua->GetUserData( 1 );
	vgui::VPANEL pVPanel = pPanel->GetVPanel();
	g_GameConsole->SetParent( pVPanel );
	return 0;
}

LUA_FUNCTION( ServerCommand )
{
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );
	g_EngineServer->ServerCommand( ml_Lua->GetString( 1 ) );
	return 0;
}

LUA_FUNCTION( ClientCmd )
{
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );
	const char* CmdStr = ml_Lua->GetString( 1 );
	g_EngineClient->ClientCmd( ( CmdStr != NULL ? CmdStr : "") );
	return 0;
}

LUA_FUNCTION( ClientCmd_Unrestricted )
{
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );
	const char* CmdStr = ml_Lua->GetString( 1 );
	g_EngineClient->ExecuteClientCmd( ( CmdStr != NULL ? CmdStr : "") );
	return 0;
}

LUA_FUNCTION ( GetAllPlayers )
{
	ILuaObject* AllPlayers = ml_Lua->GetNewTable();

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

	ml_Lua->Push( AllPlayers );

	AllPlayers->UnReference();

	return 1;
}


LUA_FUNCTION( GetAbsOrigin )
{
	ml_Lua->CheckType(1, GLua::TYPE_NUMBER );
	
	IClientEntity* pClient = g_ClientEntityList->GetClientEntity( ml_Lua->GetNumber(1) );
	const Vector &vec = pClient->GetAbsOrigin();
	//Vector &newVec( vec.x, vec.y, vec.z );
	//PushVector( L, newVec );
	
	ml_Lua->Push( (int)vec.x );
	ml_Lua->Push( (int)vec.y );
	ml_Lua->Push( (int)vec.z );
	
	return 3;
}


LUA_FUNCTION( GetAbsAngles )
{
	ml_Lua->CheckType(1, GLua::TYPE_NUMBER);
	
	IClientEntity* pClient = g_ClientEntityList->GetClientEntity( ml_Lua->GetNumber(1) );
	QAngle ang = pClient->GetAbsAngles();
	//QAngle &newAng( ang.x, ang.y, ang.z );
	//PushAngle( L, newAng );
	
	ml_Lua->Push( (int)ang.x );
	ml_Lua->Push( (int)ang.y );
	ml_Lua->Push( (int)ang.z );
	
	return 3;
}


LUA_FUNCTION( GetPlayerName )
{
	ml_Lua->CheckType(1, GLua::TYPE_NUMBER );
	
	player_info_t plyinfo;
	g_EngineClient->GetPlayerInfo( (int)g_EngineClient->GetPlayerForUserID( ml_Lua->GetNumber( 1 ) ), &plyinfo );
	
	const char* plname = plyinfo.name;
	ml_Lua->Push( (plname != NULL ? plname : "") );
	
	return 1;
}

LUA_FUNCTION( GetPlayerJingle )
{
	ml_Lua->CheckType(1, GLua::TYPE_NUMBER );

	int player = (int)g_EngineClient->GetPlayerForUserID( ml_Lua->GetNumber( 1 ) );

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

	ml_Lua->Push( ( fullsoundname != NULL ? fullsoundname : "") );

	return 1;
}

LUA_FUNCTION( GetPlayerLogo )
{
	ml_Lua->CheckType(1, GLua::TYPE_NUMBER );

	int player = (int)g_EngineClient->GetPlayerForUserID( ml_Lua->GetNumber( 1 ) );

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
		ml_Lua->ErrorNoHalt("Texture not found.\n");
		return 0; // not found
	}

	// Update the texture used by the material if need be.
	bool bFound = false;
	IMaterialVar *pMatVar = logo->FindVar("$basetexture", &bFound );
	if ( bFound && pMatVar ) {
		if ( pMatVar->GetTextureValue() != texture ) {
			pMatVar->SetTextureValue( texture );
			logo->RefreshPreservingMaterialVars();
		}
	}

	ILuaObject* meta = ml_Lua->GetMetaTable("IMaterial", GLua::TYPE_MATERIAL );
	ml_Lua->PushUserData( meta, logo ); // Would have liked to push the material, but it likes to crash me. Taken from gmcl_renderx <3
	meta->UnReference();
	//SAFE_UNREF( meta );
	*/

	ml_Lua->Push( ( texname != NULL ? texname : "") );

	return 1;

}

LUA_FUNCTION( GetPlayerIndex )
{
	ml_Lua->CheckType(1, GLua::TYPE_NUMBER );
	
	ml_Lua->Push( (float)g_EngineClient->GetPlayerForUserID( ml_Lua->GetNumber( 1 ) ) );
	
	return 1;
}

LUA_FUNCTION( GetPlayerSteamID )
{
	ml_Lua->CheckType(1, GLua::TYPE_NUMBER );
	
	player_info_t plyinfo;
	g_EngineClient->GetPlayerInfo( (int)g_EngineClient->GetPlayerForUserID( ml_Lua->GetNumber( 1 ) ), &plyinfo );
	
	unsigned int friendid = plyinfo.friendsID;
	unsigned int steamid = friendid / 2;

	std::stringstream formattedID;
	formattedID << "STEAM_0:";
	friendid % 2 == 1 ? formattedID << "1:" : formattedID << "0:";
	formattedID << steamid;

	ml_Lua->Push( formattedID.str().c_str() );

	return 1;
}

LUA_FUNCTION( GetLocalSteamID )
{
	HSteamPipe hPipe = g_SteamClient->CreateSteamPipe();
	HSteamUser hUser = g_SteamClient->ConnectToGlobalUser( hPipe );

	ISteamUser009 *SteamUser = ( ISteamUser009* )g_SteamClient->GetISteamUser( hUser, hPipe, STEAMUSER_INTERFACE_VERSION_009 );

	CSteamID steamid = SteamUser->GetSteamID();
	g_SteamClient->BReleaseSteamPipe(hPipe);

	ml_Lua->Push( steamid.Render() );

	return 1;
}

LUA_FUNCTION( GetFriendID )
{

	ml_Lua->CheckType(1, GLua::TYPE_NUMBER );
	
	player_info_t plyinfo;
	g_EngineClient->GetPlayerInfo( (int)g_EngineClient->GetPlayerForUserID( ml_Lua->GetNumber( 1 ) ), &plyinfo );
	
	unsigned int friendid = plyinfo.friendsID;

	std::stringstream formattedID;
	formattedID << friendid;

	ml_Lua->Push( formattedID.str().c_str() );

	return 1;
}

LUA_FUNCTION( LocalPlayerUserID )
{

	player_info_t plyinfo;
	g_EngineClient->GetPlayerInfo( (int)g_EngineClient->GetLocalPlayer(), &plyinfo );

	ml_Lua->Push( (float)plyinfo.userID );
	
	return 1;
}

LUA_FUNCTION( IsFakePlayer )
{
	ml_Lua->CheckType(1, GLua::TYPE_NUMBER );

	player_info_t plyinfo;
	g_EngineClient->GetPlayerInfo( (int)g_EngineClient->GetPlayerForUserID( ml_Lua->GetNumber( 1 ) ), &plyinfo );

	ml_Lua->Push( (bool)plyinfo.fakeplayer );
	return 1;
}

LUA_FUNCTION( GetKeyForBinding )
{
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );
	ml_Lua->Push( g_EngineClient->Key_LookupBinding( ml_Lua->GetString( 1 ) ) );
	return 1;
}

LUA_FUNCTION( GetScreenAspectRatio )
{
	ml_Lua->Push( (float) g_EngineClient->GetScreenAspectRatio() );
	return 1;
}

LUA_FUNCTION( GetMaxPlayers )
{
	ml_Lua->Push( (float) g_EngineClient->GetMaxClients() );
	return 1;
}

LUA_FUNCTION( GetMapName )
{
	const char* strMap = g_EngineClient->GetLevelName();
	ml_Lua->Push( ( strMap ? strMap : "") );
	return 1;
}

LUA_FUNCTION( GetMapVersion )
{
	ml_Lua->Push( (float) g_EngineClient->GetLevelVersion() );
	return 1;
}





LUA_FUNCTION( GetIP )
{
	INetChannelInfo* NetChan = g_EngineClient->GetNetChannelInfo();
	if ( NetChan != NULL ) {
		const char* ipAdress = NetChan->GetAddress();
		ml_Lua->Push( ipAdress != NULL ? ipAdress : "0.0.0.0");
	} else {
		ml_Lua->Push("0.0.0.0");
	}
	return 1;
}

LUA_FUNCTION( GetAppID )
{
	ml_Lua->Push( (float) g_EngineClient->GetAppID() );
	return 1;
}

LUA_FUNCTION( GetEngineBuildNumber )
{
	ml_Lua->Push( (float) g_EngineClient->GetEngineBuildNumber() );
	return 1;
}

LUA_FUNCTION( GetProductVersionString )
{
	const char* ProductVersion = g_EngineClient->GetProductVersionString();
	ml_Lua->Push( ProductVersion != NULL ? ProductVersion : "");
	return 1;
}

LUA_FUNCTION( IsHammerRunning )
{
	ml_Lua->Push( (bool) g_EngineClient->IsHammerRunning() );
	return 1;
}

LUA_FUNCTION( SupportsHDR )
{
	ml_Lua->Push( (bool) g_EngineClient->SupportsHDR() );
	return 1;
}

LUA_FUNCTION( GetDXSupportLevel )
{
	ml_Lua->Push( (float) g_EngineClient->GetDXSupportLevel() );
	return 1;
}




LUA_FUNCTION( SetEyeAngles )
{
	ml_Lua->CheckType( 1, GLua::TYPE_ANGLE );	
	g_EngineClient->SetViewAngles( GetAngle(1) );
	return 0;
}


/*
LUA_FUNCTION( GetEyeAngles )
{
	QAngle viewAng;
	g_EngineClient->GetViewAngles( viewAng );
	PushAngle( L, viewAng );
	return 1;
}

LUA_FUNCTION( GetEyePos )
{
	Vector *camPos;
	g_Render->GetWorldSpaceCameraPosition( camPos );
	Vector &newVec( camPos->x, camPos->y, camPos->z );
	PushVector( newVec );
	return 1;
}*/

LUA_FUNCTION( Time )
{
	ml_Lua->Push( (float) g_EngineServer->Time() );
	return 1;
}

LUA_FUNCTION( IsDrawingLoadingImage )
{
	ml_Lua->Push( (bool) g_EngineClient->IsDrawingLoadingImage() );
	return 1;
}

LUA_FUNCTION( IsConnected )
{
	ml_Lua->Push( (bool) g_EngineClient->IsConnected() );
	return 1;
}

LUA_FUNCTION( IsInEditMode )
{
	ml_Lua->Push( (bool) g_EngineClient->IsInEditMode() );
	return 1;
}

LUA_FUNCTION( IsInGame )
{
	ml_Lua->Push( (bool) g_EngineClient->IsInGame() );
	return 1;
}

LUA_FUNCTION( IsDedicatedServer )
{
	ml_Lua->Push( (bool) g_EngineServer->IsDedicatedServer() );
	return 1;
}

LUA_FUNCTION( IsLowViolence )
{
	ml_Lua->Push( (bool) g_EngineClient->IsLowViolence() );
	return 1;
}

LUA_FUNCTION( IsPaused )
{
	ml_Lua->Push( (bool) g_EngineClient->IsPaused() );
	return 1;
}

LUA_FUNCTION( IsPlayingDemo )
{
	ml_Lua->Push( (bool) g_EngineClient->IsPlayingDemo() );
	return 1;
}

LUA_FUNCTION( IsPlayingTimeDemo )
{
	ml_Lua->Push( (bool) g_EngineClient->IsPlayingTimeDemo() );
	return 1;
}

LUA_FUNCTION( IsRecordingDemo )
{
	ml_Lua->Push( (bool) g_EngineClient->IsRecordingDemo() );
	return 1;
}

LUA_FUNCTION( IsTakingScreenshot )
{
	ml_Lua->Push( (bool) g_EngineClient->IsTakingScreenshot() );
	return 1;
}

/*
LUA_FUNCTION( GetLocalPlayerModel )
{
	C_BasePlayer *pPlayer = C_BasePlayer::GetLocalPlayer();
	if ( pPlayer )
		ml_Lua->Push( pPlayer->GetModel() );
	else
		ml_Lua->Push("");
}
*/

LUA_FUNCTION( SetLoadingBackgroundDialog )
{
	ml_Lua->CheckType( 1, GLua::TYPE_PANEL );

	vgui::Panel *pPanel = *(vgui::Panel **)ml_Lua->GetUserData( 1 );
	vgui::VPANEL pVPanel = pPanel->GetVPanel();
	g_GameUI->SetLoadingBackgroundDialog( pVPanel );

	return 0;
}

LUA_FUNCTION( SetMainMenuOverride )
{
	ml_Lua->CheckType( 1, GLua::TYPE_PANEL );

	vgui::Panel *pPanel = *(vgui::Panel **)ml_Lua->GetUserData( 1 );
	vgui::VPANEL pVPanel = pPanel->GetVPanel();
	g_GameUI->SetMainMenuOverride( pVPanel );

	return 0;
}

LUA_FUNCTION( GetPanel )
{
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	ml_Lua->CheckType( 2, GLua::TYPE_PANEL );

	vgui::VPANEL root = g_EngineVGUI->GetPanel((VGuiPanel_t)ml_Lua->GetInteger(1));
	vgui::Panel *pPanel = *(vgui::Panel **)ml_Lua->GetUserData( 2 );
	//pPanel->SetParent( root );

	/*
	for(int i=0;i<vgui::ipanel()->GetChildCount(root);i++)
	{
		vgui::VPANEL child = vgui::ipanel()->GetChild(parent, i);
		if(Q_strcmp(name, vgui::ipanel()->GetName(child)) == 0) return
		child;
	}

	ILuaObject *pPanelMetaTable = ml_Lua->GetMetaTable("Panel", GLua::TYPE_PANEL );
		ml_Lua->PushUserData( pPanelMetaTable, &pPanel );
	pPanelMetaTable->UnReference();
	return 1;
	*/
	return 0;
}

LUA_FUNCTION( IsMainMenuVisible )
{
	ml_Lua->Push( g_GameUI->IsMainMenuVisible() );
	return 1;
}

LUA_FUNCTION( SendMainMenuCommand )
{
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );
	g_GameUI->SendMainMenuCommand( ml_Lua->GetString(1) );
	return 0;
}

LUA_FUNCTION( CloseMessageDialog )
{
	ml_Lua->CheckType( 1, GLua::TYPE_PANEL );

	vgui::Panel *pPanel = *(vgui::Panel **)ml_Lua->GetUserData( 1 );
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
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	g_GameUI->ContinueProgressBar( ml_Lua->GetNumber(1) );
	return 0;
}

LUA_FUNCTION( StopProgressBar )
{	
	ml_Lua->CheckType( 1, GLua::TYPE_BOOL );
	ml_Lua->CheckType( 2, GLua::TYPE_STRING );
	ml_Lua->CheckType( 3, GLua::TYPE_STRING );
	g_GameUI->StopProgressBar( ml_Lua->GetBool(1), ml_Lua->GetString(2), ml_Lua->GetString(3) );
	return 0;
}

LUA_FUNCTION( SetProgressBarStatusText )
{	
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );
	g_GameUI->SetProgressBarStatusText( ml_Lua->GetString(1) );
	return 0;
}

LUA_FUNCTION( SetSecondaryProgressBar )
{	
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	g_GameUI->SetSecondaryProgressBar( ml_Lua->GetNumber(1) );
	return 0;
}

LUA_FUNCTION( SetSecondaryProgressBarText )
{	
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );
	g_GameUI->SetSecondaryProgressBarText( ml_Lua->GetString(1) );
	return 0;
}

LUA_FUNCTION( IsPlayerMuted )
{
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	ml_Lua->Push( (bool) g_GameClientExports->IsPlayerGameVoiceMuted( ml_Lua->GetNumber( 1 ) ) );
	return 1;
}

LUA_FUNCTION( SetPlayerMuted )
{
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	ml_Lua->CheckType( 2, GLua::TYPE_BOOL );

	int plyIndex = ml_Lua->GetNumber( 1 );
	bool muteState = ml_Lua->GetBool( 2 );

	if ( muteState )
		g_GameClientExports->MutePlayerGameVoice( plyIndex );
	else
		g_GameClientExports->UnmutePlayerGameVoice( plyIndex );

	return 0;
}



/*
LUA_FUNCTION( GetPlayerHealth ) {
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	
	CBasePlayer *pEntity = ( CBasePlayer* ) GetEntity(1);
	
	if ( pEntity != NULL )
		ml_Lua->Push( (float) pEntity->GetHealth() );
	else
		ml_Lua->Push( (float) -1 );

	return 1;
}

LUA_FUNCTION( GetPlayerTeam ) {
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	
	CBasePlayer *pEntity = ( CBasePlayer* ) GetEntity(1);
	
	if ( pEntity != NULL )
		ml_Lua->Push( (float) pEntity->GetTeamNumber() );
	else
		ml_Lua->Push( (float) -1 );

	return 1;
}

LUA_FUNCTION( IsPlayerAlive ) {
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	
	CBasePlayer *pEntity = ( CBasePlayer* ) GetEntity(1);
	
	if ( pEntity != NULL )
		ml_Lua->Push( (bool) pEntity->IsAlive() );
	else
		ml_Lua->Push( false );

	return 1;
}

LUA_FUNCTION( GetPlayerEyePos ) {
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	
	CBasePlayer *pEntity = ( C_BasePlayer* ) GetEntity(1);
	
	if ( pEntity != NULL )
		PushVector( pEntity->EyePosition() );
	else
		PushVector( Vector(0,0,0) );

	return 1;
}

LUA_FUNCTION( GetPlayerEyeAngles ) {
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	
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
*/


/*
LUA_FUNCTION( IsPlayerConnected )
{
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	ml_Lua->Push( (bool) g_GameResorces->IsConnected( ml_Lua->GetNumber( 1 ) ) );
	return 1;
}

LUA_FUNCTION( GetPlayerPing )
{
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	ml_Lua->Push( (float) g_GameResorces->GetPing( ml_Lua->GetNumber( 1 ) ) );
	return 1;
}

LUA_FUNCTION( GetPlayerFrags )
{
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	ml_Lua->Push( (float) g_GameResorces->GetFrags( ml_Lua->GetNumber( 1 ) ) );
	return 1;
}

LUA_FUNCTION( GetPlayerDeaths )
{
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	ml_Lua->Push( (float) g_GameResorces->GetDeaths( ml_Lua->GetNumber( 1 ) ) );	
	return 1;
}

LUA_FUNCTION( GetPlayerTeam )
{
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	ml_Lua->Push( (float) g_GameResorces->GetTeam( ml_Lua->GetNumber( 1 ) ) );
	return 1;
}

LUA_FUNCTION( GetPlayerHealth )
{
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );
	
	IGameResources* g_GameResorces = GameResources();
	
	ml_Lua->Push( (float) g_GameResorces->GetHealth( ml_Lua->GetNumber( 1 ) ) );
	return 1;
}
*/


LUA_FUNCTION( IsConnectedToVACSecureServer )
{
	ml_Lua->Push( (bool) g_GameUIFuncs->IsConnectedToVACSecureServer() );
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

	ILuaObject* allVideoModes = ml_Lua->GetNewTable();

	int modeIndex = 0;

	for ( int i = 0; i < count; i++, plist++ )
	{
		bool isThisWide = IsWideScreen( plist->width, plist->height );
		if ( ( isThisWide && areWeWide ) || ( !isThisWide && !areWeWide ) )
		{
			modeIndex++;
			ILuaObject* widthHeight = ml_Lua->GetNewTable();
			widthHeight->SetMember("width", (float) plist->width );
			widthHeight->SetMember("height", (float) plist->height );
			allVideoModes->SetMember( modeIndex, widthHeight );
			widthHeight->UnReference();
		}
	}

	ml_Lua->Push( allVideoModes );
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
	ml_Lua->Push( uilanguage );
	return 1;
}

LUA_FUNCTION( HudText )
{
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );
	g_BaseClientDLL->HudText( ml_Lua->GetString(1) );
	return 0;
}

//Friends
LUA_FUNCTION( GetPersonaName )
{
	HSteamPipe hPipe = g_SteamClient->CreateSteamPipe();
	HSteamUser hUser = g_SteamClient->ConnectToGlobalUser( hPipe );

	ISteamFriends009 *SteamFriends = ( ISteamFriends009* )g_SteamClient->GetISteamFriends( hUser, hPipe, STEAMFRIENDS_INTERFACE_VERSION_009 );

	ml_Lua->Push( SteamFriends->GetPersonaName() );

	g_SteamClient->BReleaseSteamPipe(hPipe);
	return 1;
}

LUA_FUNCTION( SetPersonaName )
{
	ml_Lua->CheckType( 1, GLua::TYPE_STRING );

	HSteamPipe hPipe = g_SteamClient->CreateSteamPipe();
	HSteamUser hUser = g_SteamClient->ConnectToGlobalUser( hPipe );

	ISteamFriends009 *SteamFriends = ( ISteamFriends009* )g_SteamClient->GetISteamFriends( hUser, hPipe, STEAMFRIENDS_INTERFACE_VERSION_009 );

	SteamFriends->SetPersonaName( ml_Lua->GetString(1) );

	g_SteamClient->BReleaseSteamPipe(hPipe);
	return 0;
}

LUA_FUNCTION( GetFriendCount )
{
	ml_Lua->CheckType( 1, GLua::TYPE_NUMBER );

	HSteamPipe hPipe = g_SteamClient->CreateSteamPipe();
	HSteamUser hUser = g_SteamClient->ConnectToGlobalUser( hPipe );

	ISteamFriends009 *SteamFriends = ( ISteamFriends009* )g_SteamClient->GetISteamFriends( hUser, hPipe, STEAMFRIENDS_INTERFACE_VERSION_009 );

	ml_Lua->Push( (float) SteamFriends->GetFriendCount( ml_Lua->GetInteger(1) ) );

	g_SteamClient->BReleaseSteamPipe(hPipe);
	return 1;
}





int ScreenTransform(const Vector& point, Vector& screen) {
	// UNDONE: Clean this up some, handle off-screen vertices
	float w;
	const VMatrix &worldToScreen = g_EngineClient->WorldToScreenMatrix();

	screen.x = worldToScreen[0][0] * point[0] + worldToScreen[0][1] * point[1] + worldToScreen[0][2] * point[2] + worldToScreen[0][3];
	screen.y = worldToScreen[1][0] * point[0] + worldToScreen[1][1] * point[1] + worldToScreen[1][2] * point[2] + worldToScreen[1][3];
	//	z		 = worldToScreen[2][0] * point[0] + worldToScreen[2][1] * point[1] + worldToScreen[2][2] * point[2] + worldToScreen[2][3];
	w		 = worldToScreen[3][0] * point[0] + worldToScreen[3][1] * point[1] + worldToScreen[3][2] * point[2] + worldToScreen[3][3];

	// Just so we have something valid here
	screen.z = 0.0f;

	bool behind;
	if( w < 0.001f )
	{
		behind = true;
		screen.x *= 100000;
		screen.y *= 100000;
	}
	else
	{
		behind = false;
		float invw = 1.0f / w;
		screen.x *= invw;
		screen.y *= invw;
	}

	return behind;
}

bool GetVectorInScreenSpace( int W, int H, Vector pos, int& iX, int& iY ) {
	Vector screen;

	// Apply the offset, if one was specified
	/*if ( vecOffset != NULL )
		pos += *vecOffset;*/

	// Transform to screen space
	int iFacing = ScreenTransform( pos, screen );
	iX =  0.5 * screen[0] * W;
	iY = -0.5 * screen[1] * H;
	iX += 0.5 * W;
	iY += 0.5 * H;

	// Make sure the player's facing it
	if ( iFacing )
	{
		// We're actually facing away from the Target. Stomp the screen position.
		iX = -640;
		iY = -640;
		return false;
	}

	return true;
}


LUA_FUNCTION(ToScreen) {
	ml_Lua->CheckType(1, GLua::TYPE_NUMBER);
	ml_Lua->CheckType(2, GLua::TYPE_NUMBER);
	ml_Lua->CheckType(3, GLua::TYPE_NUMBER);
	ml_Lua->CheckType(4, GLua::TYPE_NUMBER);
	ml_Lua->CheckType(5, GLua::TYPE_NUMBER);
	
	Vector point(ml_Lua->GetNumber(1), ml_Lua->GetNumber(2), ml_Lua->GetNumber(3) );
	int x,y;
	
	bool isSuc = GetVectorInScreenSpace(ml_Lua->GetNumber(4), ml_Lua->GetNumber(5), point, x,y);
	
	//ScreenTransform(point,screen);
	
	ml_Lua->Push(x);
	ml_Lua->Push(y);
	ml_Lua->Push(isSuc);
	
	return 3;
}








DEFVFUNC_( origOnConfirmQuit, void, ( IGameUI *gGUI ) );

void VFUNC newOnConfirmQuit( IGameUI *gGUI ) {
	if (ml_Lua) {
		ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
		
		ml_Lua->Push( hookCall );
			ml_Lua->Push("OnConfirmQuit");
			ml_Lua->PushNil();
		ml_Lua->Call(2, 0);
		
		hookCall->UnReference();
		hook->UnReference();
	}
	
	return origOnConfirmQuit( gGUI );
}

DEFVFUNC_( origStartProgressBar, void, ( IGameUI *gGUI ) );

void VFUNC newStartProgressBar( IGameUI *gGUI ) {
	if (ml_Lua) {
		ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
		
		ml_Lua->Push( hookCall );
			ml_Lua->Push("OnLoadingStarted");
			ml_Lua->PushNil();
		ml_Lua->Call(2, 0);
		
		hookCall->UnReference();
		hook->UnReference();
	}
	return origStartProgressBar( gGUI );
}

DEFVFUNC_( origStopProgressBar, void, ( IGameUI *gGUI, bool, const char*, const char* ) );

void VFUNC newStopProgressBar( IGameUI *gGUI, bool something1, const char* something2, const char* something3 ) {
	if (ml_Lua) {
		ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
		
		ml_Lua->Push(hookCall);
			ml_Lua->Push("OnLoadingStopped");
			ml_Lua->PushNil();
			ml_Lua->Push( something1 );
			//ml_Lua->Push( something2 );
			//ml_Lua->Push( something3 );
		ml_Lua->Call(3,0);
		
		/*
		ILuaObject* LuaSomething1 = ml_Lua->GetReturn(0);
		
		if ( !LuaSomething1->isNil() && LuaSomething1->GetType() == GLua::TYPE_BOOL )
			something1 = LuaSomething1->GetBool();
			
		LuaSomething1->UnReference();
		
		ILuaObject* LuaSomething2 = ml_Lua->GetReturn(1);
		
		if ( !LuaSomething2->isNil() && LuaSomething2->GetType() == GLua::TYPE_STRING )
			something2 = LuaSomething2->GetString();
			
		LuaSomething2->UnReference();
		
		ILuaObject* LuaSomething3 = ml_Lua->GetReturn(2);
		
		if ( !LuaSomething3->isNil() && LuaSomething3->GetType() == GLua::TYPE_STRING )
			something2 = LuaSomething3->GetString();
			
		LuaSomething3->UnReference();
		*/
		hookCall->UnReference();
		hook->UnReference();
	}
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
	if (ml_Lua) {
		//char strIP[15];
		//sprintf( strIP, "%u.%u.%u.%u", band( IP / 2^24, 0xFF ), band( IP / 2^16, 0xFF ), band( IP / 2^8, 0xFF ), band( IP, 0xFF ) );
		ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
		
		ml_Lua->Push( hookCall );
			ml_Lua->Push("OnConnectToServer");
			ml_Lua->PushNil();
			ml_Lua->Push( (float) IP );
			//ml_Lua->Push( strIP );
			ml_Lua->Push( (float) connectionPort );
			ml_Lua->Push( (float) queryPort );
		ml_Lua->Call(5, 0);
		
		hookCall->UnReference();
		hook->UnReference();
	}
	return origOnConnectToServer( gGUI, game, IP, connectionPort, queryPort );
}

DEFVFUNC_( origOnDisconnectFromServer, void, ( IGameUI *gGUI, uint8 eSteamLoginFailure ) );

void VFUNC newOnDisconnectFromServer( IGameUI *gGUI, uint8 eSteamLoginFailure ) {
	if (ml_Lua) {
		ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
		
		ml_Lua->Push(hookCall);
			ml_Lua->Push("OnDisconnectFromServer");
			ml_Lua->PushNil();
			ml_Lua->Push( (float) eSteamLoginFailure );
		ml_Lua->Call(3, 0);
		
		hookCall->UnReference();
		hook->UnReference();
	}
	return origOnDisconnectFromServer( gGUI, eSteamLoginFailure );
}

DEFVFUNC_( origVoiceStatus, void, ( IBaseClientDLL *baseCLDLL, int entindex, qboolean bTalking ) );

void VFUNC newVoiceStatus( IBaseClientDLL *baseCLDLL, int entindex, qboolean bTalking ) {
	if (ml_Lua) {
		ILuaObject* hook = ml_Lua->GetGlobal("hook");
		ILuaObject* hookCall = hook->GetMember("Call");
		
		ml_Lua->Push(hookCall);
			ml_Lua->Push("VoiceStatus");
			ml_Lua->PushNil();
			ml_Lua->Push( (float) entindex );
			ml_Lua->Push( (bool) bTalking );
		ml_Lua->Call(4, 0);
		
		hookCall->UnReference();
		hook->UnReference();
	}
	return origVoiceStatus( baseCLDLL, entindex, bTalking );
}



GMOD_MODULE( Open, Close );

int Open( lua_State *L ) {
	ml_Lua = Lua(); 
	
	CreateInterfaceFn ServerFactory = Sys_GetFactory( SERVER_LIB );
	if ( !ServerFactory )
		ml_Lua->Error("gmcl_extras: Error getting " SERVER_LIB " factory.\n");
	
	CreateInterfaceFn EngineFactory = Sys_GetFactory( ENGINE_LIB );
	if ( !EngineFactory )
		ml_Lua->Error("gmcl_extras: Error getting " ENGINE_LIB " factory.\n");
	
	CreateInterfaceFn ClientFactory = Sys_GetFactory( CLIENT_LIB );
	if ( !ClientFactory )
		ml_Lua->Error("gmcl_extras: Error getting " CLIENT_LIB " factory.\n");
	
	CreateInterfaceFn MaterialFactory = Sys_GetFactory( MATERIAL_LIB );
	if ( !MaterialFactory )
		ml_Lua->Error("gmcl_extras: Error getting " MATERIAL_LIB " factory.\n");
	
	CreateInterfaceFn FileSystemFactory = Sys_GetFactory( FILESYSTEM_LIB );
	if ( !FileSystemFactory )
		ml_Lua->Error("gmcl_extras: Error getting " FILESYSTEM_LIB " factory.\n");
	
	CreateInterfaceFn VSTDLibFactory = Sys_GetFactory( VSTD_LIB );
	if ( !VSTDLibFactory )
		ml_Lua->Error("gmcl_extras: Error getting " VSTD_LIB " factory.\n");	

	CreateInterfaceFn GameUIFactory = Sys_GetFactory( GAMEUI_LIB );
	if ( !GameUIFactory )
		ml_Lua->Error("gmcl_extras: Error getting " GAMEUI_LIB " factory.\n");

	CreateInterfaceFn ClientEngineFactory = Sys_GetFactory( STEAM_CLIENT_LIB );
	if ( !ClientEngineFactory )
		ml_Lua->Error("gmcl_extras: Error getting " STEAM_CLIENT_LIB " factory.\n");

	CreateInterfaceFn VGUI2Factory = Sys_GetFactory( VGUI2_LIB );
	if ( !VGUI2Factory )
		ml_Lua->Error("gmcl_extras: Error getting " VGUI2_LIB " factory.\n");

	g_ClientEngine = ( IClientEngine* )ClientEngineFactory( CLIENTENGINE_INTERFACE_VERSION, NULL );
	if ( !g_ClientEngine )
		ml_Lua->Error("gmcl_extras: Error getting IClientEngine interface.\n");

	g_SteamClient = ( ISteamClient012* )ClientEngineFactory( STEAMCLIENT_INTERFACE_VERSION_012, NULL );
	if ( !g_ClientEngine )
		ml_Lua->Error("gmcl_extras: Error getting ISteamClient012 interface.\n");

	g_EngineServer = ( IVEngineServer* )EngineFactory( INTERFACEVERSION_VENGINESERVER, NULL );
	if ( !g_EngineServer )
	{
		g_EngineServer = ( IVEngineServer* )EngineFactory("VEngineServerGMod021", NULL );
		if ( !g_EngineServer )
			ml_Lua->Error("gmcl_extras: Error getting IVEngineServer interface. <BETA>\n");
	}
	
	g_EngineClient = ( IVEngineClient* )EngineFactory( VENGINE_CLIENT_INTERFACE_VERSION, NULL );
	if ( !g_EngineClient )
	{
		g_EngineClient = ( IVEngineClient* )EngineFactory("VGMODEngineClient013", NULL );
		if ( !g_EngineClient )
			ml_Lua->Error("gmcl_extras: Error getting IVEngineClient interface. <BETA>\n");
	}
	
	g_Panel = (vgui::IPanel*) VGUI2Factory( VGUI_PANEL_INTERFACE_VERSION, NULL );
	if ( !g_Panel )
		ml_Lua->Error("gmcl_extras: Error getting vgui::IPanel interface.\n");

	g_VGui = (vgui::IVGui*) VGUI2Factory( VGUI_IVGUI_INTERFACE_VERSION, NULL);
	if ( !g_VGui )
		ml_Lua->Error("gmcl_extras: Error getting vgui::IVGui interface.\n");
		
	g_ICvar = ( ICvar* )VSTDLibFactory( CVAR_INTERFACE_VERSION, NULL );
	if ( !g_ICvar )
		ml_Lua->Error("gmcl_extras: Error getting ICvar interface.\n");

	g_GameConsole = ( IGameConsole* )GameUIFactory( GAMECONSOLE_INTERFACE_VERSION, NULL );
	if ( !g_GameConsole )
		ml_Lua->Error("gmcl_extras: Error getting IGameConsole interface.\n");

	g_GameUI = ( IGameUI* )GameUIFactory( GAMEUI_INTERFACE_VERSION, NULL );
	if ( !g_GameUI )
	{
		g_GameUI = ( IGameUI* )GameUIFactory("GMODGameUI011", NULL );
		if ( !g_GameUI )
			ml_Lua->Error("gmcl_extras: Error getting IGameUI interface. <BETA>\n");
	}

	g_GameUIFuncs = ( IGameUIFuncs* )EngineFactory( VENGINE_GAMEUIFUNCS_VERSION, NULL );
	if ( !g_GameUIFuncs )
		ml_Lua->Error("gmcl_extras: Error getting IGameUIFuncs interface.\n");

	g_BaseClientDLL = ( IBaseClientDLL* )ClientFactory("VClient017", NULL );
	if ( !g_BaseClientDLL )
	{
		g_BaseClientDLL = ( IBaseClientDLL* )ClientFactory("VGMODClient016", NULL );
		if ( !g_BaseClientDLL )
			ml_Lua->Error("gmcl_extras: Error getting IBaseClientDLL interface. <BETA>\n");
	}

	g_GameClientExports = ( IGameClientExports* )ClientFactory( GAMECLIENTEXPORTS_INTERFACE_VERSION, NULL );
	if ( !g_BaseClientDLL )
		ml_Lua->Error("gmcl_extras: Error getting IGameClientExports interface.\n");
	
	g_FileSystem = ( IFileSystem* )FileSystemFactory("VFileSystem022", NULL );
	if ( !g_FileSystem ) {
		ml_Lua->Error("gmcl_extras: Error getting VFileSystem022 interface.\n");
	}
	
	g_ClientEntityList = ( IClientEntityList* )ClientFactory( VCLIENTENTITYLIST_INTERFACE_VERSION, NULL );
	if ( !g_ClientEntityList )
		ml_Lua->Error("gmcl_extras: Error getting IClientEntityList interface.\n");

	g_IVModelInfoClient = ( IVModelInfoClient* )EngineFactory( VMODELINFO_CLIENT_INTERFACE_VERSION, NULL );
	if ( !g_IVModelInfoClient )
		ml_Lua->Error("gmcl_extras: Error getting IVModelInfoClient interface.\n");

	g_EngineVGUI = ( IEngineVGui* )EngineFactory( VENGINE_VGUI_VERSION, NULL );
	if ( !g_EngineVGUI )
		ml_Lua->Error("gmcl_extras: Error getting IEngineVGui interface.\n");
		
	
	ml_Lua->NewGlobalTable("console");
		ILuaObject *console = ml_Lua->GetGlobal("console");
		console->SetMember("IsVisible", IsConsoleVisible );
		console->SetMember("Clear", ConsoleClear );
		console->SetMember("Hide", ConsoleHide );
		console->SetMember("Popup", ConsolePopup );
		console->SetMember("ServerCommand", ServerCommand );
		console->SetMember("Command", ClientCmd );
		console->SetMember("UnrestrictedCommand", ClientCmd_Unrestricted );
		//console->SetMember("SetParent", ConsoleSetParent );
	console->UnReference();
	
	ml_Lua->SetGlobal("STEAM_FRIENDS_ALL", (float) k_EFriendFlagAll );
	ml_Lua->SetGlobal("STEAM_FRIENDS_IGNORED_FRIEND", (float) k_EFriendFlagIgnoredFriend );		
	ml_Lua->SetGlobal("STEAM_FRIENDS_IGNORED", (float) k_EFriendFlagIgnored );
	ml_Lua->SetGlobal("STEAM_FRIENDS_REQUESTING_INFO", (float) k_EFriendFlagRequestingInfo );		
	ml_Lua->SetGlobal("STEAM_FRIENDS_REQUESTING_FRIENDSHIP", (float) k_EFriendFlagRequestingFriendship );		
	ml_Lua->SetGlobal("STEAM_FRIENDS_ON_GAME_SERVER", (float) k_EFriendFlagOnGameServer );
	ml_Lua->SetGlobal("STEAM_FRIENDS_CLAN_MEMBER", (float) k_EFriendFlagClanMember );		
	ml_Lua->SetGlobal("STEAM_FRIENDS_FRIENDSHIP_REQUESTED", (float) k_EFriendFlagFriendshipRequested );		
	ml_Lua->SetGlobal("STEAM_FRIENDS_BLOCKED", (float) k_EFriendFlagBlocked );
	ml_Lua->SetGlobal("STEAM_FRIENDS_NONE", (float) k_EFriendFlagNone );
	
	ml_Lua->NewGlobalTable("friends");
		ILuaObject *friends = ml_Lua->GetGlobal("friends");

		friends->SetMember("GetPersonaName", GetPersonaName );
		friends->SetMember("SetPersonaName", SetPersonaName );
		friends->SetMember("GetFriendCount", GetFriendCount );
	friends->UnReference();
	
	ml_Lua->NewGlobalTable("client");
		ILuaObject *client = ml_Lua->GetGlobal("client");

		client->SetMember("IsDedicatedServer", IsDedicatedServer );
		//client->SetMember("GetGameDescription", GetGameDescription );

		client->SetMember("SetMaxEntities", SetMaxEntities );
		client->SetMember("GetMaxEntities", GetMaxEntities );
		client->SetMember("GetHighestEntityIndex", GetHighestEntityIndex );
		client->SetMember("NumberOfEntities", NumberOfEntities );
		client->SetMember("WriteSaveGameScreenshotOfSize", WriteSaveGameScreenshotOfSize );
		client->SetMember("GetLocalSteamID", GetLocalSteamID );
		
		client->SetMember("GetAbsOrigin", GetAbsOrigin );
		client->SetMember("GetAbsAngles", GetAbsAngles );
		client->SetMember("ToScreen", ToScreen);
		
		client->SetMember("IsSteamOverlayLoaded", IsSteamOverlayLoaded );

		client->SetMember("GetNumTextures", GetNumTextures );
		client->SetMember("GetAllTextures", GetAllTextures );

		client->SetMember("LoadFilmmaker", LoadFilmmaker );
		client->SetMember("UnloadFilmmaker", UnloadFilmmaker );

		client->SetMember("GetVideoModes", GetVideoModes );

		client->SetMember("Time", Time );

		// Player Stuff
		client->SetMember("GetPlayerName", GetPlayerName );
		client->SetMember("GetPlayerLogo", GetPlayerLogo );
		client->SetMember("GetPlayerJingle", GetPlayerJingle );
		client->SetMember("GetAllPlayers", GetAllPlayers );
		client->SetMember("GetPlayerIndex", GetPlayerIndex );
		client->SetMember("GetPlayerSteamID", GetPlayerSteamID );
		client->SetMember("GetFriendID", GetFriendID );
		client->SetMember("LocalPlayerUserID", LocalPlayerUserID );
		client->SetMember("IsFakePlayer", IsFakePlayer );

		client->SetMember("IsPlayerMuted", IsPlayerMuted );
		client->SetMember("SetPlayerMuted", SetPlayerMuted );

		//client->SetMember("IsPlayerAlive", IsPlayerAlive );

		//client->SetMember("IsPlayerConnected", IsPlayerConnected );
		//client->SetMember("GetPlayerPing", GetPlayerPing );
		//client->SetMember("GetPlayerFrags", GetPlayerFrags );
		//client->SetMember("GetPlayerDeaths", GetPlayerDeaths );
		//client->SetMember("GetPlayerTeam", GetPlayerTeam );
		//client->SetMember("GetPlayerHealth", GetPlayerHealth );
		
		client->SetMember("SetEyeAngles", SetEyeAngles );
		//client->SetMember("GetEyeAngles", GetEyeAngles );

		client->SetMember("GetLanguage", GetLanguage );

		// Game stuff
		client->SetMember("GetMapName", GetMapName );
		client->SetMember("GetMapVersion", GetMapVersion );

		client->SetMember("GetMaxPlayers", GetMaxPlayers );
		client->SetMember("GetScreenAspectRatio", GetScreenAspectRatio );
		client->SetMember("GetKeyForBinding", GetKeyForBinding );
		client->SetMember("GetIP", GetIP );
		client->SetMember("IsConnected", IsConnected );
		client->SetMember("IsConnectedToVACSecureServer", IsConnectedToVACSecureServer );
		
		client->SetMember("GetAppID", GetAppID );
		client->SetMember("GetEngineBuildNumber", GetEngineBuildNumber );
		client->SetMember("GetProductVersionString", GetProductVersionString ); //Crash?
		client->SetMember("IsDrawingLoadingImage", IsDrawingLoadingImage );
		client->SetMember("IsInEditMode", IsInEditMode ); //Crash?

		client->SetMember("IsInGame", IsInGame );
		client->SetMember("IsLowViolence", IsLowViolence ); //Crash?
		client->SetMember("IsHammerRunning", IsHammerRunning ); //Crash?
		client->SetMember("IsPaused", IsPaused );
		client->SetMember("IsPlayingDemo", IsPlayingDemo );
		client->SetMember("IsPlayingTimeDemo", IsPlayingTimeDemo );
		client->SetMember("IsRecordingDemo", IsRecordingDemo );
		client->SetMember("IsTakingScreenshot", IsTakingScreenshot );

		client->SetMember("HudText", HudText );
		
		// Render stuff
		client->SetMember("SupportsHDR", SupportsHDR );
		client->SetMember("GetDXSupportLevel", GetDXSupportLevel );
	client->UnReference();
	
	ml_Lua->SetGlobal("MENU", true );
	
	ml_Lua->NewGlobalTable("menu");
		ILuaObject *menu = ml_Lua->GetGlobal("menu");
		menu->SetMember("SetPanelOverride", SetMainMenuOverride );
		menu->SetMember("IsVisible", IsMainMenuVisible );
		menu->SetMember("Command", SendMainMenuCommand );
		menu->SetMember("CloseMessageDialog", CloseMessageDialog );
	menu->UnReference();
	
	
	ml_Lua->NewGlobalTable("loading");
		ILuaObject *loading = ml_Lua->GetGlobal("loading");
		loading->SetMember("SetPanelOverride", SetLoadingBackgroundDialog );
		loading->SetMember("IsVisible", IsDrawingLoadingImage );
		loading->SetMember("StartProgressBar", StartProgressBar );
		loading->SetMember("ContinueProgressBar", ContinueProgressBar );
		loading->SetMember("StopProgressBar", StopProgressBar );
		loading->SetMember("SetProgressBarStatusText", SetProgressBarStatusText );
		loading->SetMember("SetSecondaryProgressBar", SetSecondaryProgressBar );
		loading->SetMember("SetSecondaryProgressBarText", SetSecondaryProgressBarText );
	loading->UnReference();
	
	
	
	HOOKVFUNC( g_BaseClientDLL, 33, origVoiceStatus, newVoiceStatus );
	HOOKVFUNC( g_GameUI, 41, origStopProgressBar, newStopProgressBar );
	HOOKVFUNC( g_GameUI, 39, origStartProgressBar, newStartProgressBar );
	HOOKVFUNC( g_GameUI, 34, origOnConfirmQuit, newOnConfirmQuit );
	HOOKVFUNC( g_GameUI, 33, origOnDisconnectFromServer, newOnDisconnectFromServer );
	HOOKVFUNC( g_GameUI, 30, origOnConnectToServer, newOnConnectToServer );
	
	ml_Lua->SetGlobal("STEAMLOGINFAILURE_NONE", (float) STEAMLOGINFAILURE_NONE );		
	ml_Lua->SetGlobal("STEAMLOGINFAILURE_BADTICKET", (float) STEAMLOGINFAILURE_BADTICKET );		
	ml_Lua->SetGlobal("STEAMLOGINFAILURE_NOSTEAMLOGIN", (float) STEAMLOGINFAILURE_NOSTEAMLOGIN );		
	ml_Lua->SetGlobal("STEAMLOGINFAILURE_VACBANNED", (float) STEAMLOGINFAILURE_VACBANNED );		
	ml_Lua->SetGlobal("STEAMLOGINFAILURE_LOGGED_IN_ELSEWHERE", (float) STEAMLOGINFAILURE_LOGGED_IN_ELSEWHERE );
	
	
	ConColorMsg( Blue, "gmcl_extras");
	ConColorMsg( White, ": Loaded!\n");
	ConColorMsg( Blue, "gmcl_extras");
	ConColorMsg( White, ": Menu mode..\n");
	return 0;
}


int Close(lua_State *L) {
	UNHOOKVFUNC( g_BaseClientDLL, 33, origVoiceStatus );
	UNHOOKVFUNC( g_GameUI, 41, origStopProgressBar );
	UNHOOKVFUNC( g_GameUI, 39, origStartProgressBar );
	UNHOOKVFUNC( g_GameUI, 34, origOnConfirmQuit );
	UNHOOKVFUNC( g_GameUI, 33, origOnDisconnectFromServer );
	UNHOOKVFUNC( g_GameUI, 30, origOnConnectToServer );
	
	return 0;
}








