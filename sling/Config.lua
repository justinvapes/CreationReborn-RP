Config = {}

--[[
Persistent Weapons - If value set to TRUE, you can only equip Carbine, Pump Shotgun and Sawed-Off Shotgun/BeanBag via /ar, /sg, /bb commands.
If you have Persistent Weapons, you need to rack/unrack it from Emergency Vehicle and cannot change weapons unless long rifle is slung. S2021

BBOn - Set as TRUE if you use non-lethal BeanBag shotgun, which is a replacement for Sawn-Off shotgun.
]]
Config.PersistentWeapons = true
Config.BBOn = true

--[[
Commands and abbreviations - set to your liking. Do not add /, it will be added automatically.
]]
Config.SlingMain = "sling" -- Main command for sling
Config.SlingAbbr = "s" -- Shorter command for sling

Config.DisablePW = "civ" -- Disables PersistentWeapons (to be used by specific players)

Config.TakeAR = "ar" -- Rack/Unrack AR
Config.TakeSG = "sg" -- Rack/Unrack Shotgun
Config.TakeBB = "bb" -- Rack/Unrack BeanBag


--[[

If you want to add your server-specific vests or change anything, please add them in format:
	[Vest ID ingame] (ALWAYS in []) = {
	    Coordinate X = (value),
		Coordinate Y = (value),
		Coordinate Z = (value),
		Rotation X = (value),
		Rotation Y = (value),
		Rotation Z = (value)
	},
	
	You can get the ID of vest by running below code:
	
	RegisterCommand("getvest", function(source, args, raw)
		local Ped = GetPlayerPed(-1)
		ShowNotification('ID of your Vest is:')
		ShowNotification(GetPedDrawableVariation(Ped,9))
	end)	
	
	Uncomment above in client.lua (Lines 9 to 15), restart the resource and type /getvest ingame.
	Number returned is ID of vest you have on.

--]]

Config.FrontSlingVestsMale = {
	[6] = {
	    xpos = (0.22),
		ypos = (0.24),
		zpos = (0.035),
		xrot = (0.0),
		yrot = (320.0),
		zrot = (155.0)
	},	
	[7] = {
	    xpos = (0.1),
		ypos = (0.25),
		zpos = (0.1),
		xrot = (345.0),
		yrot = (340.0),
		zrot = (180.0)
	},
	[9] = {
	    xpos = (0.28),
		ypos = (0.24),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (320.0),
		zrot = (145.0)
	},	
	[12] = {
	    xpos = (0.13),
		ypos = (0.25),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (330.0),
		zrot = (180.0)
	},	
	[15] = {
	    xpos = (-0.15),
		ypos = (-0.08),
		zpos = (0.22),
		xrot = (290.0),
		yrot = (180.0),
		zrot = (0.0)
	},	
	[16] = {
	    xpos = (-0.15),
		ypos = (-0.08),
		zpos = (0.22),
		xrot = (290.0),
		yrot = (180.0),
		zrot = (0.0)
	},		
	[8] = {
	    xpos = (0.1),
		ypos = (-0.184),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (50.0),
		zrot = (357.0)
	},
	[25] = {
	    xpos = (0.1),
		ypos = (-0.184),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (50.0),
		zrot = (352.0)
	},
	[27] = {
	    xpos = (0.1),
		ypos = (-0.20),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (50.0),
		zrot = (355.0)
	}}

Config.BackSlingVestsMale = {
	[6] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[7] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[9] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[12] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[15] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[16] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[8] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[25] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[27] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	}
}

