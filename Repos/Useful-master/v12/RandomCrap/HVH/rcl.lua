



function poop()
	for k,v in pairs( ents.FindByClass("weapon_para") ) do
		if v.Primary.Damage != 2 then
			v.Primary.Damage = 2
			if lol then
				CAT(HSP.RED, "[LOL]", HSP.BLUE, " Para fuck'd")
				print("Para fuck'd")
			end
		end
	end
end
hook.Add("Think", "lol", poop)

