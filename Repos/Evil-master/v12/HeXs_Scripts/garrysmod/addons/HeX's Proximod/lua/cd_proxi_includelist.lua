//if not ADDON_PROP then return end

ADDON_PROP = {}
---- Preload
table.insert( ADDON_PROP, "cl_proxi_base.lua" )

local HAYFRAME_DIR = "proxi_hayframe/"
table.insert( ADDON_PROP, HAYFRAME_DIR .. "hayframe__initializer.lua" )
table.insert( ADDON_PROP, HAYFRAME_DIR .. "hayframe_util.lua" )
table.insert( ADDON_PROP, HAYFRAME_DIR .. "hayframe_var.lua" )
table.insert( ADDON_PROP, HAYFRAME_DIR .. "hayframe_cmds.lua" )
table.insert( ADDON_PROP, HAYFRAME_DIR .. "hayframe_mediator.lua" )
table.insert( ADDON_PROP, HAYFRAME_DIR .. "hayframe_changelog.lua" )
table.insert( ADDON_PROP, HAYFRAME_DIR .. "hayframe_ctrlcolor.lua" )
table.insert( ADDON_PROP, HAYFRAME_DIR .. "hayframe_context.lua" )

table.insert( ADDON_PROP, "cl_proxi_dup_virtualscene.lua" )

---- Beacons
table.insert( ADDON_PROP, "cl_proxi_beacons.lua" )
table.insert( ADDON_PROP, "proxi_b_default/players.lua" )
table.insert( ADDON_PROP, "proxi_b_default/physprops.lua" )
table.insert( ADDON_PROP, "proxi_b_default/rockets.lua" )
table.insert( ADDON_PROP, "proxi_b_default/bolts.lua" )
table.insert( ADDON_PROP, "proxi_b_default/playerlos.lua" )
table.insert( ADDON_PROP, "proxi_b_default/nades.lua" )
table.insert( ADDON_PROP, "proxi_b_default/compass.lua" )
table.insert( ADDON_PROP, "proxi_b_default/contraptioncompass.lua" )
table.insert( ADDON_PROP, "proxi_b_default/npc.lua" )
table.insert( ADDON_PROP, "proxi_b_default/npclos.lua" )
table.insert( ADDON_PROP, "proxi_b_default/wallfinder.lua" )
table.insert( ADDON_PROP, "proxi_b_default/chat.lua" )
table.insert( ADDON_PROP, "proxi_b_default/wallfinderpierce.lua" )
table.insert( ADDON_PROP, "proxi_b_default/helpersquare.lua" )
table.insert( ADDON_PROP, "proxi_b_default/voicechat.lua" )
table.insert( ADDON_PROP, "proxi_b_default/wallfinderpierceback.lua" )

---- Menu
table.insert( ADDON_PROP, "ProxiCollapsibleCheckbox.lua" )
table.insert( ADDON_PROP, "cl_proxi_menu.lua" )
