Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 255, g = 0, b = 0 }
Config.EnablePlayerManagement     = false -- If set to true, you need esx_addonaccount, esx_billing and esx_society
Config.EnablePaCommand            = false
Config.EnableOwnedVehicles        = true
Config.EnableSocietyOwnedVehicles = false
Config.ResellPercentage           = 50
Config.Locale                     = 'en'

Config.Zones = {

  ShopEntering = { -- Marker for accessing shop DONE
    Pos   = { x = -1242.92, y = -3392.56, z = 12.96 },
    Size  = { x = 1.5, y = 1.5, z = 1.0 },
    Type  = 27,
  },

  ShopInside = { -- Marker for viewing Vehicles DONE (old x = -965.35, y = -3030.07, z = 14.55 )
    Pos     = { x = -1264.51, y = -3386.98, z = 12.96 },
    Size    = { x = 1.5, y = 1.5, z = 1.0 },
     Heading = 330.0,
    Type    = -1,
  },

  ShopOutside = { -- Marker after purchasing vehicle DONE
    Pos     = { x = -1264.51, y = -3386.98, z = 12.96 },
    Size    = { x = 1.5, y = 1.5, z = 1.0 },
    Heading = 330.0,
    Type    = -1,
  },

  BossActions = { -- Boss Actions DONE
    Pos   = { x = -924.57, y = -2966.45, z = 18.85 },
    Size  = { x = 1.5, y = 1.5, z = 1.0 },
    Type  = -1,
  },

  GiveBackVehicle = { -- Marker for Player Management DONE (old x = -967.13, y = -2939.9, z = 14.55)
    Pos   = { x = -1040.79, y = -2991.23, z = 14.55 },
    Size  = { x = 3.0, y = 3.0, z = 1.0 },
    Type  = (Config.EnablePlayerManagement and 1 or -1),
  },

}
