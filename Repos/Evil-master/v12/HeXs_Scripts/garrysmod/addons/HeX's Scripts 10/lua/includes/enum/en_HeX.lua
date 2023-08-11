

NotEC = ents.Create
function ents.Create(ent)
    return NotEC( string.lower(ent) )
end
print("[HeX] Fixing case-sensitive ents.Create..")


if SERVER then return end

_G.HeXLoaded = true
if not _G.iface3 and (hook or timer or concommand or (getmetatable(_G) != nil)) then
	_G.HeXGlobal_AC = true
end











