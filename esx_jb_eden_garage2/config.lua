Config = {}
Config.Blip			         = {sprite= 473, color = 4}
Config.TrailerBlip		     = {sprite= 479, color = 30}
Config.PoliceBlip		     = {sprite= 479, color = 30}
Config.BoatBlip		         = {sprite= 410, color = 30}
Config.AirplaneBlip	         = {sprite= 290, color = 38}
Config.MecanoBlip	         = {sprite= 357, color = 26}
Config.Price		         = 1500 -- pound price to get vehicle back
Config.SwitchGaragePrice	 = 500 -- price to pay to switch vehicles in garage
Config.StoreOnServerStart    = false -- Store all vehicles in garage on server start?
Config.RangeCheck            = 20.0 -- this is the change you will be able to control the vehicle.


Config.Garages = {
	Centre_Garage = {--Done
		Pos = {x=215.800, y=-810.057, z=30.76},
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		SpawnPoint = {
			Pos = {x=229.700, y= -800.1149, z= 30.60},
			Heading = 160.0,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		SpawnPointTrailer = {
			Pos = {x=233.91, y= -787.64, z= 30.60},
			Heading = 160.0,
		},
		DeletePoint = {
			Pos = {x=214.1, y=-793.74, z=30.90},
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},	
	Sandy_Garage = {--Done	
		Pos = {x=2002.68, y=3051.76, z=47.25},
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		Functionmenu = OpenMenuGarage,
		SpawnPoint = {
			Pos = {x=2003.45, y= 3073.47, z= 47.08},
			Heading = 58.81,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		DeletePoint = {
			Pos = {x=1996.99, y=3061.72, z=47.08},
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},
	Bank_Garage = {--Done
		Pos = {x = 364.6,y = 297.86,z = 103.52 },
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		SpawnPoint = {
		    Pos = {x = 371.9,y = 271.31,z = 103.11 },		
			Heading = 251.86,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		DeletePoint = {
			Pos = {x = 378.00622558594,y = 288.13024902344,z = 103.20},
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},		

    Senora_Garage = {--Done
		Pos = {x = -3053.8,y = 111.94,z = 11.63 },
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		SpawnPoint = {
		    Pos = {x = -3043.85,y = 117.06,z = 11.62 },		
			Heading = 226.60,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		DeletePoint = {
			Pos = {x = -3034.11,y = 125.56,z = 11.64},
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},	
	
	Boat_Dock_Garage = {--Done
		Pos = {x = -708.06,y = -1274.13,z = 5.03 },--imound
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		SpawnPoint = {
		    Pos = {x = -712.05,y = -1271.25,z = 5.03 },		
			Heading = 139.32,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		DeletePoint = {
			Pos = {x = -704.52,y = -1277.96,z = 5.03 },
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},

	Gym_Garage = {--Done
		Pos = {x = -1185.93,y = -1507.32,z = 4.42 },--imound
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		SpawnPoint = {
		    Pos = {x = -1176.05,y = -1482.32,z = 4.42 },		
			Heading = 33.06,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		DeletePoint = {
			Pos = {x = -1191.84,y = -1493.19,z = 4.42 },
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},

	Airport_Garage = {--Done
		Pos = {x = -1334.88,y = -3289.54,z = 13.98 },--imound
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		SpawnPoint = {
		    Pos = {x = -1334.59,y = -3299.22,z = 13.98 },		
			Heading = 326.24,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		DeletePoint = {
			Pos = {x = -1328.62,y = -3303.06,z = 13.98 },
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},

	The_Motor_Motel = {--Done
		Pos = {x = 1131.39,y = 2646.38,z = 38.1 },--impound
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		SpawnPoint = {
		    Pos = {x = 1137.93,y = 2646.78,z = 38.1 },		
			Heading = 0.31,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		DeletePoint = {
			Pos = {x = 1124.05,y = 2647.19,z = 38.1 },
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},


	Pink_Cage = {--Done
		Pos = {x = 328.94,y = -202.4,z = 54.19 },--impound
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		SpawnPoint = {
		    Pos = {x = 331.96,y = -206.61,z = 54.19 },		
			Heading = 160.6,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		DeletePoint = {
			Pos = {x = 323.48,y = -203.11,z = 54.19 },
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},

	Bilingsgate_Motel = {--Done
		Pos = {x = 555.16,y = -1799.46,z = 29.3 },--impound
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		SpawnPoint = {
		    Pos = {x = 564.6,y = -1798.77,z = 29.3 },		
			Heading = 348.01,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		DeletePoint = {
			Pos = {x = 545.23,y = -1794.73,z = 29.3 },
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},

	Caesars_Garage = {--Done
		Pos = {x = -448.83,y = -798.68,z = 30.58 },--imound
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		SpawnPoint = {
		    Pos = {x = -472.08,y = -806.39,z = 30.58 },		
			Heading = 179.42,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		DeletePoint = {
			Pos = {x = -453.57,y = -806.39,z = 30.58 },
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},
	
	Paleto_Garage = {--Done
		Pos = {x = 158.43,y = 6626.39,z = 31.82 },
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		SpawnPoint = {
		    Pos = {x = 134.34,y = 6600.84,z = 31.87 },		
			Heading = 226.60,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		DeletePoint = {
			Pos = {x = 152.42,y = 6619.35,z = 31.86},
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},	
	
	Lake_Vinewood = {--Done
		Pos = {x = -72.61,y = 908.76,z = 235.66 },
		Marker = { w= 1.0, h= 1.0,r = 204, g = 204, b = 0},
		Name = 'Vehicle Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		SpawnPoint = {
		    Pos = {x = -70.77,y = 903.64,z = 235.64 },		
			Heading = 112.67,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Get Your Vehicle Out",
		},
		DeletePoint = {
			Pos = {x = -66.11,y = 891.91,z = 235.60},
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Vehicle",
		}, 	
	},	
	
}

Config.GaragesMecano = {	
	police = {
		Name = 'Police Impound',
		SpawnPoint = {
			Pos = {x = 851.28,y = -1350.07,z = 26.10},
			Heading = 357.84,
			Marker = { w= 1.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Access The Impound",
		},
		DeletePoint = {
			Pos = {x = 822.15,y = -1343.28,z = 26.15},
			Marker = { w= 1.5, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Imound This Vehicle",
		}, 	
	},	
}

Config.TrailerGarages = {

	TrailerGarage_Centre = {
		Pos = {x = -308.28,y = -1092.08,z = 23.03 },
		Marker = { w= 1.0, h= 0.5,r = 204, g = 204, b = 0},
		Name = 'Trailer Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Open The Trailer Impound",
				
		SpawnPoint = {
			Pos = {x = -337.8,y = -1097.35,z = 23.10 },
			MarkerPos = {x = -318.01,y = -1104.16 ,z = 23.03 },
			Heading = 250.0,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Access Trailer Garage"
		},
				
		DeletePoint = {
			Pos = {x = -316.15,y = -1098.25,z = 23.03},
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Trailer"
		}, 	
	},
	
	TrailerGarage_Paleto = {
		Pos = {x = -295.49,y = 6039.71,z = 31.48 },
		Marker = { w= 1.0, h= 0.5,r = 204, g = 204, b = 0},
		Name = 'Trailer Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Open The Trailer Impound",
				
		SpawnPoint = {
			Pos = {x = -265.41,y = 6041.61,z = 31.79 },
			MarkerPos = {x = -279.74,y = 6055.75 ,z = 31.52 },
			Heading = 45.93,
			Marker = { w= 2.0, h= 1.0,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Access Trailer Garage"
		},
				
		DeletePoint = {
			Pos = {x = -286.32,y = 6048.78,z = 31.50},
			Marker = { w= 2.0, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Trailer"
		}, 	
	},
}

Config.PoliceGarages = {

	Garage_Police_MRPD = {
		Pos = {x = 437.89, y = -1015.75, z = 28.73 },
		Marker = { w= 0.5, h= 1.0, r = 204, g = 204, b = 0},
		Name = 'Police Garage',
		HelpPrompt = "Press ~INPUT_CONTEXT~ To Open ~y~Your Impound~s~",
				
		SpawnPoint = {
			Pos = {x = 438.42,y = -1018.30,z = 27.7 },
			Heading = 91.77
		},	
	},

	Garage_Police_SANDY = {
		Pos = {x = 1851.03, y = 3679.44, z = 34.27 },
		Marker = { w= 0.5, h= 1.0, r = 204, g = 204, b = 0},
		Name = 'Police Garage',
		HelpPrompt = "Press ~INPUT_CONTEXT~ To Open ~y~Your Impound~s~",
				
		SpawnPoint = {
			Pos = {x = 1866.11,y = 3678.19,z = 33.6 },
			Heading = 300.0
		},	
	},

	Garage_Police_PALETO = {
		Pos = {x = -457.3, y = 6030.11, z = 31.34 },
		Marker = { w= 0.5, h= 1.0, r = 204, g = 204, b = 0},
		Name = 'Police Garage',
		HelpPrompt = "Press ~INPUT_CONTEXT~ To Open ~y~Your Impound~s~",
				
		SpawnPoint = {
			Pos = {x = -446.76,y = 6032.41,z = 31.34 },
			Heading = 300.0
		},	
	},
}

Config.BoatGarages = {

	BoatGarage_Centre = {
		Pos = {x = -725.35,y = -1333.86,z = 1.59 },
		Marker = { w= 1.0, h= 0.5,r = 204, g = 204, b = 0},
		Name = 'Boat Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Open The Boat Impound",
		
		
		SpawnPoint = {
			Pos = {x = -717.73,y = -1343.66,z = 0.4 },
			MarkerPos = {x = -719.21,y = -1326.35,z = 1.5 },
			Heading = 230.0,
			Marker = { w= 1.0, h= 0.5,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Access Boat Garage"
		},
		
		
		DeletePoint = {
			Pos = {x = -708.79,y = -1335.87,z = 0.5801},
			Marker = { w= 2.5, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Boat"
		}, 	
	},

	BoatGarage_Grapeseed = {
		Pos = {x = 1316.22,y = 4229.91,z = 33.91 },
		Marker = { w= 1.0, h= 0.5,r = 204, g = 204, b = 0},
		Name = 'Boat Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Open The Boat Impound",
		
		
		SpawnPoint = {
			Pos = {x = 1311.69,y = 4218.68,z = 31.3 },
			MarkerPos = {x = 1299.29, y = 4217.07,z = 33.9 },
			Heading = 171.29,
			Marker = { w= 1.0, h= 0.5,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Access Boat Garage"
		},
		
		
		DeletePoint = {
			Pos = {x = 1291.27,y = 4223.55,z = 31.3},
			Marker = { w= 2.5, h= 1.0,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Boat"
		}, 	
	},
}

Config.AirplaneGarages = {

	AirplaneGarage_Centre = {
		Pos = {x = -1286.89,y = -3389.49,z = 13.940155029297 },
		Marker = { w= 1.5, h= 0.5,r = 204, g = 204, b = 0},
		Name = 'Aircraft Garage',
		HelpPrompt = "Press ~INPUT_PICKUP~ To Open The Aircraft Impound",
		
		SpawnPoint = {
			Pos = {x = -1280.1153564453,y = -3378.1647949219,z = 13.940155029297 },
			MarkerPos = {x = -1271.16,y = -3398.70,z = 13.940155029297 },
			Heading = 160.0,
			Marker = { w= 1.5, h= 0.5,r=0,g=255,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Access Aircraft Garage"
		},
		
		DeletePoint = {
			Pos = {x = -1240.16,y = -3320.76,z = 13.940155029297 },
			Marker = { w= 5.5, h= 0.5,r=255,g=0,b=0},
			HelpPrompt = "Press ~INPUT_PICKUP~ To Store Your Aircraft"
		}, 	
	},
}

Config.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end