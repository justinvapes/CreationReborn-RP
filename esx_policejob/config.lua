Config                            = {}

Config.DrawDistance               = 10.0
Config.MarkerType                 = 1
Config.MarkerSize                 = {x = 1.5, y = 1.5, z = 0.5}
Config.MarkerColor                = {r = 50, g = 50, b = 204}

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = false
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableLicenses             = false -- enable if you're using esx_license
Config.EnableESXService           = true 
Config.RemoveWeaponsWhenOffDuuty  = true -- Set true to remove player weapons when going off duty
Config.MaxInService               = 14
Config.Locale                     = 'en'

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(425.1, -979.5, 30.7),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.2,
			Colour  = 4
		},

		Cloakrooms = {
			vector3(458.28, -998.93, 30.69)
		},

		Armories = {
			vector3(482.63, -995.94, 30.69)
		},
		
		VehicleDeleter = {
		
		    vector3(462.60, -1019.62, 28.11),
		    vector3(462.55, -1014.75, 28.07),	
        },

		Vehicles = {
			{
				Spawner = vector3(445.72, -1015.85, 28.59),
				InsideShop = vector3(453.90, -1025.12, 27.32),
				SpawnPoints = {
					{coords = vector3(438.4, -1018.3, 27.7), heading = 90.0, radius = 6.0}
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(461.1, -981.5, 43.6),
				InsideShop = vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
					{coords = vector3(449.5, -981.2, 43.6), heading = 92.6, radius = 10.0}
				}
			}
		},

		Impounds = {
			{
				Spawner = vector3(437.89, -1015.75, 28.73),
				InsideShop = vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
					{coords = vector3(449.5, -981.2, 43.6), heading = 92.6, radius = 10.0}
				}
			}
		},

		BossActions = {
			vector3(463.26, -985.34, 30.73)
		}

	},

	SANDY = {

		Blip = {
			Coords  = vector3(1853.81, 3685.82, 34.26),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.2,
			Colour  = 4
		},

		Cloakrooms = {
			vector3(1849.95, 3695.7, 34.26)
		},

		Armories = {
			vector3(1845.98, 3692.74, 34.26)
		},
		
		VehicleDeleter = {
		
		    vector3(1868.76, 3693.36, 33.64),
        },

		Vehicles = {
			{
				Spawner = vector3(1853.73, 3680.91, 34.27),
				InsideShop = vector3(1848.32, 3670.46, 33.69),
				SpawnPoints = {
					{coords = vector3(1866.11, 3678.19, 33.6), heading = 300.0, radius = 6.0}
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(1855.92, 3706.18, 34.27),
				InsideShop = vector3(1851.24, 3713.00, 33.18),
				SpawnPoints = {
					{coords = vector3(1851.24, 3713.00, 33.18), heading = 295, radius = 1.0}
				}
			}
		},

		Impounds = {
			{
				Spawner = vector3(1851.03, 3679.44, 34.27),
				InsideShop = vector3(1848.32, 3670.46, 33.69),
				SpawnPoints = {
					{coords = vector3(1866.11, 3678.19, 33.6), heading = 300.0, radius = 6.0}
				}
			}
		},

		BossActions = {
			vector3(1862.63, 3690.33, 34.26)
		}

	},

	PALETO = {

		Blip = {
			Coords  = vector3(-447.78, 6008.97, 31.72),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.2,
			Colour  = 4
		},

		Cloakrooms = {
			vector3(-447.78, 6008.97, 31.72)
		},

		Armories = {
			vector3(-449.82, 6016.31, 31.72)
		},
		
		VehicleDeleter = {
		
		    vector3(-482.55, 6024.64, 31.63),
        },

		Vehicles = {
			{
				Spawner = vector3(-459.08, 6031.92, 31.34),
				InsideShop = vector3(-460.29, 6042.79, 31.34),
				SpawnPoints = {
					{coords = vector3(-442.57, 6036.79, 31.34), heading = 300.0, radius = 6.0}
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(-464.74, 5999.85, 31.24),
				InsideShop = vector3(-472.83, 5972.84, 31.31),
				SpawnPoints = {
					{coords = vector3(-475.46, 5988.65, 31.34), heading = 227.67, radius = 3.0}
				}
			}
		},

		Impounds = {
			{
				Spawner = vector3(-457.3, 6030.11, 31.34),
				InsideShop = vector3(-460.29, 6042.79, 31.34),
				SpawnPoints = {
					{coords = vector3(-442.57, 6036.79, 31.34), heading = 300.0, radius = 6.0}
				}
			}
		},

		BossActions = {
			vector3(-449.68, 6011.45, 31.72)
		}

	}
}

Config.Zones = { 
   HelicoptorSpawnPoint = { 
    Pos  = { x = 449.5, y = -981.2, z = 43.6  },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },  
}

Config.AuthorizedWeapons = {

	Probationary  = {
	
	    {weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
	},
	Constable  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
	},
	SnrConstable  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
	},
	LSConstable  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
	},
	LSCHighwayI  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
	},
	LSCSOGI  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_ADVANCEDRIFLE', components = {0, 99, 49, 199, 299, nil}, price = 0}
	},
	LSCDetectiveI  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0}
	},
	Sergeant  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0}
	},
	SnrSgtHighwayII  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0}
	},
	SnrSgtSOGII  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_ADVANCEDRIFLE', components = {0, 99, 49, 199, 299, nil}, price = 0},
		{weapon = 'WEAPON_BULLPUPSHOTGUN', components = {49, 299, 99, nil}, price = 0},
	},
	SSDetectiveII  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0}
	},
	Inspector  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0}
	},
	InspHighwayII  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0}
	},
	InspSOGII  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_ADVANCEDRIFLE', components = {0, 99, 49, 199, 299, nil}, price = 0},
		{weapon = 'WEAPON_BULLPUPSHOTGUN', components = {49, 299, 99, nil}, price = 0},
	},
	InspDetectiveII  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0}
	},
	Superintendent  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0}
	},
	SuptHighwayIII  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0}
	},
	SuptSOGIII  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_ADVANCEDRIFLE', components = {0, 99, 49, 199, 299, nil}, price = 0},
		{weapon = 'WEAPON_BULLPUPSHOTGUN', components = {49, 299, 99, nil}, price = 0},
		{weapon = 'WEAPON_HEAVYSNIPER', components = {4000, 8000, nil}, price = 0}
	},
	SuptDetectiveIII  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0}
	},
	Commander  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0}
	},
	ComHighwayIII  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0}
	},
	ComSOGIII  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_ADVANCEDRIFLE', components = {0, 99, 49, 199, 299, nil}, price = 0},
		{weapon = 'WEAPON_BULLPUPSHOTGUN', components = {49, 299, 99, nil}, price = 0},
		{weapon = 'WEAPON_HEAVYSNIPER', components = {4000, 8000, nil}, price = 0}
	},
	ComDetectiveIII  = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0}
	},
	boss = {
		{weapon = 'WEAPON_FLARE', price = 0},
		{weapon = 'WEAPON_FLAREGUN', price = 0},		
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 49, 299, nil}, price = 0},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {49, 299, nil}, price = 0},
		{weapon = 'WEAPON_ADVANCEDRIFLE', components = {0, 99, 49, 199, 299, nil}, price = 0},
		{weapon = 'WEAPON_BULLPUPSHOTGUN', components = {49, 299, 99, nil}, price = 0},
		{weapon = 'WEAPON_HEAVYSNIPER', components = {4000, 8000, nil}, price = 0}
	}
}

