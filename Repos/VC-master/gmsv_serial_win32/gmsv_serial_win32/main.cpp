
//Win
#pragma comment (linker, "/NODEFAULTLIB:libcmt")

#define WIN32_LEAN_AND_MEAN
#define COMPILER_MSVC 1
#define COMPILER_MSVC32 1
#include <Windows.h>
#include <direct.h>
#include <exception>
#include <fstream>
#include <string>
#include <stdlib.h>
#include <sstream>
#include <vector>
#include <iostream>
#include <ctime>

//GMod
#include "danielga\include\GarrysMod\Lua\Interface.h"
#include "danielga\include\GarrysMod\Lua\LuaInterface.h"

using namespace std;
using namespace GarrysMod::Lua;



//Serial
#include <stdio.h>
#include <conio.h>

HANDLE hDevice = NULL;


//Open
LUA_FUNCTION(Open) {
	if (hDevice) {
		LUA->PushBool(false);
		LUA->PushString("! Serial already open, Close it first!");
		return 2;
	}
	const char* COMPort = LUA->CheckString(1);
	double rTout		= LUA->CheckNumber(2);
	double wTout		= LUA->CheckNumber(3);
	
	//Open
	hDevice = CreateFile(COMPort, GENERIC_READ | GENERIC_WRITE,FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, NULL,NULL);
	
	//Config
	if (hDevice !=INVALID_HANDLE_VALUE) {
		DCB Conf;
		GetCommState(hDevice, &Conf);
			Conf.BaudRate 		= CBR_9600;
			Conf.ByteSize 		= 8;
			Conf.Parity 		= NOPARITY;
			Conf.StopBits 		= ONESTOPBIT;
			Conf.fDtrControl 	= DTR_CONTROL_DISABLE;
		SetCommState(hDevice, &Conf);
		
		COMMTIMEOUTS TOut;
			/*
			TOut.ReadIntervalTimeout 			= 1;
			TOut.ReadTotalTimeoutMultiplier 	= 1;
			TOut.ReadTotalTimeoutConstant 		= 1;
			TOut.WriteTotalTimeoutMultiplier 	= 1;
			TOut.WriteTotalTimeoutConstant 		= 1;
			*/
			TOut.ReadIntervalTimeout 			= 0;
			TOut.ReadTotalTimeoutMultiplier 	= 0;
			TOut.ReadTotalTimeoutConstant 		= (DWORD)rTout;
			TOut.WriteTotalTimeoutMultiplier 	= 0;
			TOut.WriteTotalTimeoutConstant 		= (DWORD)wTout;
		SetCommTimeouts(hDevice, &TOut);
		
		LUA->PushBool(true);
		return 1;
	}
	
	LUA->PushBool(false);
	LUA->PushNumber( GetLastError() );
	return 2;
}

//Close
LUA_FUNCTION(Close) {
	if (!hDevice) {
		LUA->PushBool(false);
		LUA->PushString("! Can't close what isn't Open!");
		return 2;
	}
	
	//Close
	CloseHandle(hDevice);
	hDevice = NULL;
	
	LUA->PushBool(true);
	return 1;
}

//IsValid
LUA_FUNCTION(IsValid) {
	if (!hDevice) {
		LUA->PushBool(false);
		return 1;
	}
	LUA->PushBool( hDevice != INVALID_HANDLE_VALUE );
	return 1;
}


//Read
LUA_FUNCTION(Read) {
	if (!hDevice) {
		LUA->PushBool(false);
		LUA->PushString("! Can't Read, port not Open!");
		return 2;
	}
	unsigned int Bytes = LUA->CheckNumber(1);
	
	char* Buff = new char[ Bytes ];
	DWORD TotRead;
	
	//Read
	ReadFile(hDevice, Buff,Bytes, &TotRead, NULL);
	if (TotRead) {
		LUA->PushString( (const char*)Buff, Bytes);
		LUA->PushNumber(TotRead);
		
	} else {
		LUA->PushBool(false);
		LUA->PushNumber( GetLastError() );
	}
	delete [] Buff;
	
	return 2;
}



//Write
LUA_FUNCTION(Write) {
	if (!hDevice) {
		LUA->PushBool(false);
		LUA->PushString("! Can't Write, port not Open!");
		return 2;
	}
	const char* Data = LUA->CheckString(1);
	
	DWORD TotWrite;
	
	//Write
	WriteFile(hDevice, Data,strlen(Data), &TotWrite, NULL);
	if (TotWrite) {
		LUA->PushNumber(TotWrite);
		return 1;
		
	} else {
		LUA->PushBool(false);
		LUA->PushNumber( GetLastError() );
		
		return 2;
	}
}





//Open
GMOD_MODULE_OPEN() {
	LUA->PushSpecial(0);
		LUA->CreateTable();
			LUA->PushCFunction(Open);
			LUA->SetField(-2, "Open");
			
			LUA->PushCFunction(Close);
			LUA->SetField(-2, "Close");
			
			LUA->PushCFunction(IsValid);
			LUA->SetField(-2, "IsValid");
			
			LUA->PushCFunction(Read);
			LUA->SetField(-2, "Read");
			
			LUA->PushCFunction(Write);
			LUA->SetField(-2, "Write");
			
		LUA->SetField(-2, "serial");
	LUA->Pop();
	
	return 0;
}

//Close
GMOD_MODULE_CLOSE() {
	//Close port
	CloseHandle(hDevice);
	hDevice = NULL;
	
	return 0;
}



























