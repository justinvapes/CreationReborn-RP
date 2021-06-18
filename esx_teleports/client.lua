ESX                           = nil
local PlayerLoaded            = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
	LoadMarkers()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent("playradio")
AddEventHandler("playradio", function(url)
SendNUIMessage({
playradio = true,
sound = 'https://www.youtube.com/watch?v=DY_rFed96mg'
})
end)

RegisterNetEvent("stopradio")
AddEventHandler("stopradio", function()
SendNUIMessage({
stopradio = true
})
end)

function LoadMarkers()
    Citizen.CreateThread(function()
    
        while true do
            local sleep = 1000		

            local plyCoords = GetEntityCoords(PlayerPedId())

            for location, val in pairs(Config.Teleporters) do

                local Enter = val['Enter']
                local Exit = val['Exit']
				local MusicNeeded = val['Music']
				local EnterHeading = val['Enter'].h
			    local ExitHeading = val['Exit'].h

                local dstCheckEnter, dstCheckExit = GetDistanceBetweenCoords(plyCoords, Enter['x'], Enter['y'], Enter['z'], true), GetDistanceBetweenCoords(plyCoords, Exit['x'], Exit['y'], Exit['z'], true)

                if dstCheckEnter <= 3.0 then
				   sleep = 5	
				   DrawM(Enter['Information'], 27, Enter['x'], Enter['y'], Enter['z'])
				   
                   if IsControlJustPressed(0, 38) then
                      Teleport(val, 'enter', EnterHeading)
					if MusicNeeded == 'yes' then 
					   --TriggerEvent("playradio")
					end
                  end
               end

                if dstCheckExit <= 2.5 then
				   sleep = 5	
				   DrawM(Exit['Information'], 27, Exit['x'], Exit['y'], Exit['z'])
				   
                   if IsControlJustPressed(0, 38) then
                      Teleport(val, 'exit', ExitHeading)
					  
					if MusicNeeded == 'yes' then 
					   --TriggerEvent("stopradio")
			      end
               end
            end
         end
		 Citizen.Wait(sleep)
      end
   end)
end


--Teleporter Function
function Teleport(table, location, Heading)

    if location == 'enter' then	
       DoScreenFadeOut(100)
       Citizen.Wait(1000)
       ESX.Game.Teleport(PlayerPedId(), table['Exit'])
	   SetEntityHeading(PlayerPedId(), Heading)
       DoScreenFadeIn(100)
   else
       DoScreenFadeOut(100)
       Citizen.Wait(1000)
       ESX.Game.Teleport(PlayerPedId(), table['Enter'])
	   SetEntityHeading(PlayerPedId(), Heading)
       DoScreenFadeIn(100)
   end
end

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.6)
end