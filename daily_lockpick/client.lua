ESX = nil

local display = false
local action, pinHp, pinDmg, maxDist, solvePadd = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(50)
    end
end)

RegisterNetEvent("daily_lockpick:startPicking")
AddEventHandler("daily_lockpick:startPicking",function(cb, pinHp, pinDmg, maxDist, solvePadd)

    if pinHp == nil then
       pinHp = Config.DefaultPinHealth
    end

    if pinDmg == nil then
       pinDmg = Config.DefaultPinDamage
    end

    if maxDist == nil then
       maxDist = Config.DefaultMaxDistance
    end

    if solvePadd == nil then
       solvePadd = Config.DefaultSolvePadding
    end

        SetDisplay(not display, bobbypin, pinHp, pinDmg, maxDist, solvePadd)

        Citizen.CreateThread(function()
             while true do
                Citizen.Wait(0)
					
                if action == "unlocked" then
                   action = nil                       
                   cb(true) 
               break
				   
                elseif action == "failed" then
                    action = nil
                    cb(false) 
                break
             end
         end
     end)
end)

function SetDisplay(trigger, amount, health, damage, distance, padding)
    display = trigger
    SetNuiFocus(trigger, trigger)
	
    SendNUIMessage({
      type = "lockpick",
      enable = trigger,
      pins = amount,
      pinhp = health,
      pindmg = damage,
      maxdist = distance,
      solvepadd = padding
    })
end

RegisterNUICallback('exit', function() 
   SetDisplay(false) 
end)

RegisterNUICallback('action', function(data, cb)

    if data.action == "break" then
        TriggerServerEvent("daily_lockpick:removeItem")
		
    elseif data.action == "failed" then
        ESX.ShowNotification("Lockpick Failed!")
        SetDisplay(false)
        action = data.action
		TriggerEvent("CR_HouseRobbery:SetNotify")
		
    elseif data.action == "unlocked" then
        SetDisplay(false)
        action = data.action
     end
    cb('ok')
end)

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)

        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display)
        DisableControlAction(0, 106, display)

    end
end)
