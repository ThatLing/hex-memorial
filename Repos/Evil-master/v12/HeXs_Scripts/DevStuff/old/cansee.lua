


local DELAY_LAST	= 0
local DELAY_TOTAL	= 2.0
local Players		= {}

local function FillPlayerTable() --Refresh table, only adding every 2s to not lag
	if (CurTime() < (DELAY_LAST + DELAY_TOTAL)) then
		return Players
	end
	
	Players = player.GetAll()
	
	for k,v in pairs(Players) do --Remove bad players
		if ValidEntity(v) and (v:Team() == TEAM_SPECTATOR or not v:Alive()) then
			table.remove(Players, k)
		end
	end
	
	DELAY_LAST = CurTime()
	return Players
end


local function SortDistance(ply1,ply2)
	return (ply1:GetPos():Distance( ply2:GetPos() ) ) < (ply2:GetPos():Distance( ply1:GetPos() ) )
end

local MaxAngle = math.cos( math.rad(45) )
local HisEyes = Vector(0,0,32)

local lastWitnessCheck = 0
local witnessCheckDelay = 0.3
local LocaPos = nil

local TraceRes = {
	mask = MASK_SOLID_BRUSHONLY,
}
local Trace = {}
local PlayersCanSee	= {}

function CheckCanSee()
	if ( CurTime() > (lastWitnessCheck + witnessCheckDelay) ) then
		LocaPos = LocalPlayer():EyePos()
		PlayersCanSee = {}
		
		for k,target in pairs( FillPlayerTable() ) do
			if ValidEntity(target) and target != LocalPlayer() then
				Trace.start  = LocaPos + HisEyes
				Trace.endpos = target:EyePos() + HisEyes
				Trace.filter = {target, LocalPlayer()}
				
				TraceRes = util.TraceLine( Trace )
				if not TraceRes.Hit then
					if (target:EyeAngles():Forward():DotProduct((LocaPos - target:EyePos()):Normalize()) > MaxAngle) then --Can see!
						table.insert(PlayersCanSee, target)
					end
				end
			end
		end
		table.sort(PlayersCanSee, SortDistance)
		
		lastWitnessCheck = CurTime()
	end
end
hook.Add("Think", "CheckCanSee", CheckCanSee)


concommand.Add("lol", function()
	PrintTable( PlayersCanSee )
end)













