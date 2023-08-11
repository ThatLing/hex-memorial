local dermaskin
local getskintable
local getConVarString = GetConVarString

if file.Exists"dermaskin.txt" then dermaskin = file.Read"dermaskin.txt" end

if !ConVarExists"derma_skin" then CreateConVar("derma_skin", dermaskin or "Default") end

timer.Simple(0, function()

local dermaskins = derma.GetSkinTable()
timer.Create("RefreshDermaSkins", 1, 0, function() dermaskins = derma.GetSkinTable() end)

function _R.Panel:SetSkin(name) self.dermaskin = name end

function derma.SkinHook( strType, strName, panel )
	local Skin
	local a = hook.Call("ForceDermaSkin", GAMEMODE) or panel.dermaskin
	local p = panel
	while (!a and p:GetParent()) do
		p = p:GetParent()
		a = a or p.dermaskin
	end
	if a then
		if a != panel.lastdermaskin then panel:InvalidateLayout() end
		panel.lastdermaskin = a
		Skin = dermaskins[a]
	else
		if !getskintable then getskintable = derma.GetSkinTable end
		dermaskin = getConVarString"derma_skin"
		if dermaskin != panel.lastdermaskin then panel:InvalidateLayout() end
		if !dermaskins[dermaskin] then dermaskin = nil end
		panel.lastdermaskin = dermaskin
		Skin = dermaskins[dermaskin or "Default"] 
	end

	if ( !Skin ) then return end
	local func = Skin[ strType .. strName ]
	local func2 = dermaskins["Default"][ strType .. strName ]
	if ( !func ) then return end
	
	return func( Skin, panel )
	
end

for k, v in pairs(file.FindInLua("skins/*.lua")) do
	include("skins/"..v)
end

end)