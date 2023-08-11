
if (os.date("%m") != "12") then return end


local PANEL = {}
local SnowFlakes = {}

function PANEL:Init()
	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )
	
	self:SetSize( ScrW(), ScrH() )
	self:SetPos( 0, 0 )
	
	SnowFlakes = {}
end

function PANEL:AddSnowFlake()
	self.SnowFlake = vgui.Create("DImage", myParent)
	self.SnowFlake:SetImage( "blackops/snowflakes/"..math.random( 1, 24 ) )
	self.SnowFlake:SizeToContents()
	self.SnowFlake.xOff = math.random( 0, ScrW()-self.SnowFlake:GetWide() )
	self.SnowFlake.Speed = math.random( 70, 200 )
	self.SnowFlake.StartTime = SysTime()
	table.insert( SnowFlakes, self.SnowFlake)
	--print( "Snowflake added!" )
end

function PANEL:Think()
	for k,v in ipairs( SnowFlakes ) do
		local h = ScrH()
		local yOff = 0 - (v.StartTime - SysTime()) * v.Speed - v:GetTall()
		if ( yOff > h ) then --When it reaches the bottom we fake the creation of a new snowflake
			v.StartTime = SysTime()
			v.xOff = math.random( 0, ScrW()-self.SnowFlake:GetWide() )
			v:SetImage( "blackops/snowflakes/"..math.random( 1, 24 ) )
			v.Speed = math.random( 70, 200 )
		end
		v:SetPos( v.xOff + math.cos(v.StartTime - SysTime()) * v.Speed/2, yOff )
	end
end

local SnowFlakePanel = vgui.RegisterTable( PANEL, "Panel" )

local flakebackground = vgui.CreateFromTable( SnowFlakePanel )

concommand.Add("snow_add", function(ply,cmd,args)
	local amounttoadd
	if args[1] then
		amounttoadd = tonumber(args[1])
	else
		amounttoadd = math.random( 20, 50 )
	end
	
	for i=1,amounttoadd do
		flakebackground:AddSnowFlake()
	end
end ) --for lulz

concommand.Add("snow_remove", function(ply,cmd,args)
	for k,v in pairs(SnowFlakes) do
		v:Remove()
		v = nil
	end
	SnowFlakes = {}
end)


for i=1,math.random( 20, 50 ) do
	flakebackground:AddSnowFlake()
end






