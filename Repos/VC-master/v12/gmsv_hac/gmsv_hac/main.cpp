/*
	=== gmsv_hac ===
	*HeX's Anticheat*
	
	Credits:
		. Tracer (gm_winapi)
		. Helix Alioth (gm_hio)
		. Blackops (gmcl_extras)
		. Discord (Fixed the \n problem :D)
		. HeX (Combining these together)
*/

#undef _UNICODE
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN

#pragma comment(linker, "/NODEFAULTLIB:libcmt")
#pragma comment(lib, "tier0.lib")
#pragma comment(lib, "tier1.lib")

#include <eiface.h>
#include <direct.h> //This is where _getcwd is defined
#include <stdarg.h>
#include <sys/stat.h>
#include <Windows.h>
#include <exception>
#include <fstream>
#include <string>
#include <sstream>
#include <stdio.h>

//Time stuff
#include <sys/stat.h>
#include <time.h>

#include <ILuaModuleManager.h>


using namespace std;

ILuaInterface* sv_Lua		= NULL;
IVEngineServer* engine		= NULL;


LUA_FUNCTION(TimeCache) {
	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	string fullPath;
	
	if (sv_Lua->GetString(1)[1] == ':') {
		fullPath = sv_Lua->GetString(1);
	} else {
		char workingDir [256];
		_getcwd(workingDir, 256);
		
		fullPath = workingDir;
		fullPath += "\\garrysmod\\";
		fullPath += sv_Lua->GetString(1);
	}
	const char* path = fullPath.c_str();
	
	
	//struct tm* clock;			// create a time structure
	struct stat attrib;			// create a file attribute structure
	stat(path, &attrib);
	
	//clock = gmtime( &(attrib.st_mtime) );	// Get the last modified time and put it into the time structure
	
	// clock->tm_year returns the year (since 1900)
	// clock->tm_mon returns the month (January = 0)
	// clock->tm_mday returns the day of the month
	
	sv_Lua->PushDouble( (float)attrib.st_mtime );
	return 1;
}


LUA_FUNCTION(WinCMD) {
	const char* cmd = sv_Lua->GetString(1);
	int res = system(cmd);
	
	sv_Lua->Push(res == 0);
	return 1;
}


LUA_FUNCTION(Command) {
	if (!engine) {
		Msg("gmsv_hac: No engine!\n");
		return 0;
	}
	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	
	char* szCmd = new char[256];
	sprintf(szCmd, "%s\n", sv_Lua->GetString(1));
	
	engine->ServerCommand( szCmd );
	delete [] szCmd;

	return 0;
}


//CVar query
LUA_FUNCTION(GetConVarNumber) {
	if (!engine) {
		Msg("gmsv_hac: No engine!\n");
		return 0;
	}
	sv_Lua->CheckType(1, GLua::TYPE_ENTITY);
	sv_Lua->CheckType(2, GLua::TYPE_STRING);
	
	ILuaObject *pEntity = sv_Lua->GetMetaTable("Entity", GLua::TYPE_ENTITY);
		pEntity->GetMember("EntIndex")->Push();
		
		sv_Lua->GetObject(1)->Push();
		
		sv_Lua->Call(1,1);
	pEntity->UnReference();
	
	int Index = sv_Lua->GetReturn(0)->GetInt();
	
	
	sv_Lua->PushDouble( engine->StartQueryCvarValue( engine->PEntityOfEntIndex(Index), sv_Lua->GetString(2) ) );
	
	return 1;
}






LUA_FUNCTION(DeleteCache)
{
	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	string fullPath;
	
	if (sv_Lua->GetString(1)[1] == ':') {
		fullPath = sv_Lua->GetString(1);
	} else {
		char workingDir [256];
		_getcwd(workingDir, 256);
		
		fullPath = workingDir;
		fullPath += "\\garrysmod\\";
		fullPath += sv_Lua->GetString(1);
	}
	
	int res = remove( fullPath.c_str() );
	
	sv_Lua->Push(res == 0);
	return 1;
}


