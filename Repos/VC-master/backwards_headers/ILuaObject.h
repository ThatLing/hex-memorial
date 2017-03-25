#ifndef ILUAOBJECT_H
#define ILUAOBJECT_H

#include "Interface.h"
#include "ILuaTable.h"

using namespace GarrysMod::Lua;

class ILuaObject
{
public:
	ILuaObject( ILuaBase* lua );
	ILuaObject( ILuaBase* lua, int iRef );
	ILuaObject( ILuaBase* lua, ILuaObject* obj );
	~ILuaObject( void );

	void			Set( ILuaObject* obj );
	void			SetNil();
	void			SetFromStack( int i );
	
	void			UnReference();
	int				GetReference();

	int				GetType();
	const char*		GetTypeName();

	const char*		GetString( unsigned int* iLen = NULL );
	int				GetInt();
	double			GetDouble();
	float			GetFloat();
	bool			GetBool();
	void*			GetUserData();

	CUtlLuaVector*	GetMembers();
	
	void			SetMember( const char* name );
	void			SetMember( const char* name, ILuaObject* obj );
	void			SetMember( const char* name, double d );
	void			SetMember( const char* name, bool b );
	void			SetMember( const char* name, const char* s, unsigned int iLen = 0 );
	void			SetMember( const char* name, CFunc f );
	
	void			SetMember( double dKey );
	void			SetMember( double dKey, ILuaObject* obj );
	void			SetMember( double dKey, double d );
	void			SetMember( double dKey, bool b );
	void			SetMember( double dKey, const char* s, unsigned int iLen = 0 );
	void			SetMember( double dKey, CFunc f );

	void			SetMember( float fKey );
	void			SetMember( float fKey, ILuaObject* obj );
	void			SetMember( float fKey, double d );
	void			SetMember( float fKey, bool b );
	void			SetMember( float fKey, const char* s, unsigned int iLen = 0 );
	void			SetMember( float fKey, CFunc f );

	void			SetMember( int iKey );
	void			SetMember( int iKey, ILuaObject* obj );
	void			SetMember( int iKey, double d );
	void			SetMember( int iKey, bool b );
	void			SetMember( int iKey, const char* s, unsigned int iLen = 0 );
	void			SetMember( int iKey, CFunc f );

	ILuaObject*		GetMember( const char* name );
	ILuaObject*		GetMember( double dKey );
	ILuaObject*		GetMember( float fKey );
	ILuaObject*		GetMember( int iKey );
	ILuaObject*		GetMember( ILuaObject* oKey );

	bool			GetMemberBool( const char* name, bool b = true );
	int				GetMemberInt( const char* name, int i = 0 );
	float			GetMemberFloat( const char* name, float f = 0.0f );
	double			GetMemberDouble( const char* name, double d = 0 );
	const char*		GetMemberStr( const char* name, const char* s = "", unsigned int* iLen = NULL );
	void*			GetMemberUserData( const char* name, void* = NULL );
	
	void			SetMemberUserDataLite( const char* name, void* pData );
	void*			GetMemberUserDataLite( const char* name, void* u = NULL );

	void			SetUserData( void* obj );
	
	bool			isType( int iType );
	bool			isNil();
	bool			isTable();
	bool			isString();
	bool			isNumber();
	bool			isFunction();
	bool			isUserData();

	void			Push();

private:
	ILuaBase* m_pLua;
	int m_iRef;
};

#endif