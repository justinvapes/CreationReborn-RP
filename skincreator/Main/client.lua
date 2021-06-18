
local Utils = {}--Invoice Native NetworkClearVoiceChannel
function Utils.NetworkClearVoiceChannel()
    return Citizen.InvokeNative(0xE036A705F989E049)
end

local isSkinCreatorOpened = false -- Change this value to show/hide UI
local model
local cam        = -1	-- Camera control
local zoom       = "visage"	-- Define which tab is shown first (Default: Head)
local ESX        = nil
local sex        = 'm'
local lastModel  = 0 --default model value is 0. 
local creating   = false	
local heading    = 176.22499084473
		
------------------------------------------------------------------
--                          NUI
------------------------------------------------------------------

RegisterNUICallback('updateSkin', function(data)
	v = data.value
	_model = tonumber(data.model)
	if _model ~= lastModel and _model ~= nil then
		lastModel = _model
		loadPed(nil, _model)
	elseif lastModel == 0 or lastModel == nil or v == true then --v is true then we're saving load out
		-- Face
		dad = tonumber(data.dad)
		mum = tonumber(data.mum)
		dadmumpercent = tonumber(data.dadmumpercent)
		skin = tonumber(data.skin)
		eyecolor = tonumber(data.eyecolor)
		acne = tonumber(data.acne)
		skinproblem = tonumber(data.skinproblem)
		freckle = tonumber(data.freckle)
		wrinkle = tonumber(data.wrinkle)
		wrinkleopacity = tonumber(data.wrinkleopacity)
		hair = tonumber(data.hair)
		haircolor = tonumber(data.haircolor)
		eyebrow = tonumber(data.eyebrow)
		eyebrowopacity = tonumber(data.eyebrowopacity)
		beard = tonumber(data.beard)
		beardopacity = tonumber(data.beardopacity)
		beardcolor = tonumber(data.beardcolor)
		makeup = tonumber(data.makeup)
		makeupThickness = tonumber(data.makeupThickness)
		makeupColorOne = tonumber(data.makeupColorOne)
		makeupColorTwo = tonumber(data.makeupColorTwo)
		lipstick = tonumber(data.lipstick)
		lipstickThickness = tonumber(data.lipstickThickness)
		lipstickColorOne = tonumber(data.lipstickColorOne)
		lipstickColorTwo = tonumber(data.lipstickColorTwo)
		-- Clothes
		hats = tonumber(data.hats)
		glasses = tonumber(data.glasses)
		ears = tonumber(data.ears)
		tops = tonumber(data.tops)
		pants = tonumber(data.pants)
		shoes = tonumber(data.shoes)
		watches = tonumber(data.watches)
		bag = tonumber(data.bag)
		mask = tonumber(data.mask)
		
		if(v == true) then
			local ped = GetPlayerPed(-1)
			local torso = GetPedDrawableVariation(ped, 3)
			local torsotext = GetPedTextureVariation(ped, 3)
			local leg = GetPedDrawableVariation(ped, 4)
			local legtext = GetPedTextureVariation(ped, 4)
			local shoes = GetPedDrawableVariation(ped, 6)
			local shoestext = GetPedTextureVariation(ped, 6)
			local accessory = GetPedDrawableVariation(ped, 7)
			local accessorytext = GetPedTextureVariation(ped, 7)
			local undershirt = GetPedDrawableVariation(ped, 8)
			local undershirttext = GetPedTextureVariation(ped, 8)
			local torso2 = GetPedDrawableVariation(ped, 11)
			local torso2text = GetPedTextureVariation(ped, 11)
			local prop_hat = GetPedPropIndex(ped, 0)
			local prop_hat_text = GetPedPropTextureIndex(ped, 0)
			local prop_glasses = GetPedPropIndex(ped, 1)
			local prop_glasses_text = GetPedPropTextureIndex(ped, 1)
			local prop_earrings = GetPedPropIndex(ped, 2)
			local prop_earrings_text = GetPedPropTextureIndex(ped, 2)
			local prop_watches = GetPedPropIndex(ped, 6)
			local prop_watches_text = GetPedPropTextureIndex(ped, 6)
			local modelHash = GetEntityModel(GetPlayerPed(-1))
			local bag = GetPedDrawableVariation(GetPlayerPed(-1), 5)
			local bagTexture = GetPedTextureVariation(GetPlayerPed(-1), 5)
			local mask = GetPedDrawableVariation(GetPlayerPed(-1), 1)
			local maskTexture = GetPedTextureVariation(GetPlayerPed(-1), 1)
			TriggerServerEvent("updateSkin", sex, dad, mum, dadmumpercent, skin, eyecolor, acne, skinproblem, freckle, wrinkle, wrinkleopacity, eyebrow, eyebrowopacity, beard, beardopacity, beardcolor, hair, haircolor, torso, torsotext, leg, legtext, shoes, shoestext, accessory, accessorytext, undershirt, undershirttext, torso2, torso2text, prop_hat, prop_hat_text, prop_glasses, prop_glasses_text, prop_earrings, prop_earrings_text, prop_watches, prop_watches_text, modelHash, lipstick, lipstickThickness, lipstickColorOne, lipstickColorTwo, makeup, makeupThickness, makeupColorOne, makeupColorTwo, bag, bagTexture, mask, maskTexture)
			ShowSkinCreator(false)
			creating = false
			SetPlayerInvincible(PlayerPedId(), false)
			--Utils.NetworkClearVoiceChannel() 
			--NetworkSetTalkerProximity(2.5)
			
			
			local RandomSpawn = math.random(1, 8) 
				
	        if RandomSpawn == 1 then 
	           SpawnPositions = {x = -212.82,  y = -1029.55, z = 29.15}
	
	        elseif RandomSpawn == 2 then 
	           SpawnPositions = {x = -211.58,  y = -1026.38, z = 29.15}
	
	        elseif RandomSpawn == 3 then 
	           SpawnPositions = {x = -215.75,  y = -1037.83, z = 29.15}
	   
	        elseif RandomSpawn == 4 then 
	           SpawnPositions =  {x = -216.95,  y = -1040.98, z = 29.15}

            elseif RandomSpawn == 5 then 
	           SpawnPositions =  {x = -210.26,  y = -1027.08, z = 29.15}
			
			elseif RandomSpawn == 6 then 
	           SpawnPositions =  {x = -211.30,  y = -1029.77, z = 29.15}
			   
            elseif RandomSpawn == 7 then 
	           SpawnPositions =  {x = -214.51,  y = -1038.35, z = 29.15} 
			   
			elseif RandomSpawn == 8 then 
	           SpawnPositions =  {x = -215.67,  y = -1041.48, z = 29.15}   			   
	        end
								
	        SetEntityCoords(PlayerPedId(), SpawnPositions.x, SpawnPositions.y, SpawnPositions.z)
            SetEntityHeading(PlayerPedId(), 69.58)
			TriggerServerEvent("SavePlayerPos")
			FreezeEntityPosition(PlayerPedId(), true)
			Citizen.Wait(2000)
			FreezeEntityPosition(PlayerPedId(), false)
			SetEntityHealth(PlayerPedId(), 200)
			local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~New Citizen', 'Welcome [~b~'..ESX.Game.GetPedRPNames().."~s~] To ~y~CR Los Santos! ~s~We Hope You Enjoy Your Stay", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)
		else
			SetPedDefaultComponentVariation(GetPlayerPed(-1))
			-- Face
			if sex == "M" then
				SetPedHeadBlendData			(GetPlayerPed(-1), dad, mum, dad, skin, skin, skin, dadmumpercent * 0.1, dadmumpercent * 0.1, 0.0, true)
			elseif sex == "F" then
				SetPedHeadBlendData			(GetPlayerPed(-1), dad, mum, mum, skin, skin, skin, dadmumpercent * 0.1, dadmumpercent * 0.1, 0.0, true)
			end
			
			SetPedEyeColor				(GetPlayerPed(-1), eyecolor)
			if acne == 0 then
				SetPedHeadOverlay		(GetPlayerPed(-1), 0, acne, 0.0)
			else
				SetPedHeadOverlay		(GetPlayerPed(-1), 0, acne, 1.0)
			end
			SetPedHeadOverlay			(GetPlayerPed(-1), 6, skinproblem, 1.0)
			if freckle == 0 then
				SetPedHeadOverlay		(GetPlayerPed(-1), 9, freckle, 0.0)
			else
				SetPedHeadOverlay		(GetPlayerPed(-1), 9, freckle, 1.0)
			end
			SetPedHeadOverlay       	(GetPlayerPed(-1), 3, wrinkle, wrinkleopacity * 0.1)
			SetPedComponentVariation	(GetPlayerPed(-1), 2, hair, 0, 2)
			SetPedHairColor				(GetPlayerPed(-1), haircolor, haircolor)
			SetPedHeadOverlay       	(GetPlayerPed(-1), 2, eyebrow, eyebrowopacity * 0.1) 
			SetPedHeadOverlay       	(GetPlayerPed(-1), 1, beard, beardopacity * 0.1)   
			SetPedHeadOverlayColor  	(GetPlayerPed(-1), 1, 1, beardcolor, beardcolor) 
			SetPedHeadOverlayColor  	(GetPlayerPed(-1), 2, 1, beardcolor, beardcolor)
			SetPedHeadOverlay			(GetPlayerPed(-1), 4, makeup, makeupThickness * 0.1)
			SetPedHeadOverlay			(GetPlayerPed(-1), 8, lipstick, lipstickThickness * 0.1)
			SetPedHeadOverlayColor  	(GetPlayerPed(-1), 4, 1, makeupColorOne, makeupColorTwo)      -- Makeup Color
			SetPedHeadOverlayColor  	(GetPlayerPed(-1), 8, 1, lipstickColorOne, lipstickColorTwo)      -- Lipstick Color
			
			-- Clothes variations
			if sex == "M" then
				if hats == 0 then		ClearPedProp(GetPlayerPed(-1), 0)
				elseif hats == 1 then	SetPedPropIndex(GetPlayerPed(-1), 0, 3-1, 1-1, 2)
				elseif hats == 2 then	SetPedPropIndex(GetPlayerPed(-1), 0, 3-1, 7-1, 2)
				elseif hats == 3 then	SetPedPropIndex(GetPlayerPed(-1), 0, 4-1, 3-1, 2)
				elseif hats == 4 then	SetPedPropIndex(GetPlayerPed(-1), 0, 5-1, 1-1, 2)
				elseif hats == 5 then	SetPedPropIndex(GetPlayerPed(-1), 0, 5-1, 2-1, 2)
				elseif hats == 6 then	SetPedPropIndex(GetPlayerPed(-1), 0, 6-1, 1-1, 2)
				elseif hats == 7 then	SetPedPropIndex(GetPlayerPed(-1), 0, 8-1, 1-1, 2)
				elseif hats == 8 then	SetPedPropIndex(GetPlayerPed(-1), 0, 8-1, 2-1, 2)
				elseif hats == 9 then	SetPedPropIndex(GetPlayerPed(-1), 0, 8-1, 3-1, 2)
				elseif hats == 10 then	SetPedPropIndex(GetPlayerPed(-1), 0, 8-1, 6-1, 2)
				elseif hats == 11 then	SetPedPropIndex(GetPlayerPed(-1), 0, 11-1, 6-1, 2)
				elseif hats == 12 then	SetPedPropIndex(GetPlayerPed(-1), 0, 10-1, 6-1, 2)
				elseif hats == 13 then	SetPedPropIndex(GetPlayerPed(-1), 0, 11-1, 8-1, 2)
				elseif hats == 14 then	SetPedPropIndex(GetPlayerPed(-1), 0, 10-1, 8-1, 2)
				elseif hats == 15 then	SetPedPropIndex(GetPlayerPed(-1), 0, 13-1, 1-1, 2)
				elseif hats == 16 then	SetPedPropIndex(GetPlayerPed(-1), 0, 13-1, 2-1, 2)
				elseif hats == 17 then	SetPedPropIndex(GetPlayerPed(-1), 0, 14-1, 3-1, 2)
				elseif hats == 18 then	SetPedPropIndex(GetPlayerPed(-1), 0, 15-1, 1-1, 2)
				elseif hats == 19 then	SetPedPropIndex(GetPlayerPed(-1), 0, 15-1, 2-1, 2)
				elseif hats == 20 then	SetPedPropIndex(GetPlayerPed(-1), 0, 16-1, 2-1, 2)
				elseif hats == 21 then	SetPedPropIndex(GetPlayerPed(-1), 0, 16-1, 3-1, 2)
				elseif hats == 22 then	SetPedPropIndex(GetPlayerPed(-1), 0, 21-1, 6-1, 2)
				elseif hats == 23 then	SetPedPropIndex(GetPlayerPed(-1), 0, 22-1, 1-1, 2)
				elseif hats == 24 then	SetPedPropIndex(GetPlayerPed(-1), 0, 26-1, 2-1, 2)
				elseif hats == 25 then	SetPedPropIndex(GetPlayerPed(-1), 0, 27-1, 1-1, 2)
				elseif hats == 26 then	SetPedPropIndex(GetPlayerPed(-1), 0, 28-1, 1-1, 2)
				elseif hats == 27 then	SetPedPropIndex(GetPlayerPed(-1), 0, 35-1, 0, 2)
				elseif hats == 28 then	SetPedPropIndex(GetPlayerPed(-1), 0, 56-1, 1-1, 2)
				elseif hats == 29 then	SetPedPropIndex(GetPlayerPed(-1), 0, 56-1, 2-1, 2)
				elseif hats == 30 then	SetPedPropIndex(GetPlayerPed(-1), 0, 56-1, 3-1, 2)
				elseif hats == 31 then	SetPedPropIndex(GetPlayerPed(-1), 0, 77-1, 20-1, 2)
				elseif hats == 32 then	SetPedPropIndex(GetPlayerPed(-1), 0, 97-1, 3-1, 2)
				end
			elseif sex == "F" then
				if hats == 0 then		ClearPedProp(GetPlayerPed(-1), 0)
				elseif hats == 1 then	SetPedPropIndex(GetPlayerPed(-1), 0, 1, 0, 2)
				elseif hats == 2 then	SetPedPropIndex(GetPlayerPed(-1), 0, 2, 1, 2)
				elseif hats == 3 then	SetPedPropIndex(GetPlayerPed(-1), 0, 3, 7, 2)
				elseif hats == 4 then	SetPedPropIndex(GetPlayerPed(-1), 0, 4, 1, 2)
				elseif hats == 5 then	SetPedPropIndex(GetPlayerPed(-1), 0, 4, 3, 2)
				elseif hats == 6 then	SetPedPropIndex(GetPlayerPed(-1), 0, 4, 7, 2)
				elseif hats == 7 then	SetPedPropIndex(GetPlayerPed(-1), 0, 5, 3, 2)
				elseif hats == 8 then	SetPedPropIndex(GetPlayerPed(-1), 0, 5, 7, 2)
				elseif hats == 9 then	SetPedPropIndex(GetPlayerPed(-1), 0, 6, 4, 2)
				elseif hats == 10 then	SetPedPropIndex(GetPlayerPed(-1), 0, 6, 7, 2)
				elseif hats == 11 then	SetPedPropIndex(GetPlayerPed(-1), 0, 7, 3, 2)
				elseif hats == 12 then	SetPedPropIndex(GetPlayerPed(-1), 0, 9, 6, 2)
				elseif hats == 13 then	SetPedPropIndex(GetPlayerPed(-1), 0, 10, 7, 2)
				elseif hats == 14 then	SetPedPropIndex(GetPlayerPed(-1), 0, 14, 4, 2)
				elseif hats == 15 then	SetPedPropIndex(GetPlayerPed(-1), 0, 14, 2, 2)
				elseif hats == 16 then	SetPedPropIndex(GetPlayerPed(-1), 0, 15, 1, 2)
				elseif hats == 17 then	SetPedPropIndex(GetPlayerPed(-1), 0, 15, 2, 2)
				elseif hats == 18 then	SetPedPropIndex(GetPlayerPed(-1), 0, 15, 3, 2)
				elseif hats == 19 then	SetPedPropIndex(GetPlayerPed(-1), 0, 15, 6, 2)
				elseif hats == 20 then	SetPedPropIndex(GetPlayerPed(-1), 0, 16, 0, 2)
				elseif hats == 21 then	SetPedPropIndex(GetPlayerPed(-1), 0, 16, 6, 2)
				elseif hats == 22 then	SetPedPropIndex(GetPlayerPed(-1), 0, 16, 7, 2)
				elseif hats == 23 then	SetPedPropIndex(GetPlayerPed(-1), 0, 27, 0, 2)
				elseif hats == 24 then	SetPedPropIndex(GetPlayerPed(-1), 0, 27, 6, 2)
				elseif hats == 25 then	SetPedPropIndex(GetPlayerPed(-1), 0, 29, 1, 2)
				elseif hats == 26 then	SetPedPropIndex(GetPlayerPed(-1), 0, 58, 0, 2)
				elseif hats == 27 then	SetPedPropIndex(GetPlayerPed(-1), 0, 58, 1, 2)
				elseif hats == 28 then	SetPedPropIndex(GetPlayerPed(-1), 0, 60, 1, 2)
				elseif hats == 29 then	SetPedPropIndex(GetPlayerPed(-1), 0, 60, 2, 2)
				elseif hats == 30 then	SetPedPropIndex(GetPlayerPed(-1), 0, 60, 6, 2)
				elseif hats == 31 then	SetPedPropIndex(GetPlayerPed(-1), 0, 61, 0, 2)
				elseif hats == 32 then	SetPedPropIndex(GetPlayerPed(-1), 0, 61, 2, 2)
				end
			end
			
			if sex == "M" then
				if glasses == 0 then		ClearPedProp(GetPlayerPed(-1), 1)
				elseif glasses == 1 then	SetPedPropIndex(GetPlayerPed(-1), 1, 4-1, 1-1, 2)
				elseif glasses == 2 then	SetPedPropIndex(GetPlayerPed(-1), 1, 4-1, 10-1, 2)
				elseif glasses == 3 then	SetPedPropIndex(GetPlayerPed(-1), 1, 5-1, 5-1, 2)
				elseif glasses == 4 then	SetPedPropIndex(GetPlayerPed(-1), 1, 5-1, 10-1, 2)
				elseif glasses == 5 then	SetPedPropIndex(GetPlayerPed(-1), 1, 6-1, 1-1, 2)
				elseif glasses == 6 then	SetPedPropIndex(GetPlayerPed(-1), 1, 6-1, 9-1, 2)
				elseif glasses == 7 then	SetPedPropIndex(GetPlayerPed(-1), 1, 8-1, 1-1, 2)
				elseif glasses == 8 then	SetPedPropIndex(GetPlayerPed(-1), 1, 9-1, 2-1, 2)
				elseif glasses == 9 then	SetPedPropIndex(GetPlayerPed(-1), 1, 10-1, 1-1, 2)
				elseif glasses == 10 then	SetPedPropIndex(GetPlayerPed(-1), 1, 16-1, 7-1, 2)
				elseif glasses == 11 then	SetPedPropIndex(GetPlayerPed(-1), 1, 18-1, 10-1, 2)
				elseif glasses == 12 then	SetPedPropIndex(GetPlayerPed(-1), 1, 26-1, 1-1, 2)
				end
			elseif sex == "F" then
				if glasses == 0 then		ClearPedProp(GetPlayerPed(-1), 1)
				elseif glasses == 1 then	SetPedPropIndex(GetPlayerPed(-1), 1, 0, 0, 2)
				elseif glasses == 2 then	SetPedPropIndex(GetPlayerPed(-1), 1, 1, 2, 2)
				elseif glasses == 3 then	SetPedPropIndex(GetPlayerPed(-1), 1, 1, 5, 2)
				elseif glasses == 4 then	SetPedPropIndex(GetPlayerPed(-1), 1, 3, 2, 2)
				elseif glasses == 5 then	SetPedPropIndex(GetPlayerPed(-1), 1, 3, 6, 2)
				elseif glasses == 6 then	SetPedPropIndex(GetPlayerPed(-1), 1, 4, 0, 2)
				elseif glasses == 7 then	SetPedPropIndex(GetPlayerPed(-1), 1, 6, 0, 2)
				elseif glasses == 8 then	SetPedPropIndex(GetPlayerPed(-1), 1, 7, 2, 2)
				elseif glasses == 9 then	SetPedPropIndex(GetPlayerPed(-1), 1, 9, 1, 2)
				elseif glasses == 10 then	SetPedPropIndex(GetPlayerPed(-1), 1, 9, 3, 2)
				elseif glasses == 11 then	SetPedPropIndex(GetPlayerPed(-1), 1, 14, 0, 2)
				elseif glasses == 12 then	SetPedPropIndex(GetPlayerPed(-1), 1, 18, 3, 2)
				end
			end
			
			if sex == "M" then
				if ears == 0 then		ClearPedProp(GetPlayerPed(-1), 2)
				elseif ears == 1 then	SetPedPropIndex(GetPlayerPed(-1), 2, 4-1, 1-1, 2)
				elseif ears == 2 then	SetPedPropIndex(GetPlayerPed(-1), 2, 5-1, 1-1, 2)
				elseif ears == 3 then	SetPedPropIndex(GetPlayerPed(-1), 2, 6-1, 1-1, 2)
				elseif ears == 4 then	SetPedPropIndex(GetPlayerPed(-1), 2, 10-1, 2-1, 2)
				elseif ears == 5 then	SetPedPropIndex(GetPlayerPed(-1), 2, 11-1, 2-1, 2)
				elseif ears == 6 then	SetPedPropIndex(GetPlayerPed(-1), 2, 12-1, 2-1, 2)
				elseif ears == 7 then	SetPedPropIndex(GetPlayerPed(-1), 2, 19-1, 4-1, 2)
				elseif ears == 8 then	SetPedPropIndex(GetPlayerPed(-1), 2, 20-1, 4-1, 2)
				elseif ears == 9 then	SetPedPropIndex(GetPlayerPed(-1), 2, 21-1, 4-1, 2)
				elseif ears == 10 then	SetPedPropIndex(GetPlayerPed(-1), 2, 28-1, 1-1, 2)
				elseif ears == 11 then	SetPedPropIndex(GetPlayerPed(-1), 2, 29-1, 1-1, 2)
				elseif ears == 12 then	SetPedPropIndex(GetPlayerPed(-1), 2, 30-1, 1-1, 2)
				elseif ears == 13 then	SetPedPropIndex(GetPlayerPed(-1), 2, 31-1, 1-1, 2)
				elseif ears == 14 then	SetPedPropIndex(GetPlayerPed(-1), 2, 32-1, 1-1, 2)
				elseif ears == 15 then	SetPedPropIndex(GetPlayerPed(-1), 2, 33-1, 1-1, 2)
				end
			elseif sex == "F" then
				if ears == 0 then		ClearPedProp(GetPlayerPed(-1), 2)
				elseif ears == 1 then	SetPedPropIndex(GetPlayerPed(-1), 2, 1, 0, 2)
				elseif ears == 2 then	SetPedPropIndex(GetPlayerPed(-1), 2, 2, 0, 2)
				elseif ears == 3 then	SetPedPropIndex(GetPlayerPed(-1), 2, 3, 0, 2)
				elseif ears == 4 then	SetPedPropIndex(GetPlayerPed(-1), 2, 4, 0, 2)
				elseif ears == 5 then	SetPedPropIndex(GetPlayerPed(-1), 2, 5, 0, 2)
				elseif ears == 6 then	SetPedPropIndex(GetPlayerPed(-1), 2, 6, 0, 2)
				elseif ears == 7 then	SetPedPropIndex(GetPlayerPed(-1), 2, 7, 0, 2)
				elseif ears == 8 then	SetPedPropIndex(GetPlayerPed(-1), 2, 7, 1, 2)
				elseif ears == 9 then	SetPedPropIndex(GetPlayerPed(-1), 2, 8, 0, 2)
				elseif ears == 10 then	SetPedPropIndex(GetPlayerPed(-1), 2, 8, 1, 2)
				elseif ears == 11 then	SetPedPropIndex(GetPlayerPed(-1), 2, 10, 0, 2)
				elseif ears == 12 then	SetPedPropIndex(GetPlayerPed(-1), 2, 10, 1, 2)
				elseif ears == 13 then	SetPedPropIndex(GetPlayerPed(-1), 2, 12, 0, 2)
				elseif ears == 14 then	SetPedPropIndex(GetPlayerPed(-1), 2, 13, 0, 2)
				elseif ears == 15 then	SetPedPropIndex(GetPlayerPed(-1), 2, 14, 0, 2)
				elseif ears == 16 then	SetPedPropIndex(GetPlayerPed(-1), 2, 15, 0, 2)
				end
			end
			
			-- Keep these 4 variations together.
			-- It avoids empty arms or noisy clothes superposition
			if sex == "M" then
				if tops == 0 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 0, 2) 	-- Torso 2
				elseif tops == 1 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 0, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 0, 1, 2) 	-- Torso 2
				elseif tops == 2 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 0, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 0, 7, 2) 	-- Torso 2
				elseif tops == 3 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 2, 9, 2) 	-- Torso 2
				elseif tops == 4 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 5, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 3, 11, 2) 	-- Torso 2
				elseif tops == 5 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 5, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 3, 15, 2) 	-- Torso 2
				elseif tops == 6 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 23, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 4, 0, 2) 	-- Torso 2
				elseif tops == 7 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 4, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 4, 0, 2) 	-- Torso 2
				elseif tops == 8 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 26, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 4, 0, 2) 	-- Torso 2
				elseif tops == 9 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 5, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 5, 0, 2) 	-- Torso 2
				elseif tops == 10 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 4, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 6, 11, 2) 	-- Torso 2
				elseif tops == 11 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 4, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 6, 0, 2) 	-- Torso 2
				elseif tops == 12 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 4, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 6, 3, 2) 	-- Torso 2
				elseif tops == 13 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 23, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 7, 4, 2) 	-- Torso 2
				elseif tops == 14 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 23, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 7, 10, 2) 	-- Torso 2
				elseif tops == 15 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 23, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 7, 12, 2) 	-- Torso 2
				elseif tops == 16 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 23, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 7, 13, 2) 	-- Torso 2
				elseif tops == 17 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 9, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 9, 0, 2) 	-- Torso 2
				elseif tops == 18 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 10, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 10, 0, 2) 	-- Torso 2
				elseif tops == 19 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 12, 2, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 10, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 10, 0, 2) 	-- Torso 2
				elseif tops == 20 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 18, 0, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 10, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 10, 0, 2) 	-- Torso 2
				elseif tops == 21 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 11, 2, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 10, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 10, 0, 2) 	-- Torso 2
				elseif tops == 22 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 12, 10, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 12, 10, 2) 	-- Torso 2
				elseif tops == 23 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 13, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 13, 0, 2) 	-- Torso 2
				elseif tops == 24 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 14, 0, 2) 	-- Torso 2
				elseif tops == 25 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 14, 1, 2) 	-- Torso 2
				elseif tops == 26 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 16, 0, 2) 	-- Torso 2
				elseif tops == 27 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 16, 1, 2) 	-- Torso 2
				elseif tops == 28 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 16, 2, 2) 	-- Torso 2
				elseif tops == 29 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 17, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 17, 0, 2) 	-- Torso 2
				elseif tops == 30 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 17, 1, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 17, 1, 2) 	-- Torso 2
				elseif tops == 31 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 17, 4, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 17, 4, 2) 	-- Torso 2
				elseif tops == 32 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 27, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 26, 0, 2) 	-- Torso 2
				elseif tops == 33 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 27, 5, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 26, 5, 2) 	-- Torso 2
				elseif tops == 34 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 27, 6, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 26, 6, 2) 	-- Torso 2
				elseif tops == 35 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 63, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 31, 0, 2) 	-- Torso 2
				elseif tops == 36 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 57, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 36, 4, 2) 	-- Torso 2
				elseif tops == 37 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 57, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 36, 5, 2) 	-- Torso 2
				elseif tops == 38 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 24, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 37, 0, 2) 	-- Torso 2
				elseif tops == 39 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 24, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 37, 1, 2) 	-- Torso 2
				elseif tops == 40 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 24, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 37, 2, 2) 	-- Torso 2
				elseif tops == 41 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 8, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 38, 0, 2) 	-- Torso 2
				elseif tops == 42 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 8, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 38, 3, 2) 	-- Torso 2
				elseif tops == 43 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 39, 0, 2) 	-- Torso 2
				elseif tops == 44 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 39, 1, 2) 	-- Torso 2
				elseif tops == 45 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 41, 0, 2) 	-- Torso 2
				elseif tops == 46 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 42, 0, 2) 	-- Torso 2
				elseif tops == 47 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 50, 0, 2) 	-- Torso 2
				elseif tops == 48 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 50, 3, 2) 	-- Torso 2
				elseif tops == 49 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 50, 4, 2) 	-- Torso 2
				elseif tops == 50 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 57, 0, 2) 	-- Torso 2
				elseif tops == 51 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 50, 1, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 23, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 70, 0, 2) 	-- Torso 2
				elseif tops == 52 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 50, 1, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 23, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 70, 1, 2) 	-- Torso 2
				elseif tops == 53 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 50, 1, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 23, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 70, 7, 2) 	-- Torso 2
				elseif tops == 54 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 3, 1, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 72, 1, 2) 	-- Torso 2
				elseif tops == 55 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 87, 0, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 5, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 74, 0, 2) 	-- Torso 2
				elseif tops == 56 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 12, 2, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 28, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 77, 0, 2) 	-- Torso 2
				elseif tops == 57 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 79, 0, 2) 	-- Torso 2
				elseif tops == 58 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 80, 0, 2) 	-- Torso 2
				elseif tops == 59 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 80, 1, 2) 	-- Torso 2
				elseif tops == 60 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 82, 5, 2) 	-- Torso 2
				elseif tops == 61 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 82, 8, 2) 	-- Torso 2
				elseif tops == 62 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 82, 9, 2) 	-- Torso 2
				elseif tops == 63 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 86, 0, 2) 	-- Torso 2
				elseif tops == 64 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 86, 2, 2) 	-- Torso 2
				elseif tops == 65 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 86, 4, 2) 	-- Torso 2
				elseif tops == 66 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 87, 11, 2) 	-- Torso 2
				elseif tops == 67 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 87, 0, 2) 	-- Torso 2
				elseif tops == 68 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 87, 1, 2) 	-- Torso 2
				elseif tops == 69 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 87, 2, 2) 	-- Torso 2
				elseif tops == 70 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 87, 4, 2) 	-- Torso 2
				elseif tops == 71 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 87, 8, 2) 	-- Torso 2
				elseif tops == 72 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 89, 0, 2) 	-- Torso 2
				elseif tops == 73 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 95, 0, 2) 	-- Torso 2
				elseif tops == 74 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 31, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 99, 1, 2) 	-- Torso 2
				elseif tops == 75 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 31, 13, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 99, 3, 2) 	-- Torso 2
				elseif tops == 76 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 31, 13, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 101, 0, 2) 	-- Torso 2
				elseif tops == 77 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 105, 0, 2) 	-- Torso 2
				elseif tops == 78 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 10, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 106, 0, 2) 	-- Torso 2
				elseif tops == 79 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 73, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 109, 0, 2) 	-- Torso 2
				elseif tops == 80 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 111, 0, 2) 	-- Torso 2
				elseif tops == 81 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 111, 3, 2) 	-- Torso 2
				elseif tops == 82 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 113, 0, 2) 	-- Torso 2
				elseif tops == 83 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 126, 5, 2) 	-- Torso 2
				elseif tops == 84 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 126, 9, 2) 	-- Torso 2
				elseif tops == 85 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 126, 10, 2) 	-- Torso 2
				elseif tops == 86 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 126, 14, 2) 	-- Torso 2
				elseif tops == 87 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 131, 0, 2) 	-- Torso 2
				elseif tops == 88 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 134, 0, 2) 	-- Torso 2
				elseif tops == 89 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 134, 1, 2) 	-- Torso 2
				elseif tops == 90 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 0, 2) 	-- Torso 2
				elseif tops == 91 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 2, 2) 	-- Torso 2
				elseif tops == 92 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 4, 2) 	-- Torso 2
				elseif tops == 93 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 5, 2) 	-- Torso 2
				elseif tops == 94 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 6, 2) 	-- Torso 2
				elseif tops == 95 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 8, 2) 	-- Torso 2
				elseif tops == 96 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 9, 2) 	-- Torso 2
				elseif tops == 97 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 146, 0, 2) 	-- Torso 2
				elseif tops == 98 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 16, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 166, 0, 2) 	-- Torso 2
				elseif tops == 99 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 38, 1, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 167, 0, 2) 	-- Torso 2
				elseif tops == 100 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 38, 1, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 167, 4, 2) 	-- Torso 2
				elseif tops == 101 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 38, 1, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 167, 6, 2) 	-- Torso 2
				elseif tops == 102 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 38, 1, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 167, 12, 2) 	-- Torso 2
				elseif tops == 103 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 38, 1, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 169, 0, 2) 	-- Torso 2
				elseif tops == 104 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 38, 1, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 172, 0, 2) 	-- Torso 2
				elseif tops == 105 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 38, 1, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 173, 0, 2) 	-- Torso 2
				elseif tops == 106 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 41, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 185, 0, 2) 	-- Torso 2
				elseif tops == 107 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 202, 0, 2) 	-- Torso 2
				elseif tops == 108 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 203, 10, 2) 	-- Torso 2
				elseif tops == 109 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 203, 16, 2) 	-- Torso 2
				elseif tops == 110 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 203, 25, 2) 	-- Torso 2
				elseif tops == 111 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 205, 0, 2) 	-- Torso 2
				elseif tops == 112 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 226, 0, 2) 	-- Torso 2
				elseif tops == 113 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 257, 0, 2) 	-- Torso 2
				elseif tops == 114 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 257, 9, 2) 	-- Torso 2
				elseif tops == 115 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 257, 17, 2) 	-- Torso 2
				elseif tops == 116 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 259, 9, 2) 	-- Torso 2
				elseif tops == 117 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 5, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 269, 2, 2) 	-- Torso 2
				elseif tops == 118 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 282, 6, 2) 	-- Torso 2
				end
			elseif sex == "F" then --start pf female tops
				if tops == 0 then --none
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso arms?
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck/accessories
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 0, 2) 	-- Torso 2 our main item
				elseif tops == 1 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso/arms
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 0, 12, 2) 	-- Torso 2
				elseif tops == 2 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 26, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 1, 0, 2) 	-- Torso 2
				elseif tops == 3 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 26, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 1, 5, 2) 	-- Torso 2
				elseif tops == 4 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 26, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 1, 9, 2) 	-- Torso 2
				elseif tops == 5 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 2, 7, 2) 	-- Torso 2
				elseif tops == 6 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 2, 9, 2) 	-- Torso 2
				elseif tops == 7 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 2, 10, 2) 	-- Torso 2
				elseif tops == 8 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 2, 15, 2) 	-- Torso 2
				elseif tops == 9 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 3, 2, 2) 	-- Torso 2
				elseif tops == 10 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 4, 13, 2) 	-- Torso 2
				elseif tops == 11 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 4, 14, 2) 	-- Torso 2
				elseif tops == 12 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 5, 7, 2) 	-- Torso 2
				elseif tops == 13 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 41, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 6, 0, 2) 	-- Torso 2
				elseif tops == 14 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 41, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 6, 1, 2) 	-- Torso 2
				elseif tops == 15 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 41, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 6, 2, 2) 	-- Torso 2
				elseif tops == 16 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 41, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 6, 4, 2) 	-- Torso 2
				elseif tops == 17 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 41, 2, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 7, 0, 2) 	-- Torso 2
				elseif tops == 18 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 41, 2, 2) 		-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 7, 8, 2) 	-- Torso 2
				elseif tops == 19 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 30, 3, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 8, 2, 2) 	-- Torso 2
				elseif tops == 20 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 30, 3, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 8, 12, 2) 	-- Torso 2 2
				elseif tops == 21 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 30, 3, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 8, 1, 2) 	-- Torso 2
				elseif tops == 22 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 29, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 9, 0, 2) 	-- Torso 2
				elseif tops == 23 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 29, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 9, 1, 2) 	-- Torso 2
				elseif tops == 24 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 29, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 9, 2, 2) 	-- Torso 2
				elseif tops == 25 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 29, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 9, 5, 2) 	-- Torso 2
				elseif tops == 26 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 29, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 9, 6, 2) 	-- Torso 2
				elseif tops == 27 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 1, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 10, 0, 2) 	-- Torso 2
				elseif tops == 28 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 1, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 10, 1, 2) 	-- Torso 2
				elseif tops == 29 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 1, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 10, 10, 2) 	-- Torso 2
				elseif tops == 30 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 1, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 10, 15, 2) 	-- Torso 2
				elseif tops == 31 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 11, 0, 2) 	-- Torso 2
				elseif tops == 32 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 11, 2, 2) 	-- Torso 2
				elseif tops == 33 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 12, 7, 2) 	-- Torso 2
				elseif tops == 34 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 12, 8, 2) 	-- Torso 2
				elseif tops == 35 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 12, 9, 2) 	-- Torso 2
				elseif tops == 36 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 13, 0, 2) 	-- Torso 2
				elseif tops == 37 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 13, 1, 2) 	-- Torso 2
				elseif tops == 38 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 13, 5, 2) 	-- Torso 2
				elseif tops == 39 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 14, 0, 2) 	-- Torso 2
				elseif tops == 40 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 14, 1, 2) 	-- Torso 2
				elseif tops == 41 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 14, 3, 2) 	-- Torso 2
				elseif tops == 42 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 14, 10, 2) 	-- Torso 2
				elseif tops == 43 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 10, 2) 	-- Torso 2
				elseif tops == 44 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 11, 2) 	-- Torso 2
				elseif tops == 45 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 16, 0, 2) 	-- Torso 2
				elseif tops == 46 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 16, 1, 2) 	-- Torso 2
				elseif tops == 47 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 16, 2, 2) 	-- Torso 2
				elseif tops == 48 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 16, 3, 2) 	-- Torso 2
				elseif tops == 49 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 17, 0, 2) 	-- Torso 2
				elseif tops == 50 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 18, 1, 2) 	-- Torso 2
				elseif tops == 51 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 18, 6, 2) 	-- Torso 2
				elseif tops == 52 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 18, 9, 2) 	-- Torso 2
				elseif tops == 53 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 21, 0, 2) 	-- Torso 2
				elseif tops == 54 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 21, 1, 2) 	-- Torso 2
				elseif tops == 55 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 21, 5, 2) 	-- Torso 2
				elseif tops == 56 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 37, 0, 2) 	-- Torso 2
				elseif tops == 57 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 37, 5, 2) 	-- Torso 2
				elseif tops == 58 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 	-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 37, 4, 2) 	-- Torso 2
				elseif tops == 59 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 46, 0, 2) 	-- Torso 2
				elseif tops == 60 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 46, 2, 2) 	-- Torso 2
				elseif tops == 61 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 49, 0, 2) 	-- Torso 2
				elseif tops == 62 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 49, 1, 2) 	-- Torso 2
				elseif tops == 63 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 27, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 65, 0, 2) 	-- Torso 2
				elseif tops == 64 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 27, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 65, 3, 2) 	-- Torso 2
				elseif tops == 65 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 27, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 65, 4, 2) 	-- Torso 2
				elseif tops == 66 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 70, 0, 2) 	-- Torso 2
				elseif tops == 67 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 70, 1, 2) 	-- Torso 2
				elseif tops == 68 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 70, 2, 2) 	-- Torso 2
				elseif tops == 69 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 71, 0, 2) 	-- Torso 2
				elseif tops == 70 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 71, 1, 2) 	-- Torso 2
				elseif tops == 71 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 71, 2, 2) 	-- Torso 2
				elseif tops == 72 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 71, 8, 2) 	-- Torso 2
				elseif tops == 73 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 71, 12, 2) 	-- Torso 2
				elseif tops == 74 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 71, 15, 2) 	-- Torso 2
				elseif tops == 75 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 95, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 64, 0, 2) 	-- Torso 2
				elseif tops == 76 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 95, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 64, 1, 2) 	-- Torso 2
				elseif tops == 77 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 95, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 64, 3, 2) 	-- Torso 2
				elseif tops == 78 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 68, 0, 2) 	-- Torso 2
				elseif tops == 79 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 68, 7, 2) 	-- Torso 2
				elseif tops == 80 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 69, 0, 2) 	-- Torso 2
				elseif tops == 81 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 79, 0, 2) 	-- Torso 2
				elseif tops == 82 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 0, 2) 	-- Torso 2
				elseif tops == 83 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 1, 2) 	-- Torso 2
				elseif tops == 84 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 2, 2) 	-- Torso 2
				elseif tops == 85 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 3, 2) 	-- Torso 2
				elseif tops == 86 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 4, 2) 	-- Torso 2
				elseif tops == 87 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 5, 2) 	-- Torso 2
				elseif tops == 88 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 10, 2) 	-- Torso 2
				elseif tops == 89 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 11, 2) 	-- Torso 2
				elseif tops == 90 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 109, 0, 2) 	-- Torso 2
				elseif tops == 91 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 109, 1, 2) 	-- Torso 2
				elseif tops == 92 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 109, 3, 2) 	-- Torso 2
				elseif tops == 93 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 110, 0, 2) 	-- Torso 2
				elseif tops == 94 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 110, 1, 2) 	-- Torso 2
				elseif tops == 95 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 110, 2, 2) 	-- Torso 2
				elseif tops == 96 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 110, 3, 2) 	-- Torso 2
				elseif tops == 97 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 146, 4, 2) 	-- Torso 2
				elseif tops == 98 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 110, 6, 2) 	-- Torso 2
				elseif tops == 99 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 26, 1, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 120, 0, 2) 	-- Torso 2
				elseif tops == 100 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 26, 1, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 120, 2, 2) 	-- Torso 2
				elseif tops == 101 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 26, 1, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 120, 3, 2) 	-- Torso 2
				elseif tops == 102 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 26, 1, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 120, 8, 2) 	-- Torso 2
				elseif tops == 103 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 127, 0, 2) 	-- Torso 2
				elseif tops == 104 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 131, 0, 2) 	-- Torso 2
				elseif tops == 105 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 149, 0, 2) 	-- Torso 2
				elseif tops == 106 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 149, 1, 2) 	-- Torso 2
				elseif tops == 107 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 149, 2, 2) 	-- Torso 2
				elseif tops == 108 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 27, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 154, 0, 2) 	-- Torso 2
				elseif tops == 109 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 27, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 154, 1, 2) 	-- Torso 2
				elseif tops == 110 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 27, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 155, 0, 2) 	-- Torso 2
				elseif tops == 111 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 27, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 155, 1, 2) 	-- Torso 2
				elseif tops == 112 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 27, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 163, 0, 2) 	-- Torso 2
				elseif tops == 113 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 1, 0, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 168, 0, 2) 	-- Torso 2
				elseif tops == 114 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 11, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 193, 0, 2) 	-- Torso 2
				elseif tops == 115 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 11, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 193, 1, 2) 	-- Torso 2
				elseif tops == 116 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 11, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 193, 2, 2) 	-- Torso 2
				elseif tops == 117 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Torso --to prevent a glitch
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 11, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 193, 21, 2) 	-- Torso 2
				elseif tops == 118 then
					SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Torso --to prevent a glitch
					SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
					SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
					SetPedComponentVariation(GetPlayerPed(-1), 8, 11, 2, 2) 	-- Undershirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 193, 24, 2) 	-- Torso 2
				end
			end
			if sex == "M" then
				if pants == 0 then 		SetPedComponentVariation(GetPlayerPed(-1), 4, 61, 4, 2)
				elseif pants == 1 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 0, 2)
				elseif pants == 2 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 2, 2)
				elseif pants == 3 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 1, 12, 2)
				elseif pants == 4 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 2, 11, 2)
				elseif pants == 5 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 3, 0, 2)
				elseif pants == 6 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 4, 0, 2)
				elseif pants == 7 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 4, 1, 2)
				elseif pants == 8 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 4, 4, 2)
				elseif pants == 9 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 5, 0, 2)
				elseif pants == 10 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 5, 2, 2)
				elseif pants == 11 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 7, 0, 2)
				elseif pants == 12 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 7, 1, 2)
				elseif pants == 13 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 9, 0, 2)
				elseif pants == 14 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 9, 1, 2)
				elseif pants == 15 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 10, 0, 2)
				elseif pants == 16 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 10, 2, 2)
				elseif pants == 17 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 12, 0, 2)
				elseif pants == 18 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 12, 5, 2)
				elseif pants == 19 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 12, 7, 2)
				elseif pants == 20 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 0, 2)
				elseif pants == 21 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 1, 2)
				elseif pants == 22 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 3, 2)
				elseif pants == 23 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 15, 0, 2)
				elseif pants == 24 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 20, 0, 2)
				elseif pants == 25 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 0, 2)
				elseif pants == 26 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 1, 2)
				elseif pants == 27 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 5, 2)
				elseif pants == 28 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 26, 0, 2)
				elseif pants == 29 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 26, 4, 2)
				elseif pants == 30 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 26, 5, 2)
				elseif pants == 31 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 26, 6, 2)
				elseif pants == 32 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 28, 0, 2)
				elseif pants == 33 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 28, 3, 2)
				elseif pants == 34 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 28, 8, 2)
				elseif pants == 35 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 28, 14, 2)
				elseif pants == 36 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 42, 0, 2)
				elseif pants == 37 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 42, 1, 2)
				elseif pants == 38 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 48, 0, 2)
				elseif pants == 39 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 48, 1, 2)
				elseif pants == 40 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 49, 0, 2)
				elseif pants == 41 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 49, 1, 2)
				elseif pants == 42 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 54, 1, 2)
				elseif pants == 43 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 55, 0, 2)
				elseif pants == 44 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 60, 2, 2)
				elseif pants == 45 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 60, 9, 2)
				elseif pants == 46 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 71, 0, 2)
				elseif pants == 47 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 75, 2, 2)
				elseif pants == 48 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 76, 2, 2)
				elseif pants == 49 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 78, 0, 2)
				elseif pants == 50 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 78, 2, 2)
				elseif pants == 51 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 78, 4, 2)
				elseif pants == 52 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 82, 0, 2)
				elseif pants == 53 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 82, 2, 2)
				elseif pants == 54 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 82, 3, 2)
				elseif pants == 55 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 86, 9, 2)
				elseif pants == 56 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 88, 9, 2)
				elseif pants == 57 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 100, 9, 2)
				end
			elseif sex == "F" then
				if pants == 0 then 		SetPedComponentVariation(GetPlayerPed(-1), 4, 15, 3, 2)
				elseif pants == 1 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 0, 2)
				elseif pants == 2 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 6, 2)
				elseif pants == 3 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 14, 2)
				elseif pants == 4 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 1, 5, 2)
				elseif pants == 5 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 1, 0, 2)
				elseif pants == 6 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 2, 2, 2)
				elseif pants == 7 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 4, 1, 2)
				elseif pants == 8 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 5, 8, 2)
				elseif pants == 9 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 6, 0, 2)
				elseif pants == 10 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 6, 1, 2)
				elseif pants == 11 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 7, 0, 2)
				elseif pants == 12 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 8, 5, 2)
				elseif pants == 13 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 8, 3, 2)
				elseif pants == 14 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 12, 1, 2)
				elseif pants == 15 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 12, 4, 2)
				elseif pants == 16 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 23, 10, 2)
				elseif pants == 17 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 2, 2)
				elseif pants == 18 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 6, 2)
				elseif pants == 19 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 27, 6, 2)
				elseif pants == 20 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 27, 11, 2)
				elseif pants == 21 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 30, 4, 2)
				elseif pants == 22 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 43, 0, 2)
				elseif pants == 23 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 44, 1, 2)
				elseif pants == 24 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 45, 1, 2)
				elseif pants == 25 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 54, 2, 2)
				elseif pants == 26 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 57, 2, 2)
				elseif pants == 27 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 58, 1, 2)
				elseif pants == 28 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 69, 0, 2)
				elseif pants == 29 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 69, 1, 2)
				elseif pants == 30 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 69, 3, 2)
				elseif pants == 31 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 69, 5, 2)
				elseif pants == 32 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 69, 6, 2)
				elseif pants == 33 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 71, 1, 2)
				elseif pants == 34 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 73, 1, 2)
				elseif pants == 35 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 73, 3, 2)
				elseif pants == 36 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 74, 0, 2)
				elseif pants == 37 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 74, 1, 2)
				elseif pants == 38 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 74, 5, 2)
				elseif pants == 39 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 77, 0, 2)
				elseif pants == 40 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 78, 1, 2)
				elseif pants == 41 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 80, 1, 2)
				elseif pants == 42 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 89, 6, 2)
				elseif pants == 43 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 89, 9, 2)
				elseif pants == 44 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 91, 14, 2)
				elseif pants == 45 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 93, 2, 2)
				elseif pants == 46 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 93, 1, 2)
				elseif pants == 47 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 97, 6, 2)
				elseif pants == 48 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 110, 9, 2)
				elseif pants == 49 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 112, 1, 2)
				elseif pants == 50 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 112, 2, 2)
				elseif pants == 51 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 112, 7, 2)
				elseif pants == 52 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 113, 14, 2)
				elseif pants == 53 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 107, 2, 2)
				elseif pants == 54 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 107, 3, 2) 
				elseif pants == 55 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 107, 6, 2)
				elseif pants == 56 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 63, 2, 2)
				elseif pants == 57 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 63, 5, 2)
				end
			end
			if sex == "M" then
				if shoes == 0 then 	SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 2)
				elseif shoes == 1 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 0, 10, 2)
				elseif shoes == 2 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 0, 2)
				elseif shoes == 3 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 1, 2)
				elseif shoes == 4 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 3, 2)
				elseif shoes == 5 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 3, 0, 2)
				elseif shoes == 6 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 3, 6, 2)
				elseif shoes == 7 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 3, 14, 2)
				elseif shoes == 8 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 48, 0, 2)
				elseif shoes == 9 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 48, 1, 2)
				elseif shoes == 10 then SetPedComponentVariation(GetPlayerPed(-1), 6, 49, 0, 2)
				elseif shoes == 11 then SetPedComponentVariation(GetPlayerPed(-1), 6, 49, 1, 2)
				elseif shoes == 12 then SetPedComponentVariation(GetPlayerPed(-1), 6, 5, 0, 2)
				elseif shoes == 13 then SetPedComponentVariation(GetPlayerPed(-1), 6, 6, 0, 2)
				elseif shoes == 14 then SetPedComponentVariation(GetPlayerPed(-1), 6, 7, 0, 2)
				elseif shoes == 15 then SetPedComponentVariation(GetPlayerPed(-1), 6, 7, 9, 2)
				elseif shoes == 16 then SetPedComponentVariation(GetPlayerPed(-1), 6, 7, 13, 2)
				elseif shoes == 17 then SetPedComponentVariation(GetPlayerPed(-1), 6, 9, 3, 2)
				elseif shoes == 18 then SetPedComponentVariation(GetPlayerPed(-1), 6, 9, 6, 2)
				elseif shoes == 19 then SetPedComponentVariation(GetPlayerPed(-1), 6, 9, 7, 2)
				elseif shoes == 20 then SetPedComponentVariation(GetPlayerPed(-1), 6, 10, 0, 2)
				elseif shoes == 21 then SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 0, 2)
				elseif shoes == 22 then SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 2, 2)
				elseif shoes == 23 then SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 13, 2)
				elseif shoes == 24 then SetPedComponentVariation(GetPlayerPed(-1), 6, 15, 0, 2)
				elseif shoes == 25 then SetPedComponentVariation(GetPlayerPed(-1), 6, 15, 1, 2)
				elseif shoes == 26 then SetPedComponentVariation(GetPlayerPed(-1), 6, 16, 0, 2)
				elseif shoes == 27 then SetPedComponentVariation(GetPlayerPed(-1), 6, 20, 0, 2)
				elseif shoes == 28 then SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 2)
				elseif shoes == 29 then SetPedComponentVariation(GetPlayerPed(-1), 6, 27, 0, 2)
				elseif shoes == 30 then SetPedComponentVariation(GetPlayerPed(-1), 6, 28, 0, 2)
				elseif shoes == 31 then SetPedComponentVariation(GetPlayerPed(-1), 6, 28, 1, 2)
				elseif shoes == 32 then SetPedComponentVariation(GetPlayerPed(-1), 6, 28, 3, 2)
				elseif shoes == 33 then SetPedComponentVariation(GetPlayerPed(-1), 6, 28, 2, 2)
				elseif shoes == 34 then SetPedComponentVariation(GetPlayerPed(-1), 6, 31, 2, 2)
				elseif shoes == 35 then SetPedComponentVariation(GetPlayerPed(-1), 6, 31, 4, 2)
				elseif shoes == 36 then SetPedComponentVariation(GetPlayerPed(-1), 6, 36, 0, 2)
				elseif shoes == 37 then SetPedComponentVariation(GetPlayerPed(-1), 6, 36, 3, 2)
				elseif shoes == 38 then SetPedComponentVariation(GetPlayerPed(-1), 6, 42, 0, 2)
				elseif shoes == 39 then SetPedComponentVariation(GetPlayerPed(-1), 6, 42, 1, 2)
				elseif shoes == 40 then SetPedComponentVariation(GetPlayerPed(-1), 6, 42, 7, 2)
				elseif shoes == 41 then SetPedComponentVariation(GetPlayerPed(-1), 6, 57, 0, 2)
				elseif shoes == 42 then SetPedComponentVariation(GetPlayerPed(-1), 6, 57, 3, 2)
				elseif shoes == 43 then SetPedComponentVariation(GetPlayerPed(-1), 6, 57, 8, 2)
				elseif shoes == 44 then SetPedComponentVariation(GetPlayerPed(-1), 6, 57, 9, 2)
				elseif shoes == 45 then SetPedComponentVariation(GetPlayerPed(-1), 6, 57, 10, 2)
				elseif shoes == 46 then SetPedComponentVariation(GetPlayerPed(-1), 6, 57, 11, 2)
				elseif shoes == 47 then SetPedComponentVariation(GetPlayerPed(-1), 6, 75, 4, 2)
				elseif shoes == 48 then SetPedComponentVariation(GetPlayerPed(-1), 6, 75, 7, 2)
				elseif shoes == 49 then SetPedComponentVariation(GetPlayerPed(-1), 6, 75, 8, 2)
				elseif shoes == 50 then SetPedComponentVariation(GetPlayerPed(-1), 6, 77, 0, 2)
				end
			elseif sex == "F" then
				if shoes == 0 then 	SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 2)
				elseif shoes == 1 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 0, 0, 2)
				elseif shoes == 2 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 0, 2, 2)
				elseif shoes == 3 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 0, 2)
				elseif shoes == 4 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 1, 2)
				elseif shoes == 5 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 4, 2)
				elseif shoes == 6 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 6, 2)
				elseif shoes == 7 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 2, 0, 2)
				elseif shoes == 8 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 2, 1, 2)
				elseif shoes == 9 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 2, 6, 2)
				elseif shoes == 10 then SetPedComponentVariation(GetPlayerPed(-1), 6, 4, 1, 2)
				elseif shoes == 11 then SetPedComponentVariation(GetPlayerPed(-1), 6, 5, 1, 2)
				elseif shoes == 12 then SetPedComponentVariation(GetPlayerPed(-1), 6, 5, 10, 2)
				elseif shoes == 13 then SetPedComponentVariation(GetPlayerPed(-1), 6, 6, 0, 2)
				elseif shoes == 14 then SetPedComponentVariation(GetPlayerPed(-1), 6, 6, 1, 2)
				elseif shoes == 15 then SetPedComponentVariation(GetPlayerPed(-1), 6, 6, 2, 2)
				elseif shoes == 16 then SetPedComponentVariation(GetPlayerPed(-1), 6, 6, 3, 2)
				elseif shoes == 17 then SetPedComponentVariation(GetPlayerPed(-1), 6, 7, 0, 2)
				elseif shoes == 18 then SetPedComponentVariation(GetPlayerPed(-1), 6, 7, 3, 2)
				elseif shoes == 19 then SetPedComponentVariation(GetPlayerPed(-1), 6, 9, 0, 2)
				elseif shoes == 20 then SetPedComponentVariation(GetPlayerPed(-1), 6, 9, 3, 2)
				elseif shoes == 21 then SetPedComponentVariation(GetPlayerPed(-1), 6, 10, 0, 2)
				elseif shoes == 22 then SetPedComponentVariation(GetPlayerPed(-1), 6, 10, 1, 2)
				elseif shoes == 23 then SetPedComponentVariation(GetPlayerPed(-1), 6, 11, 0, 2)
				elseif shoes == 24 then SetPedComponentVariation(GetPlayerPed(-1), 6, 11, 1, 2)
				elseif shoes == 25 then SetPedComponentVariation(GetPlayerPed(-1), 6, 11, 2, 2)
				elseif shoes == 26 then SetPedComponentVariation(GetPlayerPed(-1), 6, 13, 0, 2)
				elseif shoes == 27 then SetPedComponentVariation(GetPlayerPed(-1), 6, 13, 3, 2)
				elseif shoes == 28 then SetPedComponentVariation(GetPlayerPed(-1), 6, 13, 5, 2)
				elseif shoes == 29 then SetPedComponentVariation(GetPlayerPed(-1), 6, 14, 0, 2)
				elseif shoes == 30 then SetPedComponentVariation(GetPlayerPed(-1), 6, 14, 3, 2)
				elseif shoes == 31 then SetPedComponentVariation(GetPlayerPed(-1), 6, 14, 4, 2)
				elseif shoes == 32 then SetPedComponentVariation(GetPlayerPed(-1), 6, 14, 5, 2)
				elseif shoes == 33 then SetPedComponentVariation(GetPlayerPed(-1), 6, 15, 0, 2)
				elseif shoes == 34 then SetPedComponentVariation(GetPlayerPed(-1), 6, 15, 12, 2)
				elseif shoes == 35 then SetPedComponentVariation(GetPlayerPed(-1), 6, 16, 4, 2)
				elseif shoes == 36 then SetPedComponentVariation(GetPlayerPed(-1), 6, 16, 6, 2)
				elseif shoes == 37 then SetPedComponentVariation(GetPlayerPed(-1), 6, 19, 0, 2)
				elseif shoes == 38 then SetPedComponentVariation(GetPlayerPed(-1), 6, 19, 1, 2)
				elseif shoes == 39 then SetPedComponentVariation(GetPlayerPed(-1), 6, 19, 2, 2)
				elseif shoes == 40 then SetPedComponentVariation(GetPlayerPed(-1), 6, 22, 1, 2)
				elseif shoes == 41 then SetPedComponentVariation(GetPlayerPed(-1), 6, 22, 3, 2)
				elseif shoes == 42 then SetPedComponentVariation(GetPlayerPed(-1), 6, 22, 4, 2)
				elseif shoes == 43 then SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 2)
				elseif shoes == 44 then SetPedComponentVariation(GetPlayerPed(-1), 6, 25, 0, 2)
				elseif shoes == 45 then SetPedComponentVariation(GetPlayerPed(-1), 6, 30, 0, 2)
				elseif shoes == 46 then SetPedComponentVariation(GetPlayerPed(-1), 6, 31, 0, 2)
				elseif shoes == 47 then SetPedComponentVariation(GetPlayerPed(-1), 6, 32, 1, 2)
				elseif shoes == 48 then SetPedComponentVariation(GetPlayerPed(-1), 6, 37, 3, 2)
				elseif shoes == 49 then SetPedComponentVariation(GetPlayerPed(-1), 6, 37, 1, 2)
				elseif shoes == 50 then SetPedComponentVariation(GetPlayerPed(-1), 6, 62, 6, 2)
				end
			end
			
			if watches == 0 then		ClearPedProp(GetPlayerPed(-1), 6)
			elseif watches == 1 then	SetPedPropIndex(GetPlayerPed(-1), 6, 1-1, 1-1, 2)
			elseif watches == 2 then	SetPedPropIndex(GetPlayerPed(-1), 6, 2-1, 1-1, 2)
			elseif watches == 3 then	SetPedPropIndex(GetPlayerPed(-1), 6, 4-1, 1-1, 2)
			elseif watches == 4 then	SetPedPropIndex(GetPlayerPed(-1), 6, 4-1, 3-1, 2)
			elseif watches == 5 then	SetPedPropIndex(GetPlayerPed(-1), 6, 5-1, 1-1, 2)
			elseif watches == 6 then	SetPedPropIndex(GetPlayerPed(-1), 6, 9-1, 1-1, 2)
			elseif watches == 7 then	SetPedPropIndex(GetPlayerPed(-1), 6, 11-1, 1-1, 2)
			end
			
			if bag == 0 then --done for female
				SetPedComponentVariation(GetPlayerPed(-1),5,0,0,2)
			elseif bag == 1 then
				SetPedComponentVariation(GetPlayerPed(-1),5,40,0,2)
			elseif bag == 2 then
				SetPedComponentVariation(GetPlayerPed(-1),5,41,0,2)
			elseif bag == 3 then
				SetPedComponentVariation(GetPlayerPed(-1),5,44,0,2)
			elseif bag == 4 then
				SetPedComponentVariation(GetPlayerPed(-1),5,45,0,2)
			end
			
			if mask == 0 then --done for female
				SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 2)    	-- Mask
			elseif mask == 1 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 1, 0, 2)    	-- Mask
			elseif mask == 2 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 1, 3, 2)    	-- Mask
			elseif mask == 3 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 2, 0, 2)    	-- Mask
			elseif mask == 4 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 2, 1, 2)    	-- Mask
			elseif mask == 5 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 2, 3, 2)
			elseif mask == 6 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 3, 0, 2)
			elseif mask == 7 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 4, 0, 2)
			elseif mask == 8 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 4, 1, 2)
			elseif mask == 9 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 5, 0, 2)
			elseif mask == 10 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 5, 2, 2)
			elseif mask == 11 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 6, 0, 2)
			elseif mask == 12 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 6, 1, 2)
			elseif mask == 13 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 6, 2, 2)
			elseif mask == 14 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 6, 3, 2)
			elseif mask == 15 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 7, 0, 2)
			elseif mask == 16 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 7, 1, 2)
			elseif mask == 17 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 8, 0, 2)
			elseif mask == 18 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 9, 0, 2)
			elseif mask == 19 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 10, 0, 2)
			elseif mask == 20 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 13, 0, 2)
			elseif mask == 21 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 17, 0, 2)
			elseif mask == 22 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 18, 0, 2)
			elseif mask == 23 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 19, 0, 2)
			elseif mask == 24 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 20, 0, 2)
			elseif mask == 25 then
				SetPedComponentVariation(GetPlayerPed(-1), 1, 21, 0, 2)
			elseif mask == 26 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,23,0,2)
			elseif mask == 27 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,24,0,2)
			elseif mask == 28 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,28,0,2)
			elseif mask == 29 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,33,0,2)
			elseif mask == 30 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,37,0,2)
			elseif mask == 31 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,39,0,2)
			elseif mask == 32 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,42,0,2)
			elseif mask == 33 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,44,0,2)
			elseif mask == 34 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,46,0,2)
			elseif mask == 35 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,49,0,2)
			elseif mask == 36 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,50,3,2)
			elseif mask == 37 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,51,1,2)
			elseif mask == 38 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,51,5,2)
			elseif mask == 39 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,51,6,2)
			elseif mask == 40 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,51,8,2)
			elseif mask == 41 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,53,0,2)
			elseif mask == 42 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,54,0,2)
			elseif mask == 43 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,54,5,2)
			elseif mask == 44 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,56,0,2)
			elseif mask == 45 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,56,1,2)
			elseif mask == 46 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,56,2,2)
			elseif mask == 47 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,56,4,2)
			elseif mask == 48 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,60,0,2)
			elseif mask == 49 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,65,0,2)
			elseif mask == 50 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,68,0,2)
			elseif mask == 51 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,71,1,2)
			elseif mask == 52 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,77,0,2)
			elseif mask == 53 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,93,0,2)
			elseif mask == 54 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,95,0,2)
			elseif mask == 55 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,97,0,2)
			elseif mask == 56 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,98,0,2)
			elseif mask == 57 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,100,0,2)
			elseif mask == 58 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,115,0,2)
			elseif mask == 59 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,130,0,2)
			elseif mask == 60 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,133,0,2)
			elseif mask == 61 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,143,0,2)
			elseif mask == 62 then
				SetPedComponentVariation(GetPlayerPed(-1), 1,144,0,2)
			end
		end
	end
