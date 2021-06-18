ESX = nil
DecorRegister("owner", 0)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end

    ESX.PlayAnim = function(dict, anim, speed, time, flag)
        ESX.Streaming.RequestAnimDict(dict, function()
            TaskPlayAnim(PlayerPedId(), dict, anim, speed, speed, time, flag, 1, false, false, false)
        end)
    end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
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

CreateThread(function()
    while true do
        Wait(1300)
        if IsPedTryingToEnterALockedVehicle(PlayerPedId()) then
            vehicle = GetVehiclePedIsTryingToEnter(PlayerPedId())
            -- local netVeh = VehToNet(vehicle)
            -- TriggerServerEvent('CR_VehicleLocks:AlarmSync', netVeh, 1000 * 60 * 5)
            if DecorExistOn(vehicle, "owner") then
                ClearPedTasks(PlayerPedId())
            end
        end
    end
end)

RegisterCommand(Config.commands.keys.command, function(source, args)
    vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    
    if vehicle == 0 then
        vehicle = ESX.Game.GetVehicleInDirection()
    end

    if vehicle == 0 or vehicle == nil then
        vehicle, vehicledist = ESX.Game.GetClosestVehicle()
        if vehicledist > 2.5 then
            vehicle = nil
            vehicledist = nil
        end
    end

    if vehicle == 0 or vehicle == nil then
        --ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.no_vehicle, '', 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] There are no nearby vehicles (look at your car or get closer?)", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
        return
    end
    owner = DecorGetInt(vehicle, "owner")
    if (ESX.PlayerData.job) and (ESX.PlayerData.job.name == Config.Job1) then
        if has_value(Config.Job1Cars, GetEntityModel(vehicle)) then
            owner = GetPlayerServerId(PlayerId())
        end
    end
    if (ESX.PlayerData.job) and (ESX.PlayerData.job.name == Config.Job2) then
        if has_value(Config.Job2Cars, GetEntityModel(vehicle)) then
            owner = GetPlayerServerId(PlayerId())
        end
    end

    -- if ESX.GetPlayerData().identifier == 'steam:110000107e0d26d' then
    --     owner = GetPlayerServerId(PlayerId())
    -- end

    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    ESX.TriggerServerCallback('CR_VehicleLocks:Owner', function(isOwnedVehicle)
        if isOwnedVehicle then
            if owner ~= GetPlayerServerId(PlayerId()) then
                owner = GetPlayerServerId(PlayerId())
                local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] Using your spare keys", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
            end
        end

        if owner ~= GetPlayerServerId(PlayerId()) then
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] You do not have the keys to this vehicle: [~o~".. GetVehicleNumberPlateText(vehicle).."~s~]", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)        
            --ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.no_keys, '', 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
            return
        end

        ESX.PlayAnim("anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, -1, 48)

        locktime = 1
        --print(GetVehicleDoorLockStatus(vehicle))
        if GetVehicleDoorLockStatus(vehicle) > 1 then
            -- local netVeh = VehToNet(vehicle)
            -- TriggerServerEvent('CR_VehicleLocks:AlarmSync', netVeh, 0)
            local netVeh = VehToNet(vehicle)
            TriggerServerEvent('CR_VehicleLocks:LockSync', netVeh, 1)
            SetVehicleDoorsLocked(vehicle, 1)
            PlayVehicleDoorOpenSound(vehicle, 0)
            --SetVehicleAlarmTimeLeft(vehicle, 0)
            locktime = 2
            if Config.use_interact_sound then
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'unlock', 0.2)
            end
            --ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.vehicle_unlocked, '', 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] Vehicle Unlocked: [~o~".. GetVehicleNumberPlateText(vehicle).."~s~]", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
        else
            -- local netVeh = VehToNet(vehicle)
            -- TriggerServerEvent('CR_VehicleLocks:AlarmSync', netVeh, 0)
            local netVeh = VehToNet(vehicle)
            if args[1] == 'child' then
                TriggerServerEvent('CR_VehicleLocks:LockSync', netVeh, 4)
                SetVehicleDoorsLocked(vehicle, 4)
                local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] Vehicle Locked: [~o~".. GetVehicleNumberPlateText(vehicle).."~s~] With Child Locks", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
            else
                TriggerServerEvent('CR_VehicleLocks:LockSync', netVeh, 2)
                SetVehicleDoorsLocked(vehicle, 2)
                local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] Vehicle Locked: [~o~".. GetVehicleNumberPlateText(vehicle).."~s~]", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
            end
            PlayVehicleDoorCloseSound(vehicle, 0)
            if Config.use_interact_sound then
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'lock', 0.2)
            end
            
            --ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.vehicle_locked, '', 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
        end
        
        -- for i = 1, locktime do
            -- StartVehicleHorn(vehicle, 100, "HELDDOWN", false)
            -- SetVehicleLights(vehicle, 2)
            Wait(500)
            -- SetVehicleLights(vehicle, 1)
            local netVeh = VehToNet(vehicle)
            TriggerServerEvent('CR_VehicleLocks:LockSound', netVeh, locktime)
        -- end
    end,vehicleProps)
