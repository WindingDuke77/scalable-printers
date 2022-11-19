AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

scprinters = scprinters or {}
scprinters.config = scprinters.config or {}
local config = scprinters.config

util.AddNetworkString("SCPrinter-Collect")
util.AddNetworkString("SCPrinter-Upgrade")
util.AddNetworkString("SCPrinter-Recharge")
util.AddNetworkString("SCPrinter-Repair")

function ENT:Initialize()
    self:SetModel("models/props_c17/consolebox01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS) 
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetTrigger(true)

    
    self.lastPrint = CurTime()
    self.transferPly = nil
    self.transferStep = 0

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:SetMass(30)
        phys:SetMaterial("computer")
    end

    self:SetMaterial("models/debug/debugwhite")
    self:Setup(true)

    self.Sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
    self.Sound:SetSoundLevel(50)
    self.Sound:PlayEx(1, 100)
end

function ENT:Setup(default, itemStore)


    if not itemStore then 
        if default then 
            self.tier = table.GetKeys(config.Printers)[1]
            self:Settier(table.GetKeys(config.Printers)[1])
        end

        self:Setlevel(1) 
        self:SetmoneyStored(0)
    end

    self.data = config.Printers[self.tier]

    if not itemStore then
        local printAmount = 0
        if not self.data.levels then
            printAmount = Formatter.Format(config.curves[self.data.printAmountCurve](self:Getlevel()))
        else
            printAmount = Formatter.Format(self.data.levels[1].printAmount)
        end

        self:Setbattery(self.data.maxBattery)
        self:Sethealth(self.data.maxHealth)
        self:SetprintAmount(printAmount)
    end

    self:Setrunning(true)
    self:SetColor(self.data.color)
end

function ENT:Think()
    if self:Getrunning() then
        if self.Sound and not self.Sound:IsPlaying() then
            self.Sound:PlayEx(1, 100)
        end

        self:NextPrint()
    else
        if self.Sound and self.Sound:IsPlaying() then
            self.Sound:Stop()
        end
        if self:Getbattery() >= 0 then
            self:Setrunning(true)
        end 

    end
end

function ENT:NextPrint()
    self:SetnextPrint((CurTime() - self.lastPrint)  / config.printTime)
    if self.lastPrint + config.printTime < CurTime() then
        
        local PrintAmount = scprinters.CalPrintAmount(self)

        self:Setbattery(self:Getbattery() - 1)

        self.lastPrint = CurTime()
        self:SetmoneyStored(Formatter.Format(Formatter.UnFormat(self:GetmoneyStored()) + PrintAmount))

        if self:Getbattery() <= 0 then
            self:Setrunning(false)
            self:SetnextPrint(0)
        end
    end
end

function ENT:CollectMoney(ply)
    if not ply:IsPlayer() then return end
    local money = Formatter.UnFormat(self:GetmoneyStored())
    if type(money) == "number" and money < 0 then return end

    if self.transferPly == ply then
        self.transferStep = self.transferStep + 1
        if self.transferStep >= config.transferAmount then
            self:Setowning_ent(ply)
        end
    else
        self.transferPly = ply
        self.transferStep = 0
    end 


    ply:addMoney(money)
    self:SetmoneyStored(0)
end

function ENT:Upgrade(ply)
    if not ply:IsPlayer() then return end

    local levels = self.data.levels
    if (self.data.maxLevel and self.data.maxLevel > 0) or (levels) then
        if (levels and self:Getlevel() >= #levels) or (self.data.maxLevel and self:Getlevel() >= self.data.maxLevel) then 
            return DarkRP.notify(ply, 1, 4, "The Printer is at Max Level")
        end 
    end

    local UpgradeCost
    if levels then
        UpgradeCost = levels[self:Getlevel() + 1].upgradeCost
    else
        UpgradeCost = config.curves[self.data.upgradeCostCurve](self:Getlevel() + 1)
    end

    if not ply:canAfford(UpgradeCost) then
        return DarkRP.notify(ply, 1, 4, "You can not afford this upgrade")
    end

    ply:addMoney(-UpgradeCost)
    self:Setlevel(self:Getlevel() + 1) 
    
    if levels then
        self:SetprintAmount(Formatter.Format(Formatter.UnFormat(self:GetprintAmount()) + levels[self:Getlevel()].printAmount))
    else
        self:SetprintAmount(Formatter.Format(Formatter.UnFormat(self:GetprintAmount()) + config.curves[self.data.printAmountCurve](self:Getlevel())))
    end
end

function ENT:Recharge(ply)
    if not ply:IsPlayer() then return end
    if self:Getbattery() / self.data.maxBattery == 1 then return end


    local chargeAmount = (1 - self:Getbattery() / self.data.maxBattery ) *  self.data.refillCost
    chargeAmount = math.Round(chargeAmount, 0)

    if not ply:canAfford(chargeAmount) then
        return DarkRP.notify(ply, 1, 4, "You can not afford this Recharge")
    end


    ply:addMoney(-chargeAmount)
    self:Setbattery(self.data.maxBattery) 
end

function ENT:Repair(ply)
    if not ply:IsPlayer() then return end
    if self:Gethealth() / self.data.maxHealth == 1 then return end


    local chargeAmount =  (1 - self:Gethealth() / self.data.maxHealth) *  self.data.repairCost
    chargeAmount = math.Round(chargeAmount, 0)

    if not ply:canAfford(chargeAmount) then
        return DarkRP.notify(ply, 1, 4, "You can not afford this Repair")
    end


    ply:addMoney(-chargeAmount)
    self:Sethealth(self.data.maxHealth) 
end

net.Receive("SCPrinter-Collect", function (len, ply)
    local self = net.ReadEntity()
    self:CollectMoney(ply)
end)

net.Receive("SCPrinter-Upgrade", function (len, ply)
    local self = net.ReadEntity()
    self:Upgrade(ply)
end)

net.Receive("SCPrinter-Recharge", function (len, ply)
    local self = net.ReadEntity()
    self:Recharge(ply)
end)

net.Receive("SCPrinter-Repair", function (len, ply)
    local self = net.ReadEntity()
    self:Repair(ply)
end)


function ENT:OnRemove()
    if self.Sound then
        self.Sound:Stop()
    end
    DarkRP.notify(self:Getowning_ent(), NOTIFY_ERROR, 7, "Your " .. self.tier .. " Printer has been destroyed")
end

local damageTypes = {
    [DMG_GENERIC] = true,
    [DMG_BUCKSHOT] = true,
    [DMG_BULLET] = true,
    [DMG_BLAST] = true,
    [DMG_ACID] = true,
    [DMG_CLUB] = true,
    [DMG_SHOCK] = true,
    [DMG_DISSOLVE] = true
}
function ENT:OnTakeDamage(dmgInfo)
    local isDmgType = false
    for typ, _ in next, damageTypes do
        if dmgInfo:IsDamageType(typ) or (dmgInfo:GetDamageType() == 0 and typ == 0) then
            isDmgType = true
            break
        end
    end
    if isDmgType then
        self:Sethealth(math.max(0, self:Gethealth() - dmgInfo:GetDamage()))
        if self:Gethealth() <= 0 then
            self:Remove()
        end
    end
end

function ENT:OnVarChanged( name, old, new )
	print( name, old, new )
end