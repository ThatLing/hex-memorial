
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------
m.name = "module_debug"
m.platform = "shared"
m.enabled = true

function m:Init()
	if SACH.Debug then
		MsgN("SACH debugger initialized")
	end
end

function m:Call( hook, data )
	if SERVER then
		self:SHook( hook, data )
	end
	if CLIENT then
		self:CHook( hook, data )
	end
end

function m:SHook( hook, data )
	if SACH.Debug then
		MsgN("SACH debugger(sv): "..hook )
		PrintTable(data)
	end
end

function m:CHook( hook, data )
	if SACH.Debug then
		if (type(data) == "table") then
			MsgN("SACH debugger(cl): "..hook )
			PrintTable(data)
		else
			MsgN("SACH debugger(cl): "..hook.." "..table.concat( data, " ") )
		end
	end
end

----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------
m.name = "module_debug"
m.platform = "shared"
m.enabled = true

function m:Init()
	if SACH.Debug then
		MsgN("SACH debugger initialized")
	end
end

function m:Call( hook, data )
	if SERVER then
		self:SHook( hook, data )
	end
	if CLIENT then
		self:CHook( hook, data )
	end
end

function m:SHook( hook, data )
	if SACH.Debug then
		MsgN("SACH debugger(sv): "..hook )
		PrintTable(data)
	end
end

function m:CHook( hook, data )
	if SACH.Debug then
		if (type(data) == "table") then
			MsgN("SACH debugger(cl): "..hook )
			PrintTable(data)
		else
			MsgN("SACH debugger(cl): "..hook.." "..table.concat( data, " ") )
		end
	end
end
