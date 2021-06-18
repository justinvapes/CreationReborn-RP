Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX               = nil
local PlayerData  = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do
	
		local sleep = 500
		local playerPos = GetEntityCoords(PlayerPedId(), true)

		for i = 1, #Config.doctor do

			local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Config.doctor[i].x, Config.doctor[i].y, Config.doctor[i].z, true)
			
			if distance < 0.5 then
			   sleep = 5	
			   DrawM('[~b~Press ~w~[~g~E~w~] To Talk With The Doctor~w~]', 27, Config.doctor[i].x, Config.doctor[i].y, Config.doctor[i].z - 0.8)

				if IsControlJustReleased(0, Keys['E']) and not IsEntityDead(PlayerPedId()) then
						
				ESX.TriggerServerCallback('Hospital:checkems', function(AnyEms)				
				if AnyEms <= Config.EMS then
										 
					if GetEntityHealth(PlayerPedId()) <= 198 then 
						if not IsPedDeadOrDying(PlayerPedId()) then
							TriggerServerEvent('Hospital:checkmoney')
						else
							local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~DOCTOR ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Sorry! The Doctor Can't Help Unconciousness", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)					   
						end
				   else
                       local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~DOCTOR ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Sorry! You Don't Need Any Treatment!", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)					   
				    end				   
			       else 
                       local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~DOCTOR ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Sorry! The Doctor Is All Out Of Bandages, Please Call A EMS Member", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)					   
					end					
			     end)
			  end
		   end
	    end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #Config.doctor do
		local blip = AddBlipForCoord(Config.doctor[i].x, Config.doctor[i].y, Config.doctor[i].z)
		SetBlipAsShortRange(blip, true)
		SetBlipSprite(blip, 153) 
		SetBlipColour(blip, 49) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Doctor")
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterNetEvent('Hospital:success')
AddEventHandler('Hospital:success', function()
													  					
	TriggerEvent("mythic_progbar:client:progress", {
        name = "Doctor",
        duration = 20000,
        label = "You Are Now Being Treated",
        useWhileDead = false,
        canCancel = false,
					
        controlDisables = {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
           },
        }, function(status)		      
        SetEntityHealth(PlayerPedId(), 200)
        menuOpen = false	
    end)		
end)

Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("S_M_M_Doctor_01"))
    while not HasModelLoaded(GetHashKey("S_M_M_Doctor_01")) do
      Wait(1)
    end
			
      local Doctor1 =  CreatePed(4, 0xD47303AC, 308.5, -595.15, 42.28, 68.37, false, true)
      SetEntityHeading(Doctor1, 53.59)
      FreezeEntityPosition(Doctor1, true)
      SetEntityInvincible(Doctor1, true)
      SetBlockingOfNonTemporaryEvents(Doctor1, true)
	  SetModelAsNoLongerNeeded(Doctor1)
	  
	  local Doctor2 =  CreatePed(4, 0xD47303AC, -447.84, -340.88, 33.50, 82.09, false, true)
      SetEntityHeading(Doctor2, 82.09)
      FreezeEntityPosition(Doctor2, true)
      SetEntityInvincible(Doctor2, true)
      SetBlockingOfNonTemporaryEvents(Doctor2, true)
	  SetModelAsNoLongerNeeded(Doctor2)	

      local Doctor3 =  CreatePed(4, 0xD47303AC, 1838.79, 3673.69, 33.28, 209.96, false, true)
      SetEntityHeading(Doctor3, 209.96)
      FreezeEntityPosition(Doctor3, true)
      SetEntityInvincible(Doctor3, true)
      SetBlockingOfNonTemporaryEvents(Doctor3, true)
	  SetModelAsNoLongerNeeded(Doctor3)	  

      local Doctor4 =  CreatePed(4, 0xD47303AC, -248.13, 6332.93, 31.43, 223.98, false, true)
      SetEntityHeading(Doctor4, 223.98)
      FreezeEntityPosition(Doctor4, true)
      SetEntityInvincible(Doctor4, true)
      SetBlockingOfNonTemporaryEvents(Doctor4, true)
	  SetModelAsNoLongerNeeded(Doctor4)	  	  
end)

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.5)
end