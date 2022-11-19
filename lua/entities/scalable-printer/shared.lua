ENT.Type = "anim"
ENT.Base = "base_gmodentity" 


ENT.PrintName = "Scalable Printer"
ENT.Author = "Bob Bobington#2947"
ENT.Category = "Scalable Printers"
ENT.Spawnable = true 
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.DisableDuplicator = true
ENT.IsMoneyPrinter = true

function ENT:CanTool(ply, trace, tool)
    if ply:IsSuperAdmin() then return true end
    if tool == "colour" then return true end
    if tool == "remover" and self:Getowning_ent() == ply then return true end
    return false
end

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "owning_ent") -- DarkRP compatibility
    self:NetworkVar("String", 0, "tier") 
    self:NetworkVar("Int", 0, "level") 
    self:NetworkVar("Float", 0, "nextPrint")
    self:NetworkVar("Bool", 0, "running")

    self:NetworkVar("String", 1, "moneyStored")
    self:NetworkVar("Int", 1, "battery")
    
    self:NetworkVar("String", 2, "printAmount")
    self:NetworkVar("Int", 2, "health")

    // WHY THE FUCK CAN STRINGS ONLY GO IN SLOT 4 OR LESS 
end