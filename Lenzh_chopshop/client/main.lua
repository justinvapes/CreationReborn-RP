ESX                             = nil
local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local isDead                    = false
local CurrentTask               = {}
local menuOpen 				    = false
local wasOpen 				    = false
local pedIsTryingToChopVehicle  = false
local ChoppingInProgress        = false
local disablecontrol            = false


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if menuOpen then
            ESX.UI.Menu.CloseAll()
        end
    end
end)


function IsDriver()
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end


function MaxSeats(vehicle)
    local vehpas = GetVehicleNumberOfPassengers(vehicle)
    return vehpas
end

local lastTested = 0
function ChopVehicle()
    local seats = MaxSeats(vehicle)
    if seats ~= 0 then
		exports['mythic_notify']:DoHudText('error', 'Sorry! You Can Not Chop A Vehicle With Passengers')
    elseif GetGameTimer() - lastTested > Config.CooldownMinutes * 60000 then
        ESX.TriggerServerCallback('Lenzh_chopshop:anycops', function(anycops)
            if anycops >= Config.CopsRequired then
                if Config.CallCops then
                    local randomReport = math.random(1, Config.CallCopsPercent)

                    if randomReport == Config.CallCopsPercent then
                        TriggerServerEvent('chopNotify')
                    end
                end
                local ped = PlayerPedId()
                local vehicle = GetVehiclePedIsIn( ped, false )
                ChoppingInProgress        = true
                VehiclePartsRemoval()
                if not HasAlreadyEnteredMarker then
                    HasAlreadyEnteredMarker =  true
                    ChoppingInProgress        = false
                    exports['mythic_notify']:DoHudText('error', 'You left the zone. No rewards for you!')
                    SetVehicleAlarmTimeLeft(vehicle, 60000)
                    lastTested = GetGameTimer()
                end
            else
				exports['mythic_notify']:DoHudText('error', 'Sorry! There Needs To Be 1 Cop On Duty')
            end
        end)
    else
        local timerNewChop = Config.CooldownMinutes * 60000 - (GetGameTimer() - lastTested)
        exports['mythic_notify']:DoHudText('error', "Comeback in " ..math.floor(timerNewChop / 60000).. " minute(s)")
        -- exports.pNotify:SendNotification({
        --     text = "Comeback in " ..math.floor(timerNewChop / 60000).. " minute(s)",
        --     type = "error",
        --     timeout = 1000,
        --     layout = "centerRight",
        --     queue = "right",
        --     killer = true,
        --     animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}
        -- })
    end
end



function VehiclePartsRemoval()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn( ped, false )
    SetVehicleNumberPlateText(vehicle, "stolen")
    SetVehicleEngineOn(vehicle, false, false, true)
    SetVehicleUndriveable(vehicle, false)
	disablecontrol = true
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorOpenFrontLeftTime, "Opening Front Left Door")
        Citizen.Wait(Config.DoorOpenFrontLeftTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 0, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenFrontLeftTime, "Removing Front Left Door")
        Citizen.Wait(Config.DoorBrokenFrontLeftTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 0, true)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorOpenFrontRightTime, "Opening Front Right Door")
        Citizen.Wait(Config.DoorOpenFrontRightTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 1, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenFrontRightTime, "Removing Front Right Door")
        Citizen.Wait(Config.DoorBrokenFrontRightTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 1, true)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorOpenRearLeftTime, "Opening Rear Left Door")
        Citizen.Wait(Config.DoorOpenRearLeftTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 2, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenRearLeftTime, "Removing Rear Left Door")
        Citizen.Wait(Config.DoorBrokenRearLeftTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 2, true)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorOpenRearRightTime, "Opening Rear Right Door")
        Citizen.Wait(Config.DoorOpenRearRightTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 3, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenRearRightTime, "Removing Rear Right Door")
        Citizen.Wait(Config.DoorBrokenRearRightTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 3, true)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorOpenHoodTime, "Opening Hood")
        Citizen.Wait(Config.DoorOpenHoodTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 4, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenHoodTime, "Removing Hood")
        Citizen.Wait(Config.DoorBrokenHoodTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),4, true)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorOpenTrunkTime, "Opening Trunk")
        Citizen.Wait(Config.DoorOpenTrunkTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 5, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenTrunkTime, "Removing Trunk")
        Citizen.Wait(Config.DoorBrokenTrunkTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),5, true)
    end
    Citizen.Wait(1000)
    exports['progressBars']:startUI(Config.DeletingVehicleTime, "Deleting Vehicle If Allowed")
    Citizen.Wait(Config.DeletingVehicleTime)
    if ChoppingInProgress == true then
        DeleteVehicle()
        exports['mythic_notify']:DoHudText('success', 'Vehicle Chopped Successfully...')
    end
end

