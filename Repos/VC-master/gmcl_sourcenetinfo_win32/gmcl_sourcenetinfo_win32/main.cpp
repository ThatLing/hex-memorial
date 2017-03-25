

#define INETCHANNEL_NAME "NetChannel"
#define INETCHANNEL_ID 121


#pragma once
#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment(lib, "vstdlib.lib")
#pragma comment(lib, "tier0.lib")
#pragma comment(lib, "tier1.lib")

#include <ILuaModuleManager.h>

#include <eiface.h>
#include <cdll_int.h>
#include <inetchannelinfo.h>
#include <inetchannel.h>


ILuaInterface* cl_Lua 			= NULL;
IVEngineClient* cl_engine 		= NULL;
ICvar* g_ICvar					= NULL;



static ConCommand* disconnect_msg	= NULL;

void DisconnectCmd(const CCommand &args) {
	if (args.ArgC() < 2) {
		Warning("disconnect_msg <str>\n");
		
	} else {
		INetChannel* playerNC = (INetChannel*)cl_engine->GetNetChannelInfo();
		
		if (playerNC) {
			playerNC->Shutdown( args.ArgS() );
			//Warning("Disconnected: %s\n", args.ArgS() );
		} else {
			Warning("disconnect_msg: No INetChannel\n");
		}
	}
}





LUA_FUNCTION(CL_GetNetChannel) {
	INetChannel* playerNC = (INetChannel*)cl_engine->GetNetChannelInfo();

	if (playerNC)
	{
		ILuaObject* metaT = cl_Lua->GetMetaTable(INETCHANNEL_NAME, INETCHANNEL_ID);
			cl_Lua->PushUserData(metaT, playerNC, INETCHANNEL_ID);
		metaT->UnReference();
	}
	else
	{
		cl_Lua->PushNil();
	}

	return 1;
}





LUA_FUNCTION(GetName)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->GetName());

	return 1;
}

LUA_FUNCTION(GetAddress)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->GetAddress());

	return 1;
}

LUA_FUNCTION(GetTime)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetTime());

	return 1;
}

LUA_FUNCTION(GetTimeConnected)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetTimeConnected());

	return 1;
}

LUA_FUNCTION(GetBufferSize)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetBufferSize());

	return 1;
}

LUA_FUNCTION(GetDataRate)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetDataRate());

	return 1;
}

LUA_FUNCTION(IsLoopback)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->IsLoopback());

	return 1;
}

LUA_FUNCTION(IsTimingOut)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->IsTimingOut());

	return 1;
}

LUA_FUNCTION(IsPlayback)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->IsPlayback());

	return 1;
}

LUA_FUNCTION(GetLatency)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetLatency(cl_Lua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetAvgLatency)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetAvgLatency(cl_Lua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetAvgLoss)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetAvgLoss(cl_Lua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetAvgChoke)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetAvgChoke(cl_Lua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetAvgData)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetAvgData(cl_Lua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetAvgPackets)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetAvgPackets(cl_Lua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetTotalData)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetTotalData(cl_Lua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetSequenceNr)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetSequenceNr(cl_Lua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(IsValidPacket)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);
	cl_Lua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->IsValidPacket(cl_Lua->GetInteger(2), cl_Lua->GetInteger(3)));

	return 1;
}

LUA_FUNCTION(GetPacketTime)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);
	cl_Lua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetPacketTime(cl_Lua->GetInteger(2), cl_Lua->GetInteger(3)));

	return 1;
}

LUA_FUNCTION(GetPacketBytes)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);
	cl_Lua->CheckType(3, GLua::TYPE_NUMBER);
	cl_Lua->CheckType(4, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetPacketBytes(cl_Lua->GetInteger(2), cl_Lua->GetInteger(3), cl_Lua->GetInteger(4)));

	return 1;
}

LUA_FUNCTION(GetStreamProgress)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	int received = 0, total = 0;
	
	if (channel->GetStreamProgress(cl_Lua->GetInteger(2), &received, &total))
	{
		ILuaObject *returnT  = cl_Lua->GetNewTable();
			returnT->SetMember("received", (float)received);
			returnT->SetMember("total", (float)total);
			
			cl_Lua->Push(returnT);
		returnT->UnReference();
	}
	else
	{
		cl_Lua->PushNil();
	}

	return 1;
}

