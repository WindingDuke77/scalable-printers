scprinters = scprinters or {}
scprinters.config = scprinters.config or {}
local config = scprinters.config

function scprinters.CalPrintAmount(self)

    local PrintAmount = Formatter.UnFormat(self:GetprintAmount())
    PrintAmount = PrintAmount * config.multiplier
    PrintAmount = PrintAmount * self.data.multiplier
    if self:Getowning_ent():IsPlayer() then
        PrintAmount = PrintAmount * config.rankMultipier[self:Getowning_ent():GetUserGroup()] or 1
    end
    PrintAmount = tostring(math.floor(PrintAmount))

    return PrintAmount
end
