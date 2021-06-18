Config              = {}
Config.DrawDistance = 100
Config.Size         = {x = 0.301, y = 0.301, z = 0.3001}
Config.Color        = {r = 255, g = 0, b = 0}
Config.Type         = 21
Config.Locale       = 'en'



--Ones That Should Not Show Markers
Config.Zones = {

	TwentyFourSeven = {
		Items = {},
		Pos = {
			{x = 374.34,   y = 325.83,   z = 103.60},
            {x = 2557.41,  y = 382.56,   z = 108.66},   
            {x = -3241.99, y = 1001.68,  z = 12.86}, 
            {x = 547.34,   y = 2671.33,  z = 42.20}, 
			{x = 310.12,   y = -585.98,  z = 43.28},
			{x = 161.59,   y = 6635.97,  z = 31.60}, 
			{x = -271.58,  y = 6072.05,  z = 31.48}, 
			{x = -1200.64, y = -1585.48, z = 4.30},
			{x = 26.04, y = -1346.96, z = 29.5},
			{x = 1087.10,  y = 3068.05,  z = 40.55}, --Drag Strip
			{x = 204.27, y = -804.42, z = 31.02}, -- Legion
		}
	},

	MRPD = {
		Items = {},
		Pos = {
			{x = 461.15,    y = -982.07,  z = 30.69}, --StripClub --Done
		}
	},

	RobsLiquor = {
		Items = {},
		Pos = {
			{x = 128.22,    y = -1285.14,  z = 29.28}, --StripClub --Done
			{x = -559.906,  y = 287.093,   z = 82.29}, --Bahamamas 
			{x = 322.90,    y = -922.68,   z = 29.31}, --Bahamamas Central
			{x = 348.65,    y = -921.06,   z = 29.79}, --Bahamamas Central
			{x = 352.05,    y = 284.75,    z = 91.19}, --Nightclub Downstairs --Done
			{x = 359.63,    y = 280.25,    z = 94.19}, --Nightclub Upstairs --Done
			{x = 1108.47,   y = 208.51,    z = -49.44},--Casino --Done
		}
	},
	
	LTDgasoline = {
		Items = {},
		Pos = {
			{x = -48.519,  y = -1757.514, z = 29.45}, 
            {x = 1163.18,  y = -323.81,   z = 69.21}, 
            {x = -707.85,  y = -914.33,   z = 19.25}, 
            {x = -1820.68, y = 792.22,    z = 138.17}, 
            {x = 1698.41,  y = 4924.72,   z = 42.09} 
		}
	},
	
	Pawnshop = {
		Items = {},
		Pos = {
			{x = 245.64,  y = -264.61, z = 54.04}
		}
	},
	
	BaitShop = {
		Items = {},
		Pos = {
			{x = -1820.18,  y = -1220.38, z = 13.02}
		}
	},
	
	silkroad = {
		Items = {},
		Pos = {
			{x = -210.58,   y = -1606.93, z = 38.07} 
		}
	},
	
	YouTool = {
		Items = {},
		Pos = {
			{x = 2741.05,   y = 3463.03, z = 55.67} 
		}
	},
	
	-- Pharmacy = {
	-- 	Items = {},
	-- 	Pos = {
	-- 		{x = 318.29,   y = -1077.07, z = 29.48} 
	-- 	}
	-- }
}

--Ones That Should Show Markers
Config.ZonesMarkers = {

	TwentyFourSeven = {
		Items = {},
		Pos = {
			{x = 374.34,   y = 325.83,   z = 102.60},
            {x = 2557.41,  y = 382.56,   z = 107.66},       
            {x = -3241.99, y = 1001.68,  z = 11.86},
            {x = 547.34,   y = 2671.33,  z = 41.20},
			{x = 310.12,   y = -585.98,  z = 43.28}, 
			{x = 161.59,   y = 6635.97,  z = 30.60},
			{x = -271.58,  y = 6072.05,  z = 30.48}, 
			{x = -1200.64, y = -1585.48, z = 3.30}, --Gym
		}
	},

	RobsLiquor = {
		Items = {},
		Pos = {
			
		}
	},
	
	LTDgasoline = {
		Items = {},
		Pos = {
			{x = -48.519,   y = -1757.514, z = 28.45}, 
            {x = 1163.18,  y = -323.81,  z = 68.25},   
            {x = -707.85,  y = -914.33,  z = 18.25},  
            {x = -1820.68, y = 792.22,   z = 137.17}, 
            {x = 1698.41,  y = 4924.72,  z = 41.09}    
		}
	}
}
