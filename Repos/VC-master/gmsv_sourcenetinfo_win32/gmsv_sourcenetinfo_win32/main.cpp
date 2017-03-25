

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


ILuaInterface *gLua = NULL;
IVEngineServer *sv_engine = NULL;

int GetPlayerEIndex(ILuaObject *playerEntity)
{
	ILuaObject *entityMT = gLua->GetMetaTable("Entity", GLua::TYPE_ENTITY);
		ILuaObject *entityM = entityMT->GetMember("EntIndex");
			entityM->Push();
					
			playerEntity->Push();

			gLua->Call(1, 1);
		entityM->UnReference();
	entityMT->UnReference();

	ILuaObject *returnL = gLua->GetReturn(0);

	int index = returnL->GetInt();

	returnL->UnReference();

	return index;
}


LUA_FUNCTION(SV_GetNetChannel) {
	gLua->CheckType(1, GLua::TYPE_ENTITY);

	INetChannel* playerNC = (INetChannel*)sv_engine->GetPlayerNetInfo(GetPlayerEIndex(gLua->GetObject(1)));
	
	if (playerNC)
	{
		ILuaObject* metaT = gLua->GetMetaTable(INETCHANNEL_NAME, INETCHANNEL_ID);
			gLua->PushUserData(metaT, playerNC, INETCHANNEL_ID);
		metaT->UnReference();
	}
	else
	{
		gLua->PushNil();
	}

	return 1;
}

LUA_FUNCTION(G_GetNetChannel) {
	gLua->CheckType(1, GLua::TYPE_NUMBER);
	
	INetChannel* playerNC = (INetChannel*)sv_engine->GetPlayerNetInfo( gLua->GetNumber(1) );
	
	if (playerNC)
	{
		ILuaObject* metaT = gLua->GetMetaTable(INETCHANNEL_NAME, INETCHANNEL_ID);
			gLua->PushUserData(metaT, playerNC, INETCHANNEL_ID);
		metaT->UnReference();
	}
	else
	{
		gLua->PushNil();
	}

	return 1;
}







LUA_FUNCTION(GetName)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->GetName());

	return 1;
}

LUA_FUNCTION(GetAddress)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->GetAddress());

	return 1;
}

LUA_FUNCTION(GetTime)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetTime());

	return 1;
}

LUA_FUNCTION(GetTimeConnected)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetTimeConnected());

	return 1;
}

LUA_FUNCTION(GetBufferSize)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetBufferSize());

	return 1;
}

LUA_FUNCTION(GetDataRate)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetDataRate());

	return 1;
}

LUA_FUNCTION(IsLoopback)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->IsLoopback());

	return 1;
}

LUA_FUNCTION(IsTimingOut)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->IsTimingOut());

	return 1;
}

LUA_FUNCTION(IsPlayback)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->IsPlayback());

	return 1;
}

LUA_FUNCTION(GetLatency)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetLatency(gLua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetAvgLatency)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetAvgLatency(gLua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetAvgLoss)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetAvgLoss(gLua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetAvgChoke)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetAvgChoke(gLua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetAvgData)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetAvgData(gLua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetAvgPackets)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetAvgPackets(gLua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetTotalData)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetTotalData(gLua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(GetSequenceNr)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetSequenceNr(gLua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(IsValidPacket)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);
	gLua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->IsValidPacket(gLua->GetInteger(2), gLua->GetInteger(3)));

	return 1;
}

LUA_FUNCTION(GetPacketTime)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);
	gLua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetPacketTime(gLua->GetInteger(2), gLua->GetInteger(3)));

	return 1;
}

LUA_FUNCTION(GetPacketBytes)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);
	gLua->CheckType(3, GLua::TYPE_NUMBER);
	gLua->CheckType(4, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetPacketBytes(gLua->GetInteger(2), gLua->GetInteger(3), gLua->GetInteger(4)));

	return 1;
}

LUA_FUNCTION(GetStreamProgress)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	int received = 0, total = 0;
	
	if (channel->GetStreamProgress(gLua->GetInteger(2), &received, &total))
	{
		ILuaObject *returnT  = gLua->GetNewTable();
			returnT->SetMember("received", (float)received);
			returnT->SetMember("total", (float)total);
			
			gLua->Push(returnT);
		returnT->UnReference();
	}
	else
	{
		gLua->PushNil();
	}

	return 1;
}

