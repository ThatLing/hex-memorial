
local string = string

print("[HeX] Fixing case-sensitive ents.Create")

local old = ents.Create
function ents.Create(ent)
    return old( string.lower(ent) )
end





