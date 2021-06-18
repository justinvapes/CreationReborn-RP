Config                            = {}
Config.DrawDistance               = 100.0
Config.Marker                     = { type = 27, x = 1.5, y = 1.5, z = 0.5, r = 255, g = 0, b = 0, a = 100, rotate = false }
Config.MarkerColor                = { r = 255, g = 0, b = 0 }
Config.ReviveReward               = 1000  
Config.AntiCombatLog              = true 
Config.LoadIpl                    = false 
Config.Locale                     = 'en'
Config.EnableESXService           = true
Config.MaxInService               = 10

local second = 1000
local minute = 60 * second

--EMS On Duty
Config.EarlyRespawnTimerOnDuty       = 10 * minute  
Config.BleedoutTimerOnDuty           = 5 * minute 

--EMS Not On Duty
Config.EarlyRespawnTimerNotOnDuty    = 5  * minute
Config.BleedoutTimerNotOnDuty        = 5  * minute 

Config.EnablePlayerManagement     = true
Config.EnableESXIdentity          = true
Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true
Config.EarlyRespawnFine           = true
Config.EarlyRespawnFineAmount     = 1500

Config.RespawnPoint  = {coords = vector3(299.91, -576.35, 42.27), heading = 77.55}
Config.JailBlip      = {x = 299.91, y = -576.35, z = 42.27}

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(299.18, -584.65, 28.9),
			sprite = 61,
			scale  = 1.2,
			color  = 2
		},

		AmbulanceActions = {
			vector3(301.50, -599.25, 42.30)
		},
		
		VehicleDeleter = {
			vector3(333.86, -574.41, 27.8),
			vector3(351.79, -588.28, 73.16)
			
		},
		
		-- VehicleDeleter = {
		-- 	vector3(287.34, -599.44, 42.20)
			
		-- },

		Helicopters = {
			{
				Spawner = vector3(338.41, -586.86, 74.16),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
			}
		},
		

		FastTravels = {
			{
				From = vector3(331.47, -595.50, 42.30),
				To = { coords = vector3(340.95, -584.68, 73.18), heading = 251.60 },--helicoptor up
				Marker = { type = 27, x = 1.5, y = 1.5, z = 0.5, r = 255, g = 0, b = 0, a = 100, rotate = false }
			},

			{
				From = vector3(339.19, -583.98, 73.18),
				To = { coords = vector3(329.54, -600.92, 42.30), heading = 73.28 },--helicoptor down
				Marker = { type = 27, x = 1.5, y = 1.5, z = 0.5, r = 255, g = 0, b = 0, a = 100, rotate = false }
			},

			{
				From = vector3(234.5, -1373.7, 20.9),
				To = { coords = vector3(320.9, -1478.6, 28.8), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(237.4, -1373.8, 26.0),
				To = { coords = vector3(251.9, -1363.3, 38.5), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			},

			{
				From = vector3(256.5, -1357.7, 36.0),
				To = { coords = vector3(235.4, -1372.8, 26.3), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			}
		}
	}
}


Config.Zones = {

	VehicleSpawnPoint = { --Where the vehicle spawns
	  Pos  = { x = 326.61, y = -572.08, z = 28.8 },
	  Size = { x = 1.5, y = 1.5, z = 1.0 },
	  Type = -1
	},

--   VehicleSpawnPoint = { --Where the vehicle spawns
--     Pos  = { x = 290.42, y = -612.94, z = 42.43 },
--     Size = { x = 1.5, y = 1.5, z = 1.0 },
--     Type = -1
--   },
 
   HelicoptorSpawnPoint = { --Where the helicoptor spawns
    Pos  = { x = 352.16, y = -588.19, z = 73.18  },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },
  
}

Config.Uniforms = {

 StudentUniform = {
    male = {		
		['tshirt_1']  = 15,  ['tshirt_2']  = 0,
		['torso_1']   = 246, ['torso_2']   = 0,
		['arms']      = 85,
		['pants_1']   = 95,  ['pants_2']   = 0,
		['shoes_1']   = 51,  ['shoes_2']   = 0,
		['mask_1']    = 0,   ['mask_2']    = 0,
		['helmet_1']  = -1,   ['helmet_2']  = 1,
		['bproof_1']  = 0,   ['bproof_2']  = 0,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    },
    female = {
        ['tshirt_1']  = 15,  ['tshirt_2']  = 0,
		['torso_1']   = 254, ['torso_2']   = 0,
		['arms']      = 109,
		['pants_1']   = 98,  ['pants_2']   = 0,
		['shoes_1']   = 52,  ['shoes_2']   = 0,
		['mask_1']    = 0,   ['mask_2']    = 0,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 0,   ['bproof_2']  = 0,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    }
  },
  
  ParamdeicUniform = {
    male = {		
		['tshirt_1']  = 15,  ['tshirt_2']  = 0,
		['torso_1']   = 246, ['torso_2']   = 1,
		['arms']      = 85,
		['pants_1']   = 95,  ['pants_2']   = 1,
		['shoes_1']   = 51,  ['shoes_2']   = 0,
		['mask_1']    = 0,   ['mask_2']    = 0,
		['helmet_1']  = -1, ['helmet_2']  = 0,
		['bproof_1']  = 0,   ['bproof_2']  = 0,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    },
    female = {
        ['tshirt_1']  = 15,  ['tshirt_2']  = 0,
		['torso_1']   = 254, ['torso_2']   = 1,
		['arms']      = 109,
		['pants_1']   = 98,  ['pants_2']   = 1,
		['shoes_1']   = 52,  ['shoes_2']   = 0,
		['mask_1']    = 0,   ['mask_2']    = 0,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 0,   ['bproof_2']  = 0,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    }
  },
  
  SuperviserUniform = {
    male = {		
		['tshirt_1']  = 15,  ['tshirt_2']  = 0,
		['torso_1']   = 246, ['torso_2']   = 2,
		['arms']      = 85,
		['pants_1']   = 95,  ['pants_2']   = 1,
		['shoes_1']   = 51,  ['shoes_2']   = 0,
		['mask_1']    = 0,   ['mask_2']    = 0,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 0,   ['bproof_2']  = 0,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    },
    female = {
        ['tshirt_1']  = 15,  ['tshirt_2']  = 0,
		['torso_1']   = 254, ['torso_2']   = 2,
		['arms']      = 109,
		['pants_1']   = 98,  ['pants_2']   = 1,
		['shoes_1']   = 52,  ['shoes_2']   = 0,
		['mask_1']    = 0,   ['mask_2']    = 0,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 0,   ['bproof_2']  = 0,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    }
  },
  
   ManagerUniform = {
    male = {		
		['tshirt_1']  = 15,  ['tshirt_2']  = 0,
		['torso_1']   = 246, ['torso_2']   = 7,
		['arms']      = 85,
		['pants_1']   = 95,  ['pants_2']   = 1,
		['shoes_1']   = 51,  ['shoes_2']   = 0,
		['mask_1']    = 0,   ['mask_2']    = 0,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 0,   ['bproof_2']  = 0,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    },
    female = {
        ['tshirt_1']  = 15,  ['tshirt_2']  = 0,
		['torso_1']   = 254, ['torso_2']   = 7,
		['arms']      = 109,
		['pants_1']   = 98,  ['pants_2']   = 1,
		['shoes_1']   = 52,  ['shoes_2']   = 0,
		['mask_1']    = 0,   ['mask_2']    = 0,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 0,   ['bproof_2']  = 0,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    }
  },
}