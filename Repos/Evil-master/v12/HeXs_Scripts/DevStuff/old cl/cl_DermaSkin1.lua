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

function debug.getupvalues(f)
	local t, i, k, v = {}, 1, debug.getupvalue(f, 1)
	while k do
		t[k] = v
		i = i+1
		k,v = debug.getupvalue(f, i)
	end
	return t
end

local func = debug.getupvalues(concommand.Run).CommandList["menu_extensions"]

concommand.Add("menu_extensions", function()
	func()
	local panel = debug.getupvalues(func).Extensions
	while !panel do
		local a
		a = debug.getupvalues(a or func).func
		if a then
			panel = debug.getupvalues(a).Extensions
			a = debug.getupvalues(a or func).func
		else
			break
		end
	end
	local pnl = vgui.Create"DListView"
	pnl:Dock(FILL)
	pnl:AddColumn"Name"
	pnl:AddColumn"Author"
	pnl:SetMultiSelect(false)
	local tbl = {}
	for k, v in pairs(derma.GetSkinTable()) do
		pnl:AddLine(v.PrintName or "N/A", v.Author or "N/A")
		table.insert(tbl, k)
	end
	pnl.OnRowSelected = function(_, line)
		RunConsoleCommand("derma_skin", tbl[line])
		file.Write("dermaskin.txt", tbl[line])
	end

	panel.PropertySheet:AddSheet( Localize( "Derma Skin" ), pnl, "gui/silkicons/application_view_tile" )
	concommand.Add("menu_extensions", func)
end)

for k, v in pairs(file.FindInLua("skins/*.lua")) do
	HeXInclude("skins/"..v)
end

end)