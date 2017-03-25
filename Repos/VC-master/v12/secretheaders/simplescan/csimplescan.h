#ifndef CSIMPLESCAN_H
#define CSIMPLESCAN_H

#include <interface.h>

#include "sigscan.h"

class CSimpleScan
{
public:
	CSimpleScan();
	CSimpleScan(const char *filename);

	bool SetDLL(const char *filename);
	bool FindFunction(const char *sig, const char *mask, void **func);
private:
	bool m_bInterfaceSet;

	CreateInterfaceFn m_Interface;
	CSigScan m_Signature;
};

#endif //CSIMPLESCAN_H