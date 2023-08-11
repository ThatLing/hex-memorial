
require("gmcl_replicator")


local net_blockmsg		= GetConVar("net_blockmsg")
local cl_predict 		= GetConVar("cl_predict")
local sv_client_predict = GetConVar("sv_client_predict")

local Predict = "1"

local function Freeze(ply,cmd,args)
	if cmd == "+freeze" then
		cl_predict:SetValue("0")
		Predict = sv_client_predict:GetString()
		
		sv_client_predict:SetValue("-1")
		net_blockmsg:SetValue("clc_Move")
	else
		cl_predict:SetValue("1")
		sv_client_predict:SetValue(Predict)
		net_blockmsg:SetValue("0")
	end
end
concommand.Add("+freeze", Freeze)
concommand.Add("-freeze", Freeze)






