--[[ PROSPECT CONFIGURATION ]]--
--[[      NATURALKHAOS      ]]--

------------------------Prospect-------------------------------------------------------
Config = {
        SmeltDist = 2,
        SmeltRender = 40,
		Chance = {							-- Item Drop Chances
			GoldNugget	=	{1,3}, 					-- Gold
			WeedSeed	=	{1,10},					-- Weed
			RustIron	=	{1,2},					-- Rusty Iron
			DiamondC	=	{1,200},				-- Diamond
			PlatinumC	=	{1,5},					-- Platinum
			RawIron		=	{1,5},					-- Raw Iron
		},
		Use = {								-- Usable Tools
			Shovel		=	'shovel', 				-- Shovel for digging
			Pan			=	'miningPan',			-- Pan for cleaning paydirt
			Aluminum	=	'aluminumFoil',			-- Foil for use with Iron Oxide to make Thermite
			RustyIron	=	'rustyIron',			-- Rusty Iron to be crushed into Iron Oxide
		},
		Items = {							-- Procurable Items
			IronOxide	=	'ironOxide',			-- Used with Aluminum to make Thermite
			Thermite	=	'thermal_charge',		-- To break into banks maybe...
			PayDirt		=	'payDirt',				-- To be panned in the river using a pan for gold
			GoldNugget	=	'goldNugget',			-- Found by panning paydirt
			GoldBar		=	'goldBar',				-- Created by melting down nuggets at the smelter
			IronBar		=	'ironBar',				-- Created by melting raw iron at at the smelter
			PlatBar		=	'platBar',				-- Created by melting raw platinum at the smelter
			Diamond		=	'rawDiamond',			-- Chance drop
			Platinum	=	'platinum',				-- Chance drop
			SeedM		=	'lowgrademaleseed',		-- Chance drop
			SeedF		=	'lowgradefemaleseed',	-- Chance drop
			RawIron		=	'raw_iron',				-- chance drop
		},
		Mine = {
			vector3(2953.91, 2787.1, 41.49),
			vector3(-596.22, 2089.12, 131.41),
		},
		Smelter = {
			vector3(1108.76, -2007.43, 30.90),
		},
		Scrapyard = {
			vector3(2388.01, 3054.13, 48.15),
		},
}

------------------------Search Dumpsters-----------------------------------------------
dumpster = {
    config = {
        canSearch = true,                           -- Turn on/off dumpster diving
    },

    dumpsters = {                                   -- What props are Dumpsters
        218085040, 
        666561306,
    },

    Items = {                                       -- What can be found in dumpsters
        [1] = {chance = 2, id = 'glass', name = 'Broken Glass', quantity = math.random(1,8), limit = 0},
        [2] = {chance = 2, id = 'wallet', name = 'Wallet', quantity = 1, limit = 10},
        [3] = {chance = 2, id = 'plastic', name = 'Plastic Scrap', quantity = math.random(1,8), limit = 0},
        [4] = {chance = 3, id = 'rubber', name = 'Rubber Scrap', quantity = math.random(1,5), limit = 0},
        [5] = {chance = 3, id = 'wood', name = 'Wood Scraps', quantity = math.random(1,5), limit = 0},
        [6] = {chance = 3, id = 'electronics', name = 'Electronics Parts', quantity = math.random(1,3), limit = 0},
        [7] = {chance = 4, id = 'weapon_bottle', name = 'Broken Bottle', quantity = 1, limit = 2},
        [8] = {chance = 4, id = 'weapon_poolcue', name = 'Pool Cue', quantity = 1, limit = 2},
        [9] = {chance = 4, id = 'weapon_wrench', name = 'Wrench', quantity = 1, limit = 2},
        [10] = {chance = 5, id = 'lowgradefemaleseed', name = 'Female Seed', quantity = 1, limit = 0},
        [11] = {chance = 5, id = 'lowgrademaleseed', name = 'Male Seed', quantity = 2, limit = 0},
        -- [12] = {chance = 1, id = 'brokenlaptop', name = 'Broken Laptop', quantity = 1, limit = 0},
    },
}

