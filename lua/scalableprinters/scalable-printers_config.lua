// This Addon was created by:
// Bob Bobington#2947
// 
// any questions, please contact me

scprinters = scprinters or {}
scprinters.config = scprinters.config or {}
local config = scprinters.config
 
// Do not above this line.

config.mfplus = true // Overwrite DarkRP Money formate to moneyFormatting+. https://steamcommunity.com/sharedfiles/filedetails/?id=2874776982

config.printTime = 5 // time in seconds

config.multiplier = 1 // The amound you wish the curves to me times by. // easier than creating your own curve

config.renderDistance = 250 // how far the ui on the printer renders

config.transferAmount = 5 // amount times someone has to collect money to transfer owner ship of printer

config.curves = {  // Curves of cost of upgrade / print amount compare to update level
    [1] = function (x) // Exponential Curve
        local startAmount = 100 // Staring amount
        local minIncrease = 10 // minium increase between levels
        local decreaseModifier = 100 // how slow the amount increases

        return math.Round(math.pow(2, x) / decreaseModifier + startAmount + (minIncrease * (x-1)) , 0) 
    end,
    [2] = function (x)
        local startAmount = 100 // Staring amount
        local minIncrease = 10 // minium increase between levels
        local decreaseModifier = 100 // how slow the amount increases

        return math.Round(math.sqrt(x) * 100 + startAmount + (minIncrease * (x-1)) / decreaseModifier, 0) 
    end
}

--[[
    If ItemStore is installed...

    https://www.gmodstore.com/scripts/view/15/itemstore-inventory-for-darkrp
]]
config.ItemStore = true // allows you to pick up the printer

config.rankMultipier = {
    ["superadmin"] = 1.5,
    ["admin"] = 1.3,
    ["vip"] = 1.1
}

config.Printers = {
    --[[ Example Start
    ["Eample Level"] = {    // Printer Name
        levels = {          // Levels
            [1] = {
                upgradeCost = 0,        // upgrade cost
                printAmount = 10        // the amount added to the total print amount
            },
            [2] = {
                upgradeCost = 50,
                printAmount = 15
            },
            [3] = {
                upgradeCost = 100,
                printAmount = 25
            },
            [4] = {
                upgradeCost = 250,
                printAmount = 50
            },
            [5] = {
                upgradeCost = 500,
                printAmount = 100
            },
        },
        multiplier = 1,                 // add on top of config.Multiplier
        
        refillCost = 500,               // Refill Cost
        repairCost = 1000,              // Repair Cost

        maxBattery = 20,                // how many prints need before refill
        maxHealth = 150,                // health of the printer

        color = Color(48, 10, 153),   // Color of Printer

        // DarkRP
        customCheck = NULL,             // Custom Check if a person can purchest the printer
        price = 10,                     // Price
        max = 2                         // Max able to buy
    },
    ["Eample Curve"] = {        // Printer Name
        upgradeCostCurve = 1,           // what curve the printer upgrade cost will use
        printAmountCurve = 2,           // what curve the printer amount will use

        multiplier = 1,                 // add on top of config.Multiplier
        
        refillCost = 500,               // Refill Cost
        repairCost = 1000,              // Repair Cost

        maxBattery = 20,                // how many prints need before refill
        maxHealth = 150,                // health of the printer

        color = Color(48, 10, 153),   // Color of Printer

        // DarkRP
        customCheck = NULL,             // Custom Check if a person can purchest the printer
        price = 10,                     // Price
        max = 2                         // Max able to buy
    },
    ]]-- Example End
    ["Basic"] = { // Printer Name
        levels = { // Manualy set the levels up
            [1] = {
                upgradeCost = 0, // upgrade cost
                printAmount = 10 // the amount added to the total print amount
            },
            [2] = {
                upgradeCost = 50,
                printAmount = 15
            },
            [3] = {
                upgradeCost = 100,
                printAmount = 25
            },
            [4] = {
                upgradeCost = 250,
                printAmount = 50
            },
            [5] = {
                upgradeCost = 500,
                printAmount = 100
            },
        },
        multiplier = 1, // add on top of config.Multiplier
        
        refillCost = 500,
        repairCost = 1000,

        maxBattery = 20, // how many prints need before refill
        maxHealth = 150, // health of the printer

        color = Color(48, 10, 153),

        // DarkRP
        customCheck = NULL, // Custom Check if a person can purchest the printer
        price = 10,
        max = 2

    },
    ["Advance"] = {
        // Printer
        upgradeCostCurve = 1, // what curve the printer upgrade cost will use
        printAmountCurve = 2, // what curve the printer amount will use
        multiplier = 1.5, // add on top of config.Multiplier
        
        refillCost = 600,
        repairCost = 5000,
        
        maxLevel = 50, // set to 0 if you want it to be unlimted
        maxBattery = 25, // how many prints need before refill
        maxHealth = 300, // health of the printer


        color = Color(153, 10, 10),

        // DarkRP
        customCheck = nil, // Custom Check if a person can purchest the printer
        price = 10,
        max = 2
    },
    ["Expert"] = {
        // Printer
        upgradeCostCurve = 1, // what curve the printer upgrade cost will use
        printAmountCurve = 2, // what curve the printer amount will use
        multiplier = 2.5, // add on top of config.Multiplier
        
        refillCost = 1000,
        repairCost = 10000,
        
        maxLevel = 0, // set to 0 if you want it to be unlimted
        maxBattery = 30, // how many prints need before refill
        maxHealth = 600, // health of the printer

        color = Color(216, 124, 19),

        // DarkRP
        customCheck = nil, // Custom Check if a person can purchest the printer
        price = 10,
        max = 2
    }
}