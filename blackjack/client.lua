seatSideAngle      = 30
bet                = 0
timeLeft           = 0
hand               = {}
splitHand          = {}
satDownCallback    = nil
standUpCallback    = nil
leaveCheckCallback = nil
canSitDownCallback = nil
local Show = false

function SetSatDownCallback(cb)
	satDownCallback = cb
end

function SetStandUpCallback(cb)
	standUpCallback = cb
end

function SetLeaveCheckCallback(cb)
	leaveCheckCallback = cb
end

function SetCanSitDownCallback(cb)
	canSitDownCallback = cb
end

function Notification(text, color, blink)
	if color then ThefeedNextPostBackgroundColor(color) end
	PlaySoundFrontend(-1, "OTHER_TEXT", "HUD_AWARDS", 0)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandThefeedPostTicker(blink or false, false)
end

function DisplayHelpText(helpText, time)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringWebsite(helpText)
	EndTextCommandDisplayHelp(0, 0, 1, time or -1)
end

function SetSubtitle(subtitle, duration)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringWebsite(subtitle)
	EndTextCommandPrint(duration, true)
	DebugPrint("SUBTITLE: "..subtitle)
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < -180 and t + 180 or t
end

function cardValue(card)
	local rank = 10
	for i=2,11 do
		if string.find(card, tostring(i)) then
			rank = i
		end
	end
	if string.find(card, 'ACE') then
		rank = 11
	end
	
	return rank
end

function handValue(hand)
	local tmpValue = 0
	local numAces = 0
	
	for i,v in pairs(hand) do
		tmpValue = tmpValue + cardValue(v)
	end
	
	for i,v in pairs(hand) do
		if string.find(v, 'ACE') then numAces = numAces + 1 end
	end
	
	repeat
		if tmpValue > 21 and numAces > 0 then
			tmpValue = tmpValue - 10
			numAces = numAces - 1
		else
			break
		end
	until numAces == 0
	
	return tmpValue
end


function getChips(amount)
	if amount < 500000 then
		local props = {}
		local propTypes = {}

		local d = #chipValues

		for i = 1, #chipValues do
			local iter = #props + 1
			while amount >= chipValues[d] do
				local model = chipModels[chipValues[d]]

				if not props[iter] then
					local propType = string.sub(model, 0, string.len(model) - 3)

					if propTypes[propType] then
						iter = propTypes[propType]
					else
						props[iter] = {}
						propTypes[propType] = iter
					end
				end

				props[iter][#props[iter] + 1] = model
				amount = amount - chipValues[d]
			end

			d = d - 1
		end

		return false, props
	elseif amount <= 500000 then
		return true, "vw_prop_vw_chips_pile_01a"
	elseif amount <= 5000000 then
		return true, "vw_prop_vw_chips_pile_03a"
	else
		return true, "vw_prop_vw_chips_pile_02a"
	end
end

function leaveBlackjack()
	leavingBlackjack = true
	renderScaleform = false
	renderTime = false
	renderBet = false 
	renderHand = false
	selectedBet = 1
	hand = {}
	splitHand = {}
end

function s2m(s)
    if s <= 0 then
        return "00:00"
    else
        local m = string.format("%02.f", math.floor(s/60))
        return m..":"..string.format("%02.f", math.floor(s - m * 60))
    end
end

RegisterCommand("bet", function(source, args, rawCommand)
	if args[1] and _DEBUG == true then
		TriggerServerEvent("BLACKJACK:SetPlayerBet", g_seat, closestChair, args[1])
	end
end, false)


spawnedPeds = {}
spawnedObjects = {}
AddEventHandler("onResourceStop", function(r)
	if r == GetCurrentResourceName() then
		for i,v in ipairs(spawnedPeds) do
			DeleteEntity(v)
		end
		for i,v in ipairs(spawnedObjects) do
			DeleteEntity(v)
		end
	end
end)

renderScaleform = false
renderTime = false
renderBet = false 
renderHand = false

Citizen.CreateThread(function()

    scaleform = RequestScaleformMovie_2("INSTRUCTIONAL_BUTTONS")

    repeat Wait(0) until HasScaleformMovieLoaded(scaleform)

	while true do Wait(0)
		if renderScaleform == true then
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
		end
		
		local barCount = {1}

		if renderTime == true and timeLeft ~= nil then
			if timeLeft > 0 then
				DrawTimerBar(barCount, "TIME", s2m(timeLeft))
			end
		end

		if renderBet == true then
			DrawTimerBar(barCount, "BET", bet)
		end

		if renderHand == true then
			if #splitHand > 0 then
				DrawTimerBar(barCount, "SPLIT", handValue(splitHand))
			end
			DrawTimerBar(barCount, "HAND", handValue(hand))
		end

		if _DEBUG == true then
		
			for i,p in pairs(chipOffsets) do
				for _,v in pairs(p) do
					for n,m in pairs(tables) do
						local x, y, z = GetObjectOffsetFromCoords(m.coords.x, m.coords.y, m.coords.z, m.coords.w, v)
						
						if GetDistanceBetweenCoords(GetGameplayCamCoord(), x, y, z, true) < 5.0 then
							
							DrawMarker(28, v.x, v.y, chipHeights[1], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 150, 150, 255, 150, false, false, false, false)
						
							SetTextFont(0)
							SetTextProportional(1)
							SetTextScale(0.0, 0.35)
							SetTextColour(255, 255, 255, 255)
							SetTextDropshadow(0, 0, 0, 0, 255)
							SetTextEdge(2, 0, 0, 0, 150)
							SetTextDropShadow()
							SetTextOutline()
							SetTextCentre(1)
							SetTextEntry("STRING")
							SetDrawOrigin(GetObjectOffsetFromCoords(m.coords.x, m.coords.y, m.coords.z, m.coords.w, v.x, v.y, chipHeights[1]))
							AddTextComponentString(tostring(_))
							DrawText(0.0, 0.0)
							ClearDrawOrigin()
						
						end
					end
				end
			end
		
			if hand then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.35)
				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(2, 0, 0, 0, 150)
				SetTextDropShadow()
				SetTextOutline()
				SetTextCentre(1)
				SetTextEntry("STRING")
				AddTextComponentString("HAND VALUE: "..handValue(hand))
				DrawText(0.90, 0.15)
				
				for i,v in ipairs(hand) do
					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.35)
					SetTextColour(255, 255, 255, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(2, 0, 0, 0, 150)
					SetTextDropShadow()
					SetTextOutline()
					SetTextCentre(1)
					SetTextEntry("STRING")
					AddTextComponentString(v.." ("..cardValue(v)..")")
					DrawText(0.90, 0.15+(i/40))
				end				
				
			end
		
			for i,v in pairs(spawnedPeds) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.25)
				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(2, 0, 0, 0, 150)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				SetTextCentre(1)
				SetDrawOrigin(GetEntityCoords(v))
				AddTextComponentString("i = "..i.. "\nv = " .. spawnedPeds[i])
				DrawText(0.0, 0.0)
				ClearDrawOrigin()
			end
			for i,v in pairs(spawnedObjects) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.25)
				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(2, 0, 0, 0, 150)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				SetTextCentre(1)
				SetDrawOrigin(GetEntityCoords(spawnedObjects[i]))
				AddTextComponentString("i = "..i.. "\nv = " .. spawnedObjects[i])
				DrawText(0.0, 0.0)
				ClearDrawOrigin()
			end
		end
	end