Config.AuthorizedVehicles = {
	car = {
		Probationary = {},

		Constable = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'}
		},
		SnrConstable = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
		},
		LSConstable = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},
		LSCHighwayI = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'MarkedXr6Turbo'},
			{model = 'MarkedVFSS'},
			{model = 'polbf400'},	
			{model = 'r1200rtp'},		
		},
		LSCSOGI = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'agnriot'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},
		LSCDetectiveI = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'UnmarkedTerritory'},
			{model = 'polbf400'},	
			{model = 'r1200rtp'},		
		},
		Sergeant = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},
		SnrSgtHighwayII = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'MarkedXr6Turbo'},
			{model = 'MarkedVFSS'},			
			{model = 'MarkedRaptor'},
			{model = 'police351'},
			{model = 'upolice351'},
			{model = 'polbf400'},	
			{model = 'r1200rtp'},	
		},
		SnrSgtSOGII = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'SOGTerritory'},
			{model = 'agnriot'},
			{model = 'UnmarkedTerritory'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},
		SSDetectiveII = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'UnmarkedTerritory'},
			{model = 'upolice351'},
			{model = 'polbf400'},		
			{model = 'r1200rtp'},	
		},
		Inspector = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},
		InspHighwayII = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'MarkedXr6Turbo'},
			{model = 'MarkedVFSS'},			
			{model = 'MarkedRaptor'},
			{model = 'police351'},
			{model = 'upolice351'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},
		InspSOGII = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'SOGTerritory'},
			{model = 'agnriot'},
			{model = 'UnmarkedTerritory'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},
		InspDetectiveII = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
            {model = 'UnmarkedTerritory'},
			{model = 'upolice351'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},
		Superintendent = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},
		SuptHighwayIII = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'MarkedXr6Turbo'},
			{model = 'MarkedVFSS'},			
			{model = 'MarkedRaptor'},
			{model = 'police351'},
			{model = 'upolice351'},
			{model = '2015polstang'},
			{model = 'policeVF'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
			--{model = 'upoliceVF'}		
		},
		SuptSOGIII = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'SOGTerritory'},
			{model = 'agnriot'},
			{model = 'UnmarkedTerritory'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
			--{model = 'upolice351'},
			--{model = 'upoliceVF'}
		},
		SuptDetectiveIII = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
            {model = 'UnmarkedTerritory'},
			{model = 'upoliceVF'},
			{model = 'upolice351'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},
		Commander = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},
		ComHighwayIII = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'MarkedXr6Turbo'},
			{model = 'MarkedVFSS'},			
			{model = 'MarkedRaptor'},
			{model = 'police351'},
			{model = 'upolice351'},
			{model = '2015polstang'},
			{model = 'policeVF'},
			{model = 'upoliceVF'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},
		ComSOGIII = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
			{model = 'agnriot'},
			{model = 'UnmarkedTerritory'},
			{model = 'SOGTerritory'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
			--{model = 'upolice351'},
			--{model = 'upoliceVF'}
		},	
		ComDetectiveIII = {
			{model = 'MVFEvoke'},
			{model = 'MarkedHilux'},
			{model = 'MarkedTerritory'},
            {model = 'UnmarkedTerritory'},
			{model = 'upoliceVF'},
			{model = 'upolice351'},
			{model = 'polbf400'},
			{model = 'r1200rtp'},
		},

		boss = {
		   {model = 'MVFEvoke'},
		   {model = 'MarkedHilux'},
		   {model = 'MarkedTerritory'},
		   {model = 'MarkedXr6Turbo'},
		   {model = 'MarkedVFSS'},			
		   {model = 'MarkedRaptor'},
		   {model = 'police351'},
		   {model = 'upolice351'},
		   {model = '2015polstang'},
		   {model = 'policeVF'},
		   {model = 'upoliceVF'},	
		   {model = 'SOGTerritory'},
		   {model = 'agnriot'},
           {model = 'UnmarkedTerritory'},
		   {model = 'polbf400'},
		   {model = 'r1200rtp'},
		}
	},
}


