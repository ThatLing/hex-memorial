

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <stdio.h>
#include <string>
#include <direct.h>
#include <iostream>
#include <list>
#include <algorithm>

using namespace std;



void rmkdir(const char *pszPath) {
	char *pszScan = const_cast<char*>(pszPath);

	if (*pszScan && *(pszScan + 1) == ':' && *(pszScan + 2) == '\\') {
		pszScan += 3;
	}
	
	char *pszLimit = pszScan + strlen( pszScan ) + 1;
	
	while (pszScan < pszLimit)
	{
		if (*pszScan == '\\' || *pszScan == 0) {
			char temp = *pszScan;
			*pszScan = 0;
				_mkdir(pszPath);
			*pszScan = temp;
		}
		pszScan++;
	}
}


int main(int argc, char* argv[]) {
	if (argc != 2) {
		printf("Whoops!\n");
		return 1;
	}
	
	rmkdir( argv[1] );
	
	printf("\n!made: %s\n", argv[1]);
	
	return 0;
}










