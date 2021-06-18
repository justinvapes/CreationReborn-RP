Config                            = {}
Config.DrawDistance               = 10
Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.NPCSpawnDistance           = 500.0
Config.NPCNextToDistance          = 25.0
Config.NPCJobEarnings             = { min = 15, max = 40 }
Config.Locale                     = 'en'

Config.EngineOil  = 200 
Config.OilFilter  = 150
Config.RebuilKit  = 10000
Config.Engineer   = 50000

Config.Zones = {
  MecanoActions = {
    Pos   = { x = -341.52, y = -161.61, z = 44.59 },
    Size  = { x = 0.301, y = 0.301, z = 0.3001 },
    Color = { r = 255, g = 0, b = 0 },
    Type  = 21,
  },

  VehicleSpawnPoint = {
    Pos   = { x = -371.19, y = -107.64, z = 37.69 }, -- Mechanic/boss Options
    Size  = { x = 1.5, y = 1.5, z = 1.0 },
    Type  = -1,
  },

  VehicleDeleter = {
    Pos   = { x = -381.69, y = -110.76, z =37.71 },
    Size  = { x = 3.5, y = 3.5, z = 1.0 },
    Color = { r = 255, g = 0, b = 0 },
    Type  = 27,
  },

  VehicleDelivery = {
    Pos   = { x = -382.925, y = -133.748, z = 37.685 },
    Size  = { x = 20.0, y = 20.0, z = 3.0 },
    Color = { r = 204, g = 204, b = 0 },
    Type  = -1,
  },
}


Config.Uniforms = {
 
  workuniform = {
     male = {		
		['tshirt_1'] = 59,  ['tshirt_2'] = 1,
		['torso_1']  = 273, ['torso_2']  = 1,
		['arms']     = 30,
		['pants_1']  = 9,   ['pants_2']  = 7,
		['shoes_1']  = 71,  ['shoes_2']  = 1,
		['mask_1']   = 0,   ['mask_2']   = 0,
		['helmet_1'] = -1,   ['helmet_2'] = 0,
		['bproof_1'] = 0,   ['bproof_2'] = 0
    },
    female = {
        ['tshirt_1'] = 36,  ['tshirt_2'] = 1,
		['torso_1']  = 49,  ['torso_2']  = 1,
		['arms']     = 44,
		['pants_1']  = 109, ['pants_2']  = 0,
		['shoes_1']  = 25,  ['shoes_2']  = 0,
		['mask_1']   = 0,   ['mask_2']   = 0,
		['helmet_1'] = -1,   ['helmet_2'] = 0,
		['bproof_1'] = 0,   ['bproof_2'] = 0
    }
  },
}