
#include "stdafx.h"
#include <stdio.h>
#include <iostream>
#include <Windows.h>
#include <string>
#include <fstream>
#include <direct.h>
#include <stdarg.h>
#include <sys/stat.h>

using namespace std;

HANDLE hPLThread;

int lol = 0;

DWORD WINAPI PLThread(LPVOID param) {
	while (lol < 1000) {
		lol++;
		
		printf("thread (%i)\n", lol);
	}
	
	return true;
}




int _tmain(int argc, _TCHAR* argv[]) {
	cout << "hello world\n";
	
	Sleep(500);
	
	hPLThread = CreateThread(NULL, NULL, &PLThread, NULL, NULL, NULL);
	
	printf("Made thread\n");
	
	Sleep(2000);
	return 0;
}

