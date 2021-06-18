Config = {
    IndependentGarage = false, -- if you store a vehicle in garage A, you can not take it out from garage B.
    ShowJobVehicles = false, -- show job vehicles such as police cars
    Damages = false, -- save & load damages when storing / retrieving a car?
    Use3DText = true, -- use 3d text?
    ImpoundPrice = 2500, -- price to retrieve a vehicle from the impound
    AllowMultiple = false, -- allow people to take out vehicles from the impound if it is already out?
    DefaultJob = "", -- this is the job for cars which are not for jobs. For some servers, this should be just "" and for others "civ"
    DefaultType = "car", -- if type is not defined for the garage, it will chec kif the "type" in owned_vehicles is DefaultType

    Impounding = {
        AllowJobsToImpound = true, -- allow specific jobs to impound vehicles?
        Command = "impound", -- command for impounding, or false for disabled
        AllowedJobs = { -- the specific jobs allowed to impound vehicles, if AllowJobsToImpound is enabled
            "police",
        },
    },

    Interior = {
        Enabled = false, -- should you browse vehicles at the interior or at the garage location?
        Coords = vector4(228.8, -986.97, -99.96, 180.0) -- vector4(x, y, z, heading) location of the interior.
    },
    
    Garages = {
        --[[
            garage_name = coords = vector4(x, y, z, heading) -- garage location
        ]]
        -- square = {
        --     location = vector4(232.2, -792.48, 29.61, 160.0),
        --     vehicletype = "car",
        -- },
        -- airport = 
        -- {
        --     location = vector4(-742.92, -2473.92, 13.45, 330.0),
        --     vehicletype = "car",
        -- },
        -- motel = {
        --     location = vector4(288.39, -339.62, 43.94, 160.0),
        --     vehicletype = "car",
        -- },
        -- sandy = {
        --     location = vector4(1419.45, 3619.47, 33.92, 200.0),
        --     vehicletype = "car",
        -- },
        -- paleto = {
        --     location = vector4(127.48, 6608.51, 30.87, 230.0),
        --     vehicletype = "car",
        -- },
        -- highway = {
        --     location = vector4(-2358.76, 4086.07, 31.57, 150.0),
        --     vehicletype = "car",
        -- },
        -- hangar = {
        --     location = vector4(-1274.35, -3381.59, 13.0, 331.31),
        --     vehicletype = "airplane",
        -- },
        -- haven = {
        --     browse = vector3(-987.9, -1391.31, 0.6),
        --     spawn = vector4(-991.95, -1380.99, 0.0, 290.0),
        --     vehicletype = "boat"
        -- }
    },

    Impounds = {
        -- {
        --     Retrieve = vector3(483.73, -1312.26, 28.23), -- where you open the menu to retrieve the car
        --     Spawn = vector4(490.99, -1313.66, 28.83, 285.99), -- where the car spawns
        --     vehicletype = "car",
        -- },
        -- {
        --     Retrieve = vector3(-1615.52, -3137.48, 13.00), -- where you open the menu to retrieve the plane
        --     Spawn = vector4(-1654.096, -3146.48, 13.57, 329.89), -- where the plane spawns
        --     vehicletype = "airplane",
        -- },
        -- {
        --     Retrieve = vector3(-944.03, -1375.26, 0.6), -- where you open the menu to retrieve the plane
        --     Spawn = vector4(-947.69, -1365.79, 0.0, 290.0), -- where the plane spawns
        --     vehicletype = "boat",
        -- },
    }
}