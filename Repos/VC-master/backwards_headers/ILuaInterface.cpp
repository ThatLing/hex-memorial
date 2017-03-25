#include "ILuaInterface.h"
#include "UserData.h"

ILuaInterface::ILuaInterface( lua_State* state ) : m_pState(state), m_pLua(state->luabase)
{
	m_pLua->PushSpecial( SPECIAL_GLOB );
	m_pG = new ILuaObject( m_pLua, m_pLua->ReferenceCreate() );

	m_pLua->PushSpecial( SPECIAL_REG );
	m_pR = new ILuaObject( m_pLua, m_pLua->ReferenceCreate() );

	m_pLua->PushSpecial( SPECIAL_ENV );
	m_pE = new ILuaObject( m_pLua, m_pLua->ReferenceCreate() );

	m_pErrorNoHalt = GetGlobal( "ErrorNoHalt" );
}

ILuaInterface::~ILuaInterface()
{
	m_pG->UnReference();
	m_pR->UnReference();
	m_pE->UnReference();
	m_pErrorNoHalt->UnReference();
}

lua_State* ILuaInterface::GetLuaState()
{
	return m_pState;
}

ILuaObject* ILuaInterface::Global()
{
	return m_pG;
}

ILuaObject* ILuaInterface::Registry()
{
	return m_pR;
}

ILuaObject* ILuaInterface::Environment()
{
	return m_pE;
}

ILuaObject* ILuaInterface::GetNewTable()
{
	NewTable();
	return new ILuaObject( m_pLua, m_pLua->ReferenceCreate() );
}

void ILuaInterface::NewTable()
{
	m_pLua->CreateTable();
}

ILuaObject* ILuaInterface::NewTemporaryObject()
{
	m_pLua->PushNil();
	return new ILuaObject( m_pLua, m_pLua->ReferenceCreate() );
}

ILuaObject* ILuaInterface::NewUserData( ILuaObject* metaT )
{
	UserData *data = (UserData*) m_pLua->NewUserdata( sizeof( UserData ) );
	ILuaObject* obj = new ILuaObject( m_pLua, m_pLua->ReferenceCreate() );

	obj->Push(); // +1
		metaT->Push(); // +1
		m_pLua->SetMetaTable( -2 ); // -1
	m_pLua->Pop(); // -1

	return obj;
}

void ILuaInterface::PushUserData( ILuaObject* metaT, void * v, unsigned char type )
{
	if (!metaT)
		Error("CLuaInterface - No Metatable!\n");

	UserData *data = (UserData*) m_pLua->NewUserdata( sizeof( UserData ) );
	data->data = v;
	data->type = type;

	int iRef = m_pLua->ReferenceCreate();

	m_pLua->ReferencePush( iRef );
		metaT->Push(); // +1
		m_pLua->SetMetaTable( -2 ); // -1

	m_pLua->ReferenceFree( iRef );
}

void ILuaInterface::Error( const char* strError, ... )
{
	char buff[ 1024 ];
	va_list argptr;
	va_start( argptr, strError );
#ifdef _LINUX
	vsprintf( buff, strError, argptr );
#else
	vsprintf_s( buff, strError, argptr );
#endif
	va_end( argptr );

	m_pLua->ThrowError( buff );
}

void ILuaInterface::ErrorNoHalt( const char* strError, ... )
{
	char buff[ 1024 ];
	va_list argptr;
	va_start( argptr, strError );
#ifdef _LINUX
	vsprintf( buff, strError, argptr );
#else
	vsprintf_s( buff, strError, argptr );
#endif
	va_end( argptr );

	m_pErrorNoHalt->Push();
		m_pLua->PushString( strError );
	m_pLua->Call(1,0);
}

void ILuaInterface::LuaError( const char* strError, int argument )
{
	m_pLua->ArgError( argument, strError );
}

ILuaObject* ILuaInterface::GetGlobal( const char* name )
{
	m_pLua->PushSpecial( SPECIAL_GLOB ); // +1
		m_pLua->GetField( -1, name ); // +1
		ILuaObject* o = new ILuaObject( m_pLua, m_pLua->ReferenceCreate() ); // -1
	m_pLua->Pop();
	return o;
}

