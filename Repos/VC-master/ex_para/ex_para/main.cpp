

#pragma once
#pragma comment(lib, "inpout32.lib")

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

short	_stdcall Inp32(short PortAddress);
void 	_stdcall Out32(short PortAddress, short data);









int main(int argc, char* argv[]) {
	if (argc<3) {
		printf("Error : too few arguments\n\n***** Usage *****\n\nInpoutTest read <ADDRESS> \nor \nInpoutTest write <ADDRESS> <DATA>\n\n\n\n\n");
		return 0;
	}
	
	if (!strcmp(argv[1], "read")) {
		int data = Inp32( atoi(argv[2]) );
		printf("Data read from address %s is %d\n", argv[2], data);
	} 
	else if (!strcmp(argv[1], "write")) {
		if (argc<4) {
			printf("Error in arguments supplied");
			printf("\n***** Usage *****\n\nInpoutTest read <ADDRESS> \nor \nInpoutTest write <ADDRESS> <DATA>\n");
			return 0;
		}
		
		printf("Data writing to %s\n\n\n", argv[2]);
		Out32( atoi(argv[2]), atoi(argv[3]) );
	}
	return 0;
}










