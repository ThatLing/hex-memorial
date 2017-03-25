#ifndef CSIMPLEDETOUR_H
#define CSIMPLEDETOUR_H

#include "detours.h"

class CSimpleDetour
{
public:
	CSimpleDetour( void **old, void *replacement );

	void Attach();
	void Detach();
private:
	void **m_fnOld;
	void *m_fnReplacement;

	bool m_bAttached;
};

#define SETUP_SIMPLE_DETOUR( name, old, replacement ) \
	CSimpleDetour name( &(void * &)old, (void *)(&(void * &)replacement) )

#endif //CSIMPLEDETOUR_H