LUA_FUNCTION(GetTimeSinceLastReceived)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetTimeSinceLastReceived());

	return 1;
}

LUA_FUNCTION(GetCommandInterpolationAmount)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);
	cl_Lua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetCommandInterpolationAmount(cl_Lua->GetInteger(2), cl_Lua->GetInteger(3)));

	return 1;
}

LUA_FUNCTION(GetPacketResponseLatency)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);
	cl_Lua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	int pnLatencyMsecs = 0, pnChoke = 0;

	channel->GetPacketResponseLatency(cl_Lua->GetInteger(2), cl_Lua->GetInteger(3), &pnLatencyMsecs, &pnChoke);

	ILuaObject *returnT = cl_Lua->GetNewTable();
		returnT->SetMember("latency", (float)pnLatencyMsecs);
		returnT->SetMember("choke", (float)pnChoke);

		cl_Lua->Push(returnT);
	returnT->UnReference();

	return 1;
}

LUA_FUNCTION(GetRemoteFramerate)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	float pflFrameTime = 0.0f, pflFrameTimeStdDeviation = 0.0f;

	channel->GetRemoteFramerate(&pflFrameTime, &pflFrameTimeStdDeviation);

	ILuaObject *returnT = cl_Lua->GetNewTable();
		returnT->SetMember("frametime", pflFrameTime);
		returnT->SetMember("frametimestddeviation", pflFrameTimeStdDeviation);

		cl_Lua->Push(returnT);
	returnT->UnReference();

	return 1;
}

LUA_FUNCTION(GetTimeoutSeconds)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetTimeoutSeconds());

	return 1;
}

LUA_FUNCTION(SetDataRate)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->SetDataRate(cl_Lua->GetDouble(2));

	return 0;
}

LUA_FUNCTION(StartStreaming)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->StartStreaming(cl_Lua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(ResetStreaming)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->ResetStreaming();

	return 0;
}

LUA_FUNCTION(SetTimeout)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->SetTimeout(cl_Lua->GetDouble(2));

	return 0;
}

LUA_FUNCTION(SetChallengeNr)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->SetChallengeNr(cl_Lua->GetInteger(2));

	return 0;
}

LUA_FUNCTION(Reset)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->Reset();

	return 0;
}

LUA_FUNCTION(Clear)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->Clear();

	return 0;
}

LUA_FUNCTION(Shutdown)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_STRING);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->Shutdown(cl_Lua->GetString(2));
	
	return 0;
}

LUA_FUNCTION(ProcessPlayback)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->ProcessPlayback();

	return 0;
}

LUA_FUNCTION(ProcessStream)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->ProcessStream());

	return 1;
}

LUA_FUNCTION(SetChoked)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->SetChoked();

	return 0;
}

LUA_FUNCTION(Transmit)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_BOOL);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->Transmit(cl_Lua->GetBool(2)));

	return 1;
}

LUA_FUNCTION(GetDropNumber)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetDropNumber());

	return 1;
}

LUA_FUNCTION(GetSocket)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetSocket());

	return 1;
}

LUA_FUNCTION(GetChallengeNr)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetChallengeNr());

	return 1;
}

LUA_FUNCTION(GetSequenceData)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	int nOutSequenceNr = 0, nInSequenceNr = 0, nOutSequenceNrAck = 0;

	channel->GetSequenceData(nOutSequenceNr, nInSequenceNr, nOutSequenceNrAck);

	ILuaObject *returnT = cl_Lua->GetNewTable();
		returnT->SetMember("outsequencenr", (float)nOutSequenceNr);
		returnT->SetMember("insequencenr", (float)nInSequenceNr);
		returnT->SetMember("outsequencenrack", (float)nOutSequenceNrAck);
		
		cl_Lua->Push(returnT);
	returnT->UnReference();

	return 1;
}

LUA_FUNCTION(SetSequenceData)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);
	cl_Lua->CheckType(3, GLua::TYPE_NUMBER);
	cl_Lua->CheckType(4, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->SetSequenceData(cl_Lua->GetInteger(2), cl_Lua->GetInteger(3), cl_Lua->GetInteger(4));

	return 0;
}

LUA_FUNCTION(UpdateMessageStats)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);
	cl_Lua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->UpdateMessageStats(cl_Lua->GetInteger(2), cl_Lua->GetInteger(3));

	return 0;
}

