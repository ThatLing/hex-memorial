

#ifndef ILUAOBJECTINTERNAL_H
#define ILUAOBJECTINTERNAL_H

#ifdef _WIN32
#pragma once
#endif

#include "ILuaInterface_Internal.h"

class ILuaObjectInternal;


class ILuaObjectInternal_001
{
	public:

		virtual void	Set( ILuaObjectInternal* obj ) = 0;
		virtual void	SetFromStack( int i ) = 0;
		virtual void	UnReference() = 0;

		virtual int				GetType( void ) = 0;

		virtual const char*		GetString( void ) = 0;
		virtual float			GetFloat( void ) = 0;
		virtual int				GetInt( void ) = 0;
		virtual void*			GetUserData( void ) = 0;

		virtual void			SetMember( const char* name ) = 0;
		virtual void			SetMember( const char* name, ILuaObjectInternal* obj ) = 0; // ( This is also used to set nil by passing NULL )
		virtual void			SetMember( const char* name, float val ) = 0;
		virtual void			SetMember( const char* name, bool val ) = 0;
		virtual void			SetMember( const char* name, const char* val ) = 0;
		virtual void			SetMember( const char* name, CLuaFunction f ) = 0;

		virtual bool			GetMemberBool( const char* name, bool b = true ) = 0;
		virtual int				GetMemberInt( const char* name, int i = 0 ) = 0;
		virtual float			GetMemberFloat( const char* name, float f = 0.0f ) = 0;
		virtual const char*		GetMemberStr( const char* name, const char* = "" ) = 0;
		virtual void*			GetMemberUserData( const char* name, void* = 0 ) = 0;
		virtual void*			GetMemberUserData( float name, void* = 0 ) = 0;
		virtual ILuaObjectInternal* 	GetMember( const char* name ) = 0;
		virtual ILuaObjectInternal* 	GetMember( ILuaObjectInternal* ) = 0;

		virtual void			SetMetaTable( ILuaObjectInternal* obj ) = 0;
		virtual void			SetUserData( void* obj ) = 0;

		virtual void			Push( void ) = 0;

		virtual bool			isNil() = 0;
		virtual bool			isTable() = 0;
		virtual bool			isString() = 0;
		virtual bool			isNumber() = 0;
		virtual bool			isFunction() = 0;
		virtual bool			isUserData() = 0;

		virtual ILuaObjectInternal* 	GetMember( float fKey ) = 0;

		virtual void*			Remove_Me_1( const char* name, void* = 0 ) = 0;

		virtual void			SetMember( float fKey ) = 0;
		virtual void			SetMember( float fKey, ILuaObjectInternal* obj ) = 0;
		virtual void			SetMember( float fKey, float val ) = 0;
		virtual void			SetMember( float fKey, bool val ) = 0;
		virtual void			SetMember( float fKey, const char* val ) = 0;
		virtual void			SetMember( float fKey, CLuaFunction f ) = 0;

		virtual const char*		GetMemberStr( float name, const char* = "" ) = 0;

		virtual void			SetMember( ILuaObjectInternal* k, ILuaObjectInternal* v ) = 0;
		virtual bool			GetBool( void ) = 0;

};


class ILuaObjectInternal : public ILuaObjectInternal_001
{
	public:

		// Push members to table from stack
		virtual bool			PushMemberFast( int iStackPos ) = 0;
		virtual void			SetMemberFast( int iKey, int iValue ) = 0;

		virtual void			SetFloat( float val ) = 0;
		virtual void			SetString( const char* val ) = 0;

		// GM13: get double
		virtual double			GetDouble( void ) = 0;
		
		// Return members of table
#ifndef NO_SDK
		virtual CUtlLuaVectorInternal*	GetMembers( void ) = 0;
#else
		virtual void*	GetMembers( void ) = 0;
#endif

		// Set member 'pointer'. No GC, no metatables. 
		virtual void			SetMemberUserDataLite( const char* strKeyName, void* pData ) = 0;
		virtual void*			GetMemberUserDataLite( const char* strKeyName ) = 0;
		
		//GMOD BETA
		virtual void			RequireMember(char  const*,char) = 0;
		virtual void			AddMemberTable(char  const*) = 0;
		virtual void			SetMember_FixKey(char  const*,float) = 0;
		virtual void			SetMember_FixKey(char  const*,char  const*) = 0;
		virtual void			SetMember_FixKey(char  const*,ILuaObjectInternal *) = 0;
		virtual void			isBool(void) = 0;
		virtual void			SetMemberDouble(char  const*,double) = 0;
		virtual void			SetMemberNil(char  const*) = 0;
		virtual void			SetMemberNil(float) = 0;

		// Probably another class
		/*virtual void			Init(void) = 0;
		virtual void			SetFromGlobal(char  const*) = 0;
		virtual void			GetMember(char  const*,ILuaObjectInternal *) = 0;
		virtual void			GetMember(float,ILuaObjectInternal *) = 0;
		virtual void			SetMember(char  const*,unsigned long long) = 0;
		virtual void			SetReference(int i) = 0;
		virtual void			RemoveMember(char  const*) = 0;
		virtual void			RemoveMember(float) = 0;
		virtual void			MemberIsNil(char  const*) = 0;
		virtual void			SetMemberDouble(float,double) = 0;
		virtual void			GetMemberDouble(char  const*,double) = 0;
		virtual void			CopyFrom(ILuaObjectInternal *) = 0;*/
};

#endif
//ILUAOBJECTINTERNAL_H