void ILuaInterface::SetGlobal( const char* name, CFunc f )
{
	m_pLua->PushSpecial( SPECIAL_GLOB ); // +1
		m_pLua->PushString( name ); // +1
		m_pLua->PushCFunction( f ); // +1
		m_pLua->SetTable( -3 ); // -2
	m_pLua->Pop(); // -1
}

void ILuaInterface::SetGlobal( const char* name, double d )
{
	m_pLua->PushSpecial( SPECIAL_GLOB ); // +1
		m_pLua->PushString( name ); // +1
		m_pLua->PushNumber( d ); // +1
		m_pLua->SetTable( -3 ); // -2
	m_pLua->Pop(); // -1
}

void ILuaInterface::SetGlobal( const char* name, const char* str )
{
	m_pLua->PushSpecial( SPECIAL_GLOB ); // +1
		m_pLua->PushString( name ); // +1
		m_pLua->PushString( str ); // +1
		m_pLua->SetTable( -3 ); // -2
	m_pLua->Pop(); // -1
}

void ILuaInterface::SetGlobal( const char* name, bool b )
{
	m_pLua->PushSpecial( SPECIAL_GLOB ); // +1
		m_pLua->PushString( name ); // +1
		m_pLua->PushBool( b ); // +1
		m_pLua->SetTable( -3 ); // -2
	m_pLua->Pop(); // -1
}

void ILuaInterface::SetGlobal( const char* name, void* u )
{
	m_pLua->PushSpecial( SPECIAL_GLOB ); // +1
		m_pLua->PushString( name ); // +1
		m_pLua->PushUserdata( u ); // +1
		m_pLua->SetTable( -3 ); // -2
	m_pLua->Pop(); // -1
}

void ILuaInterface::SetGlobal( const char* name, ILuaObject* o )
{
	m_pLua->PushSpecial( SPECIAL_GLOB ); // +1
		m_pLua->PushString( name ); // +1
		o->Push(); // +1
		m_pLua->SetTable( -3 ); // -2
	m_pLua->Pop(); // -1
}

void ILuaInterface::RemoveGlobal( const char* name )
{
	m_pLua->PushSpecial( SPECIAL_GLOB ); // +1
		m_pLua->PushString( name ); // +1
		m_pLua->PushNil(); // +1
		m_pLua->SetTable( -3 ); // -2
	m_pLua->Pop(); // -1
}

void ILuaInterface::NewGlobalTable( const char* name )
{
	m_pLua->PushSpecial( SPECIAL_GLOB ); // +1
		m_pLua->PushString( name ); // +1
		m_pLua->CreateTable();
		m_pLua->SetTable( -3 ); // -2
	m_pLua->Pop(); // -1
}

ILuaObject* ILuaInterface::GetObject( int i )
{
	if(i != 0)
		m_pLua->Push( i ); // +1
	return new ILuaObject( m_pLua, m_pLua->ReferenceCreate() ); // -1
}

const char* ILuaInterface::GetString( int i, unsigned int* iLen )
{
	return m_pLua->GetString( i, iLen );
}

int ILuaInterface::GetInteger( int i )
{
	return (int) GetNumber( i );
}

double ILuaInterface::GetNumber( int i )
{
	return m_pLua->GetNumber( i );
}

double ILuaInterface::GetDouble( int i )
{
	return GetNumber( i );
}

float ILuaInterface::GetFloat( int i )
{
	return (float) GetNumber( i );
}

bool ILuaInterface::GetBool( int i )
{
	return m_pLua->GetBool( i );
}

void** ILuaInterface::GetUserDataPtr( int i )
{
	UserData* data = (UserData*) m_pLua->GetUserdata( i );
	return &data->data; // Not sure if this is correct
}

void* ILuaInterface::GetUserData( int i )
{
	UserData* data = (UserData*) m_pLua->GetUserdata( i );
	return data->data;
}

void ILuaInterface::GetTable( int i ) // ???
{
	Error( "ILuaInterface::GetTable( int i ) is not implemented yet, but feel free to contribute!" );
}

const char* ILuaInterface::GetStringOrError( int i )
{
	m_pLua->CheckType( i, Type::STRING );
	return m_pLua->GetString( i );
}

