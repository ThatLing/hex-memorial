#ifndef CSTATEMANGER_H
#define CSTATEMANGER_H

#include "windows.h"

namespace LuaStates
{
	enum
	{
		CLIENT=0,
		SERVER,
		MENU
	};
}

typedef int LuaState;

class ILuaShared2;

class CStateManager {
private:
	static void Load();
	static ILuaShared2* ILuaSharedPtr;
	static void Sys_CheckInterface( const char* module, const char* interfacestr, PVOID interfaceptr );
	template<class T> static T Sys_GetInterface ( const char* module, const char* interfacestr );
public:
	static ILuaInterface* GetInterface(LuaState interfaceType);
	static ILuaInterface* GetByIndex( int index );
	
};

#endif // CSTATEMANGER_H