Config.FrontSlingVestsFemale = {
	[6] = {
	    xpos = (0.22),
		ypos = (0.24),
		zpos = (0.035),
		xrot = (0.0),
		yrot = (320.0),
		zrot = (155.0)
	},	
	[7] = {
	    xpos = (0.1),
		ypos = (0.25),
		zpos = (0.1),
		xrot = (345.0),
		yrot = (340.0),
		zrot = (180.0)
	},
	[9] = {
	    xpos = (0.28),
		ypos = (0.24),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (320.0),
		zrot = (145.0)
	},	
	[12] = {
	    xpos = (0.13),
		ypos = (0.25),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (330.0),
		zrot = (180.0)
	},	
	[15] = {
	    xpos = (-0.15),
		ypos = (-0.08),
		zpos = (0.22),
		xrot = (290.0),
		yrot = (180.0),
		zrot = (0.0)
	},	
	[16] = {
	    xpos = (-0.15),
		ypos = (-0.08),
		zpos = (0.22),
		xrot = (290.0),
		yrot = (180.0),
		zrot = (0.0)
	},		
	[8] = {
	    xpos = (0.1),
		ypos = (-0.184),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (50.0),
		zrot = (357.0)
	},
	[25] = {
	    xpos = (0.1),
		ypos = (-0.184),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (50.0),
		zrot = (352.0)
	},
	[27] = {
	    xpos = (0.1),
		ypos = (-0.20),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (50.0),
		zrot = (355.0)
	}}

Config.BackSlingVestsFemale = {
	[6] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[7] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[9] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[12] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[15] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[16] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[8] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[25] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	},
	
	[27] = {
	    xpos = (-0.1),
		ypos = (-0.18),
		zpos = (0.0),
		xrot = (0.0),
		yrot = (20.0),
		zrot = (357.0),
	}
}

-- XYZ for any other sling on front that is not in above tables.
Config.FrontSlingElseMale = {
	xpos = (0.1),
	ypos = (0.20),
	zpos = (0.0),
	xrot = (0.0),
	yrot = (320.0),
	zrot = (175.0)
}

-- XYZ for any other sling on back that is not in above tables.
Config.BackSlingElseMale = {
	xpos = (-0.1),
	ypos = (-0.18),
	zpos = (0.0),
	xrot = (0.0),
	yrot = (20.0),
	zrot = (0.0)
}

-- XYZ for any other sling on front that is not in above tables.
Config.FrontSlingElseFemale = {
	xpos = (0.1),
	ypos = (0.20),
	zpos = (0.0),
	xrot = (0.0),
	yrot = (320.0),
	zrot = (175.0)
}

-- XYZ for any other sling on back that is not in above tables.
Config.BackSlingElseFemale = {
	xpos = (-0.1),
	ypos = (-0.18),
	zpos = (0.0),
	xrot = (0.0),
	yrot = (20.0),
	zrot = (0.0)
}






























--[[

Component and weapon arrays.

EDIT ONLY IF YOU KNOW WHAT YOU ARE DOING

]]

