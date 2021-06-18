Config = {}

Config.Locale = 'en'
Config.LyeCost = 300
Config.RequiredShowMarker = 1
Config.SalesDuration = 25000 -- Sales Time (in MS)
Config.Meth1Sales = 10000 -- Crap sales price
Config.Meth2Sales = 20000 -- Alright sales price
Config.Meth3Sales = 40000 -- Premium sales price
Config.Meth4Sales = 70000 -- Perfect sales price
Config.ExtraDirtyMax = 30000 -- Get less than 2 product? get dirty cash min
Config.ExtraDirtyMin = 5000 -- Get less than 2 product? get dirty cash max
Config.SalesChance = 25
Config.RequiredPoliceSales = 1
Config.RequiredPoliceHL = 3 -- Police required for Humane Labs
Config.RequiredHLCooldown = 300 -- (in seconds)
Config.HLDelay = 30000 -- alarm delay in MS for entering through water entrance
Config.HLVehicle = 'boxville3' -- Humane Labs vehicle
Config.HLKeys = 2000 -- Key grab time in MS
Config.HLVanCrush = 10000 -- Crush Time in MS
Config.RequiredPolicePB = 2 -- Police Required for Pillbox robbery
Config.RequiredPBCooldown = 300 -- PB robbery cooldown (in seconds)
Config.PBRobberyLength = 60000 -- Time for PB robbery to complete
Config.RequiredPoliceChem = 2 -- Police Required for Chemistry robbery
Config.RequiredChemCooldown = 300 -- Chemistry robbery cooldown (in seconds)
Config.ChemRobberyLength = 60000 -- Time for Chemistry robbery to complete
Config.RequiredPoliceRP = 3 -- Police Required for Red Phosphorus
Config.RequiredRPCooldown = 300 -- (in seconds)
Config.RPVehicle = 'duster' -- RP Vehicle
Config.RPRefillTime = 3000 -- Refill Time in MS
Config.RPPlaneCrush = 3000 -- Crush Time in MS
Config.RequiredPoliceGas = 2 -- Required Police for Gas Robbery
Config.RequiredGasCooldown = 300 -- Required Cooldown for Gas
Config.BoatKeyDifficulty = 5 -- Float value from 2-5
Config.GasBoat = 'suntrap' -- Boat that spawns
Config.GasBoatCrush = 3000
Config.GasBike = 'blazer2' -- Bike that spawns after delivery
Config.GasBikeCrush = 10000
Config.RequiredPoliceCook = 1 -- Counts for outfitting the van and actually beginning the cook
Config.CookVehicle = 'journey' -- Changing this WILL break the location of the bottles in the spawnBottle function
Config.OutfitTime = 3000 -- in MS
Config.MaxSales = 5 -- Max Sale Value
Config.Chance1 = 25 -- Chance to notify cops at 2-4 minutes
Config.Chance2 = 40 -- Chance to notify cops at 5-9 minutes
Config.Chance3 = 70 -- Chance to notify cops at 10+ Minutes
Config.Locations = {
    Heistboard = { -- begins everything
        {900.01, -960.33, 39.28},  -- Real Heistboard
        --{3618.74, 3773.78, 28.56}, -- HL Heistboard
        --{2155.32, 4783.42, 40.99}, -- Grapeseed Heistboard
        --{484.64, -3121.3, 6.07}, -- Docks Heistboard
        --{358.43, -593.14, 28.79}, -- PB Heistboard
        --{1407.35, 3613.17, 39.00}, -- Ace Liquor Heistboard
    },
    HumaneLabsLocations = {
        HLCenter = {3567.78, 3701.31, 27.12}, -- Center of Humane Labs for the Alarm/Trigger radius
        Garage1 = {3625.78, 3743.96, 28.69},
        Garage2 = {3618.82, 3748.81, 28.69},
        ElevatorIn = {3540.69, 3675.32, 20.99, 170.00},
        ElevatorOut = {3540.69, 3675.32, 28.12, 170.00},
        VanSpawn = {3618.83, 3734.03, 28.59, 324.97},
        VanEndLocation = {875.55, -940.77, 25.35}, -- ACTUAL VAN END
        --VanEndLocation = {3596.22, 3759.7, 29.00},
        KeySpawns = {
            {3611.58, 3715.65, 29.69},
            {3588.69, 3717.45, 29.69},
            {3586.54, 3680.51, 27.62},
            {3560.07, 3673.41, 28.12},
            {3538.06, 3658.57, 28.12},
        },
    },
    redPhosphorusLocations = {
        KeyLoc = {2151.10, 4775.28, 41.11},
        PlaneSpawn = {2134.77, 4781.22, 40.97, 24.05},
        PlaneRefill = {2102.77, 4785.87, 40.245},
        --PlaneEnd = {},
        PlaneEnd = {1516.16, -2100.98, 75.88}, -- ACTUAL PLANE END
        AirfieldCenter = {2038.63, 4764.24, 41.06},
    },
    
    PillboxLocations = {
        RestrictedArea = {344.28, -591.2, 43.28}, -- This is where an alarm will be triggered, close to where the item theft will take place
        TheftLocation = {344.7, -592.67, 43.28}, -- Marker for item theft
        PBCenter = {344.28, -591.2, 43.28}, -- Center of Pillbox Medical for the Alarm/Trigger radius
    },

    ChemLocations = {
        RestrictedArea = {1392.31, 3612.17, 34.98}, -- This is where an alarm will be triggered, close to where the item theft will take place
        RestrictedArea2 = {1397.44, 3607.53, 38.94}, -- This is where an alarm will be triggered, close to where the item theft will take place
        RestrictedArea3 = {1388.62, 3612.89, 38.94}, -- This is where an alarm will be triggered, close to where the item theft will take place
        TheftLocation = {1391.75, 3605.99, 38.94}, -- Marker for item theft
        ChemCenter = {1392, 3608.43, 34.94}, -- Center of Ace Liquor for the Alarm/Trigger radius
    },

    GasLocations = {
        DocksCenter = {525.52, -3204.18, 8.41},
        KeyLocation = {483.79, -3110.28, 6.33},
        BoatSpawn = {517.83, -3133.46, 1.07, 190.22},
        BoatDelivery = {668.34, -1519.11, 8.71},
        BikeSpawn = {691.15, -1553.74, 9.71},
        BikeDelivery = {875.55, -940.77, 25.28}, --
    },

    CookLocations = {
        Workshop = {110.09, 6627.37, 30.80},
    },

    LyeShop = {
        {-374.77, 6031.68, 31.56, 134.43},
    },

    SalesLocations = {
        {-396.76, 6076.93, 31.5},
        {-252.15, 6235.03, 31.49},
        {-167.1, 6312.5, 31.68},
        {-102.21, 6345.18, 35.5},
        {-65.71, 6506.41, 31.54},
        {1719.13, 4677.25, 43.66},
        {1725.53, 4642.49, 43.88},
        {1673.11, 4958.07, 47.43},
        {2016.95, 4987.86, 42.1},
        {2159.06, 4782.13, 41.96},
        {3310.68, 5176.44, 19.61},
        {3688.32, 4562.9, 25.18},
        {3725.37, 4525.69, 22.47},
        {2461.23, 1575.44, 33.11},
        {2352.44, 2523.42, 47.69},
        {2359.55, 2541.9, 47.7},
        {2362.95, 2556.5, 47.29},
        {2337.73, 2605.33, 47.3},
        {2632.26, 3257.87, 55.46},
        {2618.53, 3275.21, 55.74},
        {2634.3, 3292.1, 55.73},
        {2639.6, 4246.05, 44.74},
        {1932.88, 3804.9, 32.91},
        {1899.97, 3773.38, 32.88},
        {1748.88, 3783.58, 34.83},
        {1436.17, 3639.01, 34.95},
        {101.08, 3652.64, 40.64},
        {97.84, 3682.1, 39.74},
        {78.11, 3732.57, 40.27},
        {47.82, 3701.97, 40.72},
        {-2587.75, 1910.92, 167.5},
        {-3194.09, 1229.65, 10.05},
        {-3200.35, 1165.53, 9.65},
        {-3016.03, 746.63, 27.78},
        {-2972.59, 642.51, 25.99},
        {-3037.04, 544.92, 7.51},
        {-3039.62, 492.84, 6.77},
        {-1896.25, 642.58, 130.21},
        {-1922.76, 298.29, 89.29},
        {-931.41, 690.31, 153.47},
        {-1374.21, -916.78, 10.35},
        {-1258.44, -1134.7, 7.73},
        {-1132.86, -1456.26, 4.87},
        {-1125.66, -1544.1, 5.37},
        {-1084.48, -1559.15, 4.78},
        {118.46, -1921.07, 21.32},
        {115.4, -1887.91, 23.93},
        {150.04, -1864.67, 24.59},
        {269.27, -1985.15, 20.08},
        {335.98, -2021.76, 22.35},
        {371.23, -2057.41, 21.74},
        {368.65, -1895.7, 25.18},
        {1289.2, -1710.67, 55.48},
        {1307.52, -1753.8, 53.88},
        {1314.34, -1733.09, 54.7},
        {1411.85, -1490.43, 60.66},
        {1401.84, -1490.4, 59.78},
        {-336.15, 30.99, 47.86},
        {-564.5, 94.35, 61.37},
        {-896.66, -5.2, 43.8},
        {1463.11, -381.49, 38.87},
    }
}