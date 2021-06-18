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
		Pos   = { x = -53.85, y = 67.35, z = 70.97 }, -- Main Point
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = 27
	},

	ShopInside = {
		Pos     = { x = -62.55, y = 67.98, z = 71.88 }, -- Car Spawn?
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 339.60,
		Type    = -1
	},

	ShopTrailer = {
		Pos     = { x = -51.46, y = 63.92, z = 72.44 }, -- Trailer Spawn
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 127.41,
		Type    = -1
	},

	ShopOutside = {
		Pos     = { x = -68.08, y = 82.57, z = 71.52 }, -- Outside Car Spawn (Society Vehs)
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 60.54,
		Type    = -1
	},

	BossActions = {
		Pos   = { x = -54.69, y = 74.16, z = 70.88 },
		Size  = { x = 1.0, y = 1.0, z = 1.0 },
		Type  = 27
	}

}