Config.componentlistclips = {
["COMPONENT_GUSENBERG_CLIP_02"] = "w_sb_gusenberg_mag2",
["COMPONENT_GUSENBERG_CLIP_02"] = "w_sb_gusenberg_mag2",
["COMPONENT_SMG_CLIP_01"] = "w_sb_smg_mag1",
["COMPONENT_SMG_CLIP_02"] = "w_sb_smg_mag2",
["COMPONENT_SMG_CLIP_03"] = "w_sb_smg_boxmag",
["COMPONENT_ASSAULTSMG_CLIP_01"] = "w_sb_assaultsmg_mag1",
["COMPONENT_ASSAULTSMG_CLIP_02"] = "w_sb_assaultsmg_mag2",
["COMPONENT_SMG_MK2_CLIP_01"] = "w_sb_smgmk2_mag1",
["COMPONENT_SMG_MK2_CLIP_02"] = "w_sb_smgmk2_mag2",
["COMPONENT_SMG_MK2_CLIP_TRACER"] = "w_sb_smgmk2_mag_tr",
["COMPONENT_SMG_MK2_CLIP_INCENDIARY"] = "w_sb_smgmk2_mag_inc",
["COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT"] = "w_sb_smgmk2_mag_hp",
["COMPONENT_SMG_MK2_CLIP_FMJ"] = "w_sb_smgmk2_mag_fmj",
["COMPONENT_COMBATPDW_CLIP_01"] = "w_sb_pdw_mag1",
["COMPONENT_COMBATPDW_CLIP_02"] = "w_sb_pdw_mag2",
["COMPONENT_COMBATPDW_CLIP_03"] = "w_sb_pdw_boxmag",
["COMPONENT_ASSAULTRIFLE_CLIP_01"] = "w_ar_assaultrifle_mag1",
["COMPONENT_ASSAULTRIFLE_CLIP_02"] = "w_ar_assaultrifle_mag2",
["COMPONENT_ASSAULTRIFLE_CLIP_03"] = "w_ar_assaultrifle_boxmag",
["COMPONENT_CARBINERIFLE_CLIP_01"] = "w_ar_carbinerifle_mag1",
["COMPONENT_CARBINERIFLE_CLIP_02"] = "w_ar_carbinerifle_mag2",
["COMPONENT_CARBINERIFLE_CLIP_03"] = "w_ar_carbinerifle_boxmag",
["COMPONENT_ADVANCEDRIFLE_CLIP_01"] = "w_ar_advancedrifle_mag1",
["COMPONENT_ADVANCEDRIFLE_CLIP_02"] = "w_ar_advancedrifle_mag2",
["COMPONENT_SPECIALCARBINE_CLIP_01"] = "w_ar_specialcarbine_mag1",
["COMPONENT_SPECIALCARBINE_CLIP_02"] = "w_ar_specialcarbine_mag2",
["COMPONENT_SPECIALCARBINE_CLIP_03"] = "w_ar_specialcarbine_boxmag",
["COMPONENT_SPECIALCARBINE_MK2_CLIP_01"] = "w_ar_specialcarbinemk2_mag1",
["COMPONENT_SPECIALCARBINE_MK2_CLIP_02"] = "w_ar_specialcarbinemk2_mag2",
["COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER"] = "w_ar_specialcarbinemk2_mag_tr",
["COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY"] = "w_ar_specialcarbinemk2_mag_inc",
["COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING"] = "w_ar_specialcarbinemk2_mag_ap",
["COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ"] = "w_ar_specialcarbinemk2_mag_fmj",
["COMPONENT_ASSAULTRIFLE_MK2_CLIP_01"] = "w_ar_assaultriflemk2_mag1",
["COMPONENT_ASSAULTRIFLE_MK2_CLIP_02"] = "w_ar_assaultriflemk2_mag2",
["COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER"] = "w_ar_assaultriflemk2_mag_tr",
["COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY"] = "w_ar_assaultriflemk2_mag_inc",
["COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING"] = "w_ar_assaultriflemk2_mag_ap",
["COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ"] = "w_ar_assaultriflemk2_mag_fmj",
["COMPONENT_CARBINERIFLE_MK2_CLIP_01"] = "w_ar_carbineriflemk2_mag1",
["COMPONENT_CARBINERIFLE_MK2_CLIP_02"] = "w_ar_carbineriflemk2_mag2",
["COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER"] = "w_ar_carbineriflemk2_mag_tr",
["COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY"] = "w_ar_carbineriflemk2_mag_inc",
["COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING"] = "w_ar_carbineriflemk2_mag_ap",
["COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ"] = "w_ar_carbineriflemk2_mag_fmj",
["COMPONENT_MARKSMANRIFLE_MK2_CLIP_01"] = "w_sr_marksmanriflemk2_mag1",
["COMPONENT_MARKSMANRIFLE_MK2_CLIP_02"] = "w_sr_marksmanriflemk2_mag2",
["COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER"]= "w_sr_marksmanriflemk2_mag_tr",
["COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY"] = "w_sr_marksmanriflemk2_mag_inc",
["COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING"] = "w_sr_marksmanriflemk2_mag_ap",
["COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ"] = "w_sr_marksmanriflemk2_mag_fmj",
["COMPONENT_MARKSMANRIFLE_CLIP_01"] = "w_sr_marksmanrifle_mag1",
["COMPONENT_MARKSMANRIFLE_CLIP_02"] = "w_sr_marksmanrifle_mag2",
["COMPONENT_BULLPUPRIFLE_CLIP_01"] = "w_ar_bullpuprifle_mag1",
["COMPONENT_BULLPUPRIFLE_CLIP_02"] = "w_ar_bullpuprifle_mag2",
["COMPONENT_BULLPUPRIFLE_MK2_CLIP_01"] = "w_ar_bullpupriflemk2_mag1",
["COMPONENT_BULLPUPRIFLE_MK2_CLIP_02"] = "w_ar_bullpupriflemk2_mag2",
["COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER"] = "w_ar_bullpupriflemk2_mag_tr",
["COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY"] = "w_ar_bullpupriflemk2_mag_inc",
["COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING"] = "w_ar_bullpupriflemk2_mag_ap",
["COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ"] = "w_ar_bullpupriflemk2_mag_fmj",
["COMPONENT_SNIPERRIFLE_CLIP_01"] = "w_sr_sniperrifle_mag1",
["COMPONENT_HEAVYSNIPER_CLIP_01"] = "w_sr_heavysniper_mag1",
["COMPONENT_HEAVYSNIPER_MK2_CLIP_01"] = "w_sr_heavysnipermk2_mag1",
["COMPONENT_HEAVYSNIPER_MK2_CLIP_02"] = "w_sr_heavysnipermk2_mag2",
["COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY"] = "w_sr_heavysnipermk2_mag_inc",
["COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING"] = "w_sr_heavysnipermk2_mag_ap",
["COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ"] = "w_sr_heavysnipermk2_mag_fmj",
["COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE"] = "w_sr_heavysnipermk2_mag_ap2",
["COMPONENT_ASSAULTSHOTGUN_CLIP_01"] = "w_sg_assaultshotgun_mag1",
["COMPONENT_ASSAULTSHOTGUN_CLIP_02"] = "w_sg_assaultshotgun_mag2",
["COMPONENT_HEAVYSHOTGUN_CLIP_01"] = "w_sg_heavyshotgun_mag1",
["COMPONENT_HEAVYSHOTGUN_CLIP_02"] = "w_sg_heavyshotgun_mag2",
["COMPONENT_HEAVYSHOTGUN_CLIP_03"] = "w_sg_heavyshotgun_boxmag"
}