LUA_FUNCTION(GetTimeSinceLastReceived)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetTimeSinceLastReceived());

	return 1;
}

LUA_FUNCTION(GetCommandInterpolationAmount)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);
	gLua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetCommandInterpolationAmount(gLua->GetInteger(2), gLua->GetInteger(3)));

	return 1;
}

LUA_FUNCTION(GetPacketResponseLatency)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);
	gLua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	int pnLatencyMsecs = 0, pnChoke = 0;

	channel->GetPacketResponseLatency(gLua->GetInteger(2), gLua->GetInteger(3), &pnLatencyMsecs, &pnChoke);

	ILuaObject *returnT = gLua->GetNewTable();
		returnT->SetMember("latency", (float)pnLatencyMsecs);
		returnT->SetMember("choke", (float)pnChoke);

		gLua->Push(returnT);
	returnT->UnReference();

	return 1;
}

LUA_FUNCTION(GetRemoteFramerate)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	float pflFrameTime = 0.0f, pflFrameTimeStdDeviation = 0.0f;

	channel->GetRemoteFramerate(&pflFrameTime, &pflFrameTimeStdDeviation);

	ILuaObject *returnT = gLua->GetNewTable();
		returnT->SetMember("frametime", pflFrameTime);
		returnT->SetMember("frametimestddeviation", pflFrameTimeStdDeviation);

		gLua->Push(returnT);
	returnT->UnReference();

	return 1;
}

LUA_FUNCTION(GetTimeoutSeconds)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetTimeoutSeconds());

	return 1;
}

LUA_FUNCTION(SetDataRate)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->SetDataRate(gLua->GetDouble(2));

	return 0;
}

LUA_FUNCTION(StartStreaming)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->StartStreaming(gLua->GetInteger(2)));

	return 1;
}

LUA_FUNCTION(ResetStreaming)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->ResetStreaming();

	return 0;
}

LUA_FUNCTION(SetTimeout)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->SetTimeout(gLua->GetDouble(2));

	return 0;
}

LUA_FUNCTION(SetChallengeNr)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->SetChallengeNr(gLua->GetInteger(2));

	return 0;
}

LUA_FUNCTION(Reset)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->Reset();

	return 0;
}

LUA_FUNCTION(Clear)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->Clear();

	return 0;
}

LUA_FUNCTION(Shutdown)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_STRING);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->Shutdown(gLua->GetString(2));

	return 0;
}

LUA_FUNCTION(ProcessPlayback)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->ProcessPlayback();

	return 0;
}

LUA_FUNCTION(ProcessStream)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->ProcessStream());

	return 1;
}

LUA_FUNCTION(SendFile)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_STRING);
	gLua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->SendFile(gLua->GetString(2), gLua->GetInteger(3)));

	return 1;
}

LUA_FUNCTION(DenyFile)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_STRING);
	gLua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->DenyFile(gLua->GetString(2), gLua->GetInteger(3));

	return 0;
}

LUA_FUNCTION(SetChoked)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->SetChoked();

	return 0;
}

LUA_FUNCTION(Transmit)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_BOOL);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->Transmit(gLua->GetBool(2)));

	return 1;
}

LUA_FUNCTION(GetDropNumber)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetDropNumber());

	return 1;
}

LUA_FUNCTION(GetSocket)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetSocket());

	return 1;
}

LUA_FUNCTION(GetChallengeNr)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetChallengeNr());

	return 1;
}

LUA_FUNCTION(GetSequenceData)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	int nOutSequenceNr = 0, nInSequenceNr = 0, nOutSequenceNrAck = 0;

	channel->GetSequenceData(nOutSequenceNr, nInSequenceNr, nOutSequenceNrAck);

	ILuaObject *returnT = gLua->GetNewTable();
		returnT->SetMember("outsequencenr", (float)nOutSequenceNr);
		returnT->SetMember("insequencenr", (float)nInSequenceNr);
		returnT->SetMember("outsequencenrack", (float)nOutSequenceNrAck);
		
		gLua->Push(returnT);
	returnT->UnReference();

	return 1;
}

