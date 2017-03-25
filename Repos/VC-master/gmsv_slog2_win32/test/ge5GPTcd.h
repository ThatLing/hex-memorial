Inheritance Tree:
 CGameClient
  CBaseClient
   IGameEventListener2
   IClient
    INetChannelHandler
   IClientMessageHandler
    INetMessageHandler
  CClientFrameManager

VTable for CGameClient: (0, 0)
 Lin  Win Function
   0    0 CGameClient::~CGameClient()
   1    0 CGameClient::~CGameClient()
   2    1 CBaseClient::FireGameEvent(IGameEvent *)
   3      CBaseClient::GetPlayerSlot(void)const
   4      CBaseClient::GetUserID(void)const
   5      CBaseClient::GetNetworkID(void)const
   6      CBaseClient::GetClientName(void)const
   7      CBaseClient::GetNetChannel(void)
   8      CBaseClient::GetServer(void)
   9      CBaseClient::GetUserSetting(char  const*)const
  10      CBaseClient::GetNetworkIDString(void)const
  11      CGameClient::Connect(char  const*, int, INetChannel *, bool, int)
  12      CGameClient::Inactivate(void)
  13      CGameClient::Reconnect(void)
  14      CGameClient::Disconnect(char  const*, ...)
  15      CGameClient::SetRate(int, bool)
  16      CBaseClient::GetRate(void)const
  17      CGameClient::SetUpdateRate(int, bool)
  18      CBaseClient::GetUpdateRate(void)const
  19      CGameClient::Clear(void)
  20    2 CBaseClient::DemoRestart(void)
  21      CBaseClient::GetMaxAckTickCount(void)const
  22      CGameClient::ExecuteStringCommand(char  const*)
  23      CGameClient::SendNetMsg(INetMessage &, bool)
  24      CBaseClient::ClientPrintf(char  const*, ...)
  25      CBaseClient::IsConnected(void)const
  26      CBaseClient::IsSpawned(void)const
  27      CBaseClient::IsActive(void)const
  28      CBaseClient::IsFakeClient(void)const
  29      CBaseClient::IsHLTV(void)const
  30      CBaseClient::IsReplay(void)const
  31      CGameClient::IsHearingClient(int)const
  32      CGameClient::IsProximityHearingClient(int)const
  33      CBaseClient::SetMaxRoutablePayloadSize(int)
  34    3 CBaseClient::IsSplitScreenUser(void)const
  35      CBaseClient::ProcessTick(NET_Tick *)
  36      CBaseClient::ProcessStringCmd(NET_StringCmd *)
  37      CBaseClient::ProcessSetConVar(NET_SetConVar *)
  38      CBaseClient::ProcessSignonState(NET_SignonState *)
  39      CGameClient::ProcessClientInfo(CLC_ClientInfo *)
  40      CBaseClient::ProcessBaselineAck(CLC_BaselineAck *)
  41      CBaseClient::ProcessListenEvents(CLC_ListenEvents *)
  42      CGameClient::ProcessCmdKeyValues(CLC_CmdKeyValues *)
  43      CBaseClient::ConnectionStart(INetChannel *)
  44    4 CGameClient::UpdateAcknowledgedFramecount(int)
  45    5 CGameClient::ShouldSendMessages(void)
  46    6 CBaseClient::UpdateSendState(void)
  47    7 CBaseClient::FillUserInfo(player_info_s &)
  48    8 CGameClient::UpdateUserSettings(void)
  49    9 CGameClient::SetSignonState(int, int)
  50   10 CGameClient::WriteGameSounds(bf_write &)
  51   11 CGameClient::GetDeltaFrame(int)
  52   12 CGameClient::SendSnapshot(CClientFrame *)
  53   13 CBaseClient::SendServerInfo(void)
  54   14 CGameClient::SendSignonData(void)
  55   15 CGameClient::SpawnPlayer(void)
  56   16 CGameClient::ActivatePlayer(void)
  57   17 CBaseClient::SetName(char  const*)
  58   18 CBaseClient::SetUserCVar(char  const*, char  const*)
  59   19 CBaseClient::FreeBaselines(void)
  60   20 CGameClient::IgnoreTempEntity(CEventInfo *)
  61      CGameClient::ConnectionClosing(char  const*)
  62      CGameClient::ConnectionCrashed(char  const*)
  63      CGameClient::PacketStart(int, int)
  64      CGameClient::PacketEnd(void)
  65      CGameClient::FileReceived(char  const*, unsigned int)
  66      CGameClient::FileRequested(char  const*, unsigned int)
  67      CGameClient::FileDenied(char  const*, unsigned int)
  68      CGameClient::FileSent(char  const*, unsigned int)
  69      CGameClient::ProcessMove(CLC_Move *)
  70      CGameClient::ProcessVoiceData(CLC_VoiceData *)
  71      CGameClient::ProcessRespondCvarValue(CLC_RespondCvarValue *)
  72      CGameClient::ProcessFileCRCCheck(CLC_FileCRCCheck *)
  73      CGameClient::ProcessFileMD5Check(CLC_FileMD5Check *)
  74      CGameClient::ProcessSaveReplay(CLC_SaveReplay *)

