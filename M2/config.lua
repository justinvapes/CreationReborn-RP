Config = {}

Config.AlignMenu = "center" -- this is where the menu is located [left, right, center, top-right, top-left etc.]

Config.CreateTableInDatabase = false -- enable this the first time you start the script, this will create everything in the database.

Config.MotelPrice = 50000 -- this is the price that you will pay when you buy the motel.

Config.Weapons = true -- enable this if you want weapons in the storage.
Config.DirtyMoney = true -- enable this if you want dirty money in the storage.

Config.Debug = false -- enable this only if you know what you're doing.

Config.MotelInterior = {
    ["exit"] = vector3(346.48, -1012.46, -99.20),
    ["drawer"] = vector3(351.25, -999.26, -99.20),
    ["bed"] = vector3(351.26, -996.25, -99.20),
    ["wardrobe"] = vector3(350.78, -994.04, -99.20),
    ["invite"] = vector3(346.08, -1001.69, -99.20)
}

Config.ActionLabel = {
    ["exit"] = "Exit",
    ["drawer"] = "Drawer",
    ["bed"] = "Bed",
    ["wardrobe"] = "Wardrobe",
    ["invite"] = "Invite"
}

Config.LandLord = {
    ["position"] = vector3(570.47, -1746.76, 29.22)
}

Config.HelpTextMessage = "-1 ~INPUT_CELLPHONE_LEFT~ & ~INPUT_CELLPHONE_RIGHT~ +1 ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_MP_TEXT_CHAT_TEAM~ Buy The Room For ($" .. Config.MotelPrice .. ") ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_FRONTEND_CANCEL~ Cancel ~n~"

Config.MotelsEntrances = { -- every motel entrance, add more if you want another one.
    [1] = vector3(566.18, -1778.17, 29.35),
    [2] = vector3(550.30, -1775.52, 29.31),
    [3] = vector3(552.19, -1771.50, 29.31),
    [4] = vector3(554.62, -1766.62, 29.31),
    [5] = vector3(557.72, -1759.63, 29.31),
    [6] = vector3(561.38, -1751.77, 29.31),
    [7] = vector3(559.07, -1777.35, 33.50),
    [8] = vector3(550.07, -1770.49, 33.50),
    [9] = vector3(552.64, -1765.31, 33.50),
    [10] = vector3(555.59,-1758.67, 33.50),
    [11] = vector3(559.26,-1750.78, 33.50),
    [12] = vector3(561.87,-1747.33, 33.50),
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