LUA_FUNCTION(CanPacket)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->CanPacket());

	return 1;
}

LUA_FUNCTION(IsOverflowed)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->IsOverflowed());

	return 1;
}

LUA_FUNCTION(IsTimedOut)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->IsTimedOut());

	return 1;
}

LUA_FUNCTION(HasPendingReliableData)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->HasPendingReliableData());

	return 1;
}

LUA_FUNCTION(SetFileTransmissionMode)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_BOOL);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->SetFileTransmissionMode(cl_Lua->GetBool(2));

	return 0;
}

LUA_FUNCTION(SetCompressionMode)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_BOOL);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->SetCompressionMode(cl_Lua->GetBool(2));

	return 0;
}

LUA_FUNCTION(SetMaxBufferSize)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_BOOL);
	cl_Lua->CheckType(3, GLua::TYPE_NUMBER);
	cl_Lua->CheckType(4, GLua::TYPE_BOOL);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->SetMaxBufferSize(cl_Lua->GetBool(2), cl_Lua->GetInteger(3), cl_Lua->GetBool(4));

	return 0;
}

LUA_FUNCTION(IsNull)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push(channel->IsNull());

	return 1;
}

LUA_FUNCTION(GetNumBitsWritten)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_BOOL);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetNumBitsWritten(cl_Lua->GetBool(2)));

	return 1;
}

LUA_FUNCTION(SetInterpolationAmount)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->SetInterpolationAmount(cl_Lua->GetDouble(2));

	return 0;
}

LUA_FUNCTION(SetRemoteFramerate)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);
	cl_Lua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->SetRemoteFramerate(cl_Lua->GetDouble(2), cl_Lua->GetDouble(3));

	return 0;
}

LUA_FUNCTION(SetMaxRoutablePayloadSize)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	cl_Lua->CheckType(2, GLua::TYPE_NUMBER);
	
	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	channel->SetMaxRoutablePayloadSize(cl_Lua->GetInteger(2));

	return 0;
}

LUA_FUNCTION(GetMaxRoutablePayloadSize)
{
	cl_Lua->CheckType(1, INETCHANNEL_ID);
	
	INetChannel* channel = (INetChannel*)cl_Lua->GetUserData(1);

	cl_Lua->Push( (float)channel->GetMaxRoutablePayloadSize());

	return 1;
}





GMOD_MODULE(Open, Close);

