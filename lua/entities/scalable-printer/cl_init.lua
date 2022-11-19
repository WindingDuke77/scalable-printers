include("shared.lua")

scprinters = scprinters or {}
scprinters.config = scprinters.config or {}
scprinters.modules = scprinters.modules or {}
local config = scprinters.config
local imgui = scprinters.modules.imgui

function ENT:Draw()

    if not IsValid(self) then return end

    self:DrawModel()
    
    if LocalPlayer():GetPos():Distance( self:GetPos() ) > config.renderDistance then return end
    self:DrawTop()
    self:DrawFront()
end

function ENT:Initialize()
    self.data = config.Printers[self:Gettier()]
    self.Color = self.data.color
end

local function attachCurrency(str)
    local config = GAMEMODE.Config
    return config.currencyLeft and config.currency .. str or str .. config.currency
end

surface.CreateFont("SCPrinter-Label", {
    font = "Figerona",
	size = 20,
	weight = 5000,
})
surface.CreateFont("SCPrinter-Money", {
    font = "Figerona",
	size = 30,
	weight = 5000,
})
surface.CreateFont("SCPrinter-SMoney", {
    font = "Figerona",
	size = 20,
	weight = 5000,
})
surface.CreateFont("SCPrinter-SButton", {
    font = "Figerona",
	size = 20,
	weight = 5000,
})
surface.CreateFont("SCPrinter-SSButton", {
    font = "Figerona",
	size = 15,
	weight = 5000,
})