end)

function IsSeatOccupied(coords, radius)
	local players = GetActivePlayers()
	local playerId = PlayerId()
	for i = 1, #players do
		if players[i] ~= playerId then
			local ped = GetPlayerPed(players[i])
			if IsEntityAtCoord(ped, coords, radius, radius, radius, 0, 0, 0) then
				return true
			end
		end
	end

	return false
end

dealerHand = {}
dealerHandObjs = {}
handObjs = {}

function CreatePeds()
	if not HasAnimDictLoaded("anim_casino_b@amb@casino@games@blackjack@dealer") then
		RequestAnimDict("anim_casino_b@amb@casino@games@blackjack@dealer")
		repeat Wait(0) until HasAnimDictLoaded("anim_casino_b@amb@casino@games@blackjack@dealer")
	end

	if not HasAnimDictLoaded("anim_casino_b@amb@casino@games@shared@dealer@") then
		RequestAnimDict("anim_casino_b@amb@casino@games@shared@dealer@")
		repeat Wait(0) until HasAnimDictLoaded("anim_casino_b@amb@casino@games@shared@dealer@")
	end

	if not HasAnimDictLoaded("anim_casino_b@amb@casino@games@blackjack@player") then
		RequestAnimDict("anim_casino_b@amb@casino@games@blackjack@player")
		repeat Wait(0) until HasAnimDictLoaded("anim_casino_b@amb@casino@games@blackjack@player")
	end
		
	chips = {}
							
	hand = {}
	splitHand = {}
	handObjs = {}
	
	for i,v in pairs(tables) do
	
		dealerHand[i] = {}
		dealerHandObjs[i] = {}
		local model = `s_f_y_casino_01`

		chips[i] = {}
		
		for x=1,4 do
			chips[i][x] = {}
		end
		handObjs[i] = {}
		
		for x=1,4 do
			handObjs[i][x] = {}
		end
		
		if not HasModelLoaded(model) then
			RequestModel(model)
			repeat Wait(0) until HasModelLoaded(model)
		end
		
		local dealer = CreatePed(4, model, v.coords.x, v.coords.y, v.coords.z, v.coords.w, false, true)
		-- local dealer = ClonePed(PlayerPedId(), 0.0, false, false)
		SetEntityCanBeDamaged(dealer, false)
		SetBlockingOfNonTemporaryEvents(dealer, true)
		SetPedCanRagdollFromPlayerImpact(dealer, false)
		
		-- SetPedVoiceGroup(dealer, `S_F_Y_Casino_01_ASIAN_02`)
		
		-- SetPedDefaultComponentVariation(dealer)
		
		SetPedResetFlag(dealer, 249, true)
		SetPedConfigFlag(dealer, 185, true)
		SetPedConfigFlag(dealer, 108, true)
		SetPedConfigFlag(dealer, 208, true)
		
		SetDealerOutfit(dealer, i+6)
		
		-- NetworkSetEntityInvisibleToNetwork(dealer, true)
		
		-- N_0x352e2b5cf420bf3b(dealer, true)
		-- N_0x2f3c3d9f50681de4(dealer, true)
		
		-- SetNetworkIdCanMigrate(PedToNet(dealer), false)
		
		-- local scene = NetworkCreateSynchronisedScene(v.coords.x, v.coords.y, v.coords.z, vector3(0.0, 0.0, v.coords.w), 2, true, true, 1065353216, 0, 1065353216)
		-- NetworkAddPedToSynchronisedScene(dealer, scene, "anim_casino_b@amb@casino@games@shared@dealer@", "idle", 2.0, -2.0, 13, 16, 1148846080, 0)
		-- NetworkStartSynchronisedScene(scene)
		
		local scene = CreateSynchronizedScene(v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, v.coords.w, 2)
		TaskSynchronizedScene(dealer, scene, "anim_casino_b@amb@casino@games@shared@dealer@", "idle", 1000.0, -8.0, 4, 1, 1148846080, 0)
		SetModelAsNoLongerNeeded(dealer)
		
		-- TaskLookAtEntity(dealer, PlayerPedId(), -1, 2048, 3)
		
		-- Wait(1500)
		
		-- TaskPlayAnim(dealer, anim, "idle", 4.0, -1.0, -1, 0, -1.0, true, true, true)
		
		spawnedPeds[i] = dealer
	end
end

-- function getCardOffset(seat, cardIndex)
	-- if seat == 1 then
		-- if cardIndex = 
	-- end
-- end

