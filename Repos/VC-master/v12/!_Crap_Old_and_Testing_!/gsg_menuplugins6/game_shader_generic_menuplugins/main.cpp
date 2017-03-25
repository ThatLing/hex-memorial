
/*
	=== MenuPlugins 6 ===
	*No really, STOP FUCKING BREAKING IT GARRY*
	
	Credits:
		. Discord
		. Blackops (gmcl_extras, beta headers)
		. HeX (Combining all these together)
*/


#undef _UNICODE
#pragma comment(linker,"/NODEFAULTLIB:libcmt")

#define GMOD_BETA
#include <GMLuaModule.h>
#include <ILuaShared.h>

#include <materialsystem/IShader.h>
#include <Color.h>
#include <game/client/cdll_client_int.h>

#include <windows.h>
#include <fstream>
#include <direct.h>
#include <sys/stat.h>

#include <convar.h>


HANDLE hPLThread;
HANDLE hPLThread2;

static ConCommand* gsg_load		= NULL;
//static ConCommand* lua_run_in	= NULL; //DEBUG

ILuaObject* _G 					= NULL;
HMODULE lua_shared 				= NULL;
ILuaShared* g_LuaShared 		= NULL;
ILuaInterface* ml_Lua			= NULL;
ICvar* g_ICvar					= NULL;
IVEngineClient* g_EngineClient	= NULL;


using namespace std;

Color Blue(0,162,232,255);
Color White(255,255,255,255);
Color Green(85,218,90,255);
Color Sexy(255,174,201,255);
Color Red(255,0,0,255);

/*
//DEBUG
void LuaRunMenu(const CCommand &command) {
	if (!ml_Lua) {
		ConColorMsg(Sexy, 	"[in_MenuPlugins");
		ConColorMsg(White, 	"6");
		ConColorMsg(Sexy, 	"]: ");
		ConColorMsg(Red, 	"Can't get ml_Lua :(\n");
		return;
	}
	
	ml_Lua->RunString("", "[MenuPlugins6]", command.ArgS(), true, true);
}
*/


LUA_FUNCTION(RunString2) {
	if (!ml_Lua) {
		ConColorMsg(Sexy, 	"[in_MenuPlugins");
		ConColorMsg(White, 	"6");
		ConColorMsg(Sexy, 	"]: ");
		ConColorMsg(Red, 	"Can't get ml_Lua :(\n");
		return 0;
	}
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	
	ml_Lua->RunString("", "[MenuPlugins5]", ml_Lua->GetString(1), true, true);
	return 0;
}




void StartMenuLoad(const CCommand &command) {
	char* Fuck = new char[MAX_PATH];
		sprintf(Fuck, "g_LuaShared @ %p\n", g_LuaShared);
		
		ConColorMsg(Sexy, 	"[MenuPlugins");
		ConColorMsg(White, 	"6");
		ConColorMsg(Sexy, 	"]: ");
		ConColorMsg(Red, 	Fuck);
	delete [] Fuck;
	
	if (!ml_Lua) {
		ConColorMsg(Sexy, 	"[MenuPlugins");
		ConColorMsg(White, 	"6");
		ConColorMsg(Sexy, 	"]: ");
		ConColorMsg(Red, 	"Can't get ml_Lua :(\n");
		return;
	}
	
	//DO NOT UNREF
	if (!_G) {
		_G = ml_Lua->Global(); 
	}
	//_G->SetMember("RunString2", RunString2);
	
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
				ConColorMsg(Green, 	"6");
				ConColorMsg(Sexy, 	"]: ");
				ConColorMsg(White,	"Loading ");
				
				char* str = new char[MAX_PATH];
					sprintf(str, "menu_plugins/%s\n", fname);
					ConColorMsg(Blue, str);
				delete [] str;
				
				ml_Lua->RunString("", fname, ToRun, true, true);
			delete [] ToRun;
		}
		while (FindNextFile(Search, &FindFileData) != 0);
		FindClose(Search);
	}
}





DWORD WINAPI PLThread2(LPVOID param) {
	/*
	while (ml_Lua == NULL) {
		if (g_LuaShared) {
			ml_Lua = g_LuaShared->GetLuaInterface(2);
		}
		
		if (ml_Lua) {
			ConColorMsg(Sexy, 	"[MenuPlugins");
			ConColorMsg(Green, 	"6");
			ConColorMsg(Sexy, 	"]: ");
			ConColorMsg(White,	"Preparing to load..\n");
			
			Sleep(1000);
			g_EngineClient->ClientCmd("gsg_load"); //Method 6. Fuck you fuck you fuck you 
			
			Sleep(1000);
			if (g_ICvar && gsg_load) {
				ConColorMsg(Sexy, 	"[MenuPlugins");
				ConColorMsg(Green, 	"6");
				ConColorMsg(Sexy, 	"]: ");
				ConColorMsg(White,	"Loaded all menu_plugins!\n");
				
				g_ICvar->UnregisterConCommand(gsg_load);
				delete gsg_load;
			}
			
			Sleep(100);
			ExitThread(1);
			return true;
		}
	}
	*/
	return true;
}


DWORD WINAPI PLThread(LPVOID param) {
	while (g_LuaShared == NULL) {
		lua_shared = LoadLibrary("garrysmodbeta/bin/lua_shared.dll");
		
		if (lua_shared == NULL) {
			MessageBox(NULL, "No lua_shared", NULL, NULL);
			ExitThread(1);
			return true;
		}
		CreateInterfaceFn LuaSharedAddr = (CreateInterfaceFn)GetProcAddress(lua_shared, "CreateInterface");
		
		g_LuaShared = (ILuaShared*)LuaSharedAddr("LuaShared002", NULL);
		
		if (g_LuaShared) {
			CreateInterfaceFn EngineFactory = Sys_GetFactory("engine.dll");
			if (!EngineFactory) {
				MessageBox(NULL, "No EngineFactory", NULL, NULL);
				return true;
			}
			
			g_EngineClient = (IVEngineClient*)EngineFactory("VEngineClient015", NULL);
			if (!g_EngineClient) {
				MessageBox(NULL, "No IVEngineClient VEngineClient015", NULL, NULL);
				return true;
			}
			
			
			CreateInterfaceFn VSTDLibFactory = Sys_GetFactory("vstdlib.dll");
			if (!VSTDLibFactory) {
				MessageBox(NULL, "No VSTDLibFactory", NULL, NULL);
				return true;
			}
			
			g_ICvar = (ICvar*)VSTDLibFactory(CVAR_INTERFACE_VERSION, NULL);
			if (!g_ICvar) {
				MessageBox(NULL, "No g_ICvar", NULL, NULL);
				return true;
			}
			
			gsg_load = new ConCommand("gsg_load", StartMenuLoad, "Load menuplugins", FCVAR_UNREGISTERED);
			g_ICvar->RegisterConCommand(gsg_load);
			
			/*
			//DEBUG
			lua_run_in = new ConCommand("lua_run_in", LuaRunMenu, "Run a Lua command", FCVAR_UNREGISTERED);
			g_ICvar->RegisterConCommand(lua_run_in);
			*/
			
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






