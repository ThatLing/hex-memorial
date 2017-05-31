
----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

include('shared.lua')

function ENT:Draw()

	self:DrawModel()
end

local function OnUndo()

	GAMEMODE:AddNotify("Undone Prop", NOTIFY_UNDO, 2 )
end

usermessage.Hook("UndoSpawnerProp", OnUndo )  




----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

include('shared.lua')

function ENT:Draw()

	self:DrawModel()
end

local function OnUndo()

	GAMEMODE:AddNotify("Undone Prop", NOTIFY_UNDO, 2 )
end

usermessage.Hook("UndoSpawnerProp", OnUndo )  



