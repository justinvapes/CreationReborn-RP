Config = {}
Config.Locale = 'en'

Config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 1.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

Config.PoliceNumberRequired = 2
Config.TimerBeforeNewRob    = 1800 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

Config.MaxDistance    = 15   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

Stores = {
	["littleseoul_twentyfourseven"] = {
		position = { x = -709.17, y = -904.21, z = 19.21 },--DONE
		reward = math.random(20000, 30000),
		nameOfStore = "24/7. (Little Seoul)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["grapeseed_twentyfourseven"] = {
		position = { x = 1707.67, y = 4920.12, z = 42.06 },--DONE
		reward = math.random(20000, 30000),
		nameOfStore = "24/7. (Grapeseed)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["harmony_twentyfourseven"] = {
		position = { x = 546.32, y = 2663.29, z = 42.16 },--DONE
		reward = math.random(20000, 30000),
		nameOfStore = "24/7. (harmony)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["chumash_twentyfourseven"] = {
		position = { x = -3249.54, y = 1004.39, z = 12.83 },--DONE
		reward = math.random(20000, 30000),
		nameOfStore = "24/7. (Chumash Barbareno)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["tataviam_twentyfourseven"] = {
		position = { x = 2549.8, y = 384.87, z = 108.62 },--DONE
		reward = math.random(20000, 30000),
		nameOfStore = "24/7. (Tataviam mountains)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["grove_ltd"] = {
		position = { x = -43.40, y = -1749.20, z = 29.42 },--DONE
		reward = math.random(20000, 30000),
		nameOfStore = "LTD Gasoline. (Grove Street)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["mirror_ltd"] = {
		position = { x = 1160.67, y = -314.40, z = 69.20 },--DONE
		reward = math.random(20000, 30000),
		nameOfStore = "LTD Gasoline. (Mirror Park Boulevard)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	}
}