end)

-- Character rotation
RegisterNUICallback('rotateleftheading', function(data)
	local currentHeading = GetEntityHeading(GetPlayerPed(-1))
	heading = currentHeading+tonumber(data.value)
end)

RegisterNUICallback('rotaterightheading', function(data)
	local currentHeading = GetEntityHeading(GetPlayerPed(-1))
	heading = currentHeading-tonumber(data.value)
end)

-- Define which part of the body must be zoomed
RegisterNUICallback('zoom', function(data)
	zoom = data.zoom
end)


local CamCoord = 'default'
RegisterNUICallback('DefaultCam', function()
   CamCoord = 'default'
end)

RegisterNUICallback('HeadCam', function()
   CamCoord = 'head'
end)

RegisterNUICallback('WaistCam', function()
   CamCoord = 'waist'
end)

RegisterNUICallback('FeetCam', function()
   CamCoord = 'feet'
end)

------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------

function SkinCreator(enable)
	local ped = GetPlayerPed(-1)
	ShowSkinCreator(enable)
	
	-- Disable Controls
	-- TODO: Reset controls when player confirm his character creation
	if enable == true then
		DisableControlAction(2, 14, true)
		DisableControlAction(2, 15, true)
		DisableControlAction(2, 16, true)
		DisableControlAction(2, 17, true)
		DisableControlAction(2, 30, true)
		DisableControlAction(2, 31, true)
		DisableControlAction(2, 32, true)
		DisableControlAction(2, 33, true)
		DisableControlAction(2, 34, true)
		DisableControlAction(2, 35, true)
		DisableControlAction(0, 25, true)
		DisableControlAction(0, 24, true)
		
		-- if IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
		-- 	SendNUIMessage({type = "click"})
		-- end
		
		-- Player
		SetPlayerInvincible(ped, true)
		
		-- Camera
		RenderScriptCams(false, false, 0, 1, 0)
		DestroyCam(cam, false)
		if(not DoesCamExist(cam)) then
			cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
			SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
			SetCamRot(cam, 0.0, 0.0, 0.0)
			SetCamActive(cam,  true)
			RenderScriptCams(true,  false,  0,  true,  true)
			SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
		end
		
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
				
		--Default Zoomed Out
		if CamCoord == 'default' then
		   SetCamCoord(cam, x-0.2, y-2.0, z)
		   SetCamRot(cam, 0.0, 0.0, 365.0)
	
		elseif CamCoord == "head" then		
		   SetCamCoord(cam, x-0.0, y-0.5, z+0.7)
           SetCamRot(cam, 0.0, 0.0, 360.0)		
     			
		elseif CamCoord == "waist" then		
		   SetCamCoord(cam, x-0.0, y-0.75, z+0.0)
           SetCamRot(cam, 0.0, 0.0, 360.0)
        
        elseif CamCoord == "feet" then		
		   SetCamCoord(cam, x-0.0, y-0.75, z-0.75)
           SetCamRot(cam, 0.0, 0.0, 360.0)			
        end

	else
		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(ped, false)
	end
