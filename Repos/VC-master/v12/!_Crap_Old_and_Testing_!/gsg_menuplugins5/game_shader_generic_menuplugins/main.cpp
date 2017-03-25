
/*
	=== game_shader_generic_menuplugins ===
	*Stop fucking breaking it garry*
	
	Credits:
		. Discord
		. Blackops (gmcl_extras)
		. Yakahughes (gm_preproc)
		. HeX (Combining all these together)
*/


#undef _UNICODE
#pragma comment(linker,"/NODEFAULTLIB:libcmt")

#define DEBUG false
#define RUNSTRING_IDX 70

#define GMOD_BETA
#include <GMLuaModule.h>
#include <ILuaShared.h>
#include <vfnhook.h>

#include <materialsystem/IShader.h>
#include <Color.h>
#include <game/client/cdll_client_int.h>

#include <windows.h>
#include <fstream>
#include <direct.h>
#include <sys/stat.h>

HANDLE hPLThread;
HANDLE hPLThread2;

HMODULE lua_shared 				= NULL;
ILuaShared* g_LuaShared 		= NULL;
ILuaInterface* ml_Lua			= NULL;

using namespace std;

Color Blue(0,162,232,255);
Color White(255,255,255,255);
Color Green(85,218,90,255);
Color Sexy(255,174,201,255);
Color Red(255,0,0,255);

/*
typedef ILuaInterface* (*GMod_OpenFunc) (ILuaInterface* gLua);
string MPath = "garrysmodbeta/lua/includes/modules/";

LUA_FUNCTION(require2) {
	if (!ml_Lua) { return 0; }
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	string ename = ( MPath + ml_Lua->GetString(1) );
	
	HMODULE hModule = LoadLibrary( ename.c_str() );
	if (!hModule) {
		ml_Lua->Msg("ERROR: LoadLibrary (%s) failed!\n", ename.c_str());
		return 0;
	}
	
	
	GMod_OpenFunc GMOD_OPEN;
	GMOD_OPEN = (GMod_OpenFunc)GetProcAddress(hModule, "gmod_open");
	if (!GMOD_OPEN) {
		ml_Lua->Msg("ERROR: GetProcAddress gmod_open (%s) failed!\n", ename.c_str());
		return 0;
	}
	
	GMOD_OPEN( (ILuaInterface*)ml_Lua );
	
	ml_Lua->Msg("required %s\n", ename.c_str());
	return 0;
}
*/

LUA_FUNCTION(RunString2) {
	if (!ml_Lua) { return 0; }	
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	//RunStringReal(ml_Lua, "[MenuPlugins5]", "", ml_Lua->GetString(1), true, true);
	ml_Lua->RunString("", "[MenuPlugins5]", ml_Lua->GetString(1), true, true);
	return 0;
}



DEFVFUNC_(RunStringReal, bool, (ILuaInterface* RSLua, const char* strFilename, const char* strPath, const char* strStringToRun, bool bRun, bool bShowErrors));

bool VFUNC NotRunString(ILuaInterface* RSLua, const char* strFilename, const char* strPath, const char* strStringToRun, bool bRun, bool bShowErrors) {
	if (DEBUG) {
		ConColorMsg(Green, 	"RunString: ");
		ConColorMsg(White,	strFilename);
		ConColorMsg(White,	"\n");
	}
	
	if (!strcmp(strFilename, "lua\\menu\\menu.lua")) {
		if (ml_Lua != RSLua) {
			ml_Lua = RSLua;
		}
		
		//Set globals
		ILuaObject* GTable = RSLua->Global();
			if (!GTable) { //Garry-ness
				ConColorMsg(Sexy, 	"[MenuPlugins");
				ConColorMsg(Green, 	"5");
				ConColorMsg(Sexy, 	"]: ");
				ConColorMsg(Red,	"Can't get GTable, blame garry!\n");
				
				//Unhook
				bool What = RunStringReal(RSLua, strFilename, strPath, strStringToRun, bRun, bShowErrors);
				UNHOOKVFUNC(ml_Lua, RUNSTRING_IDX, RunStringReal);
				return What;
			}
			GTable->SetMember("RunString", RunString2);
			//GTable->SetMember("require2", require2);
		GTable->UnReference();
		
		//Load files
		string fullPath;
		char workingDir[MAX_PATH];
			_getcwd(workingDir, MAX_PATH);
		fullPath = workingDir;
		fullPath += "\\garrysmodbeta\\lua\\menu_plugins\\*.lua";
		
		WIN32_FIND_DATA FindFileData;
		HANDLE Search;
		Search = FindFirstFile( (LPCSTR)fullPath.c_str(), &FindFileData);
		
		if (Search != INVALID_HANDLE_VALUE) {
			do {
				const char* fname = FindFileData.cFileName;
				
				char* ToRun = new char[MAX_PATH];
					sprintf(ToRun, "include('menu_plugins/%s')", fname);
					
					ConColorMsg(Sexy, 	"[MenuPlugins");
					ConColorMsg(Green, 	"5");
					ConColorMsg(Sexy, 	"]: ");
					ConColorMsg(White,	"Loading ");
					
					char* str = new char[MAX_PATH];
						sprintf(str, "menu_plugins/%s\n", fname);
						ConColorMsg(Blue, str);
					delete [] str;
					
					//ml_Lua->Msg("! ToRun was: %s\n", ToRun);
					RunStringReal(RSLua, fname, "", ToRun, true, true);
				delete [] ToRun;
			}
			while (FindNextFile(Search, &FindFileData) != 0);
			FindClose(Search);
		}
		
		//Unhook
		bool What = RunStringReal(RSLua, strFilename, strPath, strStringToRun, bRun, bShowErrors);
		UNHOOKVFUNC(ml_Lua, RUNSTRING_IDX, RunStringReal);
		return What;
	}
	
	return RunStringReal(RSLua, strFilename, strPath, strStringToRun, bRun, bShowErrors);
}



