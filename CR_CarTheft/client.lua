ESX = nil
local vehModel, vehicleHash, vehName, LastZone, location, getJobMarker, handInMarker = nil, nil, nil, nil, nil, nil, nil
local HasAlreadyEnteredMarker, cooldown, notifyPolice, payExtra, isOnJob = false, false, false, false, false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    if ESX ~= nil then
        ESX.TriggerServerCallback('CR_CarTheft:sv:getLoc', function(loc)
            if loc then
                location = loc
                getJobMarker = vector3(loc["getjob"][1], loc["getjob"][2], loc["getjob"][3])
                handInMarker = vector3(loc["handin"][1], loc["handin"][2], loc["handin"][3])
            end
        end)
    end
end)

AddEventHandler('CR_CarTheft:enteredMarker', function(zone)
    if zone == 'getjob' then
        CurrentAction = "getjob"
    end

    if zone == 'handin' then
        CurrentAction = "handincar"
    end
end)

AddEventHandler('CR_CarTheft:leftMarker', function(zone)
	CurrentAction = nil
end)

-- Main Thread
Citizen.CreateThread(function()
    while location == nil do
        Citizen.Wait(50)
    end

    while true do
        Citizen.Wait(1000)

        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped, false)
        local IsInMarker = false
        local CurrentZone = nil
        gjTextDraw = false
        hiMarkerDraw = false

        local gjDist = #(playerCoords - getJobMarker)
        local hiDist = #(playerCoords - handInMarker)

        
        if gjDist < 1.5 then
            gjTextDraw  = true
            IsInMarker = true
            CurrentZone = 'getjob'
        end

        if (isOnJob) and (hiDist < 6) then
            hiMarkerDraw = true
            IsInMarker = true
            CurrentZone = 'handin'
        end

        if (IsInMarker and not HasAlreadyEnteredMarker) or (IsInMarker and LastZone ~= CurrentZone) then
            HasAlreadyEnteredMarker = true
            LastZone = CurrentZone
            TriggerEvent('CR_CarTheft:enteredMarker', CurrentZone)
        end
        if (not IsInMarker and HasAlreadyEnteredMarker) then
            HasAlreadyEnteredMarker = false
            TriggerEvent('CR_CarTheft:leftMarker', LastZone)
        end
    end
end)

-- Draw Thread
Citizen.CreateThread(function()
    while location == nil do
        Citizen.Wait(50)
    end

    while true do
        Citizen.Wait(5)
        if (hiMarkerDraw ~= nil) and (hiMarkerDraw) then
            DrawMarker(21, handInMarker[1], handInMarker[2], handInMarker[3],0,0,0,0,0,0,1.5,1.5,1.5,255,0,0,200,0,false,0,true)
            --Drawtext for elementz
            DrawText3D(handInMarker[1], handInMarker[2], handInMarker[3]+1.0, "~w~Press ~r~[E]~w~ to handover vehicle to Brian.")
        elseif (gjTextDraw ~= nil) and (gjTextDraw) then
            DrawText3D(location["getjob"][1], location["getjob"][2], location["getjob"][3]+1.0, "~w~Press ~r~[E]~w~ to speak to Brian")
        else
            Citizen.Wait(1500)
        end
    end
end)

-- Key Thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if(CurrentAction) then
            if(IsControlJustPressed(0, 38)) then
                if(CurrentAction == 'getjob') then
                    if not cooldown then
                        speakToBrian()
                    else
                        exports['mythic_notify']:DoLongHudText('error', 'I won\'t do business with you right now.')
                    end
                elseif (CurrentAction == 'handincar') then
                    HandInCarJob()
                    CurrentAction = nil
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 68)
	ClearDrawOrigin()
end

-- Create NPC
Citizen.CreateThread(function()
    while location == nil do
        Citizen.Wait(50)
    end
    
    RequestModel(GetHashKey("a_m_y_business_03"))
    while not HasModelLoaded(GetHashKey("a_m_y_business_03")) do
      Wait(1)
    end
    
    local BriansCarDealer = CreatePed(4, 0xA1435105, location["getjob"][1], location["getjob"][2], location["getjob"][3]-1.0, location["getjob"][4], false, true)
    FreezeEntityPosition(BriansCarDealer, true)
    SetEntityInvincible(BriansCarDealer, true)
    SetBlockingOfNonTemporaryEvents(BriansCarDealer, true)
    SetModelAsNoLongerNeeded(BriansCarDealer)
end)

function startTimer(timer)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            if (cooldown) and (timer > 0) then
                timer = timer - 1
                if timer == 0 then
                    cooldown = false
                    return
                end
            end
        end
    end)
end

function speakToBrian()
    if not isOnJob then
        isOnJob = true
        local vehIndex = math.random(1, #Config.CarModels)
        vehModel = Config.CarModels[vehIndex]
        vehicleHash = GetHashKey(vehModel[1])
        vehName = vehModel[2]
        exports['mythic_notify']:DoLongHudText('inform', 'Find me one of these ' .. vehName .. '\'s that everyone is raving on about. Bring it to me and I will reward you.')
    else
        isOnJob = false
        startTimer(300)
        cooldown = true
        exports['mythic_notify']:DoLongHudText('inform', 'Thanks for wasting my time. I\'ll have someone else get me that car!')
    end
end

function HandInCarJob()
    if (IsPedInAnyVehicle(PlayerPedId(), false)) and (IsVehicleModel(GetVehiclePedIsIn(PlayerPedId(), true), vehicleHash)) then
        local vehicle = GetVehiclePedIsUsing(PlayerPedId())
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        ESX.TriggerServerCallback('CR_CarTheft:sv:isVehicleOwned', function(vehicleOwned)
            if not vehicleOwned then
                ESX.TriggerServerCallback('CR_CarTheft:sv:anycops', function(cops)
                    if cops then
                        chanceFactor = math.random(1, 10)
                        if (chanceFactor <= 6) then
                            local coords = GetEntityCoords(PlayerPedId())
                            TriggerServerEvent('esx_addons_gcphone:SendCoords', 'police', "A suspicious vehicle that doesn't belong here just turned up..", { x = coords['x'], y = coords['y'], z = coords['z'] })
                        end
                        payExtra = true
                    else
                        payExtra = false
                    end
                end)

                TriggerEvent("mythic_progbar:client:progress", {
                    name = "Car Dealer",
                    duration = math.random(10000, 30000),
                    label = "Handing over the vehicle..",
                    useWhileDead = false,
                    canCancel = false,
        
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(status)
                    if not status then
                        SetEntityAsMissionEntity(vehicle, true, true)
                        ESX.Game.DeleteVehicle(vehicle)
                        TriggerServerEvent('CR_CarTheft:sv:Pay', vehModel[3], payExtra)
                        isOnJob = false
                    else
                        exports['mythic_notify']:DoHudText('error', 'What happened?')
                    end
                end)
            else
                exports['mythic_notify']:DoHudText('error', 'Are you crazy? This is registered!')
            end
        end, vehicleProps)
    else
        exports['mythic_notify']:DoHudText('error', 'I did not ask for this vehicle!')
    end
end