end

function ShowSkinCreator(enable)
	SetNuiFocus(enable, enable)
	SendNUIMessage({
		openSkinCreator = enable,
		gender = sex
	})
end


------------------------------------------------------------------
--                          Citizen
------------------------------------------------------------------



Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) 
			ESX = obj 
		end)
		Citizen.Wait(5)
	end
	while not ESX.IsPlayerLoaded() do
		Citizen.Wait(250)
	end
	
	while true do
		if isSkinCreatorOpened == true then
			SkinCreator(true)
			SetEntityHeading(GetPlayerPed(-1), heading)
		elseif not isSkinCreatorOpened and sex == nil then
			SkinCreator(false)
			SetEntityHeading(GetPlayerPed(-1), 69.58)
			local pos = GetEntityCoords(GetPlayerPed(-1), true)
			cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x,pos.y,pos.z+200, 300.00,0.00,0.00, 100.00, false, 0)
			PointCamAtCoord(cam, pos.x,pos.y,pos.z+2)
			SetCamActiveWithInterp(cam, cam2, 3700, true, true)
			Citizen.Wait(250)
			PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
			RenderScriptCams(false, true, 500, true, true)
			PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
			FreezeEntityPosition(GetPlayerPed(-1), false)
			Citizen.Wait(500)
			SetCamActive(cam, false)
			DestroyCam(cam, true)
			return
		end
		Citizen.Wait(0)
	end
	
