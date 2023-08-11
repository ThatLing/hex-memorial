


local ChatSpam = {
	"sn1pe.com",
	"!donate",
	"This server uses PCMod",
	"Can't hear sound?",
	"You must have VIP",
}

function HeX.NoChatSpam(idx,name,text,typ)
	local Found,IDX,str = text:InTable(ChatSpam)
	if text:find("URules") then 
		Found = true
	end
	
	if Found then
		MsgN( Format("CHAT SPAM (%s): %s", str, text) )
		return true
	end
	--chat.PlaySound()
end
hook.Add("ChatText", "!HeX.NoChatSpam", HeX.NoChatSpam)



hook.Add("OnPlayerChat", "chat.PlaySound", function()
	chat.PlaySound()
end)











