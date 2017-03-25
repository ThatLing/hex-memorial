#include "GMLuaModule.h"
#include "windows.h"
#include "eiface.h"
#include <interface.h>
//#include "cbase.h"
#include "CStateManager.h"

class ILuaShared2
{
public:
	virtual void Member0 ();
	virtual void Member1 ();
	virtual void Member2 ();
	virtual void Member3 ();
	virtual void Member4 ();
	virtual void Member5 ();
	virtual void Member6 ();
	virtual void Member7 ();
	virtual ILuaInterface* GetLuaInterface ( unsigned char interfaceNumber );
};

ILuaShared2* CStateManager::ILuaSharedPtr = NULL;

void CStateManager::Sys_CheckInterface( const char* module, const char* interfacestr, PVOID interfaceptr ){
	if (interfaceptr != NULL) return;
	Error("Unable to create interface \"%s\" from module \"%s\"\n", interfacestr, module);
}

template<class T> T CStateManager::Sys_GetInterface ( const char* module, const char* interfacestr ){
	CSysModule *moduleptr = Sys_LoadModule( module );
	CreateInterfaceFn fn = Sys_GetFactory( moduleptr );
	T interfaceptr = reinterpret_cast< T >( fn( interfacestr, NULL) );
	Sys_CheckInterface( module, interfacestr, interfaceptr );
	return interfaceptr;
}

void CStateManager::Load()
{

	ILuaSharedPtr = Sys_GetInterface< ILuaShared2* >( "lua_shared.dll", "LuaShared001");

}

ILuaInterface* CStateManager::GetInterface( LuaState interfaceType )
{
	if (ILuaSharedPtr == NULL) CStateManager::Load();
	switch ( interfaceType )
	{

		case LuaStates::CLIENT:
			return ILuaSharedPtr->GetLuaInterface( 0 );
			break;
		case LuaStates::SERVER:
			return ILuaSharedPtr->GetLuaInterface( 1 );
			break;
		case LuaStates::MENU:
			return ILuaSharedPtr->GetLuaInterface( 2 );
			break;
		default:
			return NULL;
			break;
	}
}


ILuaInterface* CStateManager::GetByIndex( int index ){
	if (ILuaSharedPtr == NULL) CStateManager::Load();
	return ILuaSharedPtr->GetLuaInterface( index );
}

