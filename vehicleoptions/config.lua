Config = {}

Config.TCon     = true --- Enable/Disable Traction Control
Config.CCon     = true --- Enable/Disable Cruise Control
Config.Maxspeed = 37.0 --- In meters per second 34 = 75mph
Config.Minspeed = 5.0 --- In meters per second 0.1 = 0.2mph
Config.action   = 0.2     --- How much the TC wil try to stop you sliding Lower = more help


Config.SimpleCCimmage = true 
Config.SimpleTCimmage = true 


 UITC = {
	x =  0.83,	-- Traction Control Screen Coords 	0.0-1.0 left to right 
	y = 0.720,	-- Traction Control Screen Coords 	0.0-1.0 = top to bottom
}
 UI = {
	x =  0.81,	-- Cruise Control Screen Coords 	0.0-1.0 left to right 
	y =  0.720, -- Cruise Control Screen Coords 	0.0-1.0 = top to bottom
}