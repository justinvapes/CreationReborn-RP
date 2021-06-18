Config = {}

--The Popup when you get near one of the marked atms below
Config.HelpTextMessage = "~y~Press ~w~~INPUT_PICKUP~ To ~g~Access ~w~Your ~b~Account ~w~~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~y~Press ~w~~INPUT_DETONATE~ To ~r~Hack ~w~The ~b~ATM~"

--The amount they receive when successfully hacking the atm
Config.Amount = math.random(100,5500)

--How Many Police Are Needed Online To Rob The Houses
Config.PoliceNeeded = 1

--Calculated Off Less Than Or Equal To <=. So 50 is 50% chance. Lower Means Less Chance Of It Happening
Config.PoliceChance = 30 -- 30% Chance Of The Police Being Alerted

--Cooldown For Client Once A ATM Has Been Robbed. [In Minutes]
Config.CooldownTime = 10

--The atms around the map
Config.Atms = {
  {name="ATM", id=277, x=472.58,    y=-1001.6,   z=30.69},
  {name="ATM", id=277, x=468.3,     y=-990.55,   z=26.27},
  {name="ATM", id=277, x=-821.51,   y=-1082.09,  z=11.13},
  {name="ATM", id=277, x=2742.15,   y=3464.88,   z=55.67},
  {name="ATM", id=277, x=258.22,    y=-260.56,   z=54.04},
  {name="ATM", id=277, x=-38.43,    y=-1115.55,  z=26.44},
  {name="ATM", id=277, x=-201.05,   y=-1309.12,  z=31.29},
  {name="ATM", id=277, x=-386.733,  y=6045.953,  z=31.501},
  {name="ATM", id=277, x=-284.037,  y=6224.385,  z=31.187},
  {name="ATM", id=277, x=-284.037,  y=6224.385,  z=31.187},
  {name="ATM", id=277, x=-135.165,  y=6365.738,  z=31.101},
  {name="ATM", id=277, x=-110.753,  y=6467.703,  z=31.784},
  {name="ATM", id=277, x=-94.9690,  y=6455.301,  z=31.784},
  {name="ATM", id=277, x=155.4300,  y=6641.991,  z=31.784},
  {name="ATM", id=277, x=174.6720,  y=6637.218,  z=31.784},
  {name="ATM", id=277, x=1703.138,  y=6426.783,  z=32.730},
  {name="ATM", id=277, x=1735.114,  y=6411.035,  z=35.164},
  {name="ATM", id=277, x=1702.842,  y=4933.593,  z=42.051},
  {name="ATM", id=277, x=1967.333,  y=3744.293,  z=32.272},
  {name="ATM", id=277, x=1821.917,  y=3683.483,  z=34.244},
  {name="ATM", id=277, x=1174.532,  y=2705.278,  z=38.027},
  {name="ATM", id=277, x=540.0420,  y=2671.007,  z=42.177},
  {name="ATM", id=277, x=2564.399,  y=2585.100,  z=38.016},
  {name="ATM", id=277, x=2558.683,  y=349.6010,  z=108.050},
  {name="ATM", id=277, x=2558.051,  y=389.4817,  z=108.660},
  {name="ATM", id=277, x=1077.692,  y=-775.796,  z=58.218},
  {name="ATM", id=277, x=1139.018,  y=-469.886,  z=66.789},
  {name="ATM", id=277, x=1168.975,  y=-457.241,  z=66.641},
  {name="ATM", id=277, x=1153.884,  y=-326.540,  z=69.245},
  {name="ATM", id=277, x=381.2827,  y=323.2518,  z=103.270},
  {name="ATM", id=277, x=285.2029,  y=143.5690,  z=104.970},
  {name="ATM", id=277, x=157.7698,  y=233.5450,  z=106.450},
  {name="ATM", id=277, x=-164.568,  y=233.5066,  z=94.919},
  {name="ATM", id=277, x=-1827.04,  y=785.5159,  z=138.020},
  {name="ATM", id=277, x=-1409.39,  y=-99.2603,  z=52.473},
  {name="ATM", id=277, x=-1205.35,  y=-325.579,  z=37.870},
  {name="ATM", id=277, x=-1215.64,  y=-332.231,  z=37.881},
  {name="ATM", id=277, x=-2072.41,  y=-316.959,  z=13.345},
  {name="ATM", id=277, x=-2975.72,  y=379.7737,  z=14.992},
  {name="ATM", id=277, x=-2962.60,  y=482.1914,  z=15.762},
  {name="ATM", id=277, x=-2955.70,  y=488.7218,  z=15.486},
  {name="ATM", id=277, x=-3044.22,  y=595.2429,  z=7.595},
  {name="ATM", id=277, x=-3144.13,  y=1127.415,  z=20.868},
  {name="ATM", id=277, x=-3241.10,  y=996.6881,  z=12.500},
  {name="ATM", id=277, x=-3241.11,  y=1009.152,  z=12.877},
  {name="ATM", id=277, x=-1305.40,  y=-706.240,  z=25.352},
  {name="ATM", id=277, x=-538.225,  y=-854.423,  z=29.234},
  {name="ATM", id=277, x=-711.156,  y=-818.958,  z=23.768},
  {name="ATM", id=277, x=-717.614,  y=-915.880,  z=19.268},
  {name="ATM", id=277, x=-526.566,  y=-1222.90,  z=18.434},
  {name="ATM", id=277, x=-256.831,  y=-719.646,  z=33.444},
  {name="ATM", id=277, x=-203.548,  y=-861.588,  z=30.205},
  {name="ATM", id=277, x=112.4102,  y=-776.162,  z=31.427},
  {name="ATM", id=277, x=112.9290,  y=-818.710,  z=31.386},
  {name="ATM", id=277, x=119.9000,  y=-883.826,  z=31.191},
  {name="ATM", id=277, x=-846.304,  y=-340.402,  z=38.687},
  {name="ATM", id=277, x=-1204.35,  y=-324.391,  z=37.877},
  {name="ATM", id=277, x=-1216.27,  y=-331.461,  z=37.773},
  {name="ATM", id=277, x=-56.1935,  y=-1752.53,  z=29.452},
  {name="ATM", id=277, x=-261.692,  y=-2012.64,  z=30.121},
  {name="ATM", id=277, x=-273.001,  y=-2025.60,  z=30.197},
  {name="ATM", id=277, x=24.589,    y=-946.056,  z=29.357},
  {name="ATM", id=277, x=-254.112,  y=-692.483,  z=33.616},
  {name="ATM", id=277, x=-1570.197, y=-546.651,  z=34.955},
  {name="ATM", id=277, x=-1415.909, y=-211.825,  z=46.500},
  {name="ATM", id=277, x=-1430.112, y=-211.014,  z=46.500},
  {name="ATM", id=277, x=33.232,    y=-1347.849, z=29.497},
  {name="ATM", id=277, x=129.216,   y=-1292.347, z=29.269},
  {name="ATM", id=277, x=287.645,   y=-1282.646, z=29.659},
  {name="ATM", id=277, x=289.012,   y=-1256.545, z=29.440},
  {name="ATM", id=277, x=296.47,    y=-894.19,   z=29.217},
  {name="ATM", id=277, x=295.71,    y=-896.07,   z=29.217},
  {name="ATM", id=277, x=1686.753,  y=4815.809,  z=42.008},
  {name="ATM", id=277, x=-302.408,  y=-829.945,  z=32.417},
  {name="ATM", id=277, x=5.134,     y=-919.949,  z=29.557},
  {name="ATM", id=277, x=136.26,    y=-1295.03,  z=29.23},
  {name="ATM", id=277, x=-1390.97,  y=-590.44,   z=27.35},
  {name="ATM", id=277, x=-1766.21,  y=-791.15,   z=7.91},
  {name="ATM", id=277, x=937.84,    y=-941.33,   z=43.43},
  {name="ATM", id=277, x=939.87,    y=-942.88,   z=43.45},
  {name="ATM", id=277, x=837.85,    y=-936.47,   z=26.75},
  {name="ATM", id=277, x=-1199.72,  y=-1582.71,  z=4.34},
  {name="ATM", id=277, x=315.1,     y=-593.68,   z=43.28},
  {name="ATM", id=277, x=310.99,    y=-910.94,   z=29.29},
  {name="ATM", id=277, x=1116.1,    y=219.92,    z=-49.44},
}