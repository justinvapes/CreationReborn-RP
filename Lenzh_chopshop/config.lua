Config = {} -- DON'T TOUCH

Config.DrawDistance       = 100.0 -- Change the distance before you can see the marker. Less is better performance.
Config.EnableBlips        = true -- Set to false to disable blips.
Config.MarkerType         = 27    -- Change to -1 to disable marker.
Config.MarkerColor        = { r = 255, g = 0, b = 0 } -- Change the marker color.

Config.Locale             = 'en' -- Change the language. Currently available (en or fr).
Config.CooldownMinutes    = 30 -- Minutes between chopping.

Config.CallCops           = true -- Set to true if you want cops to be alerted when chopping is in progress
Config.CallCopsPercent    = 2 -- (min1) if 1 then cops will be called every time=100%, 2=50%, 3=33%, 4=25%, 5=20%.
Config.CopsRequired       = 1


Config.DoorOpenFrontLeftTime      = 1000
Config.DoorBrokenFrontLeftTime    = 5000
Config.DoorOpenFrontRightTime     = 1000
Config.DoorBrokenFrontRightTime   = 5000
Config.DoorOpenRearLeftTime       = 1000
Config.DoorBrokenRearLeftTime     = 5000
Config.DoorOpenRearRightTime      = 1000
Config.DoorBrokenRearRightTime    = 5000
Config.DoorOpenHoodTime           = 1000
Config.DoorBrokenHoodTime         = 5000
Config.DoorOpenTrunkTime          = 1000
Config.DoorBrokenTrunkTime        = 5000
Config.DeletingVehicleTime        = 5000

Config.Zones = {
    Chopshop = {coords = vector3(-522.87, -1713.99, 18.33), name = _U('map_blip'), color = 49, sprite = 225, radius = 100.0, Pos = { x = -522.87, y = -1713.99, z = 18.33}, Size  = { x = 5.0, y = 5.0, z = 0.5 }, },
}

Config.Items = {
    "battery",
    "lowradio",
    "stockrim",
    "airbag",
    "highradio",
    "highrim"
}