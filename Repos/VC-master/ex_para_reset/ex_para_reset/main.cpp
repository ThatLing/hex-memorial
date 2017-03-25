

#pragma once
#pragma comment(lib, "inpout32.lib")

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

short	_stdcall Inp32(short PortAddress);
void 	_stdcall Out32(short PortAddress, short data);


int main(int argc, char* argv[]) {
	Out32(888, 0);
	printf("Port 888 reset\n");
	return 0;
}










