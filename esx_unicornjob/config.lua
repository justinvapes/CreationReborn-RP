Config                            = {}
Config.DrawDistance               = 100.0
Config.EnablePlayerManagement     = true
Config.MaxInService               = 12
Config.Locale                     = 'fr'


Config.Blips = {
    
    Blip = {
      Pos     = { x = 129.246, y = -1299.363, z = 29.501 },
      Sprite  = 121,
      Display = 4,
      Scale   = 1.2,
      Colour  = 4,
    },
}

Config.Zones = {

    Cloakrooms1 = {
        Pos   = { x = 97.06, y = -1292.22, z = 29.30 },
        Size  = {x = 0.301, y = 0.301, z = 0.3001},
        Color = { r = 255, g = 0, b = 0 },
        Type  = 21,
    },
	
	Cloakrooms = {
        Pos   = { x = -1138.73, y = -1702.08, z = 11.9 },
        Size  = {x = 0.301, y = 0.301, z = 0.3001},
        Color = { r = 255, g = 0, b = 0 },
        Type  = 21,
    },
}

Config.BossMarkers = {

    BossActions = {
        Pos   = { x = 93.31, y = -1291.51, z = 29.27 },
        Size  = {x = 0.301, y = 0.301, z = 0.3001},
        Color = { r = 255, g = 0, b = 0 },
        Type  = 21,
    },
}

Config.Animations = {
  
    {
        name  = 'unicorn',
        label = 'Dancers',
        items = {
		{label = "Dance 1", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f"}},
		{label = "Dance 2", type = "anim", data = {lib = "mini@strip_club@private_dance@part1", anim = "priv_dance_p1"}},
        {label = "Dance 3", type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2"}},
        {label = "Dance 4", type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3"}},
		{label = "Pole Dance 1", type = "anim", data = {lib = "mini@strip_club@pole_dance@pole_dance1", anim = "pd_dance_01"}},
		{label = "Pole Dance 2", type = "anim", data = {lib = "mini@strip_club@pole_dance@pole_dance2", anim = "pd_dance_02"}},
		{label = "Pole Dance 3", type = "anim", data = {lib = "mini@strip_club@pole_dance@pole_dance3", anim = "pd_dance_03"}},	
		{label = "Lap Dance 1", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p2", anim = "ld_girl_a_song_a_p2_f"}},
		{label = "Lap Dance 2", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p3", anim = "ld_girl_a_song_a_p3_f"}},	
		{label = "Butt Wag", type = "anim", data = {lib = "SWITCH@TREVOR@MOCKS_LAPDANCE", anim = "001443_01_TRVS_28_IDLE_TRV"}},
		{label = "Hooker", type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02"}},
        {label = "Horny", type = "anim", data = {lib = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b"}},
		{label = "Air Shagging", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging"}},
        {label = "Car Giving Head", type = "anim", data = {lib = "oddjobs@towing", anim = "f_blow_job_loop"}},
        {label = "Female Car Sex", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female"}},
        {label = "Itching Balls", type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch"}},
        }
      },
   }