Config.Uniforms = {

 GDUniform = {
    male = {		
		['tshirt_1']  = 122, ['tshirt_2']  = 0,
		['torso_1']   = 190, ['torso_2']   = 0,
		['arms']      = 0,
		['pants_1']   = 96,  ['pants_2']   = 0,
		['shoes_1']   = 12,  ['shoes_2']   = 6,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 27,  ['bproof_2']  = 0,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    },
    female = {
        ['tshirt_1']  = 152, ['tshirt_2']  = 0,
		['torso_1']   = 192, ['torso_2']   = 0,
		['arms']      = 14,
		['pants_1']   = 99,  ['pants_2']   = 0,
		['shoes_1']   = 52,  ['shoes_2']   = 0,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 29,  ['bproof_2']  = 0,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    }
  },
  
  GDUniformL = {
    male = {		
		['tshirt_1']  = 122, ['tshirt_2']  = 0,
		['torso_1']   = 193, ['torso_2']   = 0,
		['arms']      = 4,
		['pants_1']   = 96,  ['pants_2']   = 0,
		['shoes_1']   = 12,  ['shoes_2']   = 6,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 27,  ['bproof_2']  = 0,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    },
    female = {
        ['tshirt_1']  = 152, ['tshirt_2']  = 0,
		['torso_1']   = 195, ['torso_2']   = 0,
		['arms']      = 7,
		['pants_1']   = 99,  ['pants_2']   = 0,
		['shoes_1']   = 52,  ['shoes_2']   = 0,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 29,  ['bproof_2']  = 0,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    }
  },
  
  HWYuniform = {
    male = {		
		['tshirt_1']  = 122, ['tshirt_2'] = 0,
		['torso_1']   = 190, ['torso_2']  = 0,
		['arms']      = 0,
		['pants_1']   = 96,  ['pants_2']   = 0,
		['shoes_1']   = 12,  ['shoes_2']   = 6,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 27,  ['bproof_2']  = 1,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    },
    female = {
        ['tshirt_1']  = 152, ['tshirt_2']  = 0,
		['torso_1']   = 192, ['torso_2']   = 0,
		['arms']      = 14,
		['pants_1']   = 99,  ['pants_2']   = 0,
		['shoes_1']   = 52,  ['shoes_2']   = 0,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 29,  ['bproof_2']  = 1,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    }
  },
  
  HWYuniformL = {
    male = {		
		['tshirt_1']  = 122, ['tshirt_2'] = 0,
		['torso_1']   = 193, ['torso_2']  = 0,
		['arms']      = 4,
		['pants_1']   = 96,  ['pants_2']   = 0,
		['shoes_1']   = 12,  ['shoes_2']   = 6,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 27,  ['bproof_2']  = 1,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    },
    female = {
        ['tshirt_1']  = 152, ['tshirt_2']  = 0,
		['torso_1']   = 195, ['torso_2']   = 0,
		['arms']      = 7,
		['pants_1']   = 99,  ['pants_2']   = 0,
		['shoes_1']   = 52,  ['shoes_2']   = 0,
		['mask_1']    = 0,   ['mask_2']    = 0,
		['helmet_1']  = -1,  ['helmet_2']  = 0,
		['bproof_1']  = 29,  ['bproof_2']  = 1,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    }
  },
  
  SOGuniform = {
    male = {		
		['tshirt_1']  = 122, ['tshirt_2']  = 0,
		['torso_1']   = 219,  ['torso_2']  = 20,
		['arms']      = 35,
		['pants_1']   = 34,  ['pants_2']   = 0,
		['shoes_1']   = 12,  ['shoes_2']   = 6,
		['mask_1']    = 52,  ['mask_2']    = 0,
		['helmet_1']  = 39,  ['helmet_2']  = 0,
		['bproof_1']  = 27,  ['bproof_2']  = 2,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    },
    female = {
        ['tshirt_1']  = 152, ['tshirt_2']  = 0,
		['torso_1']   = 223, ['torso_2']   = 20,
		['arms']      = 36,
		['pants_1']   = 33,  ['pants_2']   = 0,
		['shoes_1']   = 55,  ['shoes_2']   = 0,
		['mask_1']    = 35,  ['mask_2']    = 0,
		['helmet_1']  = 38,  ['helmet_2']  = 0,
		['bproof_1']  = 29,  ['bproof_2']  = 2,
		['bags_1']    = 0,   ['bags_2']    = 0,
		['watches_1'] = -1,  ['watches_2'] = 0,
		['chain_1']   = 0,   ['chain_2']   = 0
    }
  }, 
  
  DETuniform = {
     male = {		
    },
    female = {
    }
  },
}

