Config               = {}

Config.DrawDistance  = 5
Config.Size          = { x = 0.301, y = 0.301, z = 0.301 }
Config.Color         = { r = 255, g = 0, b = 0 }
Config.Type          = 21
Config.Locale        = 'en'

Config.LicenseEnable = true 
Config.LicensePrice  = 289

Config.Zones = {

	GunShop = {
	    Legal = true,
		Items = {
		   {weapon = 'WEAPON_FLASHLIGHT',     price = 69},
			{weapon = 'WEAPON_MACHETE',        price = 399},
			{weapon = 'WEAPON_HATCHET',        price = 389},
			{weapon = 'WEAPON_NIGHTSTICK',     price = 369},
			{weapon = 'WEAPON_BAT',            price = 349},
			{weapon = 'WEAPON_POOLCUE',        price = 359},
		    {weapon = 'WEAPON_PISTOL',         components = {0, 499, 299, 749, 4999, nil}, price = 3399},
			{weapon = 'WEAPON_PISTOL50',       components = {0, 499, 299, 749, 4999, nil}, price = 2999},
			{weapon = 'WEAPON_VINTAGEPISTOL',  components = {0, 499, 749, nil}, price = 1799},
			{weapon = 'WEAPON_MARKSMANPISTOL', components = {nil}, price = 4999}
		},
		
		Locations = {
			vector3(-662.1, -935.3, 21.8),
			vector3(810.2, -2157.3, 29.6),
			vector3(1693.4, 3759.5, 34.7),
			vector3(-330.2, 6083.8, 31.4),
			vector3(252.3, -50.0, 69.9),
			vector3(22.0, -1107.2, 29.8),
			vector3(2567.6, 294.3, 108.7),
			vector3(-1117.5, 2698.6, 18.5),
			vector3(842.4, -1033.4, 28.1)
		}
	},

	BlackWeashop = {
		Legal = false,
		Items = {		
		   {weapon = 'WEAPON_MOLOTOV',      price = 1500},
			{weapon = 'WEAPON_KNIFE',        price = 400},
			{weapon = 'WEAPON_SWITCHBLADE',        price = 1200},
			
			{weapon = 'WEAPON_REVOLVER',       components = {nil}, price = 10000},
			{weapon = 'WEAPON_APPISTOL',       components = {0, 499, 299, 749, 20000, nil}, price = 30000},
			{weapon = 'WEAPON_MICROSMG',       components = {0, 499, 299, 1599, 749, nil}, price = 25000},
			{weapon = 'WEAPON_GUSENBERG',      components = {0, 500, nil }, price = 15000},		
			{weapon = 'WEAPON_PUMPSHOTGUN',    components = {299, 749, 49999, nil}, price = 30000},
			{weapon = 'WEAPON_ASSAULTRIFLE',   components = {0, 499, 1599, 299, 3500, 749, nil}, price = 40000},
			{weapon = 'WEAPON_SPECIALCARBINE', components = {0, 499, 1599, 299, 3500, 749, nil}, price = 35000},
			{weapon = 'WEAPON_HEAVYSNIPER',    components = {20000, 25000}, price = 350000}		
		   },
		   
		Locations = {
			vector3(659.7, 593.11, 129.05)
		}
	}
}

Config.Pistols = { 
   453432689,   --WEAPON_PISTOL
  -1716589765, --WEAPON_PISTOL50
   137902532,   --WEAPON_VINTAGEPISTOL
  -598887786,  --WEAPON_MARKSMANPISTOL
  -1045183535, --WEAPON_REVOLVER
   584646201,   --WEAPON_APPISTOL  
}
Config.Smg = { 
  324215364,  --WEAPON_MICROSMG
  1627465347,  --WEAPON_GUSENBERG
}
Config.ShotGuns = { 
  487013001,   --WEAPON_PUMPSHOTGUN  
}
Config.Rifles = { 
  -1074790547, --WEAPON_ASSAULTRIFLE  
  -1063057011, --WEAPON_SPECIALCARBINE  
}

Config.PedLocations = {
	{x = 22.52,    y = -1105.53, z = 28.8,   heading = 159.66},
	{x = 810.29,   y = -2158.99, z = 28.62,  heading = 0.74},
	{x = 842.46,   y = -1035.25, z = 27.19,  heading = 356.55},
	{x = -662.19,  y = -933.54,  z = 20.83,  heading = 179.58},
	{x = 253.84,   y = -50.46,   z = 68.94,  heading = 70.37},
	{x = 2567.70,  y = 292.64,   z = 107.73, heading = 357.38},
	{x = -1118.74, y = 2699.91,  z = 17.55,  heading = 218.01},
	{x = 1692.03,  y = 3760.64,  z = 33.71,  heading = 224.43},
	{x = -331.53,  y = 6085.0,   z = 30.45,  heading = 224.15}
}


Config.MeleeList = { 
   'WEAPON_FLASHLIGHT',
   'WEAPON_MACHETE',
   'WEAPON_HATCHET',
   'WEAPON_NIGHTSTICK',
   'WEAPON_BAT',
   'WEAPON_POOLCUE', 
   'WEAPON_MOLOTOV',   
   'WEAPON_KNUCKLE', 
   'WEAPON_KNIFE', 
   'WEAPON_SWITCHBLADE',      
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
   'WEAPON_GUSENBERG'
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
   'WEAPON_HEAVYSNIPER',
   'WEAPON_SNIPERRIFLE',
   'WEAPON_HEAVYSNIPER_MK2',
   'WEAPON_MARKSMANRIFLE',
   'WEAPON_MARKSMANRIFLE_MK2',
}