ESX                  = nil
local PlayerLoaded   = false

cachedData = {
	["motels"] = {},
	["insideMotel"] = false
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	
	if ESX.IsPlayerLoaded() then
		Init()
	end
	
	  PlayerLoaded = true
	  ESX.PlayerData = ESX.GetPlayerData()
	  AddTextEntry("Instructions3", Config.HelpTextMessage)
end)

RegisterNetEvent("motel3:RefreshInit")
AddEventHandler("motel3:RefreshInit", function()
	Init()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
	Init()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent("motel3:eventHandler")
AddEventHandler("motel3:eventHandler", function(response, eventData)
	if response == "update_motels" then
		cachedData["motels"] = eventData
	elseif response == "invite_player" then
		if eventData["player"]["source"] == GetPlayerServerId(PlayerId()) then
			Citizen.CreateThread(function()
				local startedInvite = GetGameTimer()

				cachedData["invited"] = true

				while GetGameTimer() - startedInvite < 7500 do
					Citizen.Wait(0)

					ESX.ShowHelpNotification("~b~Invited ~w~To Room ~r~" .. eventData["motel"]["room"] .. " ~g~Press ~b~~INPUT_DETONATE~ ~w~To ~g~Enter")

					if IsControlJustPressed(0, 47) then
						EnterMotel(eventData["motel"])
						break
					end
				end

				cachedData["invited"] = false
			end)
		end
	elseif response == "knock_motel" then
		local currentInstance = DecorGetInt(PlayerPedId(), "currentInstance")

		if currentInstance and currentInstance == eventData["uniqueId"] then
			ESX.ShowNotification("Someone Is Knocking On Your Door!")
		end
	else
		-- print("Wrong event handler.")
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(50)

	cachedData["lastCheck"] = GetGameTimer() - 4750

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local yourMotel = GetPlayerMotel()

		for motelRoom, motelPos in ipairs(Config.MotelsEntrances) do
			local dstCheck = GetDistanceBetweenCoords(pedCoords, motelPos, true)
			local dstRange = yourMotel and (yourMotel["room"] == motelRoom and 35.0 or 3.0) or 3.0

			if dstCheck <= dstRange then
				sleepThread = 5

			if yourMotel and (yourMotel["room"] == motelRoom) then

				DrawScriptMarker({
					["type"] = 2,
					["pos"] = motelPos,
					["r"] = 0,
					["g"] = 255,
					["b"] = 0,
					["sizeX"] = 0.3,
					["sizeY"] = 0.3,
					["sizeZ"] = 0.3,
					["rotate"] = true
				})
			else				
				DrawScriptMarker({
					["type"] = 2,
					["pos"] = motelPos,
					["r"] = 155,
					["g"] = 155,
					["b"] = 155,
					["sizeX"] = 0.3,
					["sizeY"] = 0.3,
					["sizeZ"] = 0.3,
					["rotate"] = true
				  })								
				end

				if dstCheck <= 0.9 then
					local displayText = yourMotel and (yourMotel["room"] == motelRoom and "[~g~E~s~] Enter" or "") or ""; displayText = displayText .. " [~g~H~s~] Menu"

					if not cachedData["invited"] then
						DrawScriptText(motelPos - vector3(0.0, 0.0, 0.20), displayText)
					end

					if IsControlJustPressed(0, 38) then
						if yourMotel then
							if yourMotel["room"] == motelRoom then
							   EnterMotel(yourMotel)
							end
						end
					elseif IsControlJustPressed(0, 74) then
						OpenMotelRoomMenu(motelRoom)
					end
				end
			end
		end

		local dstCheck = GetDistanceBetweenCoords(pedCoords, Config.LandLord["position"], true)

		if dstCheck <= 3.0 then
			sleepThread = 5

			if dstCheck <= 0.9 then
				local displayText = "[~g~E~s~] To Speak To The Landlord"
				
				if not cachedData["purchasing"] then
					DrawScriptText(Config.LandLord["position"], displayText)
				end

				if IsControlJustPressed(0, 38) then
					OpenLandLord()
				end
			end
		end

		Citizen.Wait(sleepThread)
	end
end)