VTable for IClientMessageHandler: (1, 8)
 Lin  Win Function
T  0    0 CGameClient::~CGameClient()
T  1    0 CGameClient::~CGameClient()
T  2    1 CBaseClient::ProcessTick(NET_Tick *)
T  3    2 CBaseClient::ProcessStringCmd(NET_StringCmd *)
T  4    3 CBaseClient::ProcessSetConVar(NET_SetConVar *)
T  5    4 CBaseClient::ProcessSignonState(NET_SignonState *)
T  6    5 CGameClient::ProcessClientInfo(CLC_ClientInfo *)
T  7    6 CGameClient::ProcessMove(CLC_Move *)
T  8    7 CGameClient::ProcessVoiceData(CLC_VoiceData *)
T  9    8 CBaseClient::ProcessBaselineAck(CLC_BaselineAck *)
T 10    9 CBaseClient::ProcessListenEvents(CLC_ListenEvents *)
T 11   10 CGameClient::ProcessRespondCvarValue(CLC_RespondCvarValue *)
T 12   11 CGameClient::ProcessFileCRCCheck(CLC_FileCRCCheck *)
T 13   12 CGameClient::ProcessFileMD5Check(CLC_FileMD5Check *)
T 14   13 CGameClient::ProcessSaveReplay(CLC_SaveReplay *)
T 15   14 CGameClient::ProcessCmdKeyValues(CLC_CmdKeyValues *)

VTable for CClientFrameManager: (2, 160580)
 Lin  Win Function
T  0    0 CGameClient::~CGameClient()
T  1    0 CGameClient::~CGameClient()

VTable for IClient: (3, 4)
 Lin  Win Function
T  0    0 CGameClient::~CGameClient()
T  1    0 CGameClient::~CGameClient()
T  2    1 CBaseClient::ConnectionStart(INetChannel *)
T  3    2 CGameClient::ConnectionClosing(char  const*)
T  4    3 CGameClient::ConnectionCrashed(char  const*)
T  5    4 CGameClient::PacketStart(int, int)
T  6    5 CGameClient::PacketEnd(void)
T  7    6 CGameClient::FileRequested(char  const*, unsigned int)
T  8    7 CGameClient::FileReceived(char  const*, unsigned int)
T  9    8 CGameClient::FileDenied(char  const*, unsigned int)
T 10    9 CGameClient::FileSent(char  const*, unsigned int)
T 11   10 CGameClient::Connect(char  const*, int, INetChannel *, bool, int)
T 12   11 CGameClient::Inactivate(void)
T 13   12 CGameClient::Reconnect(void)
T 14   13 CGameClient::Disconnect(char  const*, ...)
T 15   14 CBaseClient::GetPlayerSlot(void)const
T 16   15 CBaseClient::GetUserID(void)const
T 17   16 CBaseClient::GetNetworkID(void)const
T 18   17 CBaseClient::GetClientName(void)const
T 19   18 CBaseClient::GetNetChannel(void)
T 20   19 CBaseClient::GetServer(void)
T 21   20 CBaseClient::GetUserSetting(char  const*)const
T 22   21 CBaseClient::GetNetworkIDString(void)const
T 23   22 CGameClient::SetRate(int, bool)
T 24   23 CBaseClient::GetRate(void)const
T 25   24 CGameClient::SetUpdateRate(int, bool)
T 26   25 CBaseClient::GetUpdateRate(void)const
T 27   26 CGameClient::Clear(void)
T 28   27 CBaseClient::GetMaxAckTickCount(void)const
T 29   28 CGameClient::ExecuteStringCommand(char  const*)
T 30   29 CGameClient::SendNetMsg(INetMessage &, bool)
T 31   30 CBaseClient::ClientPrintf(char  const*, ...)
T 32   31 CBaseClient::IsConnected(void)const
T 33   32 CBaseClient::IsSpawned(void)const
T 34   33 CBaseClient::IsActive(void)const
T 35   34 CBaseClient::IsFakeClient(void)const
T 36   35 CBaseClient::IsHLTV(void)const
T 37   36 CBaseClient::IsReplay(void)const
T 38   37 CGameClient::IsHearingClient(int)const
T 39   38 CGameClient::IsProximityHearingClient(int)const
T 40   39 CBaseClient::SetMaxRoutablePayloadSize(int)