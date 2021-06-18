Config = {}

Config.AlignMenu              = "center" -- this is where the menu is located [left, right, center, top-right, top-left etc.]
Config.CreateTableInDatabase  = false -- enable this the first time you start the script, this will create everything in the database.
Config.MotelPrice             = 10000 -- this is the price that you will pay when you buy the motel.
Config.SellPrice              = 2500 -- this is the price they get back if they sell the motel.
Config.Weapons                = true -- enable this if you want weapons in the storage.
Config.DirtyMoney             = true -- enable this if you want dirty money in the storage.
Config.Debug                  = false -- enable this only if you know what you're doing.

Config.MotelInterior = {
    ["exit"] = vector3(265.94, -1007.19, -101.01),
    ["drawer"] = vector3(265.64, -999.49, -99.01),
    ["bed"] = vector3(262.07, -1003.07, -99.01),
    ["wardrobe"] = vector3(259.89, -1004.04, -99.01),
    ["invite"] = vector3(264.73, -1002.77, -99.01)
}

Config.ActionLabel = {
    ["exit"] = "Exit",
    ["drawer"] = "Drawer",
    ["bed"] = "Bed",
    ["wardrobe"] = "Wardrobe",
    ["invite"] = "Invite"
}

Config.LandLord = {
    ["position"] = vector3(1141.76, 2663.87, 38.16)
}

Config.HelpTextMessage = "-1 ~INPUT_CELLPHONE_LEFT~ & ~INPUT_CELLPHONE_RIGHT~ +1 ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_MP_TEXT_CHAT_TEAM~ Buy The Room For ($" .. Config.MotelPrice .. ") ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_FRONTEND_CANCEL~ Cancel ~n~"

Config.MotelsEntrances = { -- every motel entrance, add more if you want another one.
    [1] = vector3(1142.42,  2654.63, 38.15),
    [2] = vector3(1142.34,  2651.09, 38.15),
    [3] = vector3(1142.37,  2643.57, 38.15),
    [4] = vector3(1141.18,  2641.64, 38.15),
    [5] = vector3(1136.29,  2641.66, 38.15),
    [6] = vector3(1132.70,  2641.66, 38.15),
    [7] = vector3(1125.19,  2641.74, 38.15),
    [8] = vector3(1121.41,  2641.64, 38.15),	
	[9] = vector3(1114.69,  2641.65, 38.15),
	[10] = vector3(1107.11, 2641.66, 38.15),
	[11] = vector3(1106.11, 2649.06, 38.15),	
	[12] = vector3(1106.01, 2652.84, 38.15),	
}

Config.GenerateUniqueId = function()
    math.randomseed(GetGameTimer() + math.random())
    return math.random(1000000, 9999999)
end

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