Config.PistolList = { 
   'WEAPON_PISTOL',
   'WEAPON_PISTOL_MK2',
   'WEAPON_COMBATPISTOL',
   'WEAPON_APPISTOL',
   'WEAPON_PISTOL50',
   'WEAPON_SNSPISTOL', 
   'WEAPON_SNSPISTOL_MK2',   
   'WEAPON_HEAVYPISTOL', 
   'WEAPON_VINTAGEPISTOL', 
   'WEAPON_FLAREGUN', 
   'WEAPON_MARKSMANPISTOL',
   'WEAPON_REVOLVER', 
   'WEAPON_REVOLVER_MK2', 
   'WEAPON_DOUBLEACTION', 
   'WEAPON_RAYPISTOL',  
   'WEAPON_CERAMICPISTOL',
   'WEAPON_NAVYREVOLVER',   
   'WEAPON_STUNGUN',   
   'WEAPON_FLAREGUN',
}
Config.SmgList = { 
   'WEAPON_MICROSMG',
   'WEAPON_SMG',  
   'WEAPON_SMG_MK2',
   'WEAPON_ASSAULTSMG',
   'WEAPON_COMBATPDW',
   'WEAPON_MACHINEPISTOL',
   'WEAPON_MINISMG',
   'WEAPON_RAYCARBINE',
   'WEAPON_GUSENBERG',
}
Config.ShotgunList = { 
   'WEAPON_PUMPSHOTGUN',
   'WEAPON_PUMPSHOTGUN_MK2',
   'WEAPON_SAWNOFFSHOTGUN',
   'WEAPON_ASSAULTSHOTGUN',
   'WEAPON_BULLPUPSHOTGUN',
   'WEAPON_MUSKET',
   'WEAPON_HEAVYSHOTGUN',
   'WEAPON_DBSHOTGUN',
   'WEAPON_AUTOSHOTGUN',
}
Config.RifleList = { 
   'WEAPON_ASSAULTRIFLE',
   'WEAPON_ASSAULTRIFLE_MK2',
   'WEAPON_CARBINERIFLE',
   'WEAPON_CARBINERIFLE_MK2',
   'WEAPON_ADVANCEDRIFLE',
   'WEAPON_SPECIALCARBINE',
   'WEAPON_SPECIALCARBINE_MK2',
   'WEAPON_BULLPUPRIFLE',
   'WEAPON_BULLPUPRIFLE_MK2',
   'WEAPON_COMPACTRIFLE',
}
Config.SniperList = { 
   'WEAPON_SNIPERRIFLE',
   'WEAPON_HEAVYSNIPER',
   'WEAPON_HEAVYSNIPER_MK2',
   'WEAPON_MARKSMANRIFLE',
   'WEAPON_MARKSMANRIFLE_MK2',
}
Config.MeleeList = { 
   'WEAPON_NIGHTSTICK',
   'WEAPON_FLASHLIGHT',
   'WEAPON_FLARE',
}