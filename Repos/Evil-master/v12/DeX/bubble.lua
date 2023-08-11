
if IsUH then return end

local HoverHeads = {}

concommand.Add("gm_b_on", function(ply,cmd,args)
	if not ValidEntity(ply) then return end
	
	if not HoverHeads[ply] then
		local ent = ents.Create("prop_physics")
			HoverHeads[ply] = ent
			ent:SetModel("models/extras/info_speech.mdl")
			ent:SetMoveType(MOVETYPE_NONE)
			ent:SetNotSolid(1)
			ent:AddEffects(EF_ITEM_BLINK)
			ent:AddEffects(EF_NOSHADOW)
			ent:SetParent(ply)
			ent:SetPos( ply:GetPos() + Vector(0,0,100) )
		ent:SetAngles(Angle(0,0,0))
	end
	
	if ValidEntity(ply.HSPChatKeyboard) then
		ply.HSPChatKeyboard:Remove()
	end
	
	ply.HSPChatKeyboard = ents.Create("prop_physics")
		ply.HSPChatKeyboard:SetModel("models/props_c17/computer01_keyboard.mdl")
		ply.HSPChatKeyboard:SetPos( ply:LocalToWorld(Vector(16,0,42)) )
		ply.HSPChatKeyboard:SetParent(ply)
	ply.HSPChatKeyboard:SetLocalAngles(Angle(35,180,0))
end)

concommand.Add("gm_b_off", function(ply,cmd,args)
	if not ValidEntity(ply) then return end
	
	if (HoverHeads[ply] and HoverHeads[ply]:IsValid()) then
		HoverHeads[ply]:Remove()
		HoverHeads[ply] = nil
	end
	
	if ply.HSPChatKeyboard and ply.HSPChatKeyboard:IsValid() then ply.HSPChatKeyboard:Remove() end
end)

hook.Add("Tick", "SpinMeRightRound", function()
	for k,v in pairs(HoverHeads) do
		if v:IsValid() then
			v:SetAngles( v:GetAngles() + Angle(0,3,0) )
		end
	end
end)


local Bubble = [[
	hook.Add("StartChat", "Start", function() RunConsoleCommand("gm_b_on") end)
	hook.Add("FinishChat", "Stop", function() RunConsoleCommand("gm_b_off") end)
]]

local function BubbleInitialSpawn(ply)
	ply:SendLua(Bubble)
end
hook.Add("PlayerInitialSpawn", "BubbleInitialSpawn", BubbleInitialSpawn)
BroadcastLua(Bubble)