RegisterNetEvent("BLACKJACK:SyncTimer")
AddEventHandler("BLACKJACK:SyncTimer", function(_timeLeft)
	timeLeft = _timeLeft
end)

RegisterNetEvent("BLACKJACK:PlayDealerAnim")
AddEventHandler("BLACKJACK:PlayDealerAnim", function(i, animDict, anim)
	Citizen.CreateThread(function()
	
		local v = tables[i]
		
		if not HasAnimDictLoaded(animDict) then
			RequestAnimDict(animDict)
			repeat Wait(0) until HasAnimDictLoaded(animDict)
		end
	
		-- if GetEntityModel(spawnedPeds[i]) == `s_f_y_casino_01` then
			-- anim = "female_"..anim
		-- end
		
		DebugPrint("PLAYING "..anim:upper().." ON DEALER "..i)
		
		-- if seat == 0 then
			-- local scene = CreateSynchronizedScene(v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, v.coords.w, 2)
			-- TaskSynchronizedScene(spawnedPeds[i], scene, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_deal_card_self", 1000.0, -8.0, 4, 1, 1148846080, 0)
		-- else
			-- local scene = CreateSynchronizedScene(v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, v.coords.w, 2)
			-- TaskSynchronizedScene(spawnedPeds[i], scene, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_deal_card_player_0" .. 5-seat, 1000.0, -8.0, 4, 1, 1148846080, 0)
		-- end
		
		local scene = CreateSynchronizedScene(v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, v.coords.w, 2)
		TaskSynchronizedScene(spawnedPeds[i], scene, animDict, anim, 1000.0, -8.0, 4, 1, 1148846080, 0)
	
	end)
end)

RegisterNetEvent("BLACKJACK:PlayDealerSpeech")
AddEventHandler("BLACKJACK:PlayDealerSpeech", function(i, speech)
	Citizen.CreateThread(function()
		DebugPrint("PLAYING SPEECH "..speech:upper().." ON DEALER "..i)
		StopCurrentPlayingAmbientSpeech(spawnedPeds[i])
		PlayAmbientSpeech1(spawnedPeds[i], speech, "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
	end)
end)

RegisterNetEvent("BLACKJACK:DealerTurnOverCard")
AddEventHandler("BLACKJACK:DealerTurnOverCard", function(i)
	SetEntityRotation(dealerHandObjs[i][1], 0.0, 0.0, tables[i].coords.w + cardRotationOffsetsDealer[1].z)
end)

RegisterNetEvent("BLACKJACK:SplitHand")
AddEventHandler("BLACKJACK:SplitHand", function(index, seat, splitHandSize, _hand, _splitHand)
	hand = _hand
	splitHand = _splitHand

	DebugPrint("splitHandSize = "..splitHandSize)
	DebugPrint("split card coord = "..tostring(GetObjectOffsetFromCoords(tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, tables[index].coords.w, cardSplitOffsets[seat][1])))
	
	SetEntityCoordsNoOffset(handObjs[index][seat][#handObjs[index][seat]], GetObjectOffsetFromCoords(tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, tables[index].coords.w, cardSplitOffsets[5-seat][1]))
	SetEntityRotation(handObjs[index][seat][#handObjs[index][seat]], 0.0, 0.0, cardSplitRotationOffsets[seat][splitHandSize])
end)

selectedBet = 1

RegisterNetEvent("BLACKJACK:PlaceBetChip")
AddEventHandler("BLACKJACK:PlaceBetChip", function(index, seat, bet, double, split)
	Citizen.CreateThread(function()
		local chipPile, props = getChips(bet)
		
		if chipPile then
			local model = GetHashKey(props)
			
			DebugPrint(bet)
			DebugPrint(seat)
			DebugPrint(tostring(props))
			DebugPrint(tostring(pileOffsets[seat]))
		
			RequestModel(model)
			repeat Wait(0) until HasModelLoaded(model)
			local location = 1
			if double == true then location = 2 end
			
			local chip = CreateObjectNoOffset(model, tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, false, false, false)

			table.insert(spawnedObjects, chip)
			table.insert(chips[index][seat], chip)

			if split == false then
				SetEntityCoordsNoOffset(chip, GetObjectOffsetFromCoords(tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, tables[index].coords.w, pileOffsets[seat][location].x, pileOffsets[seat][location].y, chipHeights[1]))
				SetEntityRotation(chip, 0.0, 0.0, tables[index].coords.w + pileRotationOffsets[seat][3 - location].z)
			else
				SetEntityCoordsNoOffset(chip, GetObjectOffsetFromCoords(tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, tables[index].coords.w, pileOffsets[seat][2].x, pileOffsets[seat][2].y, chipHeights[1]))
				SetEntityRotation(chip, 0.0, 0.0, tables[index].coords.w + pileRotationOffsets[seat][3 - location].z)
			end
			SetModelAsNoLongerNeeded(chip)

			--Get chip offsets
			--selectedChip = chip
			--selectedTable = index
		else
			local chipXOffset = 0.0
			local chipYOffset = 0.0
			
			if split or double then
				if seat == 1 then
					chipXOffset = chipXOffset + 0.03
					chipYOffset = chipYOffset + 0.05
				elseif seat == 2 then
					chipXOffset = chipXOffset + 0.05
					chipYOffset = chipYOffset + 0.02
				elseif seat == 3 then
					chipXOffset = chipXOffset + 0.05
					chipYOffset = chipYOffset - 0.02
				elseif seat == 4 then
					chipXOffset = chipXOffset + 0.02
					chipYOffset = chipYOffset - 0.05
				end
			end
			
			for i = 1, #props do
				local chipGap = 0.0

				for j = 1, #props[i] do
					local model = GetHashKey(props[i][j])
					
					DebugPrint(bet)
					DebugPrint(seat)
					DebugPrint(tostring(props[i][j]))
					DebugPrint(tostring(chipOffsets[seat]))
				
					RequestModel(model)
					repeat Wait(0) until HasModelLoaded(model)
				
					local location = i
					-- if double == true then location = 2 end
					
					local chip = CreateObjectNoOffset(model, tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, false, false, false)
					
					table.insert(spawnedObjects, chip)
					table.insert(chips[index][seat], chip)

					-- if split == false and double == false then
						SetEntityCoordsNoOffset(chip, GetObjectOffsetFromCoords(tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, tables[index].coords.w, chipOffsets[seat][location].x + chipXOffset, chipOffsets[seat][location].y + chipYOffset, chipHeights[1] + chipGap))
						SetEntityRotation(chip, 0.0, 0.0, tables[index].coords.w + chipRotationOffsets[seat][location].z)
					-- else
						-- SetEntityCoordsNoOffset(chip, GetObjectOffsetFromCoords(tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, tables[index].coords.w, chipSplitOffsets[seat][location].x + chipXOffset, chipSplitOffsets[seat][location].y + chipYOffset, chipHeights[1] + chipGap))
						-- SetEntityRotation(chip, 0.0, 0.0, tables[index].coords.w + chipSplitRotationOffsets[seat][location].z)
					-- end

					chipGap = chipGap + ((chipThickness[model] ~= nil) and chipThickness[model] or 0.0)
					SetModelAsNoLongerNeeded(chip)
				end

				-- Hacky way to setup each seats split chips
			end
		end
	end)
end)

RegisterNetEvent("BLACKJACK:BetReceived")

local upPressed = false
local downPressed = false

RegisterNetEvent("BLACKJACK:RequestBets")
AddEventHandler("BLACKJACK:RequestBets", function(index, _timeLeft)
	timeLeft = _timeLeft
	
	if leavingBlackjack == true then leaveBlackjack() return end

	Citizen.CreateThread(function()
		scrollerIndex = index
		renderScaleform = true
		renderTime = true
		renderBet = true

		PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
		PopScaleformMovieFunctionVoid()

		BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(80)
		EndScaleformMovieMethod()
		
		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 202, 0))
		ScaleformMovieMethodAddParamPlayerNameString("Exit")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(1)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 201, 0))
		ScaleformMovieMethodAddParamPlayerNameString("Place Bet")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(2)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 204, 0))
		ScaleformMovieMethodAddParamPlayerNameString("Max Bet")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(3)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 175, 0))
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 174, 0))
		ScaleformMovieMethodAddParamPlayerNameString("Adjust Bet")
		EndScaleformMovieMethod()
	
		BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
		EndScaleformMovieMethod()

		while true do Wait(0)
			local tableLimit = (tables[scrollerIndex].highStakes == true) and #bettingNums or lowTableLimit

			if IsControlJustPressed(1, 204) then -- TAB / Y
				selectedBet = tableLimit
			elseif IsControlJustPressed(1, 202) then -- ESC / B
			
			    show = false
                DisplayRadar(true)
				
				leavingBlackjack = true
				renderScaleform = false
				renderTime = false
				renderBet = false
				renderHand = false
				selectedBet = 1
				return
			end

			if not upPressed then
				if IsControlJustPressed(1, 175) then -- RIGHT ARROW / DPAD RIGHT
					upPressed = true
					Citizen.CreateThread(function()
						selectedBet = selectedBet + 1
						if selectedBet > tableLimit then selectedBet = 1 end
						Citizen.Wait(175)
						while IsControlPressed(1, 175) do
							selectedBet = selectedBet + 1
							if selectedBet > tableLimit then selectedBet = 1 end
							Citizen.Wait(125)
						end

						upPressed = false
					end)
				end
			end

			if not downPressed then
				if IsControlJustPressed(1, 174) then -- LEFT ARROW / DPAD LEFT
					downPressed = true
					Citizen.CreateThread(function()
						selectedBet = selectedBet - 1
						if selectedBet < 1 then selectedBet = tableLimit end
						Citizen.Wait(175)
						while IsControlPressed(1, 174) do
							selectedBet = selectedBet - 1
							if selectedBet < 1 then selectedBet = tableLimit end
							Citizen.Wait(125)
						end

						downPressed = false
					end)
				end
			end

			bet = bettingNums[selectedBet] or 10000
			
			if #bettingNums < lowTableLimit and tables[scrollerIndex].highStakes == true then
				bet = bet * 10
			end
		
			if IsControlJustPressed(1, 201) then -- ENTER / A
				
				TriggerServerEvent("BLACKJACK:CheckPlayerBet", g_seat, bet)

				local betCheckRecieved = false
				local canBet = false
				local eventHandler = AddEventHandler("BLACKJACK:BetReceived", function(_canBet)
					betCheckRecieved = true
					canBet = _canBet
				end)
				
				repeat Wait(0) until betCheckRecieved == true

				RemoveEventHandler(eventHandler)
				
				if canBet then
					renderScaleform = false
					renderTime = false
					renderBet = false
					if selectedBet < 27 then
						if leavingBlackjack == true then leaveBlackjack() return end

						local anim = "place_bet_small"
						
						playerBusy = true
						local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, false, 1065353216, 0, 1065353216)
						NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@blackjack@player", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
						NetworkStartSynchronisedScene(scene)
						
						Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))
						
						if leavingBlackjack == true then leaveBlackjack() return end

						TriggerServerEvent("BLACKJACK:SetPlayerBet", g_seat, closestChair, bet, selectedBet, false)

						Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))
						
						if leavingBlackjack == true then leaveBlackjack() return end

						playerBusy = false
						
						local idleVar = "idle_var_0"..math.random(1,5)
						
						DebugPrint("IDLING POST-BUSY: "..idleVar)
						
						local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
						NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
						NetworkStartSynchronisedScene(scene)
					else
						if leavingBlackjack == true then leaveBlackjack() return end

						local anim = "place_bet_large"
						
						playerBusy = true
						local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, false, 1065353216, 0, 1065353216)
						NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@blackjack@player", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
						NetworkStartSynchronisedScene(scene)
						
						Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))
						
						if leavingBlackjack == true then leaveBlackjack() return end

						TriggerServerEvent("BLACKJACK:SetPlayerBet", g_seat, closestChair, bet, selectedBet, false)

						Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))

						if leavingBlackjack == true then leaveBlackjack() return end
						
						playerBusy = false
						
						local idleVar = "idle_var_0"..math.random(1,5)
						
						DebugPrint("IDLING POST-BUSY: "..idleVar)

						local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
						NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
						NetworkStartSynchronisedScene(scene)
					end
					return
				else
					DisplayHelpText("~b~Sorry! ~w~You ~r~Don't ~w~Have Enough ~g~Money ~w~For This ~b~Bet", 5000)
				end
			end
		end
	end)
