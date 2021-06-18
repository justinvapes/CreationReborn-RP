Config = {}
Config.Locale = 'en'

Config.DoorList = {
	
	-- Entrance Doors
	-- Front
	{
		textCoords = vector3(434.7, -982.0, 31.5),
		authorizedJobs = { 'police', 'offpolice' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = GetHashKey('gabz_mrpd_reception_entrancedoor'),
				objYaw = -90.0,
				objCoords = vector3(434.7444, -980.7556, 30.8153)
			},

			{
				objName = GetHashKey('gabz_mrpd_reception_entrancedoor'),
				objYaw = 90.0,
				objCoords = vector3(434.7444, -983.0781, 30.8153)
			}
		}
	},
	
	-- Side
	{
		textCoords = vector3(457.09, -972.21, 31.5),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = GetHashKey('gabz_mrpd_reception_entrancedoor'),
				objYaw = 0.0,
				objCoords = vector3(455.8862, -972.2543, 30.81531)
			},

			{
				objName = GetHashKey('gabz_mrpd_reception_entrancedoor'),
				objYaw = 180.0,
				objCoords = vector3(458.2087, -972.2543, 30.81531)
			}
		}
	},
	-- Carpark
	{
		textCoords = vector3(441.94, -998.66, 31.5),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = GetHashKey('gabz_mrpd_reception_entrancedoor'),
				objYaw = 0.0,
				objCoords = vector3(440.7392, -998.7462, 30.8153)
			},

			{
				objName = GetHashKey('gabz_mrpd_reception_entrancedoor'),
				objYaw = 180.0,
				objCoords = vector3(443.0618, -998.7462, 30.8153)
			}
		}
	},
	-- Rear Entrance
	{
		textCoords = vector3(468.3686, -1014.406, 26.48382),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = GetHashKey('gabz_mrpd_door_03'),
				objYaw = 180.0,
				objCoords = vector3(469.7743, -1014.406, 26.48382)
			},

			{
				objName = GetHashKey('gabz_mrpd_door_03'),
				objYaw = 0.0,
				objCoords = vector3(467.3686, -1014.406, 26.48382)
			}
		}
	},
	{
		objName = GetHashKey('gabz_mrpd_bollards1'),
		objYaw = nil,
		objCoords  = vector3(410.0258, -1024.226, 29.22022),
		textCoords = vector3(410.0258, -1024.226, 30.22022),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 10.0,
		size = 2
	},
	{
		objName = GetHashKey('gabz_mrpd_bollards2'),
		objYaw = nil,
		objCoords  = vector3(410.0258, -1024.22, 29.2202),
		textCoords = vector3(-555555555, -1024.226, 30.22022),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 10.0,
		size = 2
	},

	--Internal Doors
	--Reception Doors
	{
		objName = GetHashKey('gabz_mrpd_door_04'),
		objYaw = 0.0,
		objCoords  = vector3(440.5201, -977.6011, 30.82319),
		textCoords = vector3(441.5201, -977.6011, 30.82319),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.0,
		size = 1
	},
	{
		objName = GetHashKey('gabz_mrpd_door_05'),
		objYaw = 180.0,
		objCoords  = vector3(440.5201, -986.2335, 30.82319),
		textCoords = vector3(441.5201, -986.2335, 30.82319),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.0,
		size = 1
	},

	--Upper Door
	{
		objName = GetHashKey('gabz_mrpd_door_03'),
		objYaw = 90.0,
		objCoords  = vector3(464.3086, -984.5284, 43.77124),
		textCoords = vector3(464.3086, -984.0, 43.67124),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.0,
		size = 1
	},

	--Interrogation 2
	{
		objName = GetHashKey('gabz_mrpd_door_04'),
		objYaw = -90.0,
		objCoords  = vector3(482.6703, -995.7285, 26.40548),
		textCoords = vector3(482.6703, -996.3, 26.40548),
		authorizedJobs = { 'police'},
		locked = true,
		distance = 2.0,
		size = 1
	},

	--Interrogation 1
	{
		objName = GetHashKey('gabz_mrpd_door_04'),
		objYaw = -90.0,
		objCoords  = vector3(482.6701, -987.5792, 26.40548),
		textCoords = vector3(482.6701, -988.16, 26.40548),
		authorizedJobs = { 'police'},
		locked = true,
		distance = 2.0,
		size = 1
	},

	--Cell Outer Door
	{
		objName = GetHashKey('gabz_mrpd_cells_door'),
		objYaw = -90.0,
		objCoords  = vector3(476.6157, -1008.875, 26.48005),
		textCoords = vector3(476.6157, -1008.3, 26.48005),
		authorizedJobs = { 'police'},
		locked = true,
		distance = 2.0,
		size = 1
	},

	--Cell Outer Door2
	{
		objName = GetHashKey('gabz_mrpd_cells_door'),
		objYaw = -180.0,
		objCoords  = vector3(481.0084, -1004.118, 26.48005),
		textCoords = vector3(481.63, -1004.118, 26.68005),
		authorizedJobs = { 'police'},
		locked = true,
		distance = 2.0,
		size = 1
	},

	--Cell 5
	{
		objName = GetHashKey('gabz_mrpd_cells_door'),
		objYaw = -180.0,
		objCoords  = vector3(484.1764, -1007.734, 26.48005),
		textCoords = vector3(484.83, -1007.734, 26.48005),
		authorizedJobs = { 'police'},
		locked = true,
		distance = 1.0,
		size = 1
	},

	--Cell 4
	{
		objName = GetHashKey('gabz_mrpd_cells_door'),
		objYaw = 0.0,
		objCoords  = vector3(486.9131, -1012.189, 26.48005),
		textCoords = vector3(486.4, -1012.189, 26.48005),
		authorizedJobs = { 'police'},
		locked = true,
		distance = 1.0,
		size = 1
	},

	--Cell 3
	{
		objName = GetHashKey('gabz_mrpd_cells_door'),
		objYaw = 0.0,
		objCoords  = vector3(483.9127, -1012.189, 26.48005),
		textCoords = vector3(483.25, -1012.189, 26.48005),
		authorizedJobs = { 'police'},
		locked = true,
		distance = 1.0,
		size = 1
	},

	--Cell 2
	{
		objName = GetHashKey('gabz_mrpd_cells_door'),
		objYaw = 0.0,
		objCoords  = vector3(480.9128, -1012.189, 26.48005),
		textCoords = vector3(480.2528, -1012.189, 26.48005),
		authorizedJobs = { 'police'},
		locked = true,
		distance = 1.0,
		size = 1
	},

	--Cell 1
	{
		objName = GetHashKey('gabz_mrpd_cells_door'),
		objYaw = 0.0,
		objCoords  = vector3(477.9126, -1012.189, 26.48005),
		textCoords = vector3(477.36, -1012.189, 26.48005),
		authorizedJobs = { 'police'},
		locked = true,
		distance = 1.0,
		size = 1
	},

	--Garage 1
	{
		objName = GetHashKey('gabz_mrpd_room13_parkingdoor'),
		objYaw = 90.0,
		objCoords  = vector3(464.1566, -997.5093, 26.3707),
		textCoords = vector3(464.1566, -997, 26.3707),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 1.0,
		size = 1
	},

	--Garage 2
	{
		objName = GetHashKey('gabz_mrpd_room13_parkingdoor'),
		objYaw = -90.0,
		objCoords  = vector3(464.1566, -974.6656, 26.3707),
		textCoords = vector3(464.1566, -975.3, 26.3707),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 1.0,
		size = 1
	},



	--Lower Internal Doors
	{
		textCoords = vector3(468.77, -1000.544, 26.50),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = GetHashKey('gabz_mrpd_door_01'),
				objYaw = 180.0,
				objCoords = vector3(469.9274, -1000.544, 26.40548)
			},

			{
				objName = GetHashKey('gabz_mrpd_door_01'),
				objYaw = 0.0,
				objCoords = vector3(467.5222, -1000.544, 26.40548)
			}
		}
	},
	{
		textCoords = vector3(471.3679, -1008.793, 26.40548),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = GetHashKey('gabz_mrpd_door_02'),
				objYaw = -90.0,
				objCoords = vector3(471.3679, -1007.793, 26.40548)
			},

			{
				objName = GetHashKey('gabz_mrpd_door_02'),
				objYaw = 90.0,
				objCoords = vector3(471.3679, -1010.198, 26.40548)
			}
		}
	},




	-- Back Gate
	{
		objName = GetHashKey('hei_prop_station_gate'),
		objYaw = 90.0,
		objCoords  = vector3(488.89480, -1017.21, 27.14843),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 15,
		size = 2
	},
	-- Front Gate
	-- {
	-- 	objName = GetHashKey('hei_prop_station_gate'),
	-- 	objYaw = 90.0,
	-- 	objCoords  = vector3(420.1533, -1017.018, 28.07248),
	-- 	textCoords = vector3(420.06, -1019.92, 30.02),
	-- 	authorizedJobs = { 'police', 'offpolice' },
	-- 	locked = true,
	-- 	distance = 15,
	-- 	size = 2
	-- },
	
	
	--Nightclub--	
	
	--Front Door
	{
		objName = GetHashKey('ba_prop_door_club_entrance'),
		objYaw = 165.6,
		objCoords  = vector3(355.69, 301.02, 104.20),
		textCoords = vector3(354.94, 301.14, 104.03),
		authorizedJobs = {'nightclub', 'offnightclub', 'police'},
		locked = false,
		distance = 2.0,
		size = 1
	},
	
	--VIP Door
	{
		objName = GetHashKey('ba_prop_door_club_generic_vip'),
		objYaw = 74.5,
		objCoords  = vector3(377.78, 267.77, 95.14),
		textCoords = vector3(377.87, 268.47, 94.99),
		authorizedJobs = {'nightclub', 'offnightclub', 'police'},
		locked = true,
		distance = 2.0,
		size = 1
	},
	
	--Back Door
	-- {
	-- 	objHash = '390840000',
	-- 	objYaw = 74.5,
	-- 	objCoords  = vector3(380.15540, 266.635, 91.35513),
	-- 	textCoords = vector3(380.16, 266.63, 91.36),
	-- 	authorizedJobs = {'nightclub', 'offnightclub', 'police'},
	-- 	locked = true,
	-- 	distance = 2.0,
	-- 	size = 1
	-- },

    --Unicorn--	
	
	--Back Door
	{
		objName = GetHashKey('prop_magenta_door'),
		objYaw = 210.0,
		objCoords  = vector3(96.09, -1284.85, 29.43),
		textCoords = vector3(95.52, -1285.12, 29.28),
		authorizedJobs = {'unicorn', 'offunicorn', 'police'},
		locked = true,
		distance = 2.0,
		size = 1
	},
	
	--VIP Door
	{
		objName = GetHashKey('v_ilev_roc_door2'),
		objYaw = 30.0,
		objCoords  = vector3(99.08, -1293.70, 29.41),
		textCoords = vector3(99.62, -1293.29, 29.27),
		authorizedJobs = {'unicorn', 'offunicorn', 'police'},
		locked = true,
		distance = 2.0,
		size = 1
	},
	
	--Dresser Door
	{
		objName = GetHashKey('v_ilev_door_orangesolid'),
		objYaw = -60.0,
		objCoords  = vector3(113.98, -1297.43, 29.41),
		textCoords = vector3(113.70, -1296.78, 29.27),
		authorizedJobs = {'unicorn', 'offunicorn', 'police'},
		locked = true,
		distance = 2.0,
		size = 1
	},

	--HHMC Clubhouse
	{ -- Front Door
		objName = -1953149158,
		objYaw = 23.5,
		objCoords  = vector3(134.10990, 323.82870, 116.80220),
		textCoords = vector3(134.75, 324.00, 117.30220),
		authorizedJobs = {'police'},
		authorizedClubs = { 'hhmc', },
		authorizedClubRank = { 0 },
		locked = true,
		distance = 2.0,
		size = 1
	},
	{ -- Front Gate
		objName = GetHashKey('prop_facgate_07b'),
		-- objYaw = 111.15410,
		objCoords  = vector3(108.43840, 328.95970, 111.15410),
		textCoords = vector3(108.43840, 328.95970, 111.15410),
		authorizedJobs = {'police'},
		authorizedClubs = { 'hhmc', },
		authorizedClubRank = { 0 },
		locked = true,
		distance = 20.0,
		size = 2
	},
	{ -- Pres Door
		objName = -1186396713,
		objYaw = -65.43962,
		objCoords  = vector3(140.16520, 335.51000, 116.77470),
		textCoords = vector3(140.00, 336.13, 117.27470),
		authorizedJobs = {'police'},
		authorizedClubs = { 'hhmc', },
		authorizedClubRank = { 6 },
		locked = true,
		distance = 2.0,
		size = 1
	},
}