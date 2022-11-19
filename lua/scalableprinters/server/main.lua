// This Addon was created by:
// Bob Bobington#2947
// 
// any questions, please contact me

scprinters = scprinters or {}
scprinters.config = scprinters.config or {}
local config = scprinters.config
 
// Do not above this line.

hook.Add("playerBoughtCustomEntity", "scprinters-f4Spawn", function(ply, data, ent, price)
    if ent:GetClass() == "scalable-printer" and data.tier then
        ent:Settier(data.tier)
        ent.tier = data.tier
        ent:Setup()
    end
end)