Config.componentlistscopes = {
["COMPONENT_AT_SCOPE_MACRO_02"] = "w_at_scope_macro_2",
["COMPONENT_AT_SCOPE_MACRO_MK2"] = "w_at_scope_macro_2_mk2",
["COMPONENT_AT_SCOPE_MACRO"] = "w_at_scope_macro",
["COMPONENT_AT_SIGHTS_SMG"] = "w_at_sights_smg",
["COMPONENT_AT_SCOPE_SMALL"] = "w_at_scope_small",
["COMPONENT_AT_SCOPE_MEDIUM"] = "w_at_scope_medium",
["COMPONENT_AT_SCOPE_MEDIUM_MK2"] = "w_at_scope_medium_2",
["COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2"] = "w_at_scope_max",
["COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM"] = "w_at_scope_max",
["COMPONENT_AT_SIGHTS"] = "w_at_sights_1",
["COMPONENT_AT_SCOPE_SMALL_MK2"] = "w_at_scope_small_mk2",
["COMPONENT_AT_SCOPE_LARGE_MK2"] = "w_at_scope_large",
["COMPONENT_AT_SCOPE_LARGE"] = "w_at_scope_large",
["COMPONENT_AT_SCOPE_MAX"] = "w_at_scope_max",
["COMPONENT_AT_SCOPE_NV"] = "w_at_scope_nv",
["COMPONENT_AT_SCOPE_THERMAL"] = "w_at_scope_nv"
}

Config.componentlistgrip = {
["COMPONENT_AT_AR_AFGRIP"] = "w_at_ar_afgrip",
["COMPONENT_AT_AR_AFGRIP_02"] = "w_at_afgrip_2"
}

