#ifndef ILUAINTERFACE_H
#define ILUAINTERFACE_H

#include <stdio.h>
#include <stdarg.h>

#include "ILuaObject.h"
#include "ILuaTable.h"

using namespace GarrysMod::Lua;

class ILuaInterface
{
public:
	ILuaInterface( lua_State* state );
	~ILuaInterface( void );

	lua_State*		GetLuaState();

	ILuaObject*		Global();
	ILuaObject*		Registry();
	ILuaObject*		Environment();

	ILuaObject*		GetNewTable();
	void			NewTable();
	ILuaObject*		NewTemporaryObject();
	ILuaObject*		NewUserData( ILuaObject* metaT );

	void			PushUserData( ILuaObject* metatable, void * v, unsigned char type );
	
	void			Error( const char* strError, ... );
	void			ErrorNoHalt( const char* strError, ... );
	void			LuaError( const char* strError, int argument = -1 );

	ILuaObject*		GetGlobal( const char* name );

	void			SetGlobal( const char* name, CFunc f );
	void			SetGlobal( const char* name, double d );
	void			SetGlobal( const char* name, const char* s );
	void			SetGlobal( const char* name, bool b );
	void			SetGlobal( const char* name, void* u );
	void			SetGlobal( const char* name, ILuaObject* o );

	void			RemoveGlobal( const char* name );
	void			NewGlobalTable( const char* name );

	ILuaObject*		GetObject( int i = -1 );
	const char*		GetString( int i = -1, unsigned int* iLen = NULL );
	int				GetInteger( int i = -1 );
	double			GetNumber( int i = -1 );
	double			GetDouble( int i = -1 );
	float			GetFloat( int i = -1 );
	bool			GetBool( int i = -1 );
	void**			GetUserDataPtr( int i = -1 );
	void*			GetUserData( int i = -1 );
	void			GetTable( int i = -1 );
	const char*		GetStringOrError( int i );

	CUtlLuaVector*	GetAllTableMembers( int iTable );
	void			DeleteLuaVector( CUtlLuaVector* pVector );

	int				GetReference( int i = -1 );
	void			FreeReference( int i );
	void			PushReference( int i );

	void			Pop( int i=1 );
	int				Top();

	void			Push( ILuaObject* o );
	void			Push( const char* str, unsigned int iLen = 0 );
	void			PushVA( const char* str, ... );
	void			Push( double d );
	void			Push( bool b );
	void			Push( CFunc f );
	void			Push( int i );
	void			Push( float f );
	void			PushLong( int i );
	void			PushNil();

	void			CheckType( int i, int iType );
	int				GetType( int iStackPos );
	const char*		GetTypeName( int iType );

	ILuaObject*		GetReturn( int iNum );

	void			Call( int args, int returns = 0 );
	int				PCall( int args, int returns = 0, int iErrorFunc = 0 );

	ILuaObject*		GetMetaTable( const char* strName, int iType );
	ILuaObject*		GetMetaTable( int i );

private:
	lua_State*		m_pState;
	ILuaBase*		m_pLua;
	ILuaObject*		m_pG;
	ILuaObject*		m_pR;
	ILuaObject*		m_pE;
	ILuaObject*		m_pErrorNoHalt;
};

#endif