Config = {}
 
Config.Animations = {
   
    {
        name  = 'festives',
        label = 'Festives',
        items = {
        {label = "Stop Animation", type = "Stopit", data = {anim = ""}},					 
        {label = "Hold Some Beer", type = "scenario", data = {anim = "WORLD_HUMAN_DRINKING"}},
        {label = "Drink Some Beer", type = "scenario", data = {anim = "WORLD_HUMAN_PARTYING"}},
        {label = "Air Guitar", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar"}},
        {label = "Air Shagging", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging"}},
        {label = "Rock'n'Roll", type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock"}},
        --{label = "Smoke A Joint", type = "scenario", data = {anim = "WORLD_HUMAN_SMOKING_POT"}},
        {label = "Stoned Idle", type = "anim", data = {lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a"}},        
        }
    },
	
	    {
        name  = 'misc dance',
        label = 'Misc Dance',
        items = {
		{label = "Stop Animation", type = "Stopit", data = {anim = ""}},        
        {label = "Dance 1", type = "loop", data = {lib = "special_ped@mountain_dancer@monologue_2@monologue_2a", anim = "mnt_dnc_angel"}},		
		{label = "Dj 1 [Looped]", type = "loop", data = {lib = "anim@mp_player_intcelebrationmale@dj", anim = "dj"}},
		{label = "Dj 2 [Looped]", type = "loop", data = {lib = "mini@strip_club@idles@dj@idle_01", anim = "idle_01"}},
		{label = "Dj 3 [Looped]", type = "loop", data = {lib = "mini@strip_club@idles@dj@idle_02", anim = "idle_02"}},
		{label = "Dj 4 [Looped]", type = "loop", data = {lib = "mini@strip_club@idles@dj@idle_03", anim = "idle_03"}},
		{label = "Dj 5 [Looped]", type = "loop", data = {lib = "mini@strip_club@idles@dj@idle_04", anim = "idle_04"}},
		{label = "Dj 6 [Looped]", type = "loop", data = {lib = "mini@strip_club@idles@dj@idle_05", anim = "idle_05"}},
        {label = "Banging Tunes [Looped]", type = "loop", data = {lib = "anim@mp_player_intcelebrationmale@banging_tunes", anim = "banging_tunes"}},
        {label = "Banging Tunes Idle [Looped]", type = "loop", data = {lib = "anim@mp_player_intupperbanging_tunes", anim = "idle_a"}},		
        {label = "Cats Cradle [Looped]", type = "loop", data = {lib = "anim@mp_player_intcelebrationmale@cats_cradle", anim = "cats_cradle"}},
        {label = "Cats Cradle Idle [Looped]", type = "loop", data = {lib = "anim@mp_player_intuppercats_cradle", anim = "idle_a"}},			
		{label = "Find The Fish [Looped]", type = "loop", data = {lib = "anim@mp_player_intcelebrationmale@find_the_fish", anim = "find_the_fish"}},
        {label = "Find The Fish Idle [Looped]", type = "loop", data = {lib = "anim@mp_player_intupperfind_the_fish", anim = "idle_a"}},		
		{label = "Heart Pumping [Looped]", type = "loop", data = {lib = "anim@mp_player_intcelebrationmale@heart_pumping", anim = "heart_pumping"}},
        {label = "Heart Pumping Idle [Looped]", type = "loop", data = {lib = "anim@mp_player_intupperheart_pumping", anim = "idle_a"}},		
		{label = "Oh Snap [Looped]", type = "loop", data = {lib = "anim@mp_player_intcelebrationmale@oh_snap", anim = "oh_snap"}},
		{label = "Oh Snap Idle [Looped]", type = "loop", data = {lib = "anim@mp_player_intupperoh_snap", anim = "idle_a"}},
        {label = "Raise The Roof [Looped]", type = "loop", data = {lib = "anim@mp_player_intcelebrationmale@raise_the_roof", anim = "raise_the_roof"}},
		{label = "Raise The Roof Idle [Looped]", type = "loop", data = {lib = "anim@mp_player_intupperraise_the_roof", anim = "idle_a"}},
		{label = "Salsa Dance [Looped]", type = "loop", data = {lib = "anim@mp_player_intcelebrationmale@salsa_roll", anim = "salsa_roll"}},
		{label = "Salsa Dance Idle [Looped]", type = "loop", data = {lib = "anim@mp_player_intuppersalsa_roll", anim = "idle_a"}},
        {label = "Uncle Disco [Looped]", type = "loop", data = {lib = "anim@mp_player_intcelebrationmale@uncle_disco", anim = "uncle_disco"}},
		{label = "Uncle Disco Idle [Looped]", type = "loop", data = {lib = "anim@mp_player_intupperuncle_disco", anim = "idle_a"}},		
		{label = "Madonna 1 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@black_madonna_entourage@", anim = "hi_dance_facedj_09_v2_male^5"}},
		{label = "Madonna 2 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@black_madonna_entourage@", anim = "li_dance_facedj_11_v1_male^1"}},
		{label = "Madonna 3 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@black_madonna_entourage@", anim = "li_dance_facedj_15_v2_male^2"}},
		{label = "Dancing 1 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "high_center"}},
		{label = "Dancing 2 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "high_center_down"}},
		{label = "Dancing 3 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "high_center_up"}},
		{label = "Dancing 4 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "high_left"}},
		{label = "Dancing 5 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "high_left_down"}},
		{label = "Dancing 6 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "high_left_up"}},
		{label = "Dancing 7 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "high_center"}},
		{label = "Dancing 8 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "med_center_down"}},
		
		

		


        }
    },
	
	{
        name  = 'female dance',
        label = 'Female Dance',
        items = {		
		{label = "Stop Animation", type = "Stopit", data = {anim = ""}},       
		{label = "Female 1 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^1"}},
		{label = "Female 2 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^2"}},
		{label = "Female 3 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^3"}},
		{label = "Female 4 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^4"}},
        {label = "Female 5 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^5"}},
		{label = "Female 6 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^6"}},		
		{label = "Female 7 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^1"}},		
		{label = "Female 8 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^2"}},
		{label = "Female 9 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^3"}},
		{label = "Female 10 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^4"}},
		{label = "Female 11 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^5"}},
        {label = "Female 12 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^6"}},	
        {label = "Female 13 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^1"}},		
		{label = "Female 14 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^2"}},		
		{label = "Female 15 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^3"}},
		{label = "Female 16 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^4"}},
		{label = "Female 17 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^5"}},
		{label = "Female 18 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^6"}},
        {label = "Female 19 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^1"}},		
		{label = "Female 20 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^2"}},		
		{label = "Female 21 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^3"}},
		{label = "Female 22 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^4"}},
		{label = "Female 23 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^5"}},
		{label = "Female 24 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^6"}},		
		{label = "Female 25 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^1"}},		
		{label = "Female 26 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^2"}},		
		{label = "Female 27 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^3"}},
		{label = "Female 28 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^4"}},
		{label = "Female 29 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^5"}},
		{label = "Female 30 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^6"}},
		       
        }
    },
	
	{
        name  = 'male dance',
        label = 'Male Dance',
        items = {	
        {label = "Stop Animation", type = "Stopit", data = {anim = ""}},       		
		{label = "Male 1 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^1"}},
		{label = "Male 2 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^2"}},
        {label = "Male 3 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^3"}},
		{label = "Male 4 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^4"}},
		{label = "Male 5 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^5"}},
		{label = "Male 6 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^6"}},		
		{label = "Male 7 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^1"}},		
		{label = "Male 8 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^2"}},
		{label = "Male 9 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^3"}},
        {label = "Male 10 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^4"}},
		{label = "Male 11 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^5"}},
		{label = "Male 12 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^6"}},		
	    {label = "Male 13 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^1"}},		
		{label = "Male 14 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^2"}},
		{label = "Male 15 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^3"}},
        {label = "Male 16 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^4"}},
		{label = "Male 17 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^5"}},
		{label = "Male 18 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^6"}},	    
		{label = "Male 19 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^1"}},		
		{label = "Male 20 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^2"}},
		{label = "Male 21 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^3"}},
        {label = "Male 22 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^4"}},
		{label = "Male 23 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^5"}},
		{label = "Male 24 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^6"}},
        {label = "Male 25 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^1"}},		
		{label = "Male 26 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^2"}},
		{label = "Male 27 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^3"}},
        {label = "Male 28 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^4"}},
		{label = "Male 29 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^5"}},
		{label = "Male 30 [Looped]", type = "loop", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^6"}},
		       
        }
    },
	
	
 
    {
        name  = 'greetings',
        label = 'Salutations',
        items = {
		{label = "Stop Animation", type = "Stopit", data = {anim = ""}},
        {label = "Salute", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello"}},
        {label = "Shake Hand", type = "anim", data = {lib = "mp_common", anim = "givetake1_a"}},
        {label = "Hand Shake", type = "anim", data = {lib = "mp_ped_interaction", anim = "handshake_guy_a"}},
        {label = "Gangster Salute", type = "anim", data = {lib = "mp_ped_interaction", anim = "hugs_guy_a"}},
        {label = "Military Salute", type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute"}},
        }
    },
 
    {
        name  = 'work',
        label = 'Jobs',
        items = {
		{label = "Stop Animation", type = "Stopit", data = {anim = ""}},
        --{label = "Hands On Head On Your Knees", type = "anim", data = {lib = "random@arrests@busted", anim = "idle_c"}},
        {label = "Fish", type = "scenario", data = {anim = "world_human_stand_fishing"}},
        {label = "Binoculars", type = "scenario", data = {anim = "WORLD_HUMAN_BINOCULARS"}},
        {label = "Digging Ground", type = "scenario", data = {anim = "world_human_gardener_plant"}},
        {label = "Mechanic : Repairing Engine", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped"}},
        {label = "Observing", type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_KNEEL"}},
        {label = "Turn To Backseat Car", type = "anim", data = {lib = "oddjobs@taxi@driver", anim = "leanover_idle"}},
        {label = "Handing Drivers License In Car", type = "anim", data = {lib = "oddjobs@taxi@cyi", anim = "std_hand_off_ps_passenger"}},
        {label = "Loading The Trunk", type = "anim", data = {lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper"}},
        {label = "Take A Photo", type = "scenario", data = {anim = "WORLD_HUMAN_PAPARAZZI"}},
        {label = "Hammering A Wall", type = "scenario", data = {anim = "WORLD_HUMAN_HAMMERING"}},
        {label = "Homeless Sign", type = "scenario", data = {anim = "WORLD_HUMAN_BUM_FREEWAY"}},
        {label = "Human Statue", type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE"}},
        }
    },
 
    {
        name  = 'humors',
        label = 'Moods',
        items = {
		{label = "Stop Animation", type = "Stopit", data = {anim = ""}},
        {label = "Clapping", type = "scenario", data = {anim = "WORLD_HUMAN_CHEERING"}},
        {label = "Thumbs Up", type = "anim", data = {lib = "mp_action", anim = "thanks_male_06"}},
        {label = "Points", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_point"}},
        {label = "Later", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_come_here_soft"}},
        {label = "U Wot Mate", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_bring_it_on"}},
        {label = "Me", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_me"}},
        {label = "Stealing", type = "anim", data = {lib = "anim@am_hold_up@male", anim = "shoplift_high"}},    
        {label = "Facepalm", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm"}},
        {label = "Calm Down", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_easy_now"}},
        {label = "Scared 1", type = "anim", data = {lib = "oddjobs@assassinate@multi@", anim = "react_big_variations_a"}},
        {label = "Scared 2", type = "anim", data = {lib = "amb@code_human_cower_stand@male@react_cowering", anim = "base_right"}},
        {label = "Fight", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e"}},
        {label = "Shits Whack", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_damn"}},
        {label = "Hug", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a"}},
		{label = "Meditating", type = "anim", data = {lib = "rcmcollect_paperleadinout@", anim = "meditiate_idle"}},
        {label = "The Bird", type = "anim", data = {lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter"}},
        {label = "Jerk Off", type = "anim", data = {lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01"}},
        --{label = "Suicide", type = "anim", data = {lib = "mp_suicide", anim = "pistol"}},
        }
    },
 
    {
        name  = 'sports',
        label = 'Sports',
        items = {
		{label = "Stop Animation", type = "Stopit", data = {anim = ""}},
        {label = "Flexing", type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base"}},
        {label = "Lifting Weights", type = "anim", data = {lib = "amb@world_human_muscle_free_weights@male@barbell@base", anim = "base"}},
        {label = "Push Ups", type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base"}},
        {label = "Sit Ups", type = "anim", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base"}},
        {label = "Yoga", type = "anim", data = {lib = "amb@world_human_yoga@male@base", anim = "base_a"}},
        }
    },
 
    {
        name  = 'misc',
        label = 'Misc',
        items = {
		{label = "Stop Animation", type = "Stopit", data = {anim = ""}},
        {label = "Drinking Coffee", type = "anim", data = {lib = "amb@world_human_aa_coffee@idle_a", anim = "idle_a"}},
		{label = "Wave Arms [Looped]", type = "loop", data = {lib = "random@car_thief@victimpoints_ig_3", anim = "arms_waving"}},
        {label = "Sitting On Ground", type = "scenario", data = {anim = "WORLD_HUMAN_PICNIC"}},
        {label = "Leaning", type = "scenario", data = {anim = "world_human_leaning"}},
        {label = "Sunbathe Stomach", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK"}},
        {label = "Sunbathe Back", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE"}},
        {label = "Washing Window", type = "scenario", data = {anim = "world_human_maid_clean"}},
        {label = "Taking A Selfie", type = "scenario", data = {anim = "world_human_tourist_mobile"}},
        {label = "Listen Through Door", type = "anim", data = {lib = "mini@safe_cracking", anim = "idle_base"}},
		{label = "Touch Crotch [Looped]", type = "loop", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch"}},
		{label = "Male Pee [Looped]", type = "loop", data = {lib = "misscarsteal2peeing", anim = "peeing_loop"}},
		{label = "Butt Wag", type = "anim", data = {lib = "switch@trevor@mocks_lapdance", anim = "001443_01_trvs_28_idle_trv"}},
        }
    },
	
	{
		name  = 'attitudem',
		label = 'Attitudes',
		items = {
	    {label = "Normal M", type = "attitude", data = {lib = "move_m@confident", anim = "move_m@confident"}},
	    {label = "Normal F", type = "attitude", data = {lib = "move_f@heels@c", anim = "move_f@heels@c"}},
	    {label = "Depressif", type = "attitude", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a"}},
	    {label = "Depressif F", type = "attitude", data = {lib = "move_f@depressed@a", anim = "move_f@depressed@a"}},
	    {label = "Business", type = "attitude", data = {lib = "move_m@business@a", anim = "move_m@business@a"}},
	    {label = "Determine", type = "attitude", data = {lib = "move_m@brave@a", anim = "move_m@brave@a"}},
	    {label = "Casual", type = "attitude", data = {lib = "move_m@casual@a", anim = "move_m@casual@a"}},
	    {label = "Trop mange", type = "attitude", data = {lib = "move_m@fat@a", anim = "move_m@fat@a"}},
	    {label = "Hipster", type = "attitude", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a"}},
	    {label = "Blesse", type = "attitude", data = {lib = "move_m@injured", anim = "move_m@injured"}},
	    {label = "Intimide", type = "attitude", data = {lib = "move_m@hurry@a", anim = "move_m@hurry@a"}},
	    {label = "Hobo", type = "attitude", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a"}},
	    {label = "Malheureux", type = "attitude", data = {lib = "move_m@sad@a", anim = "move_m@sad@a"}},
	    {label = "Muscle", type = "attitude", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a"}},
	    {label = "Choc", type = "attitude", data = {lib = "move_m@shocked@a", anim = "move_m@shocked@a"}},
	    {label = "Sombre", type = "attitude", data = {lib = "move_m@shadyped@a", anim = "move_m@shadyped@a"}},
	    {label = "Fatigue", type = "attitude", data = {lib = "move_m@buzzed", anim = "move_m@buzzed"}},
	    {label = "Pressee", type = "attitude", data = {lib = "move_m@hurry_butch@a", anim = "move_m@hurry_butch@a"}},
	    {label = "Fier", type = "attitude", data = {lib = "move_m@money", anim = "move_m@money"}},
	    {label = "Petite course", type = "attitude", data = {lib = "move_m@quick", anim = "move_m@quick"}},
	    {label = "Mangeuse d'homme", type = "attitude", data = {lib = "move_f@maneater", anim = "move_f@maneater"}},
	    {label = "Impertinent", type = "attitude", data = {lib = "move_f@sassy", anim = "move_f@sassy"}},	
	    {label = "Arrogante", type = "attitude", data = {lib = "move_f@arrogant@a", anim = "move_f@arrogant@a"}},
		}
	  },
    }