
/*
	=== gmcl_replicator ===
	
	Credits:
		. Blackops (gm_cvar3)
		. haza55 (gm_cvar2)
		. HeX
*/


#undef _UNICODE

#pragma once
#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment(lib, "vstdlib.lib")
#pragma comment(lib, "tier0.lib")
#pragma comment(lib, "tier1.lib")

//CVar2
#define _RETAIL
#define GAME_DLL
#define CLIENT_DLL
#define WIN32_LEAN_AND_MEAN

//CVar2
#include <interface.h>
#include "bitbuf.h"

#include <windows.h>
#include <cbase.h>
#include <string.h>
#include <iostream>
#include <fstream>

//Replicator
#include <convar.h>
#include <icvar.h>
#include <tier1.h>

#include "GMLuaModule.h"


ICvar *g_ICvar 				= NULL;
ILuaInterface* ml_Lua		= NULL;
IVEngineClient*	g_pEngine	= NULL;


LUA_FUNCTION( GetAllCvars )
{
	ConCommandBase *conCmds = g_ICvar->GetCommands();

	ILuaObject* conVarTable = ml_Lua->GetNewTable();

	int i = 1;
	while( conCmds )
	{
		if ( !conCmds->IsCommand() ) {
			conVarTable->SetMember( i, conCmds->GetName() );
			i++;
		}
		conCmds = conCmds->GetNext();
	}

	ml_Lua->Push( conVarTable );

	conVarTable->UnReference();

	return 1;
}

LUA_FUNCTION( GetAllCmds )
{
	ConCommandBase *conCmds = g_ICvar->GetCommands();

	ILuaObject* conVarTable = ml_Lua->GetNewTable();

	int i = 1;
	while( conCmds )
	{
		if ( conCmds->IsCommand() ) {
			conVarTable->SetMember( i, conCmds->GetName() );
			i++;
		}
		conCmds = conCmds->GetNext();
	}

	ml_Lua->Push( conVarTable );

	conVarTable->UnReference();

	return 1;
}

LUA_FUNCTION( SetConVarValue )
{
	ml_Lua->CheckType( 1, GLua::TYPE_CONVAR );

	int argType = ml_Lua->GetType(2);

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData( 1 );

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	switch( argType ) // From haza's cvar2..
	{
		case GLua::TYPE_NUMBER:
			cvar->SetValue( (float) ml_Lua->GetDouble( 2 ) );
			break;
		case GLua::TYPE_BOOL:
			cvar->SetValue( ml_Lua->GetBool( 2 ) ? 1 : 0 );
			break;
		case GLua::TYPE_STRING:
			cvar->SetValue( ml_Lua->GetString( 2 ) );
			break;
		default:
			ml_Lua->Error("Argument #2 invalid!\n");
			break;
	}

	return 0;
}

LUA_FUNCTION( GetConVarBool )
{
	ml_Lua->CheckType( 1, GLua::TYPE_CONVAR );

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData( 1 );

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	ml_Lua->Push( (bool) cvar->GetBool() );

	return 1;
}

LUA_FUNCTION( GetConVarDefault )
{
	ml_Lua->CheckType( 1, GLua::TYPE_CONVAR );

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData( 1 );

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	ml_Lua->Push( cvar->GetDefault() );

	return 1;
}

LUA_FUNCTION( GetConVarFloat )
{
	ml_Lua->CheckType( 1, GLua::TYPE_CONVAR );

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData( 1 );

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	ml_Lua->Push( (float) cvar->GetFloat() );

	return 1;
}

LUA_FUNCTION( GetConVarInt )
{
	ml_Lua->CheckType( 1, GLua::TYPE_CONVAR );

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData( 1 );

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	ml_Lua->Push( (float) cvar->GetInt() );

	return 1;
}

LUA_FUNCTION( GetConVarName )
{
	ml_Lua->CheckType( 1, GLua::TYPE_CONVAR );

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData( 1 );

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	ml_Lua->Push( cvar->GetName() );

	return 1;
}

LUA_FUNCTION( SetConVarName )
{
	ml_Lua->CheckType(1, GLua::TYPE_CONVAR);
	ml_Lua->CheckType(2, GLua::TYPE_STRING);

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData(1);

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	cvar->m_pszName = new char[50];
	strcpy( (char*)cvar->m_pszName, ml_Lua->GetString(2) );

	return 0;
}

