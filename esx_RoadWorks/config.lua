Config                            = {}
Config.DrawDistance               = 10
Config.nameJob                    = "roadworker"
Config.nameJobLabel               = "Roadworks"
Config.Locale                     = 'fr'
Config.RentPrice                  = 500
Config.caution                    = 500

Config.Blip = {
    Sprite = 460,
    Color = 5
}

Config.Vehicles = {
	Truck = {
		Spawner = 1,
		Label = 'Van',
		Hash = "steed3",
		Livery = 0,
		Trailer = "none",
	}
}

Config.Zones = {

  Cloakroom = {
    Pos     = {x = 903.79, y = -1575.65, z = 30.86},
    Size    = {x = 0.301, y = 0.301, z = 0.3001},
    Color   = {r = 255, g = 0, b = 0},
    Type    = 21,
	BlipSprite = 460,
	BlipColor = 5,
	BlipName = Config.nameJobLabel.."",
	hint = 'Press ~INPUT_CONTEXT~ To Access The Cloakroom',
  },

  VehicleSpawnPoint = {
	Pos   = {x = 897.15, y = -1546.91, z = 29.15},
	Size  = {x = 2.0, y = 2.0, z = 1.0},
	Type  = -1,
	Heading = 39.9,
  },

  VehicleDeleter = {
	Pos   = {x = 890.61, y = -1568.54, z = 29.88},
	Size  = {x = 3.5, y = 3.5, z = 1.0},
	Color = {r = 255, g = 0, b = 0},
	Type  = 27,
	hint = 'Press ~INPUT_CONTEXT~ To Return The Vehicle',
  },

  Vente = {
	Pos   = {x = 903.79, y = -1575.65, z = 30.84},
	Size    = {x = 0.301, y = 0.301, z = 0.3001},
    Color   = {r = 255, g = 0, b = 0},
    Type    = 21,
	ItemTime = 500,
	ItemDb_name = "contrat",
	ItemName = "contrat",
	ItemMax = 15,
	ItemAdd = 1,
	ItemRemove = 1,
	ItemRequires = "contrat",
	ItemRequires_name = "contrat",
	ItemDrop = 100,
	hint = 'Press ~INPUT_CONTEXT~ To Cash In Your Invoices',
  },

}

Config.Road = {
{ [ 'x' ] =   61.74	                , [ 'y' ] = 	-695.67	            , [ 'z' ] = 	29.63	            }, --Done
{ [ 'x' ] =  -177.63	            , [ 'y' ] = 	-1025.66	        , [ 'z' ] = 	26.31	            }, --Done
{ [ 'x' ] =  -1139.85	            , [ 'y' ] = 	-1404.2	            , [ 'z' ] = 	3.50	            }, --Done
{ [ 'x' ] =  -1453.6	            , [ 'y' ] = 	-900.05             , [ 'z' ] = 	9.63	            }, --Done
{ [ 'x' ] =  73.9	                , [ 'y' ] = 	-411.69             , [ 'z' ] = 	36.58	            }, --Done
{ [ 'x' ] =  410.45	                , [ 'y' ] = 	-721.79             , [ 'z' ] = 	28.10	            }, --Done
{ [ 'x' ] =  -476.56	            , [ 'y' ] = 	-1775.07            , [ 'z' ] = 	19.75	            }, --Done
{ [ 'x' ] =  955.19	                , [ 'y' ] = 	-1870.23            , [ 'z' ] = 	29.98	            }, --Done
{ [ 'x' ] =  -919.5	                , [ 'y' ] = 	-123.09             , [ 'z' ] = 	36.65	            }, --Done
{ [ 'x' ] =  -1279.66	            , [ 'y' ] = 	-987.43             , [ 'z' ] = 	8.96	            }, --Done
{ [ 'x' ] =  284.45	                , [ 'y' ] = 	774.96              , [ 'z' ] = 	183.95	            }, --Done
{ [ 'x' ] =  -770.03	            , [ 'y' ] = 	702.01              , [ 'z' ] = 	143.52	            }, --Done
{ [ 'x' ] =  741.24	                , [ 'y' ] = 	-2584.28            , [ 'z' ] = 	17.40	            }, --Done
{ [ 'x' ] =  176.92	                , [ 'y' ] = 	-2002.95            , [ 'z' ] = 	17.26	            }, --Done

{ [ 'x' ] =  -803.26	            , [ 'y' ] = 	-1123.5             , [ 'z' ] = 	9.25                }, --Done
{ [ 'x' ] =  -868.36	            , [ 'y' ] = 	-1733.55            , [ 'z' ] = 	17.89               }, --Done
{ [ 'x' ] =  -1032.99	            , [ 'y' ] = 	-2073.62            , [ 'z' ] = 	12.45               }, --Done
{ [ 'x' ] =  -429.41	            , [ 'y' ] = 	-2151.67            , [ 'z' ] = 	9.11                }, --Done
{ [ 'x' ] =  -49.34	                , [ 'y' ] = 	-1970.63            , [ 'z' ] = 	14.68               }, --Done
{ [ 'x' ] =  225.23	                , [ 'y' ] = 	-2081.16            , [ 'z' ] = 	16.68               }, --Done
{ [ 'x' ] =  463.35	                , [ 'y' ] = 	-2017.2             , [ 'z' ] = 	22.63               }, --Done
}

for i=1, #Config.Road, 1 do

    Config.Zones['Road' .. i] = {
        Pos   = Config.Road[i],
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
		['helmet_1'] = 0,   ['helmet_2'] = 0,
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
		['helmet_1'] = 0,   ['helmet_2'] = 0,
		['chain_1']  = 0,   ['chain_2']  = 0,
		['bags_1']   = 0,   ['bags_2']   = 0,
		['ears_1']   = -1,  ['ears_2']   = 0
    }
  },
}