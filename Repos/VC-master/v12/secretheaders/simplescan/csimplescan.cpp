#include "csimplescan.h"

CSimpleScan::CSimpleScan()
{
}

CSimpleScan::CSimpleScan(const char *filename)
{
	SetDLL(filename);
}

bool CSimpleScan::SetDLL(const char *filename)
{
	if (!(m_Interface = Sys_GetFactory(filename)))
		return false;

	CSigScan::sigscan_dllfunc = m_Interface;

	if (!CSigScan::GetDllMemInfo())
		return false;

	return (m_bInterfaceSet = true);
}

bool CSimpleScan::FindFunction(const char *sig, const char *mask, void **func)
{
	if (!m_bInterfaceSet)
		return false;

	m_Signature.Init((unsigned char *)sig, (char *)mask, strlen(mask));

	if (!m_Signature.is_set)
		return false;

	*func = m_Signature.sig_addr;

	return true;
}