end)

RegisterNetEvent("BLACKJACK:RequestMove")
AddEventHandler("BLACKJACK:RequestMove", function(_timeLeft)
	Citizen.CreateThread(function()
		timeLeft = _timeLeft
		if leavingBlackjack == true then leaveBlackjack() return end
		
		renderScaleform = true
		renderTime = true
		renderHand = true

		BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(80)
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(1)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 201, 0))
		ScaleformMovieMethodAddParamPlayerNameString("Hit")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(2)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 203, 0))
		ScaleformMovieMethodAddParamPlayerNameString("Stand")
		EndScaleformMovieMethod()
		
		if #hand < 3 and #splitHand == 0 then
			BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
			ScaleformMovieMethodAddParamInt(3)
			ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 192, 0))
			ScaleformMovieMethodAddParamPlayerNameString("Double Down")
			EndScaleformMovieMethod()
		end

		
		BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
		EndScaleformMovieMethod()
		
		while true do Wait(0)	
			if IsControlJustPressed(1, 201) then
				if leavingBlackjack == true then DebugPrint("returning") return end
				
				TriggerServerEvent("BLACKJACK:ReceivedMove", "hit")
				
				renderScaleform = false
				renderTime = false
				renderHand = false
				local anim = requestCardAnims[math.random(1,#requestCardAnims)]
				
				playerBusy = true
				local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, false, 1065353216, 0, 1065353216)
				NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@blackjack@player", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
				NetworkStartSynchronisedScene(scene)
				Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*990))

				if leavingBlackjack == true then leaveBlackjack() return end

				playerBusy = false
			
				local idleVar = "idle_var_0"..math.random(1,5)
				
				DebugPrint("IDLING POST-BUSY: "..idleVar)

				local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
				NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
				NetworkStartSynchronisedScene(scene)
				
				return
			end
			if IsControlJustPressed(1, 203) then
				if leavingBlackjack == true then leaveBlackjack() return end
                  
				TriggerServerEvent("BLACKJACK:ReceivedMove", "stand")
				
				renderScaleform = false
				renderTime = false
				renderHand = false
				local anim = declineCardAnims[math.random(1,#declineCardAnims)]
				
				playerBusy = true
				local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, false, 1065353216, 0, 1065353216)
				NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@blackjack@player", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
				NetworkStartSynchronisedScene(scene)
				Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*990))

				if leavingBlackjack == true then leaveBlackjack() return end

				playerBusy = false
				
				local idleVar = "idle_var_0"..math.random(1,5)
				
				DebugPrint("IDLING POST-BUSY: "..idleVar)

				local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
				NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
				NetworkStartSynchronisedScene(scene)

				return
			end
			if IsControlJustPressed(1, 192) and #hand == 2 and #splitHand == 0 then
				if leavingBlackjack == true then leaveBlackjack() return end

				TriggerServerEvent("BLACKJACK:CheckPlayerBet", g_seat, bet)

				local betCheckRecieved = false
				local canBet = false
				local eventHandler = AddEventHandler("BLACKJACK:BetReceived", function(_canBet)
					betCheckRecieved = true
					canBet = _canBet
				end)
				
				repeat Wait(0) until betCheckRecieved == true

				RemoveEventHandler(eventHandler)
				
				if canBet then
					if leavingBlackjack == true then leaveBlackjack() return end

					TriggerServerEvent("BLACKJACK:ReceivedMove", "double")
					
					renderScaleform = false
					renderTime = false
					renderHand = false
					local anim = "place_bet_double_down"
					
					playerBusy = true
					local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, false, 1065353216, 0, 1065353216)
					NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@blackjack@player", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
					NetworkStartSynchronisedScene(scene)
					Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))
					
					if leavingBlackjack == true then leaveBlackjack() return end

					TriggerServerEvent("BLACKJACK:SetPlayerBet", g_seat, closestChair, bet, selectedBet, true)
					
					Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))

					if leavingBlackjack == true then leaveBlackjack() return end

					playerBusy = false
					
					local idleVar = "idle_var_0"..math.random(1,5)
					
					DebugPrint("IDLING POST-BUSY: "..idleVar)

					local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
					NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
					NetworkStartSynchronisedScene(scene)

					return
				else
					DisplayHelpText("You don't have enough money to double down.", 5000)
				end
			end
		end
	end)
