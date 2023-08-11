


if not vgui.CreateOld then
	vgui.CreateOld =  vgui.Create
end


function vgui.CreateNew(...)
	HeX.include("HeX/hx_DFrame.lua")
	
	vgui.Create = vgui.CreateOld
	
	return vgui.CreateOld(...)
end
vgui.Create = vgui.CreateNew




