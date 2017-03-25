// This is not a real plugin, mostly a struct so that GetPluginDescription can be called

#include "plugin.h"

FakePluginWhyDoThisToMeValve::FakePluginWhyDoThisToMeValve()
{
	m_iClientCommandIndex = 0;
}

FakePluginWhyDoThisToMeValve::~FakePluginWhyDoThisToMeValve()
{
}

bool FakePluginWhyDoThisToMeValve::Load(CreateInterfaceFn interfaceFactory, CreateInterfaceFn gameServerFactory) {
	return true;
}

void FakePluginWhyDoThisToMeValve::Unload(void)
{
}

void FakePluginWhyDoThisToMeValve::Pause(void)
{
}

void FakePluginWhyDoThisToMeValve::UnPause(void)
{
}

const char *FakePluginWhyDoThisToMeValve::GetPluginDescription(void)
{
	return "AskConnect Plugin";
}

void FakePluginWhyDoThisToMeValve::LevelInit(char const *pMapName)
{
}

void FakePluginWhyDoThisToMeValve::ServerActivate(edict_t *pEdictList, int edictCount, int clientMax)
{
}

void FakePluginWhyDoThisToMeValve::GameFrame(bool simulating)
{
}

void FakePluginWhyDoThisToMeValve::LevelShutdown(void)
{
}

void FakePluginWhyDoThisToMeValve::ClientActive(edict_t *pEntity)
{
}

void FakePluginWhyDoThisToMeValve::ClientDisconnect(edict_t *pEntity)
{
}

void FakePluginWhyDoThisToMeValve::ClientPutInServer(edict_t *pEntity, char const *playername)
{
}

void FakePluginWhyDoThisToMeValve::SetCommandClient(int index)
{
}

void FakePluginWhyDoThisToMeValve::ClientSettingsChanged(edict_t *pEdict)
{
}

PLUGIN_RESULT FakePluginWhyDoThisToMeValve::ClientConnect(bool *bAllowConnect, edict_t *pEntity, const char *pszName, const char *pszAddress, char *reject, int maxrejectlen)
{
	return PLUGIN_CONTINUE;
}

PLUGIN_RESULT FakePluginWhyDoThisToMeValve::ClientCommand(edict_t *pEntity, const CCommand &args)
{
	return PLUGIN_CONTINUE;
}

PLUGIN_RESULT FakePluginWhyDoThisToMeValve::NetworkIDValidated(const char *pszUserName, const char *pszNetworkID)
{
	return PLUGIN_CONTINUE;
}

void FakePluginWhyDoThisToMeValve::OnQueryCvarValueFinished(QueryCvarCookie_t iCookie, edict_t *pPlayerEntity, EQueryCvarValueStatus eStatus, const char *pCvarName, const char *pCvarValue)
{
}

void FakePluginWhyDoThisToMeValve::FireGameEvent(KeyValues * event)
{
}

void FakePluginWhyDoThisToMeValve::OnEdictAllocated(edict_t *edict)
{
}
void FakePluginWhyDoThisToMeValve::OnEdictFreed(const edict_t *edict)
{
}

FakePluginWhyDoThisToMeValve g_EmptyServerPlugin;