function DeleteVehicle()
    if IsDriver() then
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)
        if IsPedInAnyVehicle(playerPed,  false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            ESX.Game.DeleteVehicle(vehicle)
        end
        TriggerServerEvent("lenzh_chopshop:rewards", rewards)
        
        lastTested = GetGameTimer()
		ChoppingInProgress   = false
		disablecontrol       = false
    end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if disablecontrol == true then
            DisableControlAction(0, 75,  true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        end
  end
end)

AddEventHandler('lenzh_chopshop:hasEnteredMarker', function(zone)
    if zone == 'Chopshop' and IsDriver() then
        CurrentAction     = 'Chopshop'
        CurrentActionMsg  = _U('press_to_chop')
        CurrentActionData = {}
    end
end)

AddEventHandler('lenzh_chopshop:hasExitedMarker', function(zone)
    if menuOpen then
        ESX.UI.Menu.CloseAll()
    end

    if zone == 'Chopshop' then

        if ChoppingInProgress == true then
            exports['mythic_notify']:DoHudText('error', 'You left the zone! Go back into the zone!')
        end
    end
    ChoppingInProgress        = false
    CurrentAction = nil
end)

function CreateBlipCircle(coords, text, radius, color, sprite)

    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
    if Config.EnableBlips == true then
        for k,zone in pairs(Config.Zones) do
            CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
        end
    end
end)

-- Display markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true
        for k,v in pairs(Config.Zones) do
            if Config.MarkerType ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
                DrawMarker(Config.MarkerType, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
                letSleep = false
            end
        end
        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords      = GetEntityCoords(PlayerPedId())
        local isInMarker  = false
        local currentZone = nil
        local letSleep = true
        for k,v in pairs(Config.Zones) do
            if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                letSleep = false
                isInMarker  = true
                currentZone = k
            end
        end
        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
            HasAlreadyEnteredMarker = true
            LastZone                = currentZone
            TriggerEvent('lenzh_chopshop:hasEnteredMarker', currentZone)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('lenzh_chopshop:hasExitedMarker', LastZone)
        end
        if letSleep then
            Citizen.Wait(1000)
        end
    end
end)

-- Key controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentAction ~= nil then
            ESX.ShowHelpNotification(CurrentActionMsg)
            if IsControlJustReleased(0, 38) then
                if IsDriver() then
                    if CurrentAction == 'Chopshop' then
                        ChopVehicle()
                    end
                end
                CurrentAction = nil
            end
        else
            Citizen.Wait(500)
        end
    end
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if menuOpen then
            ESX.UI.Menu.CloseAll()
        end
    end
end)

--Only if Config.CallCops = true
GetPlayerName()


RegisterNetEvent('outlawChopNotify')
AddEventHandler('outlawChopNotify', function(alert)
    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
        ESX.ShowAdvancedNotification(_U('911'), _U('chop'), _U('call'), 'CHAR_CALL911', 7)
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

local timer = 1 --in minutes - Set the time during the player is outlaw
local blipTime = 35 --in second
local showcopsmisbehave = true --show notification when cops steal too
local timing = timer * 60000 --Don't touche it

Citizen.CreateThread(function()
    while true do
        Wait(100)
        if NetworkIsSessionStarted() then
            DecorRegister("IsOutlaw",  3)
            DecorSetInt(PlayerPedId(), "IsOutlaw", 1)
            return
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Wait(100)
        local plyPos = GetEntityCoords(PlayerPedId(),  true)
        if pedIsTryingToChopVehicle then
            DecorSetInt(PlayerPedId(), "IsOutlaw", 2)
            if PlayerData.job ~= nil and PlayerData.job.name == 'police' and showcopsmisbehave == false then
            elseif PlayerData.job ~= nil and PlayerData.job.name == 'police' and showcopsmisbehave then
                TriggerServerEvent('ChoppingInProgressPos', plyPos.x, plyPos.y, plyPos.z)
                TriggerServerEvent('ChopInProgress')
                Wait(3000)
                pedIsTryingToChopVehicle = false
            end
        end
    end
end)


RegisterNetEvent('Choplocation')
AddEventHandler('Choplocation', function(tx, ty, tz)
    if PlayerData.job.name == 'police' then
        local transT = 250
        local Blip = AddBlipForCoord(tx, ty, tz)
        SetBlipSprite(Blip,  10)
        SetBlipColour(Blip,  1)
        SetBlipAlpha(Blip,  transT)
        SetBlipAsShortRange(Blip,  false)
        while transT ~= 0 do
            Wait(blipTime * 4)
            transT = transT - 1
            SetBlipAlpha(Blip,  transT)
            if transT == 0 then
                SetBlipSprite(Blip,  2)
                return
            end
        end
    end
end)

RegisterNetEvent('chopEnable')
AddEventHandler('chopEnable', function()
    pedIsTryingToChopVehicle = true
end)