LUA_FUNCTION(SetSequenceData)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);
	gLua->CheckType(3, GLua::TYPE_NUMBER);
	gLua->CheckType(4, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->SetSequenceData(gLua->GetInteger(2), gLua->GetInteger(3), gLua->GetInteger(4));

	return 0;
}

LUA_FUNCTION(UpdateMessageStats)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);
	gLua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->UpdateMessageStats(gLua->GetInteger(2), gLua->GetInteger(3));

	return 0;
}

LUA_FUNCTION(CanPacket)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->CanPacket());

	return 1;
}

LUA_FUNCTION(IsOverflowed)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->IsOverflowed());

	return 1;
}

LUA_FUNCTION(IsTimedOut)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->IsTimedOut());

	return 1;
}

LUA_FUNCTION(HasPendingReliableData)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->HasPendingReliableData());

	return 1;
}

LUA_FUNCTION(SetFileTransmissionMode)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_BOOL);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->SetFileTransmissionMode(gLua->GetBool(2));

	return 0;
}

LUA_FUNCTION(SetCompressionMode)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_BOOL);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->SetCompressionMode(gLua->GetBool(2));

	return 0;
}

LUA_FUNCTION(RequestFile)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_STRING);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->RequestFile(gLua->GetString(2)));

	return 1;
}

LUA_FUNCTION(SetMaxBufferSize)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_BOOL);
	gLua->CheckType(3, GLua::TYPE_NUMBER);
	gLua->CheckType(4, GLua::TYPE_BOOL);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->SetMaxBufferSize(gLua->GetBool(2), gLua->GetInteger(3), gLua->GetBool(4));

	return 0;
}

LUA_FUNCTION(IsNull)
{
	gLua->CheckType(1, INETCHANNEL_ID);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push(channel->IsNull());

	return 1;
}

LUA_FUNCTION(GetNumBitsWritten)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_BOOL);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetNumBitsWritten(gLua->GetBool(2)));

	return 1;
}

LUA_FUNCTION(SetInterpolationAmount)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->SetInterpolationAmount(gLua->GetDouble(2));

	return 0;
}

LUA_FUNCTION(SetRemoteFramerate)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);
	gLua->CheckType(3, GLua::TYPE_NUMBER);

	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->SetRemoteFramerate(gLua->GetDouble(2), gLua->GetDouble(3));

	return 0;
}

LUA_FUNCTION(SetMaxRoutablePayloadSize)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	gLua->CheckType(2, GLua::TYPE_NUMBER);
	
	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	channel->SetMaxRoutablePayloadSize(gLua->GetInteger(2));

	return 0;
}

LUA_FUNCTION(GetMaxRoutablePayloadSize)
{
	gLua->CheckType(1, INETCHANNEL_ID);
	
	INetChannel* channel = (INetChannel*)gLua->GetUserData(1);

	gLua->Push( (float)channel->GetMaxRoutablePayloadSize());

	return 1;
}





GMOD_MODULE(Open, Close);

int Open(lua_State *L)
{
	gLua = Lua();

	ILuaObject* metaT, *__index;

	metaT = gLua->GetMetaTable(INETCHANNEL_NAME, INETCHANNEL_ID);
		__index = gLua->GetNewTable();
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

			__index->SetMember("SendFile", SendFile);
			__index->SetMember("DenyFile", DenyFile);
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
			__index->SetMember("RequestFile", RequestFile);

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
	
	
	ILuaObject *playerMT = gLua->GetMetaTable("Player", GLua::TYPE_ENTITY);
		playerMT->SetMember("GetNetChannel", SV_GetNetChannel);
	playerMT->UnReference();
	
	gLua->NewGlobalTable("sourcenetinfo");
	ILuaObject* sourcenetinfo = gLua->GetGlobal("sourcenetinfo");
		sourcenetinfo->SetMember("GetNetChannel",	G_GetNetChannel);
	sourcenetinfo->UnReference();
	
	
	CreateInterfaceFn engineFactory = Sys_GetFactory("engine.dll");
	sv_engine = (IVEngineServer *)engineFactory(INTERFACEVERSION_VENGINESERVER, NULL);
	
	return 0;
}

int Close(lua_State *L)
{
	return 0;
}
