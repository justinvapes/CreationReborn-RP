local showPlayerId, isScoreboardActive = true, false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(1000)
	ESX.TriggerServerCallback('esx_scoreboard:getConnectedPlayers', function(connectedPlayers, maxPlayers)
		UpdatePlayerTable(connectedPlayers)

		SendNUIMessage({
			action = 'updateServerInfo',
			maxPlayers = GetConvarInt('sv_maxclients', 64),
			playTime = '00h 00m'
		})
	end)
end)

RegisterNetEvent('esx_scoreboard:updatestaff')
AddEventHandler('esx_scoreboard:updatestaff', function(anystaff)
UpdateStaffTable(anystaff)
end)

RegisterNetEvent('esx_scoreboard:updateConnectedPlayers')
AddEventHandler('esx_scoreboard:updateConnectedPlayers', function(connectedPlayers)
	UpdatePlayerTable(connectedPlayers)
end)

RegisterNetEvent('esx_scoreboard:updatePlayersInQueue')
AddEventHandler('esx_scoreboard:updatePlayersInQueue', function(playersInQueue)
	SendNUIMessage({action = 'updateServerInfo', playersInQueue = playersInQueue})
end)

RegisterNetEvent('esx_scoreboard:updatePing')
AddEventHandler('esx_scoreboard:updatePing', function(connectedPlayers)
	SendNUIMessage({action = 'updatePing', players = connectedPlayers})
end)

RegisterNetEvent('esx_scoreboard:toggleID')
AddEventHandler('esx_scoreboard:toggleID', function(state)
	if state then
		showPlayerId = state
	else
		showPlayerId = not showPlayerId
	end

	SendNUIMessage({action = 'toggleID', state = showPlayerId})
end)

RegisterNetEvent('uptime:tick')
AddEventHandler('uptime:tick', function(uptime)
	SendNUIMessage({action = 'updateServerInfo', uptime = uptime})
end)