end)

RegisterNetEvent('showSkinCreator')
AddEventHandler('showSkinCreator', function(_sex)
	sex = _sex
	if sex ~= nil then 
		loadPed(sex, nil)
		isSkinCreatorOpened = not isSkinCreatorOpened
	else
		isSkinCreatorOpened = not isSkinCreatorOpened
	end
end)

function loadPed(_sex, value)
	local playerPed = PlayerPedId()
	local characterModel
	
	if _sex ~= nil then
		sex = _sex
	end
	if value ~= nil then
		if sex == "F" then
			if value == 0 then
				model = 'mp_f_freemode_01'
			elseif value == 1 then
				model = 'ig_abigail'
			elseif value == 2 then
				model = 's_f_y_airhostess_01'
			elseif value == 3 then
				model = 'ig_amandatownley'
			elseif value == 4 then
				model = 'csb_anita'
			elseif value == 5 then
				model = 'ig_ashley'
			elseif value == 6 then
				model = 'g_f_y_ballas_01'
			elseif value == 7 then
				model = 's_f_y_bartender_01'
			elseif value == 8 then
				model = 's_f_y_baywatch_01'
			elseif value == 9 then
				model = 'a_f_m_beach_01'
			elseif value == 10 then
				model = 'a_f_y_beach_01'
			elseif value == 11 then
				model = 'a_f_m_bevhills_01'
			elseif value == 12 then
				model = 'a_f_y_bevhills_01'
			elseif value == 13 then
				model = 'a_f_m_bevhills_02'
			elseif value == 14 then
				model = 'a_f_y_bevhills_02'
			elseif value == 15 then
				model = 'a_f_y_bevhills_03'
			elseif value == 16 then
				model = 'a_f_y_bevhills_04'
			elseif value == 17 then
				model = 'u_f_y_bikerchic'
			elseif value == 18 then
				model = 'mp_f_boatstaff_01'
			elseif value == 19 then
				model = 'a_f_m_bodybuild_01'
			elseif value == 20 then
				model = 'ig_bride'
			elseif value == 21 then
				model = 'a_f_y_business_01'
			elseif value == 22 then
				model = 'a_f_m_business_02'
			elseif value == 23 then
				model = 'a_f_y_business_03'
			elseif value == 24 then
				model = 'a_f_y_business_04'
			elseif value == 25 then
				model = 'u_f_y_comjane'
			elseif value == 26 then
				model = 'cs_debra'
			elseif value == 27 then
				model = 'ig_denise'
			elseif value == 28 then
				model = 'csb_denise_friend'
			elseif value == 29 then
				model = 'a_f_m_eastsa_01'
			elseif value == 30 then
				model = 'a_f_m_eastsa_02'
			elseif value == 31 then
				model = 'a_f_y_eastsa_02'
			elseif value == 32 then
				model = 'a_f_y_eastsa_03'
			elseif value == 33 then
				model = 'a_f_y_epsilon_01'
			elseif value == 34 then
				model = 'a_f_m_fatbla_01'
			elseif value == 35 then
				model = 'a_f_m_fatwhite_01'
			elseif value == 36 then
				model = 's_f_m_fembarber'
			elseif value == 37 then
				model = 'a_f_y_fitness_01'
			elseif value == 38 then
				model = 'a_f_y_fitness_02'
			elseif value == 39 then
				model = 'a_f_y_genhot_01'
			elseif value == 40 then
				model = 'a_f_o_genstreet_01'
			elseif value == 41 then
				model = 'a_f_y_golfer_01'
			elseif value == 42 then
				model = 'cs_gurk'
			elseif value == 43 then
				model = 'a_f_y_hiker_01'
			elseif value == 44 then
				model = 'a_f_y_hippie_01'
			elseif value == 45 then
				model = 'a_f_y_hipster_01'
			elseif value == 46 then
				model = 'a_f_y_hipster_02'
			elseif value == 47 then
				model = 'a_f_y_hipster_03'
			elseif value == 48 then
				model = 'a_f_y_hipster_04'
			elseif value == 49 then
				model = 's_f_y_hooker_01'
			elseif value == 50 then
				model = 's_f_y_hooker_02'
			elseif value == 51 then
				model = 's_f_y_hooker_03'
			elseif value == 52 then
				model = 'u_f_y_hotposh_01'
			elseif value == 53 then
				model = 'a_f_y_indian_01'
			elseif value == 54 then
				model = 'ig_janet'
			elseif value == 55 then
				model = 'u_f_y_jewelass_01'
			elseif value == 56 then
				model = 'ig_jewelass'
			elseif value == 57 then
				model = 'a_f_y_juggalo_01'
			elseif value == 58 then
				model = 'mp_f_helistaff_01'
			elseif value == 59 then
				model = 'ig_kerrymcintosh'
			elseif value == 60 then
				model = 'a_f_m_ktown_01'
			elseif value == 61 then
				model = 'a_f_o_ktown_01'
			elseif value == 62 then
				model = 'a_f_m_ktown_02'
			elseif value == 63 then
				model = 'g_f_y_lost_01'
			elseif value == 64 then
				model = 'ig_magenta'
			elseif value == 65 then
				model = 's_f_m_maid_01'
			elseif value == 66 then
				model = 'ig_marnie'
			elseif value == 67 then
				model = 'ig_maryann'
			elseif value == 68 then
				model = 'ig_maude'
			elseif value == 69 then
				model = 'u_f_m_miranda'
			elseif value == 70 then
				model = 'u_f_y_mistress'
			elseif value == 71 then
				model = 'ig_molly'
			elseif value == 72 then
				model = 'cs_movpremf_01'
			elseif value == 73 then
				model = 'u_f_o_moviestar'
			elseif value == 74 then
				model = 's_f_y_movprem_01'
			elseif value == 75 then
				model = 'ig_mrsphillips'
			elseif value == 76 then
				model = 'ig_mrs_thornhill'
			elseif value == 77 then
				model = 'ig_natalia'
			elseif value == 78 then
				model = 'ig_patricia'
			elseif value == 79 then
				model = 'u_f_y_princess'
			elseif value == 80 then
				model = 'a_f_m_prolhost_01'
			elseif value == 81 then
				model = 'a_f_y_runner_01'
			elseif value == 82 then
				model = 'a_f_y_rurmeth_01'
			elseif value == 83 then
				model = 'a_f_m_salton_01'
			elseif value == 84 then
				model = 'a_f_o_salton_01'
			elseif value == 85 then
				model = 'a_f_y_scdressy_01'
			elseif value == 86 then
				model = 'ig_screen_writer'
			elseif value == 87 then
				model = 's_f_m_shop_high'
			elseif value == 88 then
				model = 's_f_y_shop_low'
			elseif value == 89 then
				model = 's_f_y_shop_mid'
			elseif value == 90 then
				model = 'a_f_y_skater_01'
			elseif value == 91 then
				model = 'a_f_m_soucent_01'
			elseif value == 92 then
				model = 'a_f_o_soucent_01'
			elseif value == 93 then
				model = 'a_f_y_soucent_01'
			elseif value == 94 then
				model = 'a_m_y_soucent_01'
			elseif value == 95 then
				model = 'a_f_m_soucent_02'
			elseif value == 96 then
				model = 'a_f_o_soucent_02'
			elseif value == 97 then
				model = 'a_f_y_soucent_02'
			elseif value == 98 then
				model = 'a_f_y_soucent_03'
			elseif value == 99 then
				model = 'a_f_m_soucentmc_01'
			elseif value == 100 then
				model = 'u_f_y_spyactress'
			elseif value == 101 then
				model = 'csb_stripper_01'
			elseif value == 102 then
				model = 'csb_stripper_02'
			elseif value == 103 then
				model = 's_f_y_sweatshop_01'
			elseif value == 104 then
				model = 'ig_tanisha'
			elseif value == 105 then
				model = 'a_f_y_tennis_01'
			elseif value == 106 then
				model = 'ig_tonya'
			elseif value == 107 then
				model = 'a_f_m_tourist_01'
			elseif value == 108 then
				model = 'a_f_y_tourist_01'
			elseif value == 109 then
				model = 'a_f_y_tourist_02'
			elseif value == 110 then
				model = 'ig_tracydisanto'
			elseif value == 111 then
				model = 'a_f_m_tramp_01'
			elseif value == 112 then
				model = 'a_f_m_trampbeac_01'
			elseif value == 113 then
				model = 'a_f_y_vinewood_01'
			elseif value == 114 then
				model = 'a_f_y_vinewood_02'
			elseif value == 115 then
				model = 'a_f_y_vinewood_03'
			elseif value == 116 then
				model = 'a_f_y_vinewood_04'
			elseif value == 117 then
				model = 'a_f_y_yoga_01'
			elseif value == 118 then
				model = 'a_f_y_femaleagent'
			elseif value == 119 then
				model = 'g_f_importexport_01'
			elseif value == 120 then
				model = 'mp_f_cardesign_01'
			elseif value == 121 then
				model = 'mp_f_chbar_01'
			elseif value == 122 then
				model = 'mp_f_counterfeit_01'				
            elseif value == 123 then
				model = 'mp_f_execpa_01'
            elseif value == 124 then
				model = 'mp_f_execpa_02'			
			end
			
		elseif sex == "M" then
			if value == 0 then
				model = 'mp_m_freemode_01'
			elseif value == 1 then
				model = 'u_m_y_abner'
			elseif value == 2 then
				model = 'a_m_o_acult_02'
			elseif value == 3 then
				model = 'a_m_m_afriamer_01'
			elseif value == 4 then
				model = 'ig_mp_agent14'
			elseif value == 5 then
				model = 'csb_agent'
			elseif value == 6 then
				model = 'u_m_m_aldinapoli'
			elseif value == 7 then
				model = 's_m_y_ammucity_01'
			elseif value == 8 then
				model = 'ig_andreas'
			elseif value == 9 then
				model = 'u_m_y_antonb'
			elseif value == 10 then
				model = 'g_m_m_armboss_01'
			elseif value == 11 then
				model = 'g_m_m_armgoon_01'
			elseif value == 12 then
				model = 'g_m_y_armgoon_02'
			elseif value == 13 then
				model = 'g_m_m_armlieut_01'
			elseif value == 14 then
				model = 's_m_m_autoshop_01'
			elseif value == 15 then
				model = 'ig_money'
			elseif value == 16 then
				model = 'g_m_y_azteca_01'
			elseif value == 17 then
				model = 'u_m_y_babyd'
			elseif value == 18 then
				model = 'g_m_y_ballaeast_01'
			elseif value == 19 then
				model = 'g_m_y_ballaorig_01'
			elseif value == 20 then
				model = 'ig_ballasog'
			elseif value == 21 then
				model = 'g_m_y_ballasout_01'
			elseif value == 22 then
				model = 'u_m_m_bankman'
			elseif value == 23 then
				model = 'ig_bankman'
			elseif value == 24 then
				model = 's_m_y_barman_01'
			elseif value == 25 then
				model = 'ig_barry'
			elseif value == 26 then
				model = 'u_m_y_baygor'
			elseif value == 27 then
				model = 's_m_y_baywatch_01'
			elseif value == 28 then
				model = 'a_m_m_beach_01'
			elseif value == 29 then
				model = 'a_m_o_beach_01'
			elseif value == 30 then
				model = 'a_m_y_beach_01'
			elseif value == 31 then
				model = 'a_m_m_beach_02'
			elseif value == 32 then
				model = 'a_m_y_beach_02'
			elseif value == 33 then
				model = 'a_m_y_beach_03'
			elseif value == 34 then
				model = 'a_m_y_beachvesp_01'
			elseif value == 35 then
				model =	'a_m_y_beachvesp_02'
			elseif value == 36 then
				model = 'ig_benny'
			elseif value == 37 then
				model = 'ig_bestmen'
			elseif value == 38 then
				model = 'ig_beverly'
			elseif value == 39 then
				model = 'a_m_m_bevhills_01'
			elseif value == 40 then
				model = 'a_m_y_bevhills_01'
			elseif value == 41 then
				model = 'a_m_m_bevhills_02'
			elseif value == 42 then
				model = 'a_m_y_bevhills_02'
			elseif value == 43 then
				model = 'u_m_m_bikehire_01'
			elseif value == 44 then
				model = 'mp_m_boatstaff_01'
			elseif value == 45 then
				model = 's_m_m_bouncer_01'
			elseif value == 46 then
				model = 'ig_brad'
			elseif value == 47 then
				model = 'csb_jackhowitzer' 
			elseif value == 48 then
				model = 'a_m_y_breakdance_01'
			elseif value == 49 then
				model = 'a_m_y_busicas_01'
			elseif value == 50 then
				model = 'a_m_m_business_01'
			elseif value == 51 then
				model = 'a_m_y_business_01'
			elseif value == 52 then
				model = 'a_m_y_business_02'
			elseif value == 53 then
				model = 'a_m_y_business_03'
			elseif value == 54 then
				model = 's_m_o_busker_01'
			elseif value == 55 then
				model = 'ig_car3guy1'
			elseif value == 56 then
				model = 'ig_jay_norris'
			elseif value == 57 then
				model = 'ig_car3guy2'
			elseif value == 58 then
				model = 'cs_carbuyer'
			elseif value == 59 then
				model = 'g_m_m_chiboss_01'
			elseif value == 60 then
				model = 'g_m_m_chigoon_01'
			elseif value == 61 then
				model = 'csb_chin_goon'
			elseif value == 62 then
				model = 'u_m_y_chip'
			elseif value == 63 then
				model = 'ig_clay'
			elseif value == 64 then
				model = 'ig_claypain'
			elseif value == 65 then
				model = 'ig_cletus'
			elseif value == 66 then
				model = 's_m_m_cntrybar_01'
			elseif value == 67 then
				model = 'ig_chrisformage'
			elseif value == 68 then
				model = 'csb_customer'
			elseif value == 69 then
				model = 'u_m_y_cyclist_01'
			elseif value == 70 then
				model = 'a_m_y_cyclist_01'
			elseif value == 71 then
				model = 'ig_dale'
			elseif value == 72 then
				model = 'ig_davenorton'
			elseif value == 73 then
				model = 's_m_y_dealer_01'
			elseif value == 74 then
				model = 'ig_devin'
			elseif value == 75 then
				model = 'a_m_y_dhill_01'
			elseif value == 76 then
				model = 'ig_dom'
			elseif value == 77 then
				model = 's_m_y_doorman_01'
			elseif value == 78 then
				model = 'a_m_y_downtown_01'
			elseif value == 79 then
				model = 'ig_dreyfuss'
			elseif value == 80 then
				model = 'ig_drfriedlander'
			elseif value == 81 then
				model = 'a_m_m_eastsa_01'
			elseif value == 82 then
				model = 'a_m_y_eastsa_01'
			elseif value == 83 then
				model = 'a_m_m_eastsa_02'
			elseif value == 84 then
				model = 'a_m_y_eastsa_02'
			elseif value == 85 then
				model = 'u_m_m_edtoh'
			elseif value == 86 then
				model = 'a_m_y_epsilon_01'
			elseif value == 87 then
				model = 'a_m_y_epsilon_02'
			elseif value == 88 then
				model = 'ig_fabien'
			elseif value == 89 then
				model = 'g_m_y_famca_01'
			elseif value == 90 then
				model = 'g_m_y_famdnf_01'
			elseif value == 91 then
				model = 'g_m_y_famfor_01'
			elseif value == 92 then
				model = 'a_m_m_farmer_01'
			elseif value == 93 then
				model = 'a_m_m_fatlatin_01'
			elseif value == 94 then
				model = 'u_m_y_fibmugger_01'
			elseif value == 95 then
				model = 'u_m_m_filmdirector'
			elseif value == 96 then
				model = 'u_m_o_filmnoir'
			elseif value == 97 then
				model = 'u_m_o_finguru_01'
			elseif value == 98 then
				model = 'csb_fos_rep'
			elseif value == 99 then
				model = 's_m_m_gaffer_01'
			elseif value == 100 then
				model = 'a_m_y_gay_01'
			elseif value == 101 then
				model = 'a_m_y_gay_02'
			elseif value == 102 then
				model = 'a_m_m_genfat_01'
			elseif value == 103 then
				model = 'a_m_m_genfat_02'
			elseif value == 104 then
				model = 'a_m_o_genstreet_01'
			elseif value == 105 then
				model = 'a_m_y_genstreet_01'
			elseif value == 106 then
				model = 'a_m_y_genstreet_02'
			elseif value == 107 then
				model = 'u_m_m_glenstank_01'
			elseif value == 108 then
				model = 'u_m_m_griff_01'
			elseif value == 109 then
				model = 'ig_groom'
			elseif value == 110 then
				model = 'csb_grove_str_dlr'
			elseif value == 111 then
				model = 'u_m_y_guido_01'
			elseif value == 112 then
				model = 'u_m_y_gunvend_01'
			elseif value == 113 then
				model = 'hc_hacker'
			elseif value == 114 then
				model = 's_m_m_hairdress_01'
			elseif value == 115 then
				model = 'ig_hao'	
			elseif value == 116 then
				model = 'a_m_m_hasjew_01'
			elseif value == 117 then
				model = 'a_m_y_hasjew_01'
			elseif value == 118 then
				model = 's_m_m_highsec_01'
			elseif value == 119 then
				model = 's_m_m_highsec_02'
			elseif value == 120 then
				model = 'a_m_y_hiker_01'
			elseif value == 121 then
				model = 'a_m_m_hillbilly_02'
			elseif value == 122 then
				model = 'u_m_y_hippie_01'	
            elseif value == 123 then
				model = 'a_m_y_hippy_01'
            elseif value == 124 then
				model = 'a_m_y_hipster_02'
				
			end
		end
	else
		if sex == "M" then
			model = 'mp_m_freemode_01'
		else
			model = 'mp_f_freemode_01'
		end
	end
	
	characterModel = GetHashKey(model)
	
	RequestModel(characterModel)
	while not HasModelLoaded(characterModel) do
		RequestModel(characterModel)
		Citizen.Wait(0)
	end
	
	if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
		SetPlayerModel(PlayerId(), characterModel)
		SetPedDefaultComponentVariation(GetPlayerPed(-1))		
	end		    
	    SetModelAsNoLongerNeeded(characterModel)	
	   
	Citizen.CreateThread(function()
	fuckshit()
   end)   
      SetEntityHealth(PlayerPedId(), 200)
end

function fuckshit()
	local ped = PlayerPedId()
	--NetworkSetVoiceChannel(math.random(100,1000))
	--NetworkSetTalkerProximity(0.0)
	SetPlayerInvincible(ped, true)
	creating = true
	while creating do 
		Citizen.Wait(0)
		SetLocalPlayerVisibleLocally(true)
		for _, player in pairs(GetActivePlayers()) do
			local playerPed = GetPlayerPed(player)		
			if playerPed ~= ped then
				if DoesEntityExist(playerPed) then
					local xC = GetEntityCoords(ped)
					local tC = GetEntityCoords(playerPed)
					if GetDistanceBetweenCoords(xC.x, xC.y, xC.z, tC.x, tC.y, tC.z, false) < 10.0 then
						SetEntityCoords(playerPed)
						SetEntityLocallyInvisible(playerPed)
						SetEntityNoCollisionEntity(ped, playerPed, true)
					end
				end
			end
		end
	end
end