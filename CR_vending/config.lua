Config = {}

Config.RageSuccessChance = 5
Config.RageCopChance = 5
Config.VendingMachineScamChance = 5 -- 5% chance that you don't get a product for your money, because vending machines scam you yo.
Config.MachineBrokenTimer = 5 -- in minutes
Config.MaxCount = 10

Config.Costs = {
    ["Coffee"] = 4,
    ["Snacks"] = 5,
    ["Drinks"] = 3
}

-- ["items"] = {[id] = {[itemname], [item label]}}
Config.CoffeeMachine = {
    ["models"] = {
        `prop_vend_coffe_01`
    },
    ["items"] = {
        [1] = {'latte', 'Latte'},
        [2] = {'cappuccino', 'Cappuccino'},
        [3] = {'mocha', 'Mocha'},
        [4] = {'icedcoffee', 'Iced Coffee'}
    }
}

Config.SnackMachine = {
    ["models"] = {
        `prop_vend_snak_01`
    },
    ["items"] = {
        [1] = {'potatochips', 'Potato Chips'},
        [2] = {'donut', 'Donut'},
        [3] = {'nuggets', 'Nuggets'}
    }
}

Config.DrinkMachine = {
    ["models"] = {
        `prop_vend_soda_01`,
        `prop_vend_soda_02`
    },
    ["items"] = {
        [1] = {'drink_pepsi', 'Pepsi'},
        [2] = {'drink_coke', 'Coke'},
        [3] = {'drink_sprite', 'Sprite'}
    }
}