rootMenuConfig =  {
    {
        id = "cancelemotesroot",
        displayName = "Cancel Emotes",
        icon = "#cancelemotes",
        functionName = "e c",
        enableMenu = function()
            return not isDead
        end,
        group = "foot"
    },
    {
        id = "clothes",
        displayName = "Clothing",
        icon = "#clothing",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"clothes:mask", "clothes:hat", "clothes:gloves", "clothes:glasses", "clothes:hair", "clothes:pants", "clothes:shirt", "clothes:reset"},
        group = "foot"
    },
    {
        id = "carry",
        displayName = "Carry",
        icon = "#carry",
        functionName = "crcarry",
        enableMenu = function()
            return not isDead
        end,
        group = "foot"
    },
    {
        id = "Animations",
        displayName = "Animations",
        icon = "#animations",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"animations:thumbsup", "animations:finger", "animations:finger2", "animations:crossarms", "animations:facepalm", "animations:think", "animations:laychill", "animations:sitchill"},
        group = "foot"
    },
    {
        id = "Animations2",
        displayName = "Animations 2",
        icon = "#animations",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"animations:sitsad", "animations:sitfemale", "animations:whistle", "animations:whistle2", "animations:twerk", "animations:teddy", "animations:rose", "animations:flowers"},
        group = "foot"
    },
    {
        id = "engine",
        displayName = "Engine",
        icon = "#engine",
        functionName = "engine",
        enableMenu = function()
            return not isDead
        end,
        -- subMenus = {"animations:sitsad", "animations:sitfemale", "animations:whistle", "animations:whistle2", "animations:twerk", "animations:teddy", "animations:rose", "animations:flowers"},
        group = "car"
    },
    {
        id = "traction",
        displayName = "Traction",
        icon = "#traction",
        functionName = "traction",
        enableMenu = function()
            return not isDead
        end,
        -- subMenus = {"animations:sitsad", "animations:sitfemale", "animations:whistle", "animations:whistle2", "animations:twerk", "animations:teddy", "animations:rose", "animations:flowers"},
        group = "car"
    },
    {
        id = "cruise",
        displayName = "Cruise",
        icon = "#cruise",
        functionName = "cruise",
        enableMenu = function()
            return not isDead
        end,
        -- subMenus = {"animations:sitsad", "animations:sitfemale", "animations:whistle", "animations:whistle2", "animations:twerk", "animations:teddy", "animations:rose", "animations:flowers"},
        group = "car"
    },
    {
        id = "boot",
        displayName = "Boot",
        icon = "#boot",
        functionName = "boot",
        enableMenu = function()
            return not isDead
        end,
        -- subMenus = {"animations:sitsad", "animations:sitfemale", "animations:whistle", "animations:whistle2", "animations:twerk", "animations:teddy", "animations:rose", "animations:flowers"},
        group = "car"
    },
    {
        id = "hood",
        displayName = "Hood",
        icon = "#hood",
        functionName = "hood",
        enableMenu = function()
            return not isDead
        end,
        -- subMenus = {"animations:sitsad", "animations:sitfemale", "animations:whistle", "animations:whistle2", "animations:twerk", "animations:teddy", "animations:rose", "animations:flowers"},
        group = "car"
    },
    {
        id = "doors",
        displayName = "Doors",
        icon = "#doors",
        functionName = "doors",
        enableMenu = function()
            return not isDead
        end,
        -- subMenus = {"animations:sitsad", "animations:sitfemale", "animations:whistle", "animations:whistle2", "animations:twerk", "animations:teddy", "animations:rose", "animations:flowers"},
        group = "car"
    },
    {
        id = "window",
        displayName = "Windows",
        icon = "#windows",
        functionName = "windows",
        enableMenu = function()
            return not isDead
        end,
        -- subMenus = {"animations:sitsad", "animations:sitfemale", "animations:whistle", "animations:whistle2", "animations:twerk", "animations:teddy", "animations:rose", "animations:flowers"},
        group = "car"
    },
    {
        id = "keys",
        displayName = "Give Keys",
        icon = "#keys",
        functionName = "CR_VehicleLocksGiveKeys near",
        enableMenu = function()
            return not isDead
        end,
        -- subMenus = {"animations:sitsad", "animations:sitfemale", "animations:whistle", "animations:whistle2", "animations:twerk", "animations:teddy", "animations:rose", "animations:flowers"},
        group = "car"
    },
}

