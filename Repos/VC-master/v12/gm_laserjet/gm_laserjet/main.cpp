/*
	=== gm_laserjet ===
	*Because i got a free Laserjet 4200*
	
	Credits:
		. HeX
		. Anonymous (hpnt.c)
*/


#undef _UNICODE
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment (lib, "WSock32.lib")
#pragma comment (lib, "MsWSock.lib")

#include <GMLuaModule.h>

#include <winsock.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

using namespace std;

ILuaInterface* sv_Lua	= NULL;
int LCD_CHARS			= 20; //Default size is a Laserjet 4200's 20x4 LCD display
int LCD_LINES			= 4;
const char* Printer		= "0.0.0.0";
const char* Message		= "No Data";


LUA_FUNCTION(SetWidth) {
	sv_Lua->CheckType(1, GLua::TYPE_NUMBER);
	sv_Lua->CheckType(2, GLua::TYPE_NUMBER);
	
	LCD_CHARS = sv_Lua->GetNumber(1);
	LCD_LINES = sv_Lua->GetNumber(2);
	return 0;
}

LUA_FUNCTION(IPAddress) {
	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	
	Printer = sv_Lua->GetString(1);
	return 0;
}

LUA_FUNCTION(GetWide) {
	sv_Lua->PushDouble( LCD_CHARS );
	return 1;
}

LUA_FUNCTION(GetValue) {
	sv_Lua->Push( Message );
	return 1;
}



LUA_FUNCTION(WriteString) {
	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	
	if (strcmp(Printer, "0.0.0.0") == 0) {
		sv_Lua->Msg("[gm_laserjet]: You didn't set the IP!\n");
		sv_Lua->Push(false);
		return 1;
	}
	
	Message	= sv_Lua->GetString(1);
	struct hostent* host;
	struct sockaddr_in Client;
	SOCKET sockfd;
	WSADATA wsaData;
	
	if (WSAStartup(0x202, &wsaData) == SOCKET_ERROR) {
		sv_Lua->Msg("[gm_laserjet]: WSAStartup failed with error %d\n", WSAGetLastError() );
		WSACleanup();
		sv_Lua->Push(false);
		return 1;
	}
	
	if ( (host = gethostbyname(Printer)) == NULL) {
		sv_Lua->Msg("[gm_laserjet]: Can't find printer @ %s, did you set the IP?\n", Printer);
		WSACleanup();
		sv_Lua->Push(false);
		return 1;
	}
	
	memset(&Client,0,sizeof(Client));
	memcpy(&(Client.sin_addr),host->h_addr,host->h_length);	
	
	Client.sin_family = host->h_addrtype;
	Client.sin_port = htons(9100);
	
	if ((sockfd = socket(AF_INET,SOCK_STREAM,0)) < 0) {
		sv_Lua->Msg("[gm_laserjet]: Can't open connection to printer!\n");
		WSACleanup();
		sv_Lua->Push(false);
		return 1;
	}
	
	if (connect(sockfd, (struct sockaddr *)&Client,sizeof(Client)) == -1) {
		sv_Lua->Msg("[gm_laserjet]: Can't connect to printer's socket!\n");
		WSACleanup();
		sv_Lua->Push(false);
		return 1;
	}
	
	char* Line = new char[255];
		strcpy(Line,"\033%-12345X@PJL RDYMSG DISPLAY = \"");
		strncat(Line,Message, (LCD_CHARS * LCD_LINES) );
		strcat(Line,"\"\r\n\033%-12345X\r\n");
		
		int Sent = send(sockfd, Line, strlen(Line), 0);
	delete [] Line;
	
	closesocket(sockfd);
	WSACleanup();
	
	sv_Lua->Push( (float)Sent );
	return 1;
}




GMOD_MODULE(Open,Close);

int Open(lua_State* L) {
	sv_Lua = Lua();
	
	sv_Lua->NewGlobalTable("laserjet");
	ILuaObject* laserjet = sv_Lua->GetGlobal("laserjet");
		laserjet->SetMember("SetWidth", 	SetWidth);
		laserjet->SetMember("IPAddress", 	IPAddress);
		laserjet->SetMember("GetWide", 		GetWide);
		laserjet->SetMember("GetValue", 	GetValue);
		laserjet->SetMember("WriteString",	WriteString);
	laserjet->UnReference();
	
	sv_Lua->Msg("[gm_laserjet]: Loaded, made by HeX, code by \"Anonymous\" (hpnt.c)\n");
	return 0;
}

int Close(lua_State* L) {
	return 0;
}


