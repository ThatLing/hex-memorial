
local Settings = {
	--"vgui_allowhtml 0",
	
	--"net_showfragments 2",
	"sv_cheats 0",
	"hud_draw_fixed_reticle 1",
	"sv_password beta",
	"developer 1",
	"download_debug 1",
	"lua_log_cl 1",
	"lua_log_sv 1",
	"r_lod 0",
	"mat_hdr_level 0",
	"mat_bumpmap 1",
	"sv_gamemodeoverride sandbox",
	"sv_gamemode sandbox",
	"sbox_noclip 1",
	"sbox_godmode 0",
	[[alias mp "bot_mimic 0; maxplayers 9; map gm_construct"]],
}

local KidaSettings = {
	[[alias go "connect gmod.game-host.org:27015"]],
}

local KeepAt = {
	["pp_motionblur"] = "0",
}



if IsMainGMod then --Not on test version!
	table.Merge(Settings, KidaSettings)
end

for k,v in pairs(Settings) do
	HeXLRCL(v)
end

timer.Create("CheckCVars", 1, 0, function()
	for k,v in pairs(KeepAt) do
		if (ConVarExists(k) and GetConVarString(k) != v) then
			HeXLRCL(k.." "..v)
			COLCON(CMIColor, k, RED, " != ", GREEN, v, CMIColor, ", resetting..")
		end
	end
end)


timer.Simple(0.1, function()
	COLCON(CMIColor, "Set ", RED, "["..#Settings.."]", CMIColor, " settings!")
end)







