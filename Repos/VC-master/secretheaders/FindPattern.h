


#include <Windows.h>


BOOL DataCompare( BYTE* pData, BYTE* bMask, char * szMask ) {
	for ( ; *szMask; ++szMask, ++pData, ++bMask ) {
		if ( *szMask == 'x' && *pData != *bMask ) {
			return FALSE;
		}
	}
	return (*szMask == NULL);
}
DWORD FindPattern( DWORD dwAddress, DWORD dwLen, BYTE *bMask, char * szMask ) {
	for (DWORD i = 0; i < dwLen; i++) {
		if ( DataCompare( (BYTE*)( dwAddress + i ), bMask, szMask ) ) {
			return (DWORD)( dwAddress + i );
		}
	}
	return 0;
}