------------------------Crafting-----------------------------------------------
Crafting = {
    Locations = {                              -- Location of crafting tables
        [1] = {x = 1208.73, y = -3114.41, z = 5.55},
        [2] = {x = 379.12, y = 258.88, z = 92.19},
    },

    Items = {                                  -- Craftable items at the normal crafting table
        ["shovel"] = {
            label = "Shovel",
            needs = {
                ["ironBar"]     = {label = "Iron Bar", count = 1},
                ["wood"]        = {label = "Wood", count = 5},
            },
            threshold = 0,
        },
        ["miningPan"] = {
            label = "Mining Pan",
            needs = {
                ["plastic"]     = {label = "Plastic", count = 5},
            },
            threshold = 0,
        },
        ["screwdriver"] = {
            label = "Screwdriver",
            needs = {
                ["ironBar"]     = {label = "Iron Bar", count = 3},
                ["plastic"]     = {label = "Plastic", count = 6},
            },
            threshold = 15,
        },
        -- ["tyrekit"] = {
        --     label = "Car Tyre Kit",
        --     needs = {
        --         ["screwdriver"]     = {label = "Screwdriver", count = 1},
        --         ["ironBar"]     = {label = "Iron Bar", count = 4},
        --         ["rubber"]     = {label = "Rubber Scrap", count = 10},
        --     },
        --     threshold = 25,
        -- },
        -- ["repairkit"] = {
        --     label = "Body Repair Kit",
        --     needs = {
        --         ["screwdriver"]     = {label = "Screwdriver", count = 1},
        --         ["ironBar"]     = {label = "Iron Bar", count = 5},
        --         ["plastic"]     = {label = "Plastic Scrap", count = 4},
        --         ["rubber"]     = {label = "Rubber Scrap", count = 4},
        --     },
        --     threshold = 30,
        -- },
        ["bobbypin"] = {
            label = "10x Pins",
            needs = {
                ["ironBar"]     = {label = "Iron Bar", count = 4},
                ["plastic"]     = {label = "Plastic", count = 3},
            },
            threshold = 25,
        },
        ["hdevice"] = {
            label = "Hack Dev",
            needs = {
                ["ironBar"]     = {label = "Iron Bar", count = 5},
                ["plastic"]     = {label = "Plastic", count = 4},
                ["electronics"] = {label = "Electronic Parts", count = 5},
                ["glass"]       = {label = "Glass", count = 4},
            },
            threshold = 35,
        },
        ["fscanner"] = {
            label = "FScan",
            needs = {
                ["ironBar"]     = {label = "Iron Bar", count = 10},
                ["plastic"]     = {label = "Plastic", count = 8},
                ["electronics"] = {label = "Electronic Parts", count = 8},
                ["glass"]       = {label = "Glass", count = 5},
            },
            threshold = 40,
        },
        ["handcuffkeys"] = {
            label = "Handcuff Keys",
            needs = {
                ["ironBar"]     = {label = "Iron Bar", count = 10},
                ["plastic"]     = {label = "Plastic", count = 10},
            },
            threshold = 40,
        },
        ["vest"] = {
            label = "Bulletproof Vest",
            needs = {
                ["ironBar"]     = {label = "Iron Bar", count = 10},
                ["plastic"]     = {label = "Plastic", count = 10},
                ["platBar"]     = {label = "Plat Bar", count = 2},
            },
            threshold = 50,
        },
        ["laptop_h"] = {
            label = "Hacking Laptop",
            needs = {
                ["ironBar"]     = {label = "Iron Bar", count = 10},
                ["plastic"]     = {label = "Plastic", count = 20},
                ["electronics"]     = {label = "Electronics", count = 50},
            },
            threshold = 100,
        },
    },

    ItemsG = {                                  -- Craftable items at the Galaxy crafting table
        ["weapon_knuckle"] = {
            label = "Knuckles",
            needs = {
                ["ironBar"]     = {label = "IBar", count = 1},
                ["goldBar"]     = {label = "GBar", count = 1},
            },
            threshold = 0,
        },
        ["weapon_switchblade"] = {
            label = "SwitchB",
            needs = {
                ["ironBar"]     = {label = "IBar", count = 3},
                ["wood"]        = {label = "Wood", count = 2},
            },
            threshold = 0,
        },
        ["weapon_pistol"] = {
            label = "Pistol",
            needs = {
                ["ironBar"]     = {label = "IBar", count = 10},
                ["plastic"]     = {label = "Plas", count = 5},
                ["rubber"]      = {label = "Rub", count = 5},
                ["wood"]        = {label = "Wood", count = 2},
            },
            threshold = 5,
        },
        ["weapon_microsmg"] = {
            label = "Micro SMG",
            needs = {
                ["ironBar"]     = {label = "IBar", count = 15},
                ["plastic"]     = {label = "Plas", count = 7},
                ["rubber"]      = {label = "Rub", count = 5},
                ["wood"]        = {label = "Wood", count = 3},
            },
            threshold = 10,
        },
        ["weapon_appistol"] = {
            label = "APPistol",
            needs = {
                ["ironBar"]     = {label = "IBar", count = 25},
                ["plastic"]     = {label = "Plas", count = 10},
                ["rubber"]      = {label = "Rub", count = 5},
                ["wood"]        = {label = "Wood", count = 3},
            },
            threshold = 15,
        },
        ["weapon_sawnoffshotgun"] = {
            label = "S/O Shotgun",
            needs = {
                ["ironBar"]     = {label = "IBar", count = 35},
                ["plastic"]     = {label = "Plas", count = 10},
                ["rubber"]      = {label = "Rub", count = 5},
                ["wood"]        = {label = "Wood", count = 5},
            },
            threshold = 20,
        },
        ["weapon_assaultrifle"] = {
            label = "AR",
            needs = {
                ["ironBar"]     = {label = "IBar", count = 50},
                ["plastic"]     = {label = "Plas", count = 15},
                ["rubber"]      = {label = "Rub", count = 8},
                ["wood"]        = {label = "Wood", count = 5},
            },
            threshold = 30,
        },
        ["weapon_marksmanrifle"] = {
            label = "Marks Rifle",
            needs = {
                ["ironBar"]     = {label = "IBar", count = 100},
                ["plastic"]     = {label = "Plas", count = 20},
                ["rubber"]      = {label = "Rub", count = 10},
                ["wood"]        = {label = "Wood", count = 5},
                ["glass"]       = {label = "Glass", count = 4},
            },
            threshold = 150,
        },
        ["blowtorch"] = {
            label = "Blowtorch",
            needs = {
                ["ironBar"]     = {label = "IBar", count = 5},
                ["plastic"]     = {label = "Plas", count = 20},
                ["rubber"]      = {label = "Rub", count = 10},
                ["glass"]       = {label = "Glass", count = 4},
            },
            threshold = 65,
        },
    },
}