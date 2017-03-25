#define WIN32_LEAN_AND_MEAN


#define SDK_DLL
#define GAME_DLL
#define CLIENT_DLL

//Windows
#include <Windows.h>
#include <iostream>
#include <string>
#include <sstream>

//SDK
#include "interface.h"
#include "networkstringtabledefs.h"

//GMod
#include "danielga\include\GarrysMod\Lua\Interface.h"


using namespace GarrysMod;

HANDLE hConsole;
HWND wConsole;



//Setpos
int SetConsolePosition(lua_State* state) {
	LUA->CheckType(1, Lua::Type::NUMBER);
	LUA->CheckType(2, Lua::Type::NUMBER);
	LUA->CheckType(3, Lua::Type::NUMBER);
	LUA->CheckType(4, Lua::Type::NUMBER);
	
	int x 		= LUA->GetNumber(1);
	int y 		= LUA->GetNumber(2);
	
	int w 		= LUA->GetNumber(3);
	int h 		= LUA->GetNumber(4);
	
	if (!wConsole) {
		LUA->ThrowError("[consize] Couldn't find wConsole\n");
		return 0;
	}
	
	MoveWindow(wConsole, x,y, w,h, true);
	
	return 0;
}

//Size
int SetConsoleSize(lua_State *state) {
	LUA->CheckType(1, Lua::Type::NUMBER);
	LUA->CheckType(2, Lua::Type::NUMBER);
	
	int x = LUA->GetNumber(1);
	int y = LUA->GetNumber(2);
	
	if (!hConsole) {
		LUA->ThrowError("[consize] Couldn't find hConsole\n");
		return 0;
	}
	
	
	//Check size is in range
	COORD largestSize = GetLargestConsoleWindowSize(hConsole);
	if (x > largestSize.X) {
		LUA->ThrowError("[consize] X too big!\n");
		return 0;
	}
	if (y > largestSize.Y) {
		LUA->ThrowError("[consize] Y too big!\n");
		return 0;
	}
	
	
	CONSOLE_SCREEN_BUFFER_INFO bufferInfo;
	if (!GetConsoleScreenBufferInfo(hConsole, &bufferInfo)) {
		LUA->ThrowError("[consize] Unable to retrieve screen buffer!\n");
		return 0;
	}
	
	SMALL_RECT& winInfo = bufferInfo.srWindow;
	COORD windowSize = { winInfo.Right - winInfo.Left + 1, winInfo.Bottom - winInfo.Top + 1};
	
	if (windowSize.X > x || windowSize.Y > y) {
		// window size needs to be adjusted before the buffer size can be reduced.
		SMALL_RECT info = 
		{ 
			0, 
			0, 
			x < windowSize.X ? x-1 : windowSize.X-1, 
			y < windowSize.Y ? y-1 : windowSize.Y-1 
		};
		
		if ( !SetConsoleWindowInfo(hConsole, TRUE, &info) ) {
			LUA->ThrowError("[consize] Unable to resize window before resizing buffer!\n");
			return 0;
		}
	}
	
	COORD size = {x,y};
	if ( !SetConsoleScreenBufferSize(hConsole, size) ) {
		LUA->ThrowError("[consize] Unable to resize screen buffer!\n");
		return 0;
	}
	
	SMALL_RECT info = { 0, 0, x - 1, y - 1 };
	if ( !SetConsoleWindowInfo(hConsole, TRUE, &info) ) {
		LUA->ThrowError("[consize] Unable to resize window after resizing buffer!\n");
		return 0;
	}
}










//MaxConsoleSize
int MaxConsoleSize(lua_State* state) {
	if (!hConsole) {
		LUA->ThrowError("[consize] Couldn't find hConsole\n");
		return 0;
	}
	
	//Check size is in range
	COORD largestSize = GetLargestConsoleWindowSize(hConsole);
	
	LUA->PushNumber( largestSize.X );
	LUA->PushNumber( largestSize.Y );
	
	return 2;
}

//Get
int CurrentSize(lua_State* state) {
	if (!hConsole) {
		LUA->ThrowError("[consize] Couldn't find hConsole\n");
		return 0;
	}
	
	CONSOLE_SCREEN_BUFFER_INFO Buffer;
	int Ran = GetConsoleScreenBufferInfo(hConsole, &Buffer);
	if (!Ran) {
		LUA->ThrowError("[consize] CurrentSize, GetConsoleScreenBufferInfo didn't run\n");
		return 0;
	}
	
	LUA->PushNumber( Buffer.dwSize.X );
	LUA->PushNumber( Buffer.dwSize.Y );
	
	return 2;
}




GMOD_MODULE_OPEN() {
	//Get console window
	wConsole = GetConsoleWindow();
	if ( !wConsole ) {
		LUA->ThrowError("Can't get wConsole: " + GetLastError() );
		return 0;
	}
	
	//Get console handle
	hConsole = CreateFile("CONOUT$", GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, 0, NULL);
	if (hConsole == INVALID_HANDLE_VALUE) {
		LUA->ThrowError("Can't get hConsole handle: " + GetLastError() );
		return 1;
	}
	
	
	LUA->PushSpecial(Lua::SPECIAL_GLOB);
		LUA->CreateTable();
			//Setting
			LUA->PushCFunction(SetConsoleSize);
			LUA->SetField(-2, "SetSize");
			
			LUA->PushCFunction(SetConsolePosition);
			LUA->SetField(-2, "SetPos");
			
			
			//Gettting
			LUA->PushCFunction(MaxConsoleSize);
			LUA->SetField(-2, "MaxSize");
			
			LUA->PushCFunction(CurrentSize);
			LUA->SetField(-2, "CurrentSize");
		LUA->SetField(-2, "consize");
	LUA->Pop();
	
	return 0;
}

GMOD_MODULE_CLOSE() {
	return 0;
}