function ENT:DrawTop()
    if imgui.Entity3D2D(self, Vector(-16.35, -15.165, 10.59), Angle(0, 90, 0), 0.1) then
        local x, y = 309, 309

        // Background of printer
        surface.SetDrawColor(scprinters.DarkenColor(self.Color, 0.2))
        surface.DrawRect(0, 0, x, y )
        draw.NoTexture()

        // white circle
        surface.SetDrawColor(Color(255,255,255))
        scprinters.Circle( x / 2, x / 2, (x - x / 4) / 2, 100)

        // the next print circle
        surface.SetDrawColor(scprinters.DarkenColor(self.Color, -0.1))
        scprinters.DegCircle( x / 2, x / 2, (x - x / 4) / 2, 100, self:GetnextPrint() * 100, 180 )

        // the top circle
        surface.SetDrawColor(scprinters.DarkenColor(self.Color, 0.2))
        scprinters.Circle( x / 2, x / 2, (x - x / 4) / 2.2, 100)

        // print amount
        local PrintAmount = scprinters.CalPrintAmount(self)

        local hovering = imgui.IsHovering(x / 6, x / 6, x / 1.5, x / 1.5)
        if hovering then
            // displays amount in printer
            draw.SimpleText(attachCurrency(self:GetmoneyStored()), "SCPrinter-SMoney", x / 2, y / 2 + 31, Color(99,99,99), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)            
        else
            // displays amount in printer and print amount
            draw.SimpleText(attachCurrency(self:GetmoneyStored()), "SCPrinter-Money", x / 2, y / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(attachCurrency(Formatter.Format(PrintAmount)) .. "/s", "SCPrinter-SMoney", x / 2, y / 2 + 31, Color(99,99,99), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        
        // collect button
        local button1 = imgui.xTextButton("Collect", "SCPrinter-Money", x / 6, x / 6, x / 1.5, x / 1.5, 0, Color(255,0,0,0), Color(255,255,255), Color(143,143,143))
        if button1 then
            surface.PlaySound("garrysmod/ui_click.wav")

            net.Start("SCPrinter-Collect")
            net.WriteEntity(self)
            net.SendToServer()
        end

        // level Button


        draw.RoundedBox(5, 5, 5, 60, 25, self.Color)
        draw.SimpleText("Lvl: " .. tostring(self:Getlevel()), "SCPrinter-SButton", 5 + 60 / 2, 5 + 25 /2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        // Power Button
        draw.RoundedBox(5, x - 65, 5, 60, 25, self.Color)
        local hovering2 = imgui.IsHovering(x - 65, 5, 60, 25)
        if not hovering2 then
            scprinters.DrawIcon( self:BatteryMaterial(),  x - 65 + 29 / 2, 5 - 5, Color(255,255,255), 35, 35 )
        else
            local chargeAmount = (1 - self:Getbattery() / self.data.maxBattery ) *  self.data.refillCost
            chargeAmount = math.Round(chargeAmount, 0)
            local button3 = imgui.xTextButton("$" .. Formatter.Format(chargeAmount), "SCPrinter-SButton",  x - 65, 5, 60, 25, 0, Color(255,0,0,0), Color(255,255,255), Color(143,143,143))
            if button3 then
                surface.PlaySound("garrysmod/ui_click.wav")

                net.Start("SCPrinter-Recharge")
                net.WriteEntity(self)
                net.SendToServer()
            end
        end
        
        // todo make it change icom depening on icon

        // upgrade
        draw.RoundedBox(5, 80, y - 5 - 25, x - 160, 25, self.Color)
        local hovering2 = imgui.IsHovering(80, y - 5 - 25,  x - 160, 25)
        local upgradeText = "Upgrade"
        local levels = self.data.levels
        local UpgradeCost
        if levels then
            if not levels[self:Getlevel() + 1] then
                UpgradeCost = "MAX"
            else
                UpgradeCost = Formatter.Format(levels[self:Getlevel() + 1].upgradeCost)
            end
        else
            UpgradeCost = Formatter.Format(config.curves[self.data.upgradeCostCurve](self:Getlevel() + 1))
        end
        if hovering2 then upgradeText = UpgradeCost end
        local button2 = imgui.xTextButton(upgradeText, "SCPrinter-SButton", 80, y - 5 - 25,  x - 160, 25, 0, Color(255,255,255), Color(129,129,129), Color(2,155,10))
        if button2 then

            surface.PlaySound("garrysmod/content_downloaded.wav")

            net.Start("SCPrinter-Upgrade")
            net.WriteEntity(self)
            net.SendToServer()
        end

        
        imgui.End3D2D()
    end
end

function ENT:DrawFront()
    if imgui.Entity3D2D(self, Vector(16.23, -14.42, 10.21), Angle(0, 90, 90), 0.1) then
        local x, y = 220, 96

        surface.SetDrawColor(scprinters.DarkenColor(self.Color, 0.2))
        surface.DrawRect(0, 0, x, y )

        draw.RoundedBox(5, 2.5, 5, x / 3 - 5, 20, self.Color)
        draw.SimpleText("Owner", "SCPrinter-Label", 2.5 + (x / 3 - 5) / 2, 7 + 10, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.RoundedBox(5, 2.5, 30, x / 3 - 5, 20, self.Color)
        draw.SimpleText(self:FormatOwner(), "SCPrinter-Label", 2.5 + (x / 3 - 5) / 2, 7 + 35, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local tier = self:Gettier()
        if #tier > 6 then
            tier = tier:sub(1, 5)
        end

        draw.RoundedBox(5, 2.5 + x / 3, 5, x / 3 - 5, 20, self.Color)
        draw.SimpleText("Tier", "SCPrinter-Label", 2.5 + (x / 3 * 1) + (x / 3) / 2 - 3, 7 + 10, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.RoundedBox(5, 2.5 + x / 3, 30, x / 3 - 5, 20, self.Color)
        draw.SimpleText(tier, "SCPrinter-Label", 2.5 + (x / 3 * 1) + (x / 3) / 2 - 3, 7 + 35, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.RoundedBox(5, 2.5 + x / 3 * 2, 5, x / 3 - 5, 20, self.Color)
        draw.SimpleText("Level", "SCPrinter-Label", 2.5 + (x / 3 * 2) + (x / 3) / 2 - 3, 7 + 10, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.RoundedBox(5, 2.5 + x / 3 * 2, 30, x / 3 - 5, 20, self.Color)
        draw.SimpleText(tostring(self:Getlevel()), "SCPrinter-Label", 2.5 + (x / 3 * 2) + (x / 3) / 2 - 3, 7 + 35, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    

        // charge + health

        draw.RoundedBox(5, 2.5, 55, 60 - 22.5, 35, self.Color)
        local hovering = imgui.IsHovering(2.5, 55, 60 - 22.5, 35)
        if not hovering then
            scprinters.DrawIcon( Material("scalable-printers/wplus.png", "noclamp smooth" ) , 10, 60, Color(255,255,255), 25, 25 )
        else
            local chargeAmount = (1 - self:Gethealth() / self.data.maxHealth) *  self.data.repairCost
            chargeAmount = math.Round(chargeAmount, 0)
            local button = imgui.xTextButton("$" .. Formatter.Format(chargeAmount), "SCPrinter-SSButton",  2.5, 55, 60 - 22.5, 35, 0, Color(255,0,0,0), Color(255,255,255), Color(143,143,143))
            if button then
                surface.PlaySound("garrysmod/ui_click.wav")

                net.Start("SCPrinter-Repair")
                net.WriteEntity(self)
                net.SendToServer()
            end
        end
        



        draw.RoundedBox(5, 68 - 22.5, 55, x - 50, 35, self.Color)
        // make repair buutton
        draw.RoundedBox(5, 68 - 22.5 + 2.5, 55 + 2.5,(x - 50 - 5)  * self:Gethealth() / self.data.maxHealth, 35 - 5, scprinters.DarkenColor(self.Color, 0.2))
        


        imgui.End3D2D()
    end
end

function ENT:FormatOwner()
    local owner = self:Getowning_ent()
    if owner:IsPlayer() then
        owner = owner:Nick()
    else
        owner = "Null"
    end

    if #owner > 6 then
        owner = owner:sub(1, 6)
    end

    return owner
end

function ENT:BatteryMaterial()
    local batteryPrecent =  self:Getbattery() / self.data.maxBattery * 100
    local mstring
    
    if batteryPrecent > 95 then
        mstring = "wfull-battery.png"
    elseif batteryPrecent > 75 then
        mstring = "wbattery.png"
    elseif batteryPrecent > 50 then
        mstring = "whalf-battery.png"
    elseif batteryPrecent > 5 then
        mstring = "wlow-battery.png"
    else
        mstring = "wempty-battery.png"
    end

    return Material( "scalable-printers/" ..mstring, "noclamp smooth" )
end