LUA_FUNCTION( GetConVarString )
{
	ml_Lua->CheckType( 1, GLua::TYPE_CONVAR );

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData( 1 );

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	ml_Lua->Push( cvar->GetString() );

	return 1;
}

LUA_FUNCTION( SetConVarFlags )
{
	ml_Lua->CheckType(1, GLua::TYPE_CONVAR);
	ml_Lua->CheckType(2, GLua::TYPE_NUMBER);

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData(1);

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	cvar->m_nFlags = ml_Lua->GetInteger(2);

	return 0;
}

LUA_FUNCTION( GetConVarFlags )
{
	ml_Lua->CheckType(1, GLua::TYPE_CONVAR);

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData(1);

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	ml_Lua->Push((float)cvar->m_nFlags);

	return 1;
}

LUA_FUNCTION( ConVarHasFlag )
{
	ml_Lua->CheckType(1, GLua::TYPE_CONVAR);
	ml_Lua->CheckType(2, GLua::TYPE_NUMBER);

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData(1);

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	ml_Lua->Push( (bool) cvar->IsFlagSet( ml_Lua->GetInteger( 2 ) ) );

	return 1;
}

LUA_FUNCTION( SetConVarHelpText )
{
	ml_Lua->CheckType(1, GLua::TYPE_CONVAR);
	ml_Lua->CheckType(2, GLua::TYPE_STRING);

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData(1);

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	cvar->m_pszHelpString = new char[100];
	strcpy( (char*)cvar->m_pszHelpString, ml_Lua->GetString(2) );

	return 0;
}

LUA_FUNCTION( GetConVarHelpText )
{
	ml_Lua->CheckType(1, GLua::TYPE_CONVAR);

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData(1);

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	ml_Lua->Push( cvar->m_pszHelpString );

	return 1;
}

LUA_FUNCTION( ResetConVarValue )
{
	ml_Lua->CheckType(1, GLua::TYPE_CONVAR);

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData(1);

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	cvar->Revert();

	return 0;
}

LUA_FUNCTION( GetConVarMin )
{
	ml_Lua->CheckType(1, GLua::TYPE_CONVAR);

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData(1);

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	float min;
	bool hasMin = cvar->GetMin( min );

	if ( hasMin ) {
		ml_Lua->Push( min );
		return 1;
	}

	return 0;
}

LUA_FUNCTION( GetConVarMax )
{
	ml_Lua->CheckType(1, GLua::TYPE_CONVAR);

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData(1);

	if (!cvar)
		ml_Lua->Error("Invalid ConVar handle!\n");

	float max;
	bool hasMax = cvar->GetMax( max );

	if ( hasMax ) {
		ml_Lua->Push(max);
		return 1;
	}

	return 0;
}

LUA_FUNCTION( RemoveConVar )
{
	ml_Lua->CheckType( 1, GLua::TYPE_CONVAR );

	ConVar *cvar = (ConVar*) ml_Lua->GetUserData( 1 );

	if (!cvar)
		ml_Lua->Error("Invalid ConVar!\n");

	g_ICvar->UnregisterConCommand( cvar );
	delete cvar;
	return 0;
}

LUA_FUNCTION( __eq )
{
	ml_Lua->CheckType( 1, GLua::TYPE_CONVAR );
	ml_Lua->CheckType( 2, GLua::TYPE_CONVAR );

	ConVar *cvar1 = ( ConVar* ) ml_Lua->GetUserData(1);
	ConVar *cvar2 = ( ConVar* ) ml_Lua->GetUserData(2);
	
	ml_Lua->Push( (bool)(cvar1 == cvar2) );
	return 1;
}

LUA_FUNCTION( __tostring )
{
	ml_Lua->CheckType( 1, GLua::TYPE_CONVAR );

	ConVar *cvar = ( ConVar* ) ml_Lua->GetUserData(1);

	if ( !cvar )
		ml_Lua->Error("Invalid ConVar!\n");
	
	ml_Lua->PushVA( "ConVar: %p", cvar );

	return 1;
}

