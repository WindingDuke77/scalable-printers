hook.Add("DarkRPFinishedLoading", "scprinters-addtof4", function ()

    for k, v in next, DarkRPEntities do
        if v.ent == "scalable-printer" then
            DarkRP.removeEntity(k)
        end
    end

    DarkRP.createCategory({
        name = "Scalable Printers",
        categorises = "entities",
        color = Color(0,96,185),
        startExpanded = true
    })

    scprinters = scprinters or {}
    scprinters.config = scprinters.config or {}
    local config = scprinters.config

    for printer, data in pairs(config.Printers) do
        local itemData = {
            ent = "scalable-printer",
            model = "models/props_c17/consolebox01a.mdl",
            tier = printer, -- Tier name is case insensitive
            price = data.price or 0,
            max = data.max or 1,
            cmd = "buy" .. printer .. "printer",
            category = "Scalable Printers"
            -- customCheck = data.customCheck or function ()
            --     return true
            -- end
        }
        DarkRP.createEntity(printer .. " Printer", itemData)
    end

end)