CUtlLuaVector* ILuaInterface::GetAllTableMembers( int i )
{
	if(i != 0)
		m_pLua->Push( i );

	if( m_pLua->GetType( -1 ) != Type::TABLE )
    {
		m_pLua->ThrowError( "ILuaInterface::GetAllTableMembers, object not a table !" );
        return NULL;
    }

	CUtlLuaVector* tableMembers = new CUtlLuaVector();

	m_pLua->PushNil();
	while ( m_pLua->Next( -2 ) != 0 )
	{
		LuaKeyValue keyValues;

		keyValues.pKey = GetObject( -2 );
		keyValues.pValue = GetObject( -1 );

#ifndef NO_SDK
		tableMembers->AddToTail( keyValues );
#else
		tableMembers->push_back( keyValues );
#endif

		keyValues.pKey->Push(); // Push key back for next loop
	}

	if(i != 0)
		m_pLua->Pop( i );

	/*
	FOR_LOOP( tableMembers, j ) // Example Loop
	{
	#ifndef NO_SDK
		LuaKeyValue& keyValues = tableMembers->Element(j);
	#else
		LuaKeyValue& keyValues = tableMembers->at(j);
	#endif
	}
	*/

	return tableMembers;
}

void ILuaInterface::DeleteLuaVector( CUtlLuaVector* pVector )
{
	FOR_LOOP( pVector, i )
	{

	#ifndef NO_SDK
		LuaKeyValue& keyValues = pVector->Element(i);
	#else
		LuaKeyValue& keyValues = pVector->at(i);
	#endif

		ILuaObject* key = keyValues.pKey;
		ILuaObject* value = keyValues.pValue;

		key->UnReference();
		value->UnReference();
	}

	if (pVector)
		delete pVector;
}

int ILuaInterface::GetReference( int i )
{
	if(i != 0)
		m_pLua->Push( i ); // +??
	return m_pLua->ReferenceCreate();
}

void ILuaInterface::FreeReference( int i )
{
	m_pLua->ReferenceFree( i );
}

void ILuaInterface::PushReference( int i )
{
	m_pLua->ReferencePush( i );
}

void ILuaInterface::Pop( int i )
{
	m_pLua->Pop( i );
}

int ILuaInterface::Top()
{
	return m_pLua->Top();
}

void ILuaInterface::Push( ILuaObject* o )
{
	o->Push();
}

void ILuaInterface::Push( const char* str, unsigned int iLen )
{
	m_pLua->PushString( str, iLen );
}

void ILuaInterface::PushVA(const char* str, ...)
{
	char buff[ 1024 ];
	va_list argptr;
	va_start( argptr, str );
#ifdef _LINUX
	vsprintf( buff, str, argptr );
#else
	vsprintf_s( buff, str, argptr );
#endif
	va_end( argptr );
	m_pLua->PushString( buff );
}

void ILuaInterface::Push( double d )
{
	m_pLua->PushNumber( d );
}

void ILuaInterface::Push( bool b )
{
	m_pLua->PushBool( b );
}

void ILuaInterface::Push( CFunc f )
{
	m_pLua->PushCFunction( f );
}

void ILuaInterface::Push( int i )
{
	m_pLua->PushNumber( i );
}

void ILuaInterface::Push( float f )
{
	m_pLua->PushNumber( f );
}

void ILuaInterface::PushLong( int i )
{
	m_pLua->PushNumber( i );
}

void ILuaInterface::PushNil()
{
	m_pLua->PushNil();
}

void ILuaInterface::CheckType( int i, int iType )
{
	m_pLua->CheckType( i, iType );
}

int ILuaInterface::GetType( int iStackPos )
{
	return m_pLua->GetType( iStackPos );
}

const char* ILuaInterface::GetTypeName( int iType )
{
	return m_pLua->GetTypeName( iType );
}

ILuaObject* ILuaInterface::GetReturn( int iNum )
{
	return GetObject( iNum );
}

void ILuaInterface::Call( int args, int returns )
{
	m_pLua->Call( args, returns );
}

int ILuaInterface::PCall( int args, int returns, int iErrorFunc )
{
	return m_pLua->PCall( args, returns, iErrorFunc );
}

ILuaObject* ILuaInterface::GetMetaTable( const char* strName, int iType )
{
	m_pLua->CreateMetaTableType( strName, iType );
	return new ILuaObject( m_pLua, m_pLua->ReferenceCreate() );
}

ILuaObject* ILuaInterface::GetMetaTable( int i )
{
	if( m_pLua->GetMetaTable( i ) )
		return new ILuaObject( m_pLua, m_pLua->ReferenceCreate() );
	else
		return NULL;
}