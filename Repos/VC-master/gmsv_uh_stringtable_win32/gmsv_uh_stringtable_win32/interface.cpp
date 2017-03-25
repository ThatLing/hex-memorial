#include "interface.h"

#ifdef _WIN32
#include <Windows.h>
#else
// TODO:
#endif

typedef void *(*CreateInterfaceFn)(const char *name, int *ret);

void *GetInterface_Internal(const char *module_name, const char *interface_name) {
	HMODULE hModule;
	CreateInterfaceFn CreateInterface;

	if (!(hModule = GetModuleHandle(module_name)))
		return nullptr;

	if (!(CreateInterface = reinterpret_cast<CreateInterfaceFn>(GetProcAddress(hModule, "CreateInterface"))))
		return nullptr;

	return CreateInterface(interface_name, 0);
}