LUA_FUNCTION( GetConVar )
{
	ml_Lua->CheckType(1, GLua::TYPE_STRING);

	ConVar *ConVar = g_ICvar->FindVar( ml_Lua->GetString( 1 ) );

	ILuaObject *metaT = ml_Lua->GetMetaTable( "ConVar", GLua::TYPE_CONVAR );
		ml_Lua->PushUserData( metaT, cvar );
	metaT->UnReference();

	return 1;
}

LUA_FUNCTION( GetCommand )
{
	ml_Lua->CheckType(1, GLua::TYPE_STRING);

	ConCommand *cvar = g_ICvar->FindCommand( ml_Lua->GetString( 1 ) );

	ILuaObject *metaT = ml_Lua->GetMetaTable( "ConVar", GLua::TYPE_CONVAR );
		ml_Lua->PushUserData( metaT, cvar );
	metaT->UnReference();

	return 1;
}




LUA_FUNCTION(DoClientCommand) {
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	g_pEngine->ClientCmd( ml_Lua->GetString(1) );
	return 0;
}



GMOD_MODULE(Open, Close);

int Open(lua_State *L) {
	ml_Lua = Lua();
	
	
	CreateInterfaceFn g_pEngineFactory = Sys_GetFactory("engine.dll"); //Engine
	g_pEngine = (IVEngineClient*)g_pEngineFactory(VENGINE_CLIENT_INTERFACE_VERSION, NULL);
	if (!g_pEngine) {
		ml_Lua->Msg("[gmcl_replicator] Can't get IVEngineClient interface " VENGINE_CLIENT_INTERFACE_VERSION " :(\n");
		return 0;
	}
	
	CreateInterfaceFn VSTDLibFactory = Sys_GetFactory("vstdlib.dll");
	if (!VSTDLibFactory) {
		ml_Lua->Msg("[gmcl_replicator] Error getting vstdlib.dll factory.\n");
		return 0;
	}
	g_ICvar = (ICvar*)VSTDLibFactory(CVAR_INTERFACE_VERSION, NULL);
	if (!g_ICvar) {
		ml_Lua->Msg("[gmcl_replicator] Error getting ICvar " CVAR_INTERFACE_VERSION " interface.\n");
		return 0;
	}
	
	ml_Lua->NewGlobalTable("replicator");
	ILuaObject* replicator = ml_Lua->GetGlobal("replicator");
		replicator->SetMember("ConCommand",			DoClientCommand);
		replicator->SetMember("GetAllConVars",		GetAllCvars);
		replicator->SetMember("GetAllConCommands",	GetAllCmds);
		replicator->SetMember("GetConCommand", 		GetCommand);
	replicator->UnReference();
	
	ml_Lua->SetGlobal("FCVAR_DEVELOPMENTONLY", (float) FCVAR_DEVELOPMENTONLY);
	ml_Lua->SetGlobal("FCVAR_HIDDEN", (float) FCVAR_HIDDEN);
	
	ILuaObject* conVarMeta = ml_Lua->GetMetaTable("ConVar", GLua::TYPE_CONVAR);
	if (conVarMeta) {
		conVarMeta->SetMember("SetValue",		SetConVarValue);
		//conVarMeta->SetMember("GetBool",		GetConVarBool);
		conVarMeta->SetMember("GetDefault",		GetConVarDefault);
		conVarMeta->SetMember("GetFloat",		GetConVarFloat);
		//conVarMeta->SetMember("GetInt",		GetConVarInt);
		conVarMeta->SetMember("GetName",		GetConVarName);
		conVarMeta->SetMember("SetName",		SetConVarName);
		//conVarMeta->SetMember("GetString",	GetConVarString);
		conVarMeta->SetMember("SetFlags",		SetConVarFlags);
		conVarMeta->SetMember("GetFlags",		GetConVarFlags);
		conVarMeta->SetMember("HasFlag",		ConVarHasFlag);
		conVarMeta->SetMember("SetHelpText",	SetConVarHelpText);
		//conVarMeta->SetMember("GetHelpText",	GetConVarHelpText);
		conVarMeta->SetMember("Reset",			ResetConVarValue);
		conVarMeta->SetMember("Remove",			RemoveConVar);
		conVarMeta->SetMember("__tostring",		__tostring);
		conVarMeta->SetMember("__eq",			__eq);
		conVarMeta->SetMember("__index",		conVarMeta);
	}
	conVarMeta->UnReference();
	
	return 0;
}

int Close(lua_State *L) {
	return 0;
}




