Config                            = {}
Config.DrawDistance               = 10
Config.nameJob                    = "deliverer"
Config.nameJobLabel               = "Australia Post"
Config.Locale                     = 'fr'
Config.RentPrice                  = 500
Config.caution                    = 500

Config.Blip = {
    Sprite = 85,
    Color = 5
}

Config.Vehicles = {
	Truck = {
		Spawner = 1,
		Label = 'Van',
		Hash = "postvan",
		Livery = 0,
		Trailer = "none",
	}
}

Config.Zones = {

  Cloakroom = {
    Pos   = {x = 53.77, y = 115.21, z = 79.11},
    Size    = {x = 0.301, y = 0.301, z = 0.3001},
    Color   = {r = 255, g = 0, b = 0},
    Type    = 21,
	BlipSprite = 85,
	BlipColor = 5,
	BlipName = Config.nameJobLabel.."",
	hint = 'Press ~INPUT_CONTEXT~ To Access The Cloakroom',
  },

  VehicleSpawnPoint = {
	Pos   = {x = 74.33, y = 120.43, z = 78.09},
	Size  = {x = 2.0, y = 2.0, z = 1.0},
	Type  = -1,
	Heading = 159.3,
  },

  VehicleDeleter = {
	Pos   = {x = 61.98, y = 125.12, z = 78.25},
	Size  = {x = 3.5, y = 3.5, z = 1.0},
	Color = {r = 255, g = 0, b = 0},
	Type  = 27,
	hint = 'Press ~INPUT_CONTEXT~ To Return The Vehicle',
  },

  Vente = {
    Pos   = {x = 53.77, y = 115.21, z = 79.11},	
	Size    = {x = 0.301, y = 0.301, z = 0.3001},
	Color = {r = 255, g = 0, b = 0},
	Type  = 21,
	ItemTime = 500,
	ItemDb_name = "check",
	ItemName = "Check",
	ItemMax = 35,
	ItemAdd = 1,
	ItemRemove = 1,
	ItemRequires = "check",
	ItemRequires_name = "Check",
	ItemDrop = 100,
	hint = 'Press ~INPUT_CONTEXT~ To Cash In Your Checks',
  },
}

Config.Post = {
{ [ 'x' ] =   1098.45	,[ 'y' ] = 	-465.14	    ,[ 'z' ] = 	66.34   }, ----Done
{ [ 'x' ] =  -1047.11	,[ 'y' ] = 	-518.97	    ,[ 'z' ] = 	35.06	}, ----Done
{ [ 'x' ] =  -1135.43	,[ 'y' ] = 	 376.49	    ,[ 'z' ] = 	70.32	}, ----Done
{ [ 'x' ] =  -1248.13   ,[ 'y' ] = 	-1425.13    ,[ 'z' ] = 	3.34    }, ----Done
{ [ 'x' ] =  -60.86     ,[ 'y' ] = 	1000.2      ,[ 'z' ] = 	233.42	}, ----Done
{ [ 'x' ] =  -69.08	    ,[ 'y' ] = 	-2654.05	,[ 'z' ] = 	5.25	}, ----Done
{ [ 'x' ] =   2672.25	,[ 'y' ] = 	1612.67	    ,[ 'z' ] = 	23.52	}, ----Done
{ [ 'x' ] =  -467.45	,[ 'y' ] = 	328.57	    ,[ 'z' ] = 	103.16	}, ----Done
{ [ 'x' ] =  -152.1	    ,[ 'y' ] = 	910.94	    ,[ 'z' ] = 	234.68	}, ----Done
{ [ 'x' ] =   850.67	,[ 'y' ] = 	2383.14	    ,[ 'z' ] = 	53.19	}, ----Done

{ [ 'x' ] =   944.44	,[ 'y' ] = -678.28	    ,[ 'z' ] = 	57.47	}, ----Done
{ [ 'x' ] =  -240.55	,[ 'y' ] = 	381.21	    ,[ 'z' ] = 	111.45	}, ----Done
{ [ 'x' ] =  -1019.89	,[ 'y' ] = 	717.83	    ,[ 'z' ] = 	163.19	}, ----Done
{ [ 'x' ] =  -1368.76	,[ 'y' ] = -647.64	    ,[ 'z' ] = 	27.71	}, ----Done
{ [ 'x' ] =  -1251.87	,[ 'y' ] = -1452.9	    ,[ 'z' ] = 	3.37	}, ----Done
{ [ 'x' ] =   85.46	    ,[ 'y' ] = -1959.25	    ,[ 'z' ] = 	20.14	}, ----Done
{ [ 'x' ] =   464.68	,[ 'y' ] = -1672.64	    ,[ 'z' ] = 	28.31	}, ----Done
}

for i=1, #Config.Post, 1 do

    Config.Zones['Post' .. i] = {
        Pos   = Config.Post[i],
        Size  = {x = 1.0, y = 1.0, z = 1.0},
        Color = {r = 255, g = 0, b = 0},
        Type  = -1
    }

end

Config.Uniforms = {

  job_wear = {
    male = {
        ['tshirt_1'] = 57,  ['tshirt_2'] = 0,
		['torso_1']  = 133, ['torso_2']  = 0,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms']     = 11,
		['pants_1']  = 47,  ['pants_2']  = 0,
		['shoes_1']  = 12,  ['shoes_2']  = 0,
		['helmet_1'] = -1,   ['helmet_2'] = 0,
		['chain_1']  = 0,   ['chain_2']  = 0,
		['bags_1']   = 0,   ['bags_2']   = 0,
		['ears_1']   = -1,  ['ears_2']   = 0
    },
    female = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
		['torso_1']  = 130, ['torso_2']  = 0,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms']     = 33,
		['pants_1']  = 49,  ['pants_2']  = 0,
		['shoes_1']  = 52,  ['shoes_2']  = 0,
		['helmet_1'] = -1,  ['helmet_2'] = 0,
		['chain_1']  = 0,   ['chain_2']  = 0,
		['bags_1']   = 0,   ['bags_2']   = 0,
		['ears_1']   = -1,  ['ears_2']   = 0
    }
  },
}
