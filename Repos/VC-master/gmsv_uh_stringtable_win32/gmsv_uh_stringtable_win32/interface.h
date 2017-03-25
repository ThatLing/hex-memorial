#ifndef GM_STRINGTABLE_INTERFACE_H
#define GM_STRINGTABLE_INTERFACE_H


void *GetInterface_Internal(const char *module_name, const char *interface_name);

template<class TYPE>
TYPE GetInterface(const char *module_name, const char *interface_name) {
	return reinterpret_cast<TYPE>(GetInterface_Internal(module_name, interface_name));
}


#endif