int Open(lua_State *L) {
	cl_Lua = Lua();
	
	CreateInterfaceFn engineFactory = Sys_GetFactory("engine.dll");
	if (!engineFactory) {
		Warning("Can't get engineFactory engine.dll :(\n");
		return 0;
	}
	
	cl_engine = (IVEngineClient*)engineFactory(VENGINE_CLIENT_INTERFACE_VERSION, NULL);
	if (!cl_engine) {
		Warning("Can't get IVEngineClient " VENGINE_CLIENT_INTERFACE_VERSION " :(\n");
		return 0;
	}
	
	
	CreateInterfaceFn VSTDLibFactory = Sys_GetFactory("vstdlib.dll");
	if (VSTDLibFactory) {
		g_ICvar = (ICvar*)VSTDLibFactory(CVAR_INTERFACE_VERSION, NULL);
		
		if (g_ICvar) {
			disconnect_msg = new ConCommand("disconnect_msg", DisconnectCmd, "disconnect_msg <str> : Leave with style", FCVAR_UNREGISTERED);
			g_ICvar->RegisterConCommand(disconnect_msg);
			
		} else {
			Warning("No g_ICvar, not adding disconnect_msg command\n");
		}
	} else {
		Warning("No VSTDLibFactory, not adding disconnect_msg command\n");
	}
	
	
	ILuaObject* metaT = cl_Lua->GetMetaTable(INETCHANNEL_NAME, INETCHANNEL_ID);
		ILuaObject* __index = cl_Lua->GetNewTable();
			//INetChannelInfo
			__index->SetMember("GetName", GetName);
			__index->SetMember("GetAddress", GetAddress);
			__index->SetMember("GetTime", GetTime);
			__index->SetMember("GetTimeConnected", GetTimeConnected);
			__index->SetMember("GetBufferSize", GetBufferSize);
			__index->SetMember("GetDataRate", GetDataRate);
			
			__index->SetMember("IsLoopback", IsLoopback);
			__index->SetMember("IsTimingOut", IsTimingOut);
			__index->SetMember("IsPlayback", IsPlayback);
			
			__index->SetMember("GetLatency", GetLatency);
			__index->SetMember("GetAvgLatency", GetAvgLatency);
			__index->SetMember("GetAvgLoss", GetAvgLoss);
			__index->SetMember("GetAvgChoke", GetAvgChoke);
			__index->SetMember("GetAvgData", GetAvgData);
			__index->SetMember("GetAvgPackets", GetAvgPackets);
			__index->SetMember("GetTotalData", GetTotalData);
			__index->SetMember("GetSequenceNr", GetSequenceNr);
			__index->SetMember("IsValidPacket", IsValidPacket);
			__index->SetMember("GetPacketTime", GetPacketTime);
			__index->SetMember("GetPacketBytes", GetPacketBytes);
			__index->SetMember("GetStreamProgress", GetStreamProgress);
			__index->SetMember("GetTimeSinceLastReceived", GetTimeSinceLastReceived);
			__index->SetMember("GetCommandInterpolationAmount", GetCommandInterpolationAmount);
			__index->SetMember("GetPacketResponseLatency", GetPacketResponseLatency);
			__index->SetMember("GetRemoteFramerate", GetRemoteFramerate);
			
			__index->SetMember("GetTimeoutSeconds", GetTimeoutSeconds);
			
			//INetChannel
			
			__index->SetMember("SetDataRate", SetDataRate);
			__index->SetMember("StartStreaming", StartStreaming);
			__index->SetMember("ResetStreaming", ResetStreaming);
			__index->SetMember("SetTimeout", SetTimeout);
			__index->SetMember("SetChallengeNr", SetChallengeNr);
			
			__index->SetMember("Reset", Reset);
			__index->SetMember("Clear", Clear);
			__index->SetMember("Shutdown", Shutdown);
			
			__index->SetMember("ProcessPlayback", ProcessPlayback);
			__index->SetMember("ProcessStream", ProcessStream);
			
			__index->SetMember("SetChoked", SetChoked);
			__index->SetMember("Transmit", Transmit);
			
			__index->SetMember("GetDropNumber", GetDropNumber);
			__index->SetMember("GetSocket", GetSocket);
			__index->SetMember("GetChallengeNr", GetChallengeNr);
			__index->SetMember("GetSequenceData", GetSequenceData);
			__index->SetMember("SetSequenceData", SetSequenceData);
			
			__index->SetMember("UpdateMessageStats", UpdateMessageStats);
			__index->SetMember("CanPacket", CanPacket);
			__index->SetMember("IsOverflowed", IsOverflowed);
			__index->SetMember("IsTimedOut", IsTimedOut);
			__index->SetMember("HasPendingReliableData", HasPendingReliableData);
			
			__index->SetMember("SetFileTransmissionMode", SetFileTransmissionMode);
			__index->SetMember("SetCompressionMode", SetCompressionMode);
			
			__index->SetMember("SetMaxBufferSize", SetMaxBufferSize);
			
			__index->SetMember("IsNull", IsNull);
			__index->SetMember("GetNumBitsWritten", GetNumBitsWritten);
			__index->SetMember("SetInterpolationAmount", SetInterpolationAmount);
			__index->SetMember("SetRemoteFramerate", SetRemoteFramerate);
			
			__index->SetMember("SetMaxRoutablePayloadSize", SetMaxRoutablePayloadSize);
			__index->SetMember("GetMaxRoutablePayloadSize", GetMaxRoutablePayloadSize);
			
			metaT->SetMember("__index", __index);
		__index->UnReference();
	metaT->UnReference();
	
	
	cl_Lua->NewGlobalTable("sourcenetinfo");
	ILuaObject* sourcenetinfo = cl_Lua->GetGlobal("sourcenetinfo");
		sourcenetinfo->SetMember("GetNetChannel",	CL_GetNetChannel);
	sourcenetinfo->UnReference();
	
	return 0;
}


int Close(lua_State *L) {
	if (g_ICvar && disconnect_msg) {
		g_ICvar->UnregisterConCommand(disconnect_msg);
		delete disconnect_msg;
	}
	
	return 0;
}















