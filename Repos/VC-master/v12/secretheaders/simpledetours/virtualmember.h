#ifndef VIRTUALMEMBER_H
#define VIRTUALMEMBER_H

#include "detours.h"

//############## Converts a virtual member-function's pointer to a member-function pointer. Thank you Jinto for helping me out with this @Jinto, aVoN
template<typename T>
union VirtualPointer_t{
	size_t* m_pointer;
	T m_function;
};

//############## Sets up entries in your Detour-Class @aVoN
#define VDETOUR_SETUP(_class_,_type_,_method_,...)\
	typedef _type_ (T##_method_)(##__VA_ARGS__);\
	typedef _type_ (_class_::*T__##_method_)(##__VA_ARGS__);\
	T##_method_ _method_;\
	static T__##_method_ __##_method_;

//############## Creates your hook @aVoN
#define VDETOUR_HOOK(_class_,_type_,_method_,...)\
	_class_::T__##_method_ _class_::__##_method_ = NULL;\
	_type_ _class_::_method_(##__VA_ARGS__)

//############## Starts detouring your method, giving the object as argument @aVoN
#define VDETOUR_FROM_OBJECT(_object_,_vtableindex_,_class_,_method_)\
	{\
		size_t** vtable = *reinterpret_cast<size_t***>(_object_);\
		VirtualPointer_t<_class_::T__##_method_> wrapper;\
		wrapper.m_pointer = vtable[_vtableindex_];\
		_class_::__##_method_ = reinterpret_cast<_class_::T__##_method_>(wrapper.m_function);\
	}\
	DetourAttach(&(PVOID&) _class_::__##_method_,(PVOID)(&(PVOID&)  _class_::_method_));

//############## Same as above but for passing classes (Creates momentary overhead - but frees memory again - Does not work if no non-generic constructor is available) @aVoN
#define VDETOUR_FROM_CLASS(_target_class_,_vtableindex_,_class_,_method_)\
	{\
		_target_class_* object = new _target_class_;\
		VDETOUR_FROM_OBJECT(object,_vtableindex_,_class_,_method_);\
		delete object;\
	}

//############## Removes/Detaches a hook @aVoN
#define VDETOUR_REMOVE(_class_,_method_)\
	DetourDetach(&(PVOID&) _class_::__##_method_,(PVOID)(&(PVOID&)  _class_::_method_));

/*
############## Example usage!
//Let's assume you want to detour the virtual method "int Read(bool b)" from IFileSystem.
class IFileSystem{
public:
	virtual int Read(bool b); //VTable index: 0
	virtual void Write(char c); //VTable index: 1
	bool Delete(int d); //This has NO VTable index
	virtual void Read(char e); //VTable index: 2
	
	//Overloaded functions are getting added in opposite order!
	virtual Size(int a);//VTable index: 5!!!!!
	virtual Size(bool b);//VTable index: 4!!!!!
	virtual Size(char c);//VTable index: 3!!!!!
	
	//VTable indexing is straight forward ... (Just with multiple-inherited classes, it's not that easy though)
};

//Then this class can (but hasn't be necessarily) initialized (You see why in code later - Two ways of detouring using VDETOUR_FROM_OBJECT or VDETOUR_FROM_CLASS)
IFileSystem* FILESYSTEM = new IFileSystem;



//To prepare detouring, create a class like this
class CDetour{
public:
	VDETOUR_SETUP(CDetour,int,Read,bool b);
	//The above macro does simply this
	//	int Read(bool b); //This is your hook
	//	static int (CDetour::*__Read)(bool b); 
}

//Then define your actual hook "int CDetour::Read(bool b)" with this
VDETOUR_HOOK(CDetour,int,Read,bool b){ //This defines CDetour::Read(bool b);
	(this->*__Read)(b); //With this, you can call the original method again
}

//Later in code: Start detouring. Make sure, you use the correct VTable index (here, it is 0)
DetourTransactionBegin();
DetourUpdateThread(GetCurrentThread());

//Now if your class already has an initialized object or has no generic constructor, use the already initialized object
VDETOUR_FROM_OBJECT(FILESYSTEM,0,CDetour,Read);
//Or if you want to, simply supply the classname with this method below (but be warned: This macro initializes the class and creates an object for the time it detours. It will destroy the object later)
VDETOUR_FROM_CLASS(IFileSystem,0,CDetour,Read);

DetourTransactionCommit();



//Unloading hooks

//Just run

DetourTransactionBegin();
DetourUpdateThread(GetCurrentThread());

VDETOUR_REMOVE(CDetour,Read);

DetourTransactionCommit();


//FAQ:
Q:	Why did I chose the order VDETOUR_SETUP(CDetour,int,Read,bool b) instead of VDETOUR_SETUP(int,CDetour,Read,bool b) which
	is more convenient for the naming convention of the method int CDetour::Read(bool b) ?
A:	It's better readable
	VDETOUR_SETUP(CDetour,int,Read,bool b)
	VDETOUR_SETUP(CDetour,bool,Write,bool b)
	
	looks better than
	
	VDETOUR_SETUP(int,CDetour,Read,bool b)
	VDETOUR_SETUP(bool,CDetour,Write,bool b)

*/

#endif //VIRTUALMEMBER_H