end)

RegisterNetEvent("BLACKJACK:GameEndReaction")
AddEventHandler("BLACKJACK:GameEndReaction", function(result)
	Citizen.CreateThread(function()
		
		if #hand == 2 and handValue(hand) == 21 and result == "good" then
			DisplayHelpText("~b~Blackjack!", 5000)
		elseif handValue(hand) > 21 and result ~= "good" then
			DisplayHelpText("You ~r~Busted", 5000)
		else
			DisplayHelpText("You ~g~"..resultNames[result].."~w~ With The Hand ~b~"..handValue(hand), 5000)
		end
		
		hand = {}
		splitHand = {}
		renderHand = false

		if leavingBlackjack == true then leaveBlackjack() return end

		local anim = "reaction_"..result.."_var_0"..math.random(1,4)
		
		DebugPrint("Reacting: "..anim)
		
		playerBusy = true
		local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, false, false, 1065353216, 0, 1065353216)
		NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
		NetworkStartSynchronisedScene(scene)
		Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@shared@player@", anim)*990))

		if leavingBlackjack == true then leaveBlackjack() return end

		playerBusy = false
		
		idleVar = "idle_var_0"..math.random(1,5)

		local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
		NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
		NetworkStartSynchronisedScene(scene)
	end)
end)

RegisterNetEvent("BLACKJACK:RetrieveCards")
AddEventHandler("BLACKJACK:RetrieveCards", function(i, seat)
	DebugPrint("TABLE "..i..": DELETE SEAT ".. seat .." CARDS")

	if seat == 0 then
		for x,v in pairs(dealerHandObjs[i]) do
			DeleteEntity(v)
			dealerHandObjs[i][x] = nil
		end
	else
		for x,v in pairs(handObjs[i][seat]) do
			DeleteEntity(v)
		end
		for x,v in pairs(chips[i][5-seat]) do
			DeleteEntity(v)
		end
	end
end)
	