function UpdatePlayerTable(connectedPlayers)

	local formattedPlayerList = {}	
	local ems, police, mechanic, mechanic2, cardealer, cardealer2, unicorn, nightclub, players  = "N", "N", 0, 0, 0, 0, 0, 0, 0
	local offmechanic, offmechanic2, offcardealer, offcardealer2, offunicorn, offnightclub  = 0, 0, 0, 0, 0, 0

	for k,v in pairs(connectedPlayers) do
	
	if v.group == 'mod' then
       table.insert(formattedPlayerList, ('<tr><td style="color:#55ff55">%s - [Mod]</td><td>%s</td><td>%s</td></tr>'):format(v.name, v.playerId, v.ping))
    elseif v.group == 'smod' then   
       table.insert(formattedPlayerList, ('<tr><td style="color:#00aa00">%s - [Senior Mod]</td><td>%s</td><td>%s</td></tr>'):format(v.name, v.playerId, v.ping))
	elseif v.group == 'admin' then   
       table.insert(formattedPlayerList, ('<tr><td style="color:#aa0000">%s - [Admin]</td><td>%s</td><td>%s</td></tr>'):format(v.name, v.playerId, v.ping))     
    elseif v.group == 'developer' then      
       table.insert(formattedPlayerList, ('<tr><td style="color:#a968b3">%s - [Developer]</td><td>%s</td><td>%s</td></tr>'):format(v.name, v.playerId, v.ping))
    elseif v.group == 'superadmin' then      
       table.insert(formattedPlayerList, ('<tr><td style="color:#714ad3">%s - [Owner]</td><td>%s</td><td>%s</td></tr>'):format(v.name, v.playerId, v.ping))
	elseif v.donator then
		table.insert(formattedPlayerList, ('<tr><td style="color:#6cc1e9">%s - [Supporter]</td><td>%s</td><td>%s</td></tr>'):format(v.name, v.playerId, v.ping))

	else
       table.insert(formattedPlayerList, ('<tr><td>%s</td><td>%s</td><td>%s</td></tr>'):format(v.name, v.playerId, v.ping))
    end  

		players = players + 1

		if v.job == 'ambulance' then
			ems = "Y"
		elseif v.job == 'police' then
			police = "Y"
		elseif v.job == 'mecano' then
			mechanic = mechanic + 1
		elseif v.job == 'offmecano' then
			offmechanic = offmechanic + 1
		elseif v.job == 'mecano2' then
			mechanic2 = mechanic2 + 1
		elseif v.job == 'offmecano2' then
			offmechanic2 = offmechanic2 + 1
		elseif v.job == 'cardealer' then
			cardealer = cardealer + 1
		elseif v.job == 'offcardealer' then
			offcardealer = offcardealer + 1
		elseif v.job == 'cardealer2' then
			cardealer2 = cardealer2 + 1
		elseif v.job == 'offcardealer2' then
			offcardealer2 = offcardealer2 + 1
		elseif v.job == 'unicorn' then
			unicorn = unicorn + 1
		elseif v.job == 'offunicorn' then
			offunicorn = offunicorn + 1
		elseif v.job == 'nightclub' then
			nightclub = nightclub + 1
		elseif v.job == 'offnightclub' then
			offnightclub = offnightclub + 1
		end
	end

	SendNUIMessage({
		action  = 'updatePlayerList',
		players = table.concat(formattedPlayerList)
	})

	SendNUIMessage({
		action = 'updatePlayerJobs',
		jobs   = {
			ems = ems,
			police = police,
			mechanic = mechanic,
			offmechanic = offmechanic,
			mechanic2 = mechanic2,
			offmechanic2 = offmechanic2,
			cardealer = cardealer,
			offcardealer = offcardealer,
			cardealer2 = cardealer2,
			offcardealer2 = offcardealer2,
			unicorn = unicorn,
			offunicorn = offunicorn,
			nightclub = nightclub,
			offnightclub = offnightclub,
			player_count = players
		}
	})
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() and isScoreboardActive then
		SetNuiFocus(false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

	if IsControlJustReleased(0, 178) and IsInputDisabled(0) then
		isScoreboardActive = true
		SetNuiFocus(true, true)
		SendNUIMessage({action = 'enable'})
		local subtier = 'None'
		ESX.TriggerServerCallback('esx_scoreboard:Credits', function(HasMoney, Money) 
			if Money > 0 then
			credits = Money           
		else		   
			credits = '0'
			end
			SendNUIMessage({action = 'updatecredits', credits = credits})  
		end)	

		ESX.TriggerServerCallback('esx_scoreboard:donationTier', function(cb)
			subtier = cb
			SendNUIMessage({action = 'updateSubTier', subtier = subtier})
		end)	
			
	-- ESX.TriggerServerCallback('esx_scoreboard:SubscriberSilver', function(Silver) 	
	-- 	if Silver then	
	-- 	   subtier = 'Silver'
    --        SendNUIMessage({action = 'updateSubTier', subtier = subtier})		   
	-- 	end
	--   end)

    -- ESX.TriggerServerCallback('esx_scoreboard:SubscriberGold', function(Gold) 	
	-- 	if Gold then	
	-- 	   subtier = 'Gold'	
	-- 	   SendNUIMessage({action = 'updateSubTier', subtier = subtier})
	-- 	end
	--   end)	

    -- ESX.TriggerServerCallback('esx_scoreboard:SubscriberPlat', function(Plat) 	
	-- 	if Plat then	
	-- 	   subtier = 'Platinum' 
    --        SendNUIMessage({action = 'updateSubTier', subtier = subtier})		   
	-- 	end
	--   end)	  
		SendNUIMessage({action = 'updateSubTier', subtier = subtier})
		Citizen.Wait(1000)
      end
   end
end)

RegisterNUICallback('onCloseMenu', function()
	isScoreboardActive = false
	SetNuiFocus(false)
end)

function UpdateStaffTable(anystaff)

	SendNUIMessage({
		action = 'updatePlayerJobs',
		jobs   = {server_uptime = anystaff}
	})
end

Citizen.CreateThread(function()
	local playMinute, playHour = 0, 0

	while true do
		Citizen.Wait(60000)
		playMinute = playMinute + 1

		if playMinute == 60 then
			playMinute = 0
			playHour = playHour + 1
		end

		SendNUIMessage({
		  action = 'updateServerInfo',
		  playTime = string.format("%02dh %02dm", playHour, playMinute)
		})
	end
end)
