
#ifndef ILUAINTERFACEINTERNAL_H
#define ILUAINTERFACEINTERNAL_H

#ifdef _WIN32
#pragma once
#endif

#ifndef NO_SDK
#include "tier1/utlvector.h"
#endif

#ifdef UNICODE
#undef GetObject
#endif


// Forward Definitions
class ILuaObjectInternal;
class ILuaModuleManager;
struct lua_State;


// This struct is used to get a Lua table from Lua to C++
struct LuaKeyValueInternal
{
	ILuaObjectInternal* pKey;
	ILuaObjectInternal* pValue;
};

#ifndef NO_SDK
typedef CUtlVector<LuaKeyValueInternal> CUtlLuaVectorInternal;
#endif

typedef void (*VoidFunction) ( void );
typedef int (*CLuaFunction) (lua_State*);
typedef int (*CFuncInternal) (lua_State *L);


class LArgList;

namespace GLuaInternal
{
	enum {
		TYPE_INVALID = -1,
		TYPE_NIL, 
		TYPE_BOOL,
		TYPE_LIGHTUSERDATA,
		TYPE_NUMBER, 
		TYPE_STRING, 
		TYPE_TABLE,
		TYPE_FUNCTION,
		TYPE_USERDATA,
		TYPE_THREAD,
		
		// UserData
		TYPE_ENTITY, 
		TYPE_VECTOR, 
		TYPE_ANGLE,
		TYPE_PHYSOBJ,
		TYPE_SAVE,
		TYPE_RESTORE,
		TYPE_DAMAGEINFO,
		TYPE_EFFECTDATA,
		TYPE_MOVEDATA,
		TYPE_RECIPIENTFILTER,
		TYPE_USERCMD,
		TYPE_SCRIPTEDVEHICLE,
		
		// Client Only
		TYPE_MATERIAL,
		TYPE_PANEL,
		TYPE_PARTICLE,
		TYPE_PARTICLEEMITTER,
		TYPE_TEXTURE,
		TYPE_USERMSG,
		
		TYPE_CONVAR,
		TYPE_IMESH,
		TYPE_MATRIX,
		TYPE_SOUND,
		TYPE_PIXELVISHANDLE,
		TYPE_DLIGHT,
		TYPE_VIDEO,
		TYPE_FILE,
		TYPE_COUNT
	};
}



class ILuaInterfaceInternal
{
public:
	virtual int			Top( void ) = 0;
	virtual void		Push( int iStackPos ) = 0;
	virtual void		Pop( int iAmt = 1 ) = 0;
	virtual void		GetTable( int iStackPos ) = 0;
	virtual void		GetField( int iStackPos, const char* strName ) = 0;
	virtual void		SetField( int iStackPos, const char* strName ) = 0;
	virtual void		CreateTable() = 0;
	virtual void		SetTable( int i ) = 0;
	virtual void		SetMetaTable( int i ) = 0;
	virtual bool		GetMetaTable( int i ) = 0;
	virtual void		Call( int iArgs, int iResults ) = 0;
	virtual int			PCall( int iArgs, int iResults, int iErrorFunc ) = 0;
	virtual int			Equal( int iA, int iB ) = 0;
	virtual int			RawEqual( int iA, int iB ) = 0;
	virtual void		Insert( int iStackPos ) = 0;
	virtual void		Remove( int iStackPos ) = 0;
	virtual int			Next( int iStackPos ) = 0;
	virtual void*		NewUserdata( unsigned int iSize ) = 0;
	virtual void		ThrowError( const char* strError ) = 0;
	virtual void		CheckType( int iStackPos, int iType ) = 0;
	virtual void		ArgError( int iArgNum, const char* strMessage ) = 0;
	virtual void		RawGet( int iStackPos ) = 0;
	virtual void		RawSet( int iStackPos ) = 0;
	virtual const char*	GetString( int iStackPos = -1, unsigned int* iOutLen = NULL ) = 0;
	virtual double		GetNumber( int iStackPos = -1 ) = 0;
	virtual bool		GetBool( int iStackPos = -1 ) = 0;
	virtual CFuncInternal			GetCFunction( int iStackPos = -1 ) = 0;
	virtual void*		GetUserdata( int iStackPos = -1 ) = 0;
	virtual void		PushNil() = 0;
	virtual void		PushString( const char* val, unsigned int iLen = 0 ) = 0;
	virtual void		PushNumber( double val ) = 0;
	virtual void		PushBool( bool val ) = 0;
	virtual void		PushCFunction( CFuncInternal val ) = 0;
	virtual void		PushCClosure( CFuncInternal val, int iVars ) = 0;
	virtual void		PushUserdata( void* ) = 0;
	virtual int			ReferenceCreate() = 0;
	virtual void		ReferenceFree( int i ) = 0;
	virtual void		ReferencePush( int i ) = 0;
	virtual void		PushSpecial( int iType ) = 0;
	virtual bool			IsType( int iStackPos, int iType ) = 0;
	virtual int				GetType( int iStackPos ) = 0;
	virtual const char*		GetTypeName( int iType ) = 0;
	virtual void			CreateMetaTableType( const char* strName, int iType ) = 0;
	virtual const char*		CheckString( int iStackPos = -1 ) = 0;
	virtual double			CheckNumber( int iStackPos = -1 ) = 0;
	virtual double			ObjLen( int iStackPos = -1 ) = 0;
	//END LuaBase, 46. 44 from here to RS
	