end, false)

RegisterCommand(Config.commands.givekeys.command, function(source, args, rawcommand)
    --print('test')
    if args[1] == nil then
        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] Missing the player ID - usage /givekeys (id)", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
        --ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.error, Config.notify.argument_1, 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
        return
    end

    vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if vehicle == 0 then
        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] Vehicle not found, Enter it first!", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
        --ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.no_vehicle, Config.notify.enter_vehicle, 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
        return
    end

    if GetPedInVehicleSeat(vehicle, -1) ~= PlayerPedId() then
        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] You are not the driver!", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
        return
    end

    owner = DecorGetInt(vehicle, "owner")
    if owner ~= GetPlayerServerId(PlayerId()) then
        --ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.no_keys, Config.notify.this_vehicle_is_not_your, 'CHAR_MP_STRIPCLUB_PR', 4, true, true)    
        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] You do not have keys to give away", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
        return
    end

    if args[1] == 'near' then
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer and closestPlayerDistance > 3.0 then
            closestPlayer = nil
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] No Players Nearby!", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
            return
        end
        if closestPlayer ~= nil and closestPlayer ~= -1 then
            target = GetPlayerServerId(closestPlayer)
            DecorSetInt(vehicle, "owner", tonumber(target))
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] You have given keys to [~b~" .. GetPlayerName(GetPlayerFromServerId(tonumber(target))) .. "~s~]", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
            TriggerServerEvent('CR_VehicleLocks:KeysSend', target, GetVehicleNumberPlateText(vehicle))
            return
        else
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] No Players Nearby!", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
        end
        return
    end
    DecorSetInt(vehicle, "owner", tonumber(args[1]))
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] You have given keys to [~b~" .. GetPlayerName(GetPlayerFromServerId(tonumber(args[1]))) .. "~s~]", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
    TriggerServerEvent('CR_VehicleLocks:KeysSend', args[1], GetVehicleNumberPlateText(vehicle))
    --ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.success, Config.notify.keys_gived_to .. args[1], 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
end, false)

RegisterKeyMapping(Config.commands.keys.command, 'Vehicle Locks', 'keyboard', Config.commands.keys.input)
RegisterKeyMapping(Config.commands.keys.command2, 'Vehicle Child Locks', 'keyboard', Config.commands.keys.input2)

RegisterNetEvent('CR_VehicleLocks:KeysRecv')
AddEventHandler('CR_VehicleLocks:KeysRecv', function(sender, plate)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] You have received keys for [~b~" .. GetPlayerName(GetPlayerFromServerId(tonumber(sender))) .. "~s~] vehicle: [~o~".. plate.."~s~]", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~Vehicle Locks', '[~b~'..ESX.Game.GetPedRPNames().."~s~] Make sure you enter the vehicle before locking it", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
end)

RegisterNetEvent('CR_VehicleLocks:LockSound')
AddEventHandler('CR_VehicleLocks:LockSound', function(vehicle, locktime)
    vehicle = NetToVeh(vehicle)
    for i = 1, locktime do
        --StartVehicleHorn(vehicle, 100, "HELDDOWN", false)
        SetVehicleLights(vehicle, 2)
        Wait(250)
        SetVehicleLights(vehicle, 0)
    end
end)

-- RegisterNetEvent('CR_VehicleLocks:AlarmSync')
-- AddEventHandler('CR_VehicleLocks:AlarmSync', function(vehicle, alarmtime)
--     vehicle = NetToVeh(vehicle)
--     SetVehicleAlarmTimeLeft(vehicle, alarmtime)
-- end)

RegisterNetEvent('CR_VehicleLocks:LockSync')
AddEventHandler('CR_VehicleLocks:LockSync', function(vehicle, lock)
    --print(lock)
    vehicle = NetToVeh(vehicle)
    SetVehicleDoorsLocked(vehicle, lock)
end)

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if GetHashKey(value) == val then
            return true
        end
    end

    return false
end