newSubMenus = {
    ['clothes:gloves'] = {
        title = "Gloves",
        icon = "#gloves",
        functionName = "gloves"
    }, 
    ['clothes:shoes'] = {
        title = "shoes",
        icon = "#shoes",
        functionName = "shoes"
    }, 
    ['clothes:hair'] = {
        title = "Hair",
        icon = "#hair",
        functionName = "hair"
    }, 
    ['clothes:hat'] = {
        title = "Hat",
        icon = "#hat",
        functionName = "hat"
    }, 
    ['clothes:glasses'] = {
        title = "Glasses",
        icon = "#glasses",
        functionName = "glasses"
    }, 
    ['clothes:ear'] = {
        title = "Ear",
        icon = "#ear",
        functionName = "ear"
    }, 
    ['clothes:neck'] = {
        title = "Necklace",
        icon = "#neck",
        functionName = "neck"
    }, 
    ['clothes:watch'] = {
        title = "Watch",
        icon = "#watch",
        functionName = "watch"
    }, 
    ['clothes:bracelet'] = {
        title = "Bracelet",
        icon = "#bracelet",
        functionName = "gloves"
    }, 
    ['clothes:mask'] = {
        title = "Mask",
        icon = "#mask",
        functionName = "mask"
    }, 
    ['clothes:pants'] = {
        title = "Pants",
        icon = "#pants",
        functionName = "pants"
    }, 
    ['clothes:shirt'] = {
        title = "Shirt",
        icon = "#shirt",
        functionName = "shirt"
    }, 
    ['clothes:reset'] = {
        title = "Reset",
        icon = "#reset",
        functionName = "reset"
    }, 
    ['animations:thumbsup'] = {
        title = "Thumbs Up",
        icon = "#thumbsup",
        functionName = "e thumbsup"
    }, 
    ['animations:finger'] = {
        title = "Finger",
        icon = "#finger",
        functionName = "e finger"
    }, 
    ['animations:finger2'] = {
        title = "Finger 2",
        icon = "#finger",
        functionName = "e finger2"
    }, 
    ['animations:crossarms'] = {
        title = "Cross Arms",
        icon = "#crossarms",
        functionName = "e crossarms"
    }, 
    ['animations:facepalm'] = {
        title = "Facepalm",
        icon = "#facepalm",
        functionName = "e facepalm4"
    }, 
    ['animations:think'] = {
        title = "Think",
        icon = "#think",
        functionName = "e think4"
    }, 
    ['animations:laychill'] = {
        title = "Lay Chill",
        icon = "#lay",
        functionName = "e chill"
    }, 
    ['animations:sitchill'] = {
        title = "Sit Chill",
        icon = "#sit",
        functionName = "e sit5"
    }, 
    ['animations:sitsad'] = {
        title = "Sit Sad",
        icon = "#sad",
        functionName = "e sit7"
    }, 
    ['animations:sitfemale'] = {
        title = "Sit Female",
        icon = "#sit",
        functionName = "e sit4"
    }, 
    ['animations:whistle'] = {
        title = "Whistle",
        icon = "#whistle",
        functionName = "e whistle"
    }, 
    ['animations:whistle2'] = {
        title = "Whistle 2",
        icon = "#whistle",
        functionName = "e whistle2"
    }, 
    ['animations:twerk'] = {
        title = "Twerk",
        icon = "#twerk",
        functionName = "e twerk"
    }, 
    ['animations:teddy'] = {
        title = "Teddy",
        icon = "#teddy",
        functionName = "e teddy"
    }, 
    ['animations:rose'] = {
        title = "Rose",
        icon = "#flowers",
        functionName = "e rose"
    }, 
    ['animations:flowers'] = {
        title = "Flowers",
        icon = "#flowers",
        functionName = "e flowers"
    }, 
}