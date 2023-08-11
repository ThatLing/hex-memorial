

local dermaskin
local getskintable

if file.Exists("dermaskin.txt") then
	dermaskin = file.Read("dermaskin.txt")
end
if not ConVarExists("derma_skin") then
	CreateConVar("derma_skin", dermaskin or "Default")
end



timer.Simple(0, function()
	if HSP then return end
	
	local dermaskins = derma.GetSkinTable()
	timer.Create("RefreshDermaSkins", 15, 1, function()
		dermaskins = derma.GetSkinTable()
	end)
	
	_R.Panel.SetSkinOld = _R.Panel.SetSkin
	function _R.Panel:SetSkin(name)
		if HeX.MyCall():find("HSP") then
			return self:SetSkinOld(name)
		end
		
		self.dermaskin = name
	end
	
	derma.SkinHookOld = derma.SkinHook
	function derma.SkinHook(strType, strName, panel)
		local Skin
		local a = panel.dermaskin
		local p = panel
		
		while (!a and p:GetParent()) do
			p = p:GetParent()
			a = a or p.dermaskin
		end
		
		if a then
			if a != panel.lastdermaskin then
				panel:InvalidateLayout()
			end
			
			panel.lastdermaskin = a
			Skin = dermaskins[a]
		else
			if not getskintable then
				getskintable = derma.GetSkinTable
			end
			
			dermaskin = GetConVarString("derma_skin")
			if dermaskin != panel.lastdermaskin then
				panel:InvalidateLayout()
			end
			
			if !dermaskins[dermaskin] then
				dermaskin = nil
			end
			panel.lastdermaskin = dermaskin
			Skin = dermaskins[dermaskin or "Default"] 
		end

		if not Skin then return end
		local func = Skin[ strType..strName ]
		--local func2 = dermaskins["Default"][ strType..strName ]
		if not func then return end
		
		if HeX.FPath(func):find("HSP") then
			return derma.SkinHookOld(strType,strName,panel)
		end
		
		return func(Skin,panel)
	end
	
	
	for k, v in pairs(file.FindInLua("skins/*.lua")) do
		HeXInclude("skins/"..v)
	end
end)