Config.componentlistbarrels = {
["COMPONENT_AT_SC_BARREL_01"] = "w_ar_sc_barrel_1",
["COMPONENT_AT_SC_BARREL_02"] = "w_ar_sc_barrel_2",
["COMPONENT_AT_AR_BARREL_01"] = "w_at_ar_barrel_1",
["COMPONENT_AT_AR_BARREL_02"] = "w_at_ar_barrel_2",
["COMPONENT_AT_CR_BARREL_01"] = "w_at_cr_barrel_1",
["COMPONENT_AT_CR_BARREL_02"] = "w_at_cr_barrel_2",
["COMPONENT_AT_BP_BARREL_01"] = "w_ar_bp_mk2_barrel1",
["COMPONENT_AT_BP_BARREL_02"] = "w_ar_bp_mk2_barrel2",
["COMPONENT_AT_MRFL_BARREL_01"] = "w_at_sr_barrel_1",
["COMPONENT_AT_MRFL_BARREL_02"] = "w_at_sr_barrel_2",
["COMPONENT_AT_SR_BARREL_01"] = "w_at_sr_barrel_1",
["COMPONENT_AT_SR_BARREL_02"] = "w_at_sr_barrel_2"
}

Config.componentlistsupps = {
["COMPONENT_AT_AR_SUPP_02"] = "w_at_ar_supp_02",
["COMPONENT_AT_AR_SUPP"] = "w_at_ar_supp",
["COMPONENT_AT_SR_SUPP"] = "w_at_sr_supp",
["COMPONENT_AT_SR_SUPP_03"] = "w_at_sr_supp3",
["COMPONENT_AT_PI_SUPP"] = "w_at_pi_supp",
["COMPONENT_AT_MUZZLE_01"] = "w_at_muzzle_1",
["COMPONENT_AT_MUZZLE_02"] = "w_at_muzzle_2",
["COMPONENT_AT_MUZZLE_03"] = "w_at_muzzle_3",
["COMPONENT_AT_MUZZLE_04"] = "w_at_muzzle_4",
["COMPONENT_AT_MUZZLE_05"] = "w_at_muzzle_5",
["COMPONENT_AT_MUZZLE_06"] = "w_at_muzzle_6",
["COMPONENT_AT_MUZZLE_07"] = "w_at_muzzle_7",
["COMPONENT_AT_MUZZLE_08"] = "w_at_muzzle_8",
["COMPONENT_AT_MUZZLE_09"] = "w_at_muzzle_9"
}

Config.componentlistflash = {
["COMPONENT_AT_AR_FLSH"] = "w_at_ar_flsh"
}

-- List of weapons allowed for /sling
Config.weaponlist = {
[1627465347] = "w_sb_gusenberg",
[736523883] = "w_sb_smg",
[2024373456] = "w_sb_smgmk2",
[-270015777] = "w_sb_assaultsmg",
[171789620] = "w_sb_pdw",
[-1074790547] = "w_ar_assaultrifle",
[961495388] = "w_ar_assaultriflemk2",
[-2084633992] = "w_ar_carbinerifle",
[-86904375] = "w_ar_carbineriflemk2",
[-1357824103] = "w_ar_advancedrifle",
[-1063057011] = "w_ar_specialcarbine",
[-1768145561] = "w_ar_specialcarbinemk2",
[2132975508] = "w_ar_bullpuprifle",
[100416529] = "w_sr_sniperrifle",
[205991906] = "w_sr_heavysniper",
[177293209] = "w_sr_heavysnipermk2",
[-952879014] = "w_sr_marksmanrifle",
[487013001] = "w_sg_pumpshotgun",
[2017895192] = "w_sg_sawnoff",
[-494615257] = "w_sg_assaultshotgun",
[-1654528753] = "w_sg_bullpupshotgun",
[984333226] = "w_sg_heavyshotgun",
[-1466123874] = "w_ar_musket",
[1432025498] = "w_sg_pumpshotgunmk2", 
[-2066285827] = "w_ar_bullpupriflemk2",
[1785463520] = "w_sr_marksmanriflemk2"
}
 
-- List of weapons that will be attached on back (ie. sniper rifles)
Config.weaponlistback = {
100416529, --SniperRifle
205991906, --HeavySniper
177293209, --HeavySniperMk2
-1466123874 --Musket
}
