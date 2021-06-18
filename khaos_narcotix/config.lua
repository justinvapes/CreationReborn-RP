--[[ NARCOTIX CONFIGURATION ]]--
--[[      NATURALKHAOS      ]]--
--[[   CREATION REBORN RP   ]]--

Config = {
	Pweed = {										-- Weed Processing
		Items = {
			Paper		=	'zigzag',     			-- Rolling Papers for drugs
			WeedLow		=	'lowqualitybud',  		-- Low Grade Marijuana to be used in drugs
			WeedAve		=	'averagequalitybud',	-- Average Grade Marijuana to be used in drugs
			WeedMed		=	'mediumqualitybud',		-- Medium Grade Marijuana to be used in drugs
			WeedHgh		=	'highqualitybud',		-- High Grade Marijuana to be used in drugs
			aveJoint	=	'averagejoint', 		-- Crafted item Average Grade Joint
			MBud		=	'medbud',				-- Medicinal Bud
			mJoint		=	'medjoint',				-- Crafted item
		},					   	
		jCount = 1,									-- How many joints received from each roll
		jPaper = 1,									-- How many rolling papers per roll
		jWeed = 3,									-- How much marijuana per roll
		jbudmed = {1,40},							-- Chance for Medicinal bud from Medium Grade (Default is 1 out of 20)
		jbudhgh = {1,20},							-- Chance for Medicinal bud from High Grade (Default is 1 out of 20)
		jmed = 4,									-- How much health will be restored by a medicinal joint [1 = Full, 2 = Half, 4 = Quarter, 8 = Eighth]
		jmed_active = true,							-- Turn off or on medicinal joints and bud [true = on, false = off]
	},
}
