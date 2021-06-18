Config = {}
Config.Locale = "en"
Config.IncludeCash = true -- Include cash in inventory?
Config.IncludeWeapons = true -- Include weapons in inventory?
Config.IncludeAccounts = true -- Include accounts (bank, black money, ...)?
Config.ExcludeAccountsList = {"bank"} -- List of accounts names to exclude from inventory
Config.OpenControl = 289 -- Key for opening inventory. Edit html/js/config.js to change key for closing it.

-- List of item names that will close ui when used
Config.CloseUiItems = {"tuning_laptop","notepad", "hdevice", "plate", "origplate", "binoculars", "handcuffkeys", "lowgrademaleseed", "highgrademaleseed", "lowgradefemaleseed", "highgradefemaleseed", "VehicleLicense", "WeaponLicense",}

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
   'WEAPON_FLARE',   
   'WEAPON_NIGHTSTICK', 
   'WEAPON_BOTTLE', 
   'WEAPON_WRENCH', 
   'WEAPON_PETROLCAN',
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