RegisterNetEvent("BLACKJACK:GiveCard")
AddEventHandler("BLACKJACK:GiveCard", function(i, seat, handSize, card, flipped, split)
	
	flipped = flipped or false
	split = split or false
	
	if i == g_seat and seat == closestChair then
		if split == true then
			table.insert(splitHand, card)
		else
			table.insert(hand, card)
		end
		
		DebugPrint("GOT CARD "..card.." ("..cardValue(card)..")")
		DebugPrint("HAND VALUE "..handValue(hand))
	elseif seat == 0 then
		table.insert(dealerHand[i], card)
	end
	
	local model = GetHashKey("vw_prop_cas_card_"..card)
	
	RequestModel(model)
	repeat Wait(0) until HasModelLoaded(model)
	
	local card = CreateObjectNoOffset(model, tables[i].coords.x, tables[i].coords.y, tables[i].coords.z, false, false, false)
	
	table.insert(spawnedObjects, card)
		
	if seat > 0 then
		table.insert(handObjs[i][seat], card)
	end
	
	-- SetNetworkIdCanMigrate(ObjToNet(card), false)
	
	AttachEntityToEntity(card, spawnedPeds[i], GetPedBoneIndex(spawnedPeds[i], 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
	
	Wait(500)
	
	-- AttachEntityToEntity(card, spawnedPeds[i], GetPedBoneIndex(spawnedPeds[i], 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
	
	Wait(800)
	
	DetachEntity(card, 0, true)
	
	if seat == 0 then
		table.insert(dealerHandObjs[i], card)
		
		SetEntityCoordsNoOffset(card, GetObjectOffsetFromCoords(tables[i].coords.x, tables[i].coords.y, tables[i].coords.z, tables[i].coords.w, cardOffsetsDealer[handSize]))
		
		if flipped == true then
			SetEntityRotation(card, 180.0, 0.0, tables[i].coords.w + cardRotationOffsetsDealer[handSize].z)
		else
			SetEntityRotation(card, 0.0, 0.0, tables[i].coords.w + cardRotationOffsetsDealer[handSize].z)
		end
	else
		if split == true then
			SetEntityCoordsNoOffset(card, GetObjectOffsetFromCoords(tables[i].coords.x, tables[i].coords.y, tables[i].coords.z, tables[i].coords.w, cardSplitOffsets[5-seat][handSize]))
			SetEntityRotation(card, 0.0, 0.0, tables[i].coords.w + cardSplitRotationOffsets[5-seat][handSize])
		else
			SetEntityCoordsNoOffset(card, GetObjectOffsetFromCoords(tables[i].coords.x, tables[i].coords.y, tables[i].coords.z, tables[i].coords.w, cardOffsets[5-seat][handSize]))
			SetEntityRotation(card, 0.0, 0.0, tables[i].coords.w + cardRotationOffsets[5-seat][handSize])
		end
	end
	SetModelAsNoLongerNeeded(card)
end)

function ProcessTables()	
	RequestAnimDict("anim_casino_b@amb@casino@games@shared@player@")
	
	while true do Wait(0)
		local playerPed = PlayerPedId()

		if not IsEntityDead(playerPed) then
			for i,v in pairs(tables) do
				local cord = v.coords
				local highStakes = v.highStakes
				
				if GetDistanceBetweenCoords(cord.x, cord.y, cord.z, GetEntityCoords(PlayerPedId()), true) < 3.0 then
				
					-- local pCoords = vector3(cord.x, cord.y, cord.z)
					local pCoords = GetEntityCoords(PlayerPedId())
					local tableObj = GetClosestObjectOfType(pCoords, 1.0, `vw_prop_casino_blckjack_01`, false, false, false)
					-- highStakes = false
					
					if GetEntityCoords(tableObj) == vector3(0.0, 0.0, 0.0) then
						tableObj = GetClosestObjectOfType(pCoords, 1.0, `vw_prop_casino_blckjack_01b`, false, false, false)
						-- highStakes = true
					end
					
					if GetEntityCoords(tableObj) ~= vector3(0.0, 0.0, 0.0) then
						closestChair = 1
						local coords = GetWorldPositionOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, "Chair_Base_0"..closestChair))
						local rot = GetWorldRotationOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, "Chair_Base_0"..closestChair))
						dist = GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), true)
						
						for i=1,4 do
							local coords = GetWorldPositionOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, "Chair_Base_0"..i))
							if GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), true) < dist then
								dist = GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), true)
								closestChair = i
							end
						end
						
						local coords = GetWorldPositionOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, "Chair_Base_0"..closestChair))
						local rot = GetWorldRotationOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, "Chair_Base_0"..closestChair))
						
						g_coords = coords
						g_rot = rot
						
						local angle = rot.z-findRotation(coords.x, coords.y, pCoords.x, pCoords.y)+90.0
						
						local seatAnim = "sit_enter_"
						
						if angle > 0 then seatAnim = "sit_enter_left" end
						if angle < 0 then seatAnim = "sit_enter_right" end
						if angle > seatSideAngle or angle < -seatSideAngle then seatAnim = seatAnim .. "_side" end

						local canSit = true

						if canSitDownCallback ~= nil then
							canSit = canSitDownCallback()
						end

						if GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), true) < 1.5 and not IsSeatOccupied(coords, 0.5) and canSit then
											
							if highStakes then
								DisplayHelpText("~b~Press~w~ ~INPUT_CONTEXT~ To Play ~g~High-Limit ~y~Blackjack")
							else
								DisplayHelpText("~b~Press~w~ ~INPUT_CONTEXT~ To Play ~g~Low Limit ~y~Blackjack")
							end
							
							if _DEBUG == true then
								SetTextFont(0)
								SetTextProportional(1)
								SetTextScale(0.0, 0.45)
								SetTextColour(255, 255, 255, 255)
								SetTextDropshadow(0, 0, 0, 0, 255)
								SetTextEdge(2, 0, 0, 0, 150)
								SetTextDropShadow()
								SetTextOutline()
								SetTextEntry("STRING")
								SetTextCentre(1)
								SetDrawOrigin(cord.x, cord.y, cord.z)
								AddTextComponentString("table = "..i)
								DrawText(0.0, 0.0)
								ClearDrawOrigin()
							end
							
							if IsControlJustPressed(1, 51) then
							   show = true
                               DisplayRadar(false)
						
								if satDownCallback ~= nil then
									satDownCallback()									
								end

								local initPos = GetAnimInitialOffsetPosition("anim_casino_b@amb@casino@games@shared@player@", seatAnim, coords, rot, 0.01, 2)
								local initRot = GetAnimInitialOffsetRotation("anim_casino_b@amb@casino@games@shared@player@", seatAnim, coords, rot, 0.01, 2)
								
								TaskGoStraightToCoord(PlayerPedId(), initPos, 1.0, 5000, initRot.z, 0.01)
								repeat Wait(0) until GetScriptTaskStatus(PlayerPedId(), 2106541073) == 7
								Wait(50)
								
								SetPedCurrentWeaponVisible(PlayerPedId(), 0, true, 0, 0)
								
								local scene = NetworkCreateSynchronisedScene(coords, rot, 2, true, true, 1065353216, 0, 1065353216)
								NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", seatAnim, 2.0, -2.0, 13, 16, 1148846080, 0)
								NetworkStartSynchronisedScene(scene)

								local scene = NetworkConvertSynchronisedSceneToSynchronizedScene(scene)
								repeat Wait(0) until GetSynchronizedScenePhase(scene) >= 0.99 or HasAnimEventFired(PlayerPedId(), 2038294702) or HasAnimEventFired(PlayerPedId(), -1424880317)

								Wait(1000)

								idleVar = "idle_cardgames"

								scene = NetworkCreateSynchronisedScene(coords, rot, 2, true, true, 1065353216, 0, 1065353216)
								NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", "idle_cardgames", 2.0, -2.0, 13, 16, 1148846080, 0)
								NetworkStartSynchronisedScene(scene)

								repeat Wait(0) until IsEntityPlayingAnim(PlayerPedId(), "anim_casino_b@amb@casino@games@shared@player@", "idle_cardgames", 3) == 1

								g_seat = i
		
								leavingBlackjack = false

								TriggerServerEvent("BLACKJACK:PlayerSatDown", i, closestChair)

								local endTime = GetGameTimer() + math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@shared@player@", idleVar)*990)

								Citizen.CreateThread(function() -- Disable pause when while in-blackjack
									local startCount = false
									local count = 0
									while true do
										Citizen.Wait(0)
										SetPauseMenuActive(false)
										if leavingBlackjack == true then
											startCount = true
										end

										if startCount == true then
											count = count + 1
										end

										if count > 3000 then -- Make it so it enables 3 seconds after hitting the leave button so the pause menu doesn't show up when trying to leave
											break
										end
									end
								end)

								while true do
									Wait(0)
									if GetGameTimer() >= endTime then
										if playerBusy == true then
											while playerBusy == true do
												Wait(0)
												local playerPed = PlayerPedId()

												if IsEntityDead(playerPed) then
													TriggerServerEvent("BLACKJACK:PlayerRemove", i)
													ClearPedTasks(playerPed)
													leaveBlackjack()
													break
												elseif leaveCheckCallback ~= nil then
													if leaveCheckCallback() then
														TriggerServerEvent("BLACKJACK:PlayerRemove", i)
														ClearPedTasks(playerPed)
														leaveBlackjack()
														break									
													end
												end
											end
										end
										
										if leavingBlackjack == false then
											idleVar = "idle_var_0"..math.random(1,5)

											local scene = NetworkCreateSynchronisedScene(coords, rot, 2, true, true, 1065353216, 0, 1065353216)
											NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
											NetworkStartSynchronisedScene(scene)
											endTime = GetGameTimer() + math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@shared@player@", idleVar)*990)
										end
									end
									
									if leavingBlackjack == true then
										if standUpCallback ~= nil then
											standUpCallback()
										end

										local scene = NetworkCreateSynchronisedScene(coords, rot, 2, false, false, 1065353216, 0, 1065353216)
										NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", "sit_exit_left", 2.0, -2.0, 13, 16, 1148846080, 0)
										NetworkStartSynchronisedScene(scene)
										TriggerServerEvent("BLACKJACK:PlayerSatUp", i)
										Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@shared@player@", "sit_exit_left")*800))
										ClearPedTasks(PlayerPedId())
										break
									else
										local playerPed = PlayerPedId()

										if IsEntityDead(playerPed) then
											TriggerServerEvent("BLACKJACK:PlayerRemove", i)
											ClearPedTasks(playerPed)
											leaveBlackjack()
											if standUpCallback ~= nil then
												standUpCallback()
											end
											break
										elseif leaveCheckCallback ~= nil then
											if leaveCheckCallback() then
												TriggerServerEvent("BLACKJACK:PlayerRemove", i)
												ClearPedTasks(playerPed)
												leaveBlackjack()
												if standUpCallback ~= nil then
													standUpCallback()
												end
												break									
											end
										end
									end

									-- if IsEntityPlayingAnim(PlayerPedId(), "anim_casino_b@amb@casino@games@shared@player@", idleVar, 3) ~= 1 then break end
								end
							end
						end
					end
				else
					--Citizen.Wait(1000)
				end
			end
		end	
	end
