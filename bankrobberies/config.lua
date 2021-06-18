Config             = {}
Config.CopsNeeded  = 4 --How many cops need to be on to start the job
Config.AllowedBags = {45}

Config.Banks = {
    ["Principal Bank"] = {
        ["start"] = { 
            ["pos"] = vector3(253.47, 228.41, 101.30), 
            ["heading"] = 359.48452758789 
        },
        ["door"] = { 
            ["pos"] = vector3(255.23, 223.98, 102.39),
            ["model"] = 961976194
        },
        ["device"] = {
            ["model"] = -160937700
        },
        ["trolleys"] = {
            ["left"] = { 
                ["pos"] = vector3(265.71, 215.22, 100.70), 
                ["heading"] = 249.88 + 180.0
            },
            ["right"] = { 
                ["pos"] = vector3(264.67, 212.37, 100.70), 
                ["heading"] = 249.88 + 180.0
            },
        }
    },
    ["Pacific Fleeca"] = {
        ["start"] = { 
            ["pos"] = vector3(-2956.5498046875, 481.62054443359, 15.697087287903), 
            ["heading"] = 359.48452758789 
        },
        ["door"] = { 
            ["pos"] = vector3(-2957.7080078125, 481.89660644531, 15.697031974792),
            ["model"] = -63539571
        },
        ["device"] = {
            ["model"] = -160937700
        },
        ["trolleys"] = {
            ["left"] = { 
                ["pos"] = vector3(-2952.837890625, 485.85018920898, 15.675424575806), 
                ["heading"] = 315.0 + 180.0
            },
            ["right"] = { 
                ["pos"] = vector3(-2952.984375, 482.74969482422, 15.675343513489), 
                ["heading"] = 220.0 + 180.0
            },
        }
    },
	["Legion Fleeca"] = {
        ["start"] = { 
            ["pos"] = vector3(146.79, -1045.77, 29.37), 
            ["heading"] = 359.48452758789 
        },
        ["door"] = { 
            ["pos"] = vector3(148.03, -1044.36, 29.51),
            ["model"] = 2121050683
        },
        ["device"] = {
            ["model"] = -160937700
        },
        ["trolleys"] = {
            ["left"] = { 
                ["pos"] = vector3(149.77, -1050.73, 28.35), 
                ["heading"] = 161.03 + 180.0
            },
            ["right"] = { 
                ["pos"] = vector3(147.07, -1049.87, 28.35), 
                ["heading"] = 161.03 + 180.0
            },
        }
    },
	["Burton Fleeca"] = {
        ["start"] = { 
            ["pos"] = vector3(-353.93, -55.03, 49.04), 
            ["heading"] = 234.95
        },
        ["door"] = { 
            ["pos"] = vector3(-352.74, -53.57, 49.18),
            ["model"] = 2121050683
        },
        ["device"] = {
            ["model"] = -160937700
        },
        ["trolleys"] = {
            ["left"] = { 
                ["pos"] = vector3(-350.70, -59.70, 48.01), 
                ["heading"] = 162.71 + 180.0
            },
            ["right"] = { 
                ["pos"] = vector3(-353.44, -58.81, 48.01), 
                ["heading"] = 162.71 + 180.0
            },
        }
    }
}

Config.Trolley = {
    ["cash"] = {250, 2500}, --The amount you get each pickup at the small banks.. Math random between the 2 numbers approx 80-90 pickups
    ["model"] = GetHashKey("hei_prop_hei_cash_trolly_01")
}

Config.Trolley2 = {
    ["cash"] = {600, 6000}, --The amount you get each pickup at the large bank.. Math random between the 2 numbers approx 80-90 pickups
    ["model"] = GetHashKey("hei_prop_hei_cash_trolly_01")
}

Config.EmptyTrolley = {
    ["model"] = GetHashKey("hei_prop_hei_cash_trolly_03")
}

Config.Doors = {--Door locks
    [1] = {
        Doors = { --Big Bank Downtown
            {Coords = vector3(257.22, 220.72, 106.28), Object = "hei_v_ilev_bk_gate_pris",  Heading = -20.0,  BTPosition = {C = vector3(257.0, 219.76, 105.41),  H = 338.38}, Time = 300, Frozen = true}, 
            {Coords = vector3(261.58, 222.05, 106.28), Object = "hei_v_ilev_bk_gate2_pris", Heading = -110.0, BTPosition = {C = vector3(261.34, 221.91, 105.4),  H = 254.73}, Time = 300, Frozen = true},         		
        },
    },	
	[2] = {
        Doors = { --Big Bank Downtown            
            {Coords = vector3(253.49, 221.10, 101.70), Object = "hei_v_ilev_bk_safegate_pris", Heading = 160.0,  BTPosition = {C = vector3(253.46, 221.03, 100.70), H = 155.92}, Time = 300, Frozen = true},	
            {Coords = vector3(261.30, 214.51, 101.83), Object = "hei_v_ilev_bk_safegate_pris", Heading = 250.0,  BTPosition = {C = vector3(261.30, 216.10, 100.70), H = 244.59}, Time = 500, Frozen = true},			           						
        },
    },	
	[3] = {
        Doors = { --Big Bank Downtown vault         
            {Coords = vector3(255.23, 223.98, 102.39), Object = "v_ilev_bk_vaultdoor", Heading = 160.0,  BTPosition = {C = vector3(253.46, 221.03, 100.70), H = 155.92}, Time = 300, Frozen = true},	          			           						
        },
    },
	[4] = {
        Doors = {--Pacific Fleeca 			          
            {Coords = vector3(-2956.116, 485.4206, 15.99531), Object = "v_ilev_gb_vaubar", Heading = -92.4, BTPosition = {C = vector3(-2956.73, 484.27, 14.68), H = 280.38}, Time = 300, Frozen = true},                        			
        },
    },			
	[5] = {
        Doors = {--Legion Fleeca   			
            {Coords = vector3(150.2913, -1047.629, 29.6663), Object = "v_ilev_gb_vaubar", Heading = -200.0, BTPosition = {C = vector3(149.38, -1046.79, 28.35), H = 156.8}, Time = 300, Frozen = true},           
        },
    },
	[6] = {
        Doors = {--Burton Fleeca   			        
            {Coords = vector3(-350.41, -56.80, 49.33), Object = "v_ilev_gb_vaubar", Heading = -199.0, BTPosition = {C = vector3(-351.25, -55.96, 48.01), H = 158.94}, Time = 300, Frozen = true},                        			
        },
    }
}