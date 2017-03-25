
#ifndef GARRYSMOD_LUA_TYPES_H
#define GARRYSMOD_LUA_TYPES_H

#ifdef ENTITY
#undef ENTITY
#endif 

#ifdef VECTOR
#undef VECTOR
#endif 

namespace GarrysMod 
{
	namespace Lua
	{
		namespace GLua
		{
			enum
			{
				TYPE_INVALID = -1,
				TYPE_NIL, 
				TYPE_BOOL,
				TYPE_LIGHTUSERDATA,
				TYPE_NUMBER, 
				TYPE_STRING, 
				TYPE_TABLE,
				TYPE_FUNCTION,
				TYPE_USERDATA,
				TYPE_THREAD,

				// UserData
				TYPE_ENTITY, 
				TYPE_VECTOR, 
				TYPE_ANGLE,
				TYPE_PHYSOBJ,
				TYPE_SAVE,
				TYPE_RESTORE,
				TYPE_DAMAGEINFO,
				TYPE_EFFECTDATA,
				TYPE_MOVEDATA,
				TYPE_RECIPIENTFILTER,
				TYPE_USERCMD,
				TYPE_SCRIPTEDVEHICLE,

				// Client Only
				TYPE_MATERIAL,
				TYPE_PANEL,
				TYPE_PARTICLE,
				TYPE_PARTICLEEMITTER,
				TYPE_TEXTURE,
				TYPE_USERMSG,

				TYPE_CONVAR,
				TYPE_IMESH,
				TYPE_MATRIX,
				TYPE_SOUND,
				TYPE_PIXELVISHANDLE,
				TYPE_DLIGHT,
				TYPE_VIDEO,
				TYPE_FILE,

				TYPE_COUNT
			};
		}
		
		namespace Type
		{
			enum
			{

				INVALID = -1,
				NIL, 
				BOOL,
				LIGHTUSERDATA,
				NUMBER, 
				STRING, 
				TABLE,
				FUNCTION,
				USERDATA,
				THREAD,

				// UserData
				ENTITY, 
				VECTOR, 
				ANGLE,
				PHYSOBJ,
				SAVE,
				RESTORE,
				DAMAGEINFO,
				EFFECTDATA,
				MOVEDATA,
				RECIPIENTFILTER,
				USERCMD,
				SCRIPTEDVEHICLE,

				// Client Only
				MATERIAL,
				PANEL,
				PARTICLE,
				PARTICLEEMITTER,
				TEXTURE,
				USERMSG,

				CONVAR,
				IMESH,
				MATRIX,
				SOUND,
				PIXELVISHANDLE,
				DLIGHT,
				VIDEO,
				FILE,

				COUNT
			};

			static const char* Name[] = 
			{
				"nil",
				"bool",
				"lightuserdata",
				"number",
				"string",
				"table",
				"function",
				"userdata",
				"thread",
				"entity",
				"vector",
				"angle",
				"physobj",
				"save",
				"restore",
				"damageinfo",
				"effectdata",
				"movedata",
				"recipientfilter",
				"usercmd",
				"vehicle",
				"material",
				"panel",
				"particle",
				"particleemitter",
				"texture",
				"usermsg",
				"convar",
				"mesh",
				"matrix",
				"sound",
				"pixelvishandle",
				"dlight",
				"video",
				"file",

				0
			};
		}
	}
}

#endif 