end

Citizen.CreateThread(function()   
  while true do
    Citizen.Wait(1)
	
    if show == true then		
	   Value = handValue(hand)
	
	if Value == 0 then
	   Cards = ''
   else 
       Cards = Value
    end
	
       x2, y2, z2 = table.unpack(GetEntityCoords(PlayerPedId(), true))
       DrawText3D(x2, y2, z2+0.76, 'Total Bet = [~b~$'..bet..'~w~]', 255,255,255)	
       DrawText3D(x2, y2, z2+0.70, 'Current Hand = ~b~'..Cards..'', 255,255,255)	
	end 
  end
end)


function DrawText3D(x,y,z, text, r,g,b) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1) 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
       SetTextScale(0.0*scale, 0.25*scale)
       SetTextFont(0)
       SetTextProportional(1)
       SetTextColour(r, g, b, 255)
       SetTextDropshadow(0, 0, 0, 0, 255)
       SetTextEdge(2, 0, 0, 0, 150)
       SetTextDropShadow()
       SetTextOutline()
       SetTextEntry("STRING")
       SetTextCentre(1)
       AddTextComponentString(text)
       DrawText(_x,_y)
    end
end

function DrawText3D2(x,y,z, text, r,g,b) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1) 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
       SetTextScale(0.0*scale, 0.35*scale)
       SetTextFont(0)
       SetTextProportional(1)
       SetTextColour(r, g, b, 255)
       SetTextDropshadow(0, 0, 0, 0, 255)
       SetTextEdge(2, 0, 0, 0, 150)
       SetTextDropShadow()
       SetTextOutline()
       SetTextEntry("STRING")
       SetTextCentre(1)
       AddTextComponentString(text)
       DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()

	if IsModelInCdimage('vw_prop_casino_blckjack_01') and IsModelInCdimage('s_f_y_casino_01') and IsModelInCdimage('vw_prop_chip_10dollar_x1') then
		Citizen.CreateThread(ProcessTables)
		Citizen.CreateThread(CreatePeds)
	else
		ThefeedSetAnimpostfxColor(255, 0, 0, 255)
		Notification("This server is missing objects required for KGV-Blackjack!", nil, true)
	end
