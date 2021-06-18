local PlayerData = {}
ESX = nil
local PlayerClub, PlayerRankNum = nil, 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	
	ESX.TriggerServerCallback('esx_doorlock:getDoorInfo', function(doorInfo)
		for doorID,state in pairs(doorInfo) do
			Config.DoorList[doorID].locked = state
		end
	end)

	ESX.TriggerServerCallback('sody_clubs:getPlayerClub', function(playerdata)
		PlayerClub = playerdata.club
		PlayerRankNum = playerdata.club_rank
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('sody_clubs:clubAdded')
AddEventHandler('sody_clubs:clubAdded', function(club)
	ESX.TriggerServerCallback('sody_clubs:getPlayerClub', function(playerdata)
		PlayerClub = playerdata.club
		PlayerRankNum = playerdata.club_rank
	end)
end)

RegisterNetEvent('sody_clubs:clubRemoved')
AddEventHandler('sody_clubs:clubRemoved', function()
	PlayerClub, PlayerRankNum = nil, 0
end)

-- Get objects every second, instead of every frame
Citizen.CreateThread(function()
	while true do
	
		for _,doorID in ipairs(Config.DoorList) do
			if doorID.doors then
				for k,v in ipairs(doorID.doors) do
					if not v.object or not DoesEntityExist(v.object) then
						v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objName, false, false, false)
					end
				end
			else
				if not doorID.object or not DoesEntityExist(doorID.object) then
					doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objName, false, false, false)
				end
			end
		end
	   Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		while ESX == nil do
			Citizen.Wait(50)
		end
		local sleep = 1000
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k,doorID in ipairs(Config.DoorList) do
			local distance

			if doorID.doors then
				distance = #(playerCoords - doorID.doors[1].objCoords)
			else
				distance = #(playerCoords - doorID.objCoords)
			end

			local isAuthorized = IsAuthorized(doorID)
			local maxDistance, size, displayText = 2.10, 1, _U('unlocked')

			if doorID.distance then
				maxDistance = doorID.distance
			end

			if distance < 15 then
			   sleep = 5
				if doorID.doors then
					for _,v in ipairs(doorID.doors) do
						FreezeEntityPosition(v.object, doorID.locked)

						if doorID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
							SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
						end
					end
				else
					FreezeEntityPosition(doorID.object, doorID.locked)

					if doorID.locked and doorID.objYaw and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
						SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
					end
				end
			end

			if distance < maxDistance then
				sleep = 5
				if doorID.size then
					size = doorID.size
				end

				if doorID.locked then
					displayText = _U('locked')
				end

				if isAuthorized then
					displayText = _U('press_button', displayText)
				end
				if doorID.textCoords[1] ~= -555555555 then
					ESX.Game.Utils.DrawText3D(doorID.textCoords, displayText, size)
				end

				if IsControlJustReleased(0, 38) then
					if isAuthorized then
					   doorID.locked = not doorID.locked
					   TriggerServerEvent('esx_doorlock:updateState', k, doorID.locked) -- Broadcast new state of the door to everyone
					end
				end
			end
		end
	   Citizen.Wait(sleep)
	end
end)

function IsAuthorized(doorID)
	if PlayerData.job == nil then
		return false
	end

	for _,job in pairs(doorID.authorizedJobs) do
		if job == PlayerData.job.name then
			return true
		end
	end

	if doorID.authorizedClubs ~= nil then
		if PlayerClub ~= nil and PlayerRankNum ~= nil then
			for _,club in pairs(doorID.authorizedClubs) do
				if club == PlayerClub and doorID.authorizedClubRank[1] <= PlayerRankNum then
					return true
				end
			end
		end
	end

	return false
end

-- Set state for a door
RegisterNetEvent('esx_doorlock:setState')
AddEventHandler('esx_doorlock:setState', function(doorID, state)
	Config.DoorList[doorID].locked = state
end)