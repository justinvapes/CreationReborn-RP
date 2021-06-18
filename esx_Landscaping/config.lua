Config                            = {}
Config.DrawDistance               = 10
Config.nameJob                    = "landscaper"
Config.nameJobLabel               = "Landscaping"
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
		Hash = "utillitruck4",
		Livery = 0,
		Trailer = "none",
	}
}

Config.Zones = {

  Cloakroom = {
    Pos     = {x = -1545.89, y = -586.04, z = 34.89},
    Size    = {x = 0.301, y = 0.301, z = 0.3001},
    Color   = {r = 255, g = 0, b = 0},
    Type    = 21,
	BlipSprite = 460,
	BlipColor = 5,
	BlipName = Config.nameJobLabel.."",
	hint = 'Press ~INPUT_CONTEXT~ To Access The Cloakroom',
  },

  VehicleSpawnPoint = {
	Pos   = {x = -1528.74, y = -554.1, z = 32.37},
	Size  = {x = 2.0, y = 2.0, z = 1.0},
	Type  = -1,
	Heading = 214.7,
  },

  VehicleDeleter = {
	Pos   = {x = -1539.74, y = -560.31, z = 32.62},
	Size  = {x = 3.0, y = 3.0, z = 1.0},
	Color = {r = 255, g = 0, b = 0},
	Type  = 27,
	hint = 'Press ~INPUT_CONTEXT~ To Return The Vehicle',
  },

  Vente = {
	Pos   = {x = -1545.89, y = -586.04, z = 34.89},
	Size    = {x = 0.301, y = 0.301, z = 0.3001},
    Color   = {r = 255, g = 0, b = 0},
	Type  = 21,
	ItemTime = 500,
	ItemDb_name = "payslip",
	ItemName = "payslip",
	ItemMax = 35,
	ItemAdd = 1,
	ItemRemove = 1,
	ItemRequires = "payslip",
	ItemRequires_name = "payslip",
	ItemDrop = 100,
	hint = 'Press ~INPUT_CONTEXT~ To Cash In Your payslips',
  },

}

Config.Pool = {
{ [ 'x' ] = 	 -665.7	            , [ 'y' ] = 	-989.86	            , [ 'z' ] = 	19.68	            }, ----Done
{ [ 'x' ] = 	 -999.86	        , [ 'y' ] = 	-1484.97	        , [ 'z' ] = 	4.80	            }, ----Done
{ [ 'x' ] = 	 -1343.54	        , [ 'y' ] = 	-913.52	            , [ 'z' ] = 	10.35	            }, ----Done
{ [ 'x' ] = 	 893.94         	, [ 'y' ] = 	-612.28         	, [ 'z' ] = 	57.23           	}, ----Done
{ [ 'x' ] = 	 851.27          	, [ 'y' ] = 	-524.13          	, [ 'z' ] = 	56.35	            }, ----Done
{ [ 'x' ] = 	 1258.77	        , [ 'y' ] = 	-1711.1	            , [ 'z' ] = 	54.68	            }, ----Done
{ [ 'x' ] = 	 -1516.44	        , [ 'y' ] = 	-111.68	            , [ 'z' ] = 	53.17	            }, ----Done
{ [ 'x' ] = 	 -1510.23	        , [ 'y' ] = 	179.9	            , [ 'z' ] = 	55.95	            }, ----Done
{ [ 'x' ] = 	 -1362.41	        , [ 'y' ] = 	235.93	            , [ 'z' ] = 	58.26	            }, ----Done
{ [ 'x' ] = 	 -1212.59	        , [ 'y' ] = 	306.1	            , [ 'z' ] = 	68.83	            }, ----Done
{ [ 'x' ] = 	 -1163.47	        , [ 'y' ] = 	347.07           	, [ 'z' ] = 	70.51	            }, ----Done
{ [ 'x' ] = 	 -305.82	        , [ 'y' ] = 	-1117.77	        , [ 'z' ] = 	23.23	            }, ----Done
{ [ 'x' ] = 	 147.94	            , [ 'y' ] = 	-263.26	            , [ 'z' ] = 	45.33	            }, ----Done
{ [ 'x' ] = 	 72.97           	, [ 'y' ] = 	-1973.94	        , [ 'z' ] = 	19.85	            }, ----Done
{ [ 'x' ] = 	 345.69         	, [ 'y' ] = 	445.56          	, [ 'z' ] = 	146.70          	}, ----Done
{ [ 'x' ] = 	 18.99	            , [ 'y' ] = 	-18.52	            , [ 'z' ] = 	69.61	            }, ----Done
{ [ 'x' ] = 	 -5.32          	, [ 'y' ] = 	323.7            	, [ 'z' ] = 	112.08	            }, ----Done
{ [ 'x' ] = 	 -326.03	        , [ 'y' ] = 	537.71	            , [ 'z' ] = 	120.30	            }, ----Done
{ [ 'x' ] = 	 -352.03	        , [ 'y' ] = 	447.99	            , [ 'z' ] = 	111.69	            }, ----Done
{ [ 'x' ] = 	  1378.62	        , [ 'y' ] = 	1138.54	            , [ 'z' ] = 	113.30	            }, ----Done
{ [ 'x' ] = 	 -638.64	        , [ 'y' ] = 	558.37	            , [ 'z' ] = 	110.14	            }, ----Done
{ [ 'x' ] = 	 -2950.59	        , [ 'y' ] = 	680.34	            , [ 'z' ] = 	27.87	            }, ----Done
{ [ 'x' ] = 	 -2935.61       	, [ 'y' ] = 	644.4           	, [ 'z' ] = 	23.13	            }, ----Done
{ [ 'x' ] = 	 -752.84	        , [ 'y' ] = 	475.42	            , [ 'z' ] = 	106.55	            }, ----Done
{ [ 'x' ] = 	 -1597.34	        , [ 'y' ] = 	-595.92	            , [ 'z' ] = 	31.56	            }, ----Done
}

for i=1, #Config.Pool, 1 do

    Config.Zones['Pool' .. i] = {
        Pos   = Config.Pool[i],
        Size  = {x = 1.0, y = 1.0, z = 1.0},
        Color = {r = 255, g = 0, b = 0},
        Type  = -1
    }

end


Config.Uniforms = {

  job_wear = {
    male = {
        ['tshirt_1'] = 59, ['tshirt_2'] = 0,
		['torso_1']  = 89, ['torso_2']  = 1,
		['decals_1'] = 0,  ['decals_2'] = 0,
		['arms']     = 31,
		['pants_1']  = 36, ['pants_2']  = 0,
		['shoes_1']  = 35, ['shoes_2']  = 0,
		['helmet_1'] = 0,  ['helmet_2'] = 0,
		['chain_1']  = 0,  ['chain_2']  = 0,
		['ears_1']   = -1, ['ears_2']   = 0
    },
    female = {
        ['tshirt_1'] = 36, ['tshirt_2'] = 0,
		['torso_1']  = 0,  ['torso_2']  = 11,
		['decals_1'] = 0,  ['decals_2'] = 0,
		['arms']     = 68,
		['pants_1']  = 30, ['pants_2']  = 2,
		['shoes_1']  = 24, ['shoes_2']  = 0,
		['helmet_1'] = -1, ['helmet_2'] = 0,
		['chain_1']  = 0,  ['chain_2']  = 0,
		['ears_1']   = -1, ['ears_2']   = 0
    }
  },
}