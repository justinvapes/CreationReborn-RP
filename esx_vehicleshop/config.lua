Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 255, g = 0, b = 0 }
Config.EnablePlayerManagement     = true -- enables the actual car dealer job. You'll need esx_addonaccount, esx_billing and esx_society
Config.EnableOwnedVehicles        = true
Config.EnableSocietyOwnedVehicles = false -- use with EnablePlayerManagement disabled, or else it wont have any effects
Config.Locale                     = 'en'
Config.MaxInService               = 5

Config.LicenseEnable = false -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 5
Config.PlateNumbers  = 3
Config.PlateUseSpace = false

Config.Zones = {

	ShopEntering = {
		Pos   = { x = -57.19, y = -1099.3, z = 25.452 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = 27
	},

	ShopInside = {
		Pos     = { x = -47.570, y = -1097.221, z = 25.422 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = -20.0,
		Type    = -1
	},

	ShopTrailer = {
		Pos     = { x = -62.87, y = -1101.17, z = 25.565 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 8.86,
		Type    = -1
	},

	ShopOutside = {
		Pos     = { x = -28.637, y = -1085.691, z = 25.565 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 330.0,
		Type    = -1
	},

	BossActions = {
		Pos   = { x = -31.04, y = -1110.92, z = 25.48 },
		Size  = { x = 1.0, y = 1.0, z = 1.0 },
		Type  = 27
	}

}
