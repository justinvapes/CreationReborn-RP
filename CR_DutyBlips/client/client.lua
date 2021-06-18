--On/Off Duty Code
--TriggerEvent('CR_DutyBlips:updateBlip')
--

local blipsCops, blipsAmb = {}, {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)
-- AddEventHandler('playerSpawned', function(spawn)
-- 	if not hasAlreadyJoined then
-- 		TriggerServerEvent('CR_DutyBlips:spawned')
-- 	end
-- 	hasAlreadyJoined = true
-- end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	TriggerServerEvent('CR_DutyBlips:forceBlip')
end)

-- Create blip for colleagues
function createBlip(blipSrc, job)
	local id = GetPlayerFromServerId(blipSrc)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)
    if job == 'police' then
        if not DoesBlipExist(blip) then -- Add blip and create head display on player
            blip = AddBlipForEntity(ped)
            SetBlipSprite(blip, 1)
            ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
            SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
            SetBlipNameToPlayerName(blip, id) -- update blip name
            SetBlipScale(blip, 0.85) -- set scale
            SetBlipAsShortRange(blip, true)
            SetBlipColour(blip, 38)

            table.insert(blipsCops, blip) -- add blip to array so we can remove it later
        end
    elseif job == 'ambulance' then
        if not DoesBlipExist(blip) then -- Add blip and create head display on player
            blip = AddBlipForEntity(ped)
            SetBlipSprite(blip, 1)
            ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
            SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
            SetBlipNameToPlayerName(blip, id) -- update blip name
            SetBlipScale(blip, 0.85) -- set scale
            SetBlipAsShortRange(blip, true)
            SetBlipColour(blip, 49)

            table.insert(blipsAmb, blip) -- add blip to array so we can remove it later
        end
    end
end

RegisterNetEvent('CR_DutyBlips:updateBlip')
AddEventHandler('CR_DutyBlips:updateBlip', function()
	-- Refresh all blips
	for k, existingBlip in pairs(blipsCops) do
		RemoveBlip(existingBlip)
	end
	for k, existingBlip in pairs(blipsAmb) do
		RemoveBlip(existingBlip)
	end

	while ESX == nil do
		Citizen.Wait(50)
	end

	-- Clean the blip table
    blipsCops = {}
    blipsAmb = {}

	-- Is the player a cop? In that case show all the blips for other cops
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
		ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
			for i=1, #players, 1 do
				if players[i].job.name == 'police' then
					local id = GetPlayerFromServerId(players[i].source)
					if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
						createBlip(players[i].source, 'police')
					end
				elseif players[i].job.name == 'ambulance' then
					local id = GetPlayerFromServerId(players[i].source)
					if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
						createBlip(players[i].source, 'ambulance')
					end
				end
			end
		end)
	end

end)