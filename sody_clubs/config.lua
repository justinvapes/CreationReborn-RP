Config              = {
	Locale = "en"
}

Config.DrawDistance = 50.0
Config.MarkerType = 25
Config.MarkerSize = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor = { r = 113, g = 204, b = 81 }
Config.ClubBlipPre = "Club House: " --Prefix to Blip Name on map
Config.PayInterval = 28 * 60000 -- Adjust '28' to set payout time in minutes
Config.EnableClubBankPay = true -- Enables Pay to come out of club's bank instead of thin air
Config.EnableESXIdentity = true -- Shows characer first/lastname instead of Steam name in member menu
Config.GarageScript = "eden_garage" -- 'eden_garage' (for eden_garage/esx_drp_garage) or 'esx_advancedgarage' supported

Config.ClubBlips = { -- Only shown to club members
	hhmc = { -- Must match Database name
		BlipSprite = 226,
		BlipPos = {130.22, y = 314.63, z = 112.13},
		BlipColor = 5,
	},
}

Config.Clubs = {
	hhmc = { -- Must match Database name
		-- Garage = { -- Vehicle Garage
		-- 	x = 967.06, y = -121.28, z = 73.35, h = 136.05
		-- },

		Perms = {
			StorageRankMin = 1,
			StorageRankMinPriv = 3
		},

		Zones = {

			ChangingRoom = {
				Pos   = {x = 143.73, y = 331.93, z = 116.61},
				Size  = {x = 0.5, y = 0.5, z = 0.5},
				Color = {r = 255, g = 0, b = 0},
				Marker= 21,
				Blip  = false,
				Name  = _U('lockertitle'),
				Type  = "changingroom",
				Hint  = _U('changing_room'),
			},

			-- Storage1 = {
			-- 	Pos   = {x = 972.25, y = -98.99, z = 73.85},
			-- 	Size  = {x = 0.5, y = 0.5, z = 0.5},
			-- 	Color = {r = 255, g = 0, b = 0},
			-- 	Marker= 21,
			-- 	Blip  = false,
			-- 	Name  = _U('storage'),
			-- 	Type  = "storagepub", -- Public storage, available to all members
			-- 	Hint  = _U('storage_info'),
			-- },

			Storage1 = {
				Pos   = {x = 132.39, y = 336.99, z = 116.61},
				Size  = {x = 0.5, y = 0.5, z = 0.5},
				Color = {r = 255, g = 0, b = 0},
				Marker= 21,
				Blip  = false,
				Name  = _U('storage'),
				Type  = "storagepriv", -- Private Storage, requires StorageRankMin
				Hint  = _U('storage_info'),
			},

			--[[
			Teleporter1 = { -- If using an IPL as clubhouse
				Pos   = {x = 1930.01, y = 4635.41, z = 39.47},
				PosDest   = {x = 1120.96, y = -3152.21, z = -38.05},
				PosDestH   = 1.02,
				Size  = {x = 0.7, y = 0.7, z = 0.5},
				Color = {r = 0, g = 100, b = 255},
				Marker= 25,
				Blip  = false,
				Name  = _U('lmcteleporter1'),
				Type  = "teleport",
				Hint  = _U('lmcteleporter1_info'),
			},

			Teleporter2 = { -- If using an IPL as clubhouse
				Pos   = {x = 1120.96, y = -3152.21, z = -38.05},
				PosDest   = {x = 1930.01, y = 4635.41, z = 39.47},
				PosDestH   = 357.25,
				Size  = {x = 0.7, y = 0.7, z = 0.5},
				Color = {r = 0, g = 100, b = 255},
				Marker= 25,
				Blip  = false,
				Name  = _U('lmcteleporter2'),
				Type  = "teleport",
				Hint  = _U('lmcteleporter2_info'),
			},

			GarageTeleporter1 = { -- If using an IPL as clubhouse
				Pos   = {x = 1927.92, y = 4603.3, z = 38.16},
				PosDest   = {x = 1109.06, y = -3162.71, z = -38.53},
				PosDestH   = 0.3,
				Size  = {x = 1.5, y = 1.5, z = 0.5},
				Color = {r = 0, g = 200, b = 5},
				Marker= 1,
				Blip  = false,
				Name  = _U('lmcgteleporter1'),
				Type  = "gteleport",
				Hint  = _U('lmcgteleporter1_info'),
			},

			GarageTeleporter2 = { -- If using an IPL as clubhouse
				Pos   = {x = 1109.06, y = -3162.71, z = -38.53},
				PosDest   = {x = 1927.92, y = 4603.3, z = 38.16},
				PosDestH   = 199.53,
				Size  = {x = 1.5, y = 1.5, z = 0.5},
				Color = {r = 0, g = 200, b = 5},
				Marker= 1,
				Blip  = false,
				Name  = _U('lmcgteleporter2'),
				Type  = "gteleport",
				Hint  = _U('lmcgteleporter2_info'),
			},
			]]--

			Owner = { -- Owner menu location
				Pos   = {x = 139.62, y = 340.19, z = 116.62},
				Size  = {x = 0.5, y = 0.5, z = 0.5},
				Color = {r = 255, g = 0, b = 0},
				Marker= 21,
				Blip  = false,
				Name  = _U('hhmcmenu'),
				Type  = "owner",
				Hint  = _U('hhmcmenu_info'),
			},	
		},
					
		Clothes = {
			{
				label = 'President',
				male = {		
					['bproof_1'] = 18,  ['bproof_2'] = 0
				},
				female = {
					['bproof_1'] = 0,  ['bproof_2'] = 0
				}
			},		
			{
				label = 'Vice President',
				male = {		
					['bproof_1'] = 18,  ['bproof_2'] = 2
				},
				female = {
					['bproof_1'] = 0,  ['bproof_2'] = 0
				}
			},		
			{
				label = 'Sergeant At Arms',
				male = {		
					['bproof_1'] = 18,  ['bproof_2'] = 3
				},
				female = {
					['bproof_1'] = 0,  ['bproof_2'] = 0
				}
			},		
			{
				label = 'Road Captain',
				male = {		
					['bproof_1'] = 18,  ['bproof_2'] = 4
				},
				female = {
					['bproof_1'] = 0,  ['bproof_2'] = 0
				}
			},		
			{
				label = 'Enforcer',
				male = {		
					['bproof_1'] = 18,  ['bproof_2'] = 5
				},
				female = {
					['bproof_1'] = 0,  ['bproof_2'] = 0
				}
			},		
			{
				label = 'Treasurer',
				male = {		
					['bproof_1'] = 18,  ['bproof_2'] = 6
				},
				female = {
					['bproof_1'] = 0,  ['bproof_2'] = 0
				}
			},		
			{
				label = 'Patched',
				male = {		
					['bproof_1'] = 15,  ['bproof_2'] = 0
				},
				female = {
					['bproof_1'] = 0,  ['bproof_2'] = 0
				}
			},		
			{
				label = 'Prospect',
				male = {		
					['bproof_1'] = 16,  ['bproof_2'] = 0
				},
				female = {
					['bproof_1'] = 0,  ['bproof_2'] = 0
				}
			},	
			{
				label = 'Remove Vest',
				male = {		
					['bproof_1'] = 0,  ['bproof_2'] = 0
				},
				female = {
					['bproof_1'] = 0,  ['bproof_2'] = 0
				}
			},
		}
	},
}