LUA_FUNCTION(CopyCache)
{
	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	sv_Lua->CheckType(2, GLua::TYPE_STRING);
	
	string fullPath1;
	string fullPath2;
	
	if (sv_Lua->GetString(1)[1] == ':') {
		fullPath1 = sv_Lua->GetString(1);
	} else {
		char workingDir [256];
		_getcwd(workingDir, 256);
		
		fullPath1 = workingDir;
		fullPath1 += "\\garrysmod\\";
		fullPath1 += sv_Lua->GetString(1);
	}
	
	if (sv_Lua->GetString(2)[1] == ':') {
		fullPath2 = sv_Lua->GetString(2);
	} else {
		char workingDir [256];
		_getcwd(workingDir, 256);
		
		fullPath2 = workingDir;
		fullPath2 += "\\garrysmod\\";
		fullPath2 += sv_Lua->GetString(2);
	}
	
	const char* cpath	= fullPath1.c_str();
	const char* cpath2	= fullPath2.c_str();
	
	
	try
	{
		ifstream input;
		ofstream output;
		
		input.open( cpath, ios::binary );
		output.open( cpath2, ios::binary );
		
		if ( !input.is_open() ) {
			if ( output.is_open() ) {
				output.close();
			}
			
			sv_Lua->Push( false );
			sv_Lua->Push("Local file could not be read");
			return 2;
		}
		
		if( !output.is_open() ) {
			if ( input.is_open() ) {
				input.close();
			}
			sv_Lua->Push( false );
			sv_Lua->Push("Remote file could not be opened");
			return 2;
		}
		
		output << input.rdbuf();
		
		input.close();
		output.close();
	}
	
	catch ( exception& e ) {
		sv_Lua->Push( false );
		sv_Lua->Push( e.what() );
		
		return 2;
	}
	
	sv_Lua->Push( true );
	return 1;
}




LUA_FUNCTION( FileDoesExist )
{
	sv_Lua->CheckType( 1, GLua::TYPE_STRING );

	string fullPath;

	if ( sv_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = sv_Lua->GetString( 1 );
	} else {
		char workingDir [256];
		_getcwd( workingDir, 256 );

		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += sv_Lua->GetString( 1 );
	}
	ifstream ReadFile;
	ReadFile.open( fullPath.c_str(), ios::binary );

	if ( !ReadFile.is_open() )
	{
		sv_Lua->Push( false );
	} else {
		sv_Lua->Push( true );
	}

	return 1;
}

LUA_FUNCTION( DirDoesExist )
{
	sv_Lua->CheckType( 1, GLua::TYPE_STRING );

	string fullPath;

	if ( sv_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = sv_Lua->GetString( 1 );
	} else {
		char workingDir [256];
		_getcwd( workingDir, 256 );

		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += sv_Lua->GetString( 1 );
	}
	struct stat chk;
	if ( stat( fullPath.c_str( ), &chk ) == 0 )
	{
		sv_Lua->Push( true );
	} else {
		sv_Lua->Push( false );
	}

	return 1;
}


LUA_FUNCTION( MakeDirectory )
{
	sv_Lua->CheckType( 1, GLua::TYPE_STRING );

	string fullPath;
	string fullPath2;

	if ( sv_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = sv_Lua->GetString( 1 );
	} else {
		char workingDir [256];
		_getcwd( workingDir, 256 );

		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += sv_Lua->GetString( 1 );
	}
	_mkdir( fullPath.c_str() );
	return 0;
}
LUA_FUNCTION( RemoveDirectory )
{
	sv_Lua->CheckType( 1, GLua::TYPE_STRING );

	string fullPath;
	string fullPath2;

	if ( sv_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = sv_Lua->GetString( 1 );
	} else {
		char workingDir [256];
		_getcwd( workingDir, 256 );

		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += sv_Lua->GetString( 1 );
	}
	_rmdir( fullPath.c_str() );
	return 0;
}

LUA_FUNCTION( Read )
{
	sv_Lua->CheckType( 1, GLua::TYPE_STRING );

	string fullPath;

	if ( sv_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = sv_Lua->GetString( 1 );
	} else {
		char workingDir [256];
		_getcwd( workingDir, 256 );

		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += sv_Lua->GetString( 1 );
	}
	ifstream ReadFile;
	ReadFile.open( fullPath.c_str(), ios::binary );

	if ( !ReadFile.is_open() ) {
		Msg("gmsv_hac: Bad path: %s", sv_Lua->GetString(1) );
		sv_Lua->Push( false );
	}

	ReadFile.seekg( 0, ios::end );
		int length = ReadFile.tellg();
	ReadFile.seekg( 0, ios::beg );
	char* buffer = new char[length+1];
	
	ReadFile.read( buffer, length );
	buffer[length] = 0;

	sv_Lua->Push( buffer );

	delete [] buffer;
	return 1;
}

LUA_FUNCTION(Write)
{
	sv_Lua->CheckType( 1, GLua::TYPE_STRING );
	sv_Lua->CheckType( 2, GLua::TYPE_STRING );
	
	bool Done = false;
	string fullPath;
	
	if ( sv_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = sv_Lua->GetString( 1 );
	} else {
		char workingDir [256];
		_getcwd( workingDir, 256 );
		
		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += sv_Lua->GetString( 1 );
	}
	ofstream WriteFile;
	WriteFile.open( fullPath.c_str(), ios::binary );
	
	if ( !WriteFile.is_open() )
	{
		Msg("gmsv_hac: Write, bad path: %s", sv_Lua->GetString(1) );
		sv_Lua->Push( (bool)Done );
	}
	
	WriteFile << sv_Lua->GetString( 2 );
	WriteFile.close();
	Done = true;
	
	sv_Lua->Push( (bool)Done );
	return 1;
}

