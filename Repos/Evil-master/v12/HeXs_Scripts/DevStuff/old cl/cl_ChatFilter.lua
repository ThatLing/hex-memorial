


local function SaveFilter(u)
	local flt 		= u:ReadString()
	local DoBeep	= u:ReadBool()
	file.Append("dex_filter.txt", flt)
	
	surface.PlaySound( Sound("npc/scanner/combat_scan"..math.random(2,4)..".wav") )
end


timer.Simple(1, function()
	if CHATFILTER then
		--usermessage.Hook("flt", SaveFilter)
		--print("[OK] Overriding SimpleFilter beep & save system")
	end
end)