	virtual void			AddThreadedCall(void /*GarrysMod::Lua::IThreadedCall **/);
	virtual void 			Init(void /* ILuaCallback * */);
	virtual void 			Shutdown(void);
	virtual void			Cycle( void ) = 0;
	virtual void*			GetLuaState() = 0;
	virtual ILuaObjectInternal*		Global(void);
	virtual ILuaObjectInternal*		IGetObject( int i = -1 ) = 0;
	virtual void			DELETE_ME_5437(void); //virtual void**			GetUserDataPtr( int i = -1 ) = 0;
	virtual void			_DELETE_ME2466(void); //virtual void*			GetUserData( int i = -1 ) = 0;
	virtual void			PushLuaObject( ILuaObjectInternal* ) = 0;
	virtual void			PushLuaFunction(CFuncInternal val);
	virtual void			LuaError( const char*, int argument = -1 ) = 0;
	virtual void			TypeError( const char* name, int argument ) = 0;
	virtual void			CallInternal(int,int);
	virtual void			CallInternalNoReturns(int);
	virtual void			CallInternalGetBool(int);
	virtual void			CallInternalGetString(int);
	virtual void			CallInternalGet(int,ILuaObjectInternal *);
	virtual void			_DELETE_ME(void); //virtual void			PushUserData( ILuaObjectInternal* metatable, void * v ) = 0;
	virtual void			NewGlobalTable( const char* ) = 0;
	virtual ILuaObjectInternal*		NewTemporaryObject( void ) = 0;
	virtual bool			isUserData( int i = -1 ) = 0;
	virtual void 			GetMetaTableObject(char  const*,int);
	virtual void 			GetMetaTableObject(int);
	virtual ILuaObjectInternal*		GetReturn( int iNum ) = 0;
	virtual bool			IsServer( void ) = 0;
	virtual bool			IsClient( void ) = 0;
	virtual bool			IsDedicatedServer( void ) = 0;
	virtual void			DestroyObject(ILuaObjectInternal *);
	virtual ILuaObjectInternal*		CreateObject(void);
	virtual void			SetMember( ILuaObjectInternal* table, ILuaObjectInternal* key, ILuaObjectInternal* value ) = 0;
	virtual ILuaObjectInternal*		GetNewTable( void ) = 0;
	virtual void 			SetMember(ILuaObjectInternal *,float);
	virtual void 			SetMember(ILuaObjectInternal *,float,ILuaObjectInternal *);
	virtual void 			SetMember(ILuaObjectInternal *,char  const*);
	virtual void 			SetMember(ILuaObjectInternal *,char  const*,ILuaObjectInternal *);
	virtual void			SetIsServer( bool b ) = 0;
	virtual void			PushLong( long f ) = 0;
	virtual int				GetFlags( int iStackPos ) = 0;
	virtual bool			FindOnObjectsMetaTable( int iObject, int iKey ) = 0;
	virtual bool			FindObjectOnTable( int iTable, int iKey ) = 0;
	virtual void			SetMemberFast( ILuaObjectInternal* table, int iKey, int iValue ) = 0;
	virtual bool			RunString( const char* strFilename, const char* strPath, const char* strStringToRun, bool bRun, bool bShowErrors ) = 0;
	virtual bool			IsEqual( ILuaObjectInternal* pObjectA, ILuaObjectInternal* pObjectB ) = 0;
	virtual void			Error( const char* strError ) = 0;
	virtual const char*		GetStringOrError( int i ) = 0;
	virtual bool 			RunLuaModule( const char* strName ) = 0;
	virtual bool 			FindAndRunScript( const char* strFilename, bool bRun, bool bReportErrors ) = 0;
	virtual void 			SetPathID( const char* ) = 0;
	virtual const char* 	GetPathID( void ) = 0;
	virtual void 			ErrorNoHalt( const char* fmt, ... ) = 0;
	virtual void 			Msg( const char* fmt, ... ) = 0;
	virtual void 			PushPath( const char* strPath ) = 0;
	virtual void 			PopPath( void ) = 0;
	virtual const char* 	GetPath( void ) = 0;
	virtual void 			GetColor( int iInt ) = 0;
	virtual void 			PushColor( int r, int g, int b, int a ) = 0;
	virtual void 			GetStack(int,void *) = 0;
	virtual void 			GetInfo(char  const*,void *) = 0;
	virtual void 			GetLocal(void *,int) = 0;
	virtual void 			GetUpvalue(int,int) = 0;
	virtual void 			RunStringEx(char  const*,char  const*,char  const*,bool,bool,bool) = 0;
	virtual void			DELETE_ME1(void); //virtual void 			PushDataString(char  const*,int) = 0;
	virtual void 			GetDataString(int,void **) = 0;
	virtual void 			ErrorFromLua(char  const*,...) = 0;
	virtual void 			GetCurrentLocation(void) = 0;
	virtual void 			MsgColour(Color const&,char const*,...) = 0;
	virtual void 			SetState(lua_State *) = 0;
	virtual void			DELETE_ME2(void) = 0; //112	ILuaInterface_DeleteMe::DELETE_ME2(void) //virtual void 			PopState(void) = 0;
	virtual void 			GetCurrentFile(const char&) = 0; //std::string &
	virtual void 			CompileString(void /*Bootil::Buffer &,std::string  const&*/) = 0;
	virtual void 			ThreadLock(void) = 0;;
	virtual void 			ThreadUnlock(void) = 0;;
	virtual void 			CallFunctionProtected(int,int,bool) = 0;;
	virtual void 			Require(char  const*) = 0;;
	virtual const char* 	GetActualTypeName(int) = 0;;
	virtual void 			SetupInfiniteLoopProtection(void) = 0;;
};


#endif
//ILUAINTERFACEINTERNAL_H












