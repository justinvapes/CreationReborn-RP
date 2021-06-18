Config = {}
Config.Locale = 'en'

Config.Price = 200

Config.DrawDistance = 100.0
Config.MarkerSize   = {x = 1.5, y = 1.5, z = 1.0}
Config.MarkerColor  = { r = 255, g = 0, b = 0 }
Config.MarkerType   = 27

Config.Zones = {}

Config.Shops = {
  {x=-703.82,   y=-152.05,  z=36.43},
  {x=428.694,   y=-800.106,  z=28.505},
  {x=-829.413,  y=-1073.710, z=10.333}, 
  {x=11.632,    y=6514.224,  z=30.882}, 
  {x=617.72,   y=2766.66,  z=41.092}, 
  {x=-3175.44, y=1041.75,  z=19.870}
}

for i=1, #Config.Shops, 1 do
	Config.Zones['Shop_' .. i] = {
		Pos   = Config.Shops[i],
		Size  = Config.MarkerSize,
		Color = Config.MarkerColor,
		Type  = Config.MarkerType
	}
end

Config.Zones2 = {}

Config.Shops2 = {
  {x=1103.41, y=196.01,  z=-50.40}
}

for i=1, #Config.Shops2, 1 do
	Config.Zones2['Shop_' .. i] = {
		Pos   = Config.Shops2[i],
		Size  = Config.MarkerSize,
		Color = Config.MarkerColor,
		Type  = Config.MarkerType
	}
end

Config.HelmetBL = {
	10, -- PD Hat
	122, -- AMB Hat
}

Config.ChainBL = {
	125, -- Badge
	127, -- Badge
	128, -- Badge
}

Config.FTorsoBL = {
	{192, 0}, -- PD Short
	{195, 0},-- PD Long
	{223, 20},-- PD SOG
	{254, 0}, -- AMB Student
	{254, 1}, -- AMB Paramedic
	{254, 2}, -- AMB Supervisor
	{254, 3}, -- AMB Supervisor
	{254, 4}, -- AMB Supervisor
	{254, 5}, -- AMB Supervisor
	{254, 6}, -- AMB Supervisor
	{254, 7}, -- AMB Manager
}

Config.MTorsoBL = {
	{190, 0}, -- PD Short
	{193, 0}, -- PD Long
	{219, 20}, -- PD SOG
	{246, 0}, -- AMB Student
	{246, 1}, -- AMB Paramedi
	{246, 2}, -- AMB SUpervisor
	{246, 3}, -- AMB SUpervisor
	{246, 4}, -- AMB SUpervisor
	{246, 5}, -- AMB SUpervisor
	{246, 6}, -- AMB SUpervisor
	{246, 7}, -- AMB Manager
}

-- Config.FTshirtBL = {
-- 	152,
-- }

-- Config.FPantsBL = {
-- 	99,
-- 	33
-- }