end)

exports("SetSatDownCallback", SetSatDownCallback)
exports("SetStandUpCallback", SetStandUpCallback)
exports("SetLeaveCheckCallback", SetLeaveCheckCallback)
exports("SetCanSitDownCallback", SetCanSitDownCallback)


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Peds

 --Cashier
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_y_barman_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_barman_01")) do
      Wait(1)
    end

      local Cashier =  CreatePed(4, 0xE5A11106, 1117.75, 220.06, -50.44, 91.05, false, true)
      SetEntityHeading(Cashier, 91.05)
      FreezeEntityPosition(Cashier, true)
      SetEntityInvincible(Cashier, true)
      SetBlockingOfNonTemporaryEvents(Cashier, true)
	  SetModelAsNoLongerNeeded(Cashier)
end)

 --bartender
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_f_y_bartender_01"))
    while not HasModelLoaded(GetHashKey("s_f_y_bartender_01")) do
      Wait(1)
    end

      local bartender =  CreatePed(4, 0x780C01BD, 1110.05, 208.42, -50.44, 89.25, false, true)
      SetEntityHeading(bartender, 89.25)
      FreezeEntityPosition(bartender, true)
      SetEntityInvincible(bartender, true)
      SetBlockingOfNonTemporaryEvents(bartender, true)
	  SetModelAsNoLongerNeeded(bartender)
end)

--guard
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_m_bouncer_01"))
    while not HasModelLoaded(GetHashKey("s_m_m_bouncer_01")) do
      Wait(1)
    end

      local guard =  CreatePed(4, 0x9FD4292D, 1091.92, 205.72, -50.00, 6.15, false, true)
      SetEntityHeading(guard, 6.15)
      FreezeEntityPosition(guard, true)
      SetEntityInvincible(guard, true)
      SetBlockingOfNonTemporaryEvents(guard, true)
	  Wait(1000)
	  RequestAnimDict("amb@world_human_stand_guard@male@idle_a")
      while (not HasAnimDictLoaded("amb@world_human_stand_guard@male@idle_a")) do Citizen.Wait(0) end 	  
	  TaskPlayAnim(guard, "amb@world_human_stand_guard@male@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0, false, false, false )	
      SetModelAsNoLongerNeeded(guard)	  
end)

--guard2
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_y_doorman_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_doorman_01")) do
      Wait(1)
    end

      local guard2 =  CreatePed(4, 0x22911304, 1087.37, 205.69, -50.00, 6.15, false, true)
      SetEntityHeading(guard2, 6.15)
      FreezeEntityPosition(guard2, true)
      SetEntityInvincible(guard2, true)
      SetBlockingOfNonTemporaryEvents(guard2, true)
	  Wait(3000)
	  RequestAnimDict("amb@world_human_stand_guard@male@idle_a")
      while (not HasAnimDictLoaded("amb@world_human_stand_guard@male@idle_a")) do Citizen.Wait(0) end 	  
	  TaskPlayAnim(guard2, "amb@world_human_stand_guard@male@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0, false, false, false )	
      SetModelAsNoLongerNeeded(guard2)	  
end)


--Penthouse
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("a_m_y_business_02"))
    while not HasModelLoaded(GetHashKey("a_m_y_business_02")) do
      Wait(1)
    end

      local Penthouse =  CreatePed(4, 0xB3B3F5E6, 1087.61, 221.11, -50.00, 182.00, false, true)
      SetEntityHeading(Penthouse, 182.00)
      FreezeEntityPosition(Penthouse, true)
      SetEntityInvincible(Penthouse, true)
      SetBlockingOfNonTemporaryEvents(Penthouse, true)
      SetModelAsNoLongerNeeded(Penthouse)	  
end)