LUA_FUNCTION(Rename)
{
	sv_Lua->CheckType( 1, GLua::TYPE_STRING );
	sv_Lua->CheckType( 2, GLua::TYPE_STRING );
	
	std::string fullPath;
	std::string fullPath2;
	
	if ( sv_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = sv_Lua->GetString( 1 );
		fullPath2 = sv_Lua->GetString( 2 );
	} else {
		char* workingDir = new char[256];
		char* workingDir2 = new char[256];
		_getcwd( workingDir, 256 );
		_getcwd( workingDir2, 256 );
		
		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += sv_Lua->GetString( 1 );
		fullPath2 = workingDir2; fullPath2 += "\\garrysmod\\"; fullPath2 += sv_Lua->GetString( 2 );
		
		delete [] workingDir;
		delete [] workingDir2;
	}
	int Done = rename( fullPath.c_str(), fullPath2.c_str() );
	
	sv_Lua->Push(Done == 0);
	return 1;
}


LUA_FUNCTION(Size)
{
	sv_Lua->CheckType( 1, GLua::TYPE_STRING );

	string fullPath;

	if ( sv_Lua->GetString( 1 )[1] == ':' )
	{
		fullPath = sv_Lua->GetString( 1 );
	} else {
		char workingDir [256];
		_getcwd( workingDir, 256 );

		fullPath = workingDir; fullPath += "\\garrysmod\\"; fullPath += sv_Lua->GetString( 1 );
	}
	struct stat siz;
	if ( stat( fullPath.c_str( ), &siz ) == 0 )
	{
		sv_Lua->PushDouble( siz.st_size );
	} else {
		sv_Lua->PushNil( );
	}

	return 1;
}


LUA_FUNCTION(NotRPF)
{
	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	
	string fullPath;
	char workingDir [256];
	
	_getcwd(workingDir, 256);
	
	fullPath = workingDir;
	fullPath += "\\garrysmod\\";
	fullPath += sv_Lua->GetString(1);
	
	sv_Lua->Push( fullPath.c_str() );
	return 1;
}


LUA_FUNCTION(FileFind)
{
	sv_Lua->CheckType(1,GLua::TYPE_STRING);
	string fullPath;
	
	if (sv_Lua->GetString(1)[1] == ':') {
		fullPath = sv_Lua->GetString(1);
	} else {
		char workingDir [256];
		_getcwd(workingDir, 256);
		
		fullPath = workingDir;
		fullPath += "\\garrysmod\\";
		fullPath += sv_Lua->GetString(1);
	}
	
	LPCSTR path = fullPath.c_str();
	
	int index = 0;
	WIN32_FIND_DATA FindFileData;
	HANDLE hf;
	hf = FindFirstFile(path, &FindFileData);
	
	ILuaObject *tbl = sv_Lua->GetNewTable();
	if (hf != INVALID_HANDLE_VALUE) {
		do {
			index++;
			tbl->SetMember(index,FindFileData.cFileName);
		}
		while (FindNextFile(hf,&FindFileData)!=0);
		FindClose(hf);
		index = 0;
	}
	sv_Lua->Push(tbl);
	
	tbl->UnReference();
	return 1;
}


GMOD_MODULE(Open, Close);

int Open(lua_State* L) {
	sv_Lua = Lua();
	
	CreateInterfaceFn interfaceFactory = Sys_GetFactory("engine.dll");
	engine = (IVEngineServer*)interfaceFactory(INTERFACEVERSION_VENGINESERVER, NULL);
	
	if (!engine) {
		Msg("gmsv_hsp: Fuckup, can't get IVEngineServer " INTERFACEVERSION_VENGINESERVER "\n");
	}
	
	
	ILuaObject *pMeta = sv_Lua->GetMetaTable("Player", GLua::TYPE_ENTITY);
		pMeta->SetMember("GetConVarNumber", GetConVarNumber);
	pMeta->UnReference();
	
	
	sv_Lua->NewGlobalTable("hac");
	ILuaObject* hac = sv_Lua->GetGlobal("hac");
		hac->SetMember("Command", Command);
		hac->SetMember("WinCMD", WinCMD);
		
		hac->SetMember("Copy", CopyCache);
		hac->SetMember("Exists", FileDoesExist);
		hac->SetMember("MKDIR", MakeDirectory);
		hac->SetMember("RMDIR", RemoveDirectory);
		hac->SetMember("IsDir", DirDoesExist);
		hac->SetMember("Delete", DeleteCache);
		hac->SetMember("Remove", DeleteCache);
		hac->SetMember("RPF", NotRPF);
		hac->SetMember("Read", Read);
		hac->SetMember("Rename", Rename);
		hac->SetMember("Write", Write);
		hac->SetMember("Size", Size);
		hac->SetMember("Find", FileFind);
		hac->SetMember("Time", TimeCache);
	hac->UnReference();
	
	return 0;
}

int Close(lua_State* L) {
	return 0;
}