DWORD WINAPI PLThread2(LPVOID param) {
	while (ml_Lua == NULL) {
		if (g_LuaShared) {
			ml_Lua = g_LuaShared->GetLuaInterface(2);
		}
		
		if (ml_Lua) {
			ConColorMsg(Sexy, 	"[MenuPlugins");
			ConColorMsg(Green, 	"5");
			ConColorMsg(Sexy, 	"]: ");
			ConColorMsg(White,	"Preparing to load..\n");
			
			CreateDirectoryA("garrysmodbeta/lua/menu_plugins", NULL);
			//HOOKVFUNC(ml_Lua, RUNSTRING_IDX, RunStringReal, NotRunString);
			
			
			Sleep(100);
			ExitThread(1);
			return true;
		}
	}
	
	return true;
}


DWORD WINAPI PLThread(LPVOID param) {
	while (g_LuaShared == NULL) {
		lua_shared = LoadLibrary("garrysmodbeta/bin/lua_shared.dll");
		
		if (lua_shared == NULL) {
			ExitThread(1);
			return true;
		}
		CreateInterfaceFn LuaSharedAddr = (CreateInterfaceFn)GetProcAddress(lua_shared, "CreateInterface");
		
		g_LuaShared = (ILuaShared*)LuaSharedAddr("LuaShared002", NULL);
		
		if (g_LuaShared) {
			hPLThread2 = CreateThread(NULL, 0, &PLThread2, NULL, NULL, NULL);
			
			ExitThread(1);
			return true;
		}
	}
	
	return true;
}



void InitLuaAPI() {
	hPLThread = CreateThread(NULL, 0, &PLThread, NULL, NULL, NULL);
}

void ShutdownLuaAPI() {
	if (hPLThread) { CloseHandle(hPLThread); }
	if (hPLThread2) { CloseHandle(hPLThread2); }
	
	if (lua_shared) { FreeLibrary(lua_shared); }
}






class IShader;

class IShaderDLLInternal {
	public:
		virtual bool Connect( CreateInterfaceFn factory, bool bIsMaterialSystem ) = 0;
		virtual void Disconnect( bool bIsMaterialSystem ) = 0;
		virtual int ShaderCount() const = 0;
		virtual IShader *GetShader( int nShader ) = 0;
};


class IShaderDLL {
	public:
		virtual void InsertShader( IShader *pShader ) = 0;
};


class CShaderDLL : public IShaderDLLInternal, public IShaderDLL {
	public:
		CShaderDLL();
		
		virtual bool Connect( CreateInterfaceFn factory );
		virtual void Disconnect();
		virtual int ShaderCount() const;
		virtual IShader *GetShader( int nShader );
		
		virtual bool Connect( CreateInterfaceFn factory, bool bIsMaterialSystem );
		virtual void Disconnect( bool bIsMaterialSystem );
		virtual void InsertShader( IShader *pShader );
		
	private:
		CUtlVector <IShader*> m_ShaderList;
};
static CShaderDLL *s_pShaderDLL;


IShaderDLLInternal *GetShaderDLLInternal() {
	if (!s_pShaderDLL) {
		s_pShaderDLL = new CShaderDLL;
	}
	
	return static_cast<IShaderDLLInternal*>(s_pShaderDLL);
}

EXPOSE_INTERFACE_FN( (InstantiateInterfaceFn)GetShaderDLLInternal, IShaderDLLInternal, "ShaderDLL004");

CShaderDLL::CShaderDLL(){}


bool CShaderDLL::Connect(CreateInterfaceFn factory, bool bIsMaterialSystem) {
	InitLuaAPI();
	return true;
}

void CShaderDLL::Disconnect(bool bIsMaterialSystem) {
	ShutdownLuaAPI();
}




bool CShaderDLL::Connect(CreateInterfaceFn factory) {
	return Connect(factory, false);
}

void CShaderDLL::Disconnect() {
	Disconnect(false);
}

int CShaderDLL::ShaderCount() const {
	return m_ShaderList.Count();
}

IShader *CShaderDLL::GetShader(int nShader) {
	if ( (nShader < 0) || ( nShader >= m_ShaderList.Count() ) ) {
		return NULL;
	}
	
	return m_ShaderList[nShader];
}

void CShaderDLL::InsertShader(IShader *pShader) {
	//Assert(pShader);
	
	m_ShaderList.AddToTail(pShader);
}











