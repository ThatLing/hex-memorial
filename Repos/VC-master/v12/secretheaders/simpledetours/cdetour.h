class CDetour
{
public:
        bool CLuaInterface_FindAndRunScript_H(const char *, bool, bool);
        static bool (CDetour:: *CLuaInterface_FindAndRunScript_T)(const char *, bool, bool);
};