ITEM.Name = itemstore.Translate("moneyprinter_name")
ITEM.Description = itemstore.Translate("moneyprinter_desc")
ITEM.Model = "models/props_c17/consolebox01a.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false

function ITEM:SaveData(ent)
	self:SetData("Owner", ent:Getowning_ent())

    self:SetData("Tier", ent:Gettier())
    self:SetData("Level", ent:Getlevel())
    self:SetData("Battery", ent:Getbattery())
    self:SetData("Health", ent:Gethealth())
end

function ITEM:LoadData(ent)
	ent:Setowning_ent(self:GetData("Owner"))



    timer.Simple(0, function ()
        ent.tier = self:GetData("Tier")
        ent:Settier(self:GetData("Tier"))
        ent:Setlevel(self:GetData("Level"))
        ent:Sethealth(self:GetData("Health"))
        ent:Setbattery(self:GetData("Battery"))
        ent:Setup(false, true)
    end)
end

function ITEM:GetName()
    local name = self.Name

    return self:GetData("Tier") .. " Printer " .. self:GetData("Level") .. " lvl"
end

function ITEM:CanPickup(ply, ent)
    if not ent:Getowning_ent() == ply then return false end

    return scprinters.config.ItemStore
end
