Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 255, g = 0, b = 0 }
Config.EnablePlayerManagement     = false -- enables the actual car dealer job. You'll need esx_addonaccount, esx_billing and esx_society
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
		Pos   = { x = -32.17, y = -1655.3, z = 28.51 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = 27
	},

	ShopInside = {
		Pos     = { x = -56.02, y = -1684.73, z = 29.49 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 317.4,
		Type    = -1
	},

	ShopTrailer = {
		Pos     = { x = -24.44, y = -1679.79, z = 29.44 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 108.6,
		Type    = -1
	},

	ShopOutside = {
		Pos     = { x = -24.44, y = -1679.79, z = 29.44 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 108.6,
		Type    = -1
	},

	BossActions = {
		Pos   = { x = -31.04, y = -1110.92, z = 25.48 },
		Size  = { x = 1.0, y = 1.0, z = 1.0 },
		Type  = 27
	}

}
