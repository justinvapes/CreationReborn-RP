ESX = nil
local HasAlreadyEnteredMarker, LastZone = false, nil

------- ESX Thread -------
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(500)
     end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
end)

local SalesLocations = Config.Locations["SalesLocations"]

AddEventHandler('CR_DrugSales:enteredMarker', function(Zone)
    if Zone == "sales" then
        CurrentAction ='sales'
        CurrentActionMsg = 'Press ~INPUT_DETONATE~ to sell your joint'
    end
end)

AddEventHandler('CR_DrugSales:leftMarker', function(zone)
    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
    while true do
        local WaitTime = 1000
        local Ped = PlayerPedId()
        local Dead = IsEntityDead(Ped)
        local PlyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local IsInMarker = false
        local CurrentZone = nil

        if Selling then
            WaitTime = 300
            local SaleCoords = vector3(SaleLoc[1], SaleLoc[2], SaleLoc[3])
            local SaleDist = #(PlyCoords - SaleCoords)
            SalesDraw = false
            if (SaleDist < 20) then
                SalesDraw = true
                if (SaleDist < 1) then
                    IsInMarker = true
                    CurrentZone = 'sales'
                end
            end
        end
        if (IsInMarker and not HasAlreadyEnteredMarker) or (IsInMarker and LastZone ~= CurrentZone) then
            HasAlreadyEnteredMarker = true
            LastZone = CurrentZone
            TriggerEvent('CR_DrugSales:enteredMarker', CurrentZone)
        end
        if (not IsInMarker and HasAlreadyEnteredMarker) then
            HasAlreadyEnteredMarker = false
            TriggerEvent('CR_DrugSales:leftMarker', LastZone)
        end
        if Selling and Dead then
            Selling = false
            SalesDraw = false
            TriggerEvent("CR_DrugSales:killsalesblip")
        end
        Citizen.Wait(WaitTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (Selling == true) and (SalesDraw ~= nil) and (SalesDraw == true) then
            DrawMarker(21, SaleLoc[1], SaleLoc[2], SaleLoc[3],0,0,0,0,0,0,0.5,0.5,0.5,255,0,0,200,0,false,0,true)
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread (function()
    while true do
        Citizen.Wait(0)
        if CurrentAction then
            ESX.ShowHelpNotification(CurrentActionMsg, false, true, 200)
            if (IsControlJustPressed(0, 47)) then
                if CurrentAction == 'sales' then
                    if not IsPedInAnyVehicle(PlayerPedId(), true) then
                        ESX.TriggerServerCallback('CR_DrugSales:CanSell', function(canSell)
                            if canSell then
                                Chance = math.random(1, 100)
                                if Chance <= Config.Chance then
                                    local Coords = GetEntityCoords(PlayerPedId())
                                    TriggerServerEvent('esx_addons_gcphone:SendCoords', 'police', "A Civilian has reported some suspicious handoff happening here", { x = Coords['x'], y = Coords['y'], z = Coords['z'] })
                                end
                                ESX.ShowHelpNotification('Press ~INPUT_PICKUP~ to cancel selling', false, true, 2000)
                                CurrentAction = nil
                                TriggerEvent("mythic_progbar:client:progress", {
                                    name = "selling_weed",
                                    duration = Config.SalesDuration,
                                    label = 'Selling Joints',
                                    useWhileDead = false,
                                    canCancel = true,
                                    controlDisables = {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                    animation = {
                                        animDict = "missheistfbisetup1",
                                        anim = "unlock_loop_janitor",
                                    },
                                }, function(status)
                                    if not status then
                                        TriggerServerEvent('CR_DrugSales:SellWeed')
                                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                                        TriggerEvent('CR_DrugSales:killsalesblip')
                                        Selling = false
                                        SalesDraw = false
                                        ClearPedTasks(PlayerPedId())
                                    else                    
                                        ClearPedTasks(PlayerPedId())
                                    end
                                end)
                            else
                                ESX.ShowNotification('~r~You have no product to sell')
                                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                                TriggerEvent('CR_DrugSales:killsalesblip')
                                Selling = false
                                SalesDraw = false
                            end
                        end)
                    else
                        ESX.ShowNotification('~r~You cannot do this in a vehicle')
                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                    end
                end
            end
        else
        Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('CR_DrugSales:findsales')
AddEventHandler('CR_DrugSales:findsales', function()
    if not Selling then
        SaleId = math.random(#SalesLocations)
        SaleLoc = SalesLocations[SaleId]
        Selling = true
        TriggerEvent('CR_DrugSales:salesblip', SaleLoc[1], SaleLoc[2], SaleLoc[3])
    else
        ESX.TriggerServerCallback('CR_DrugSales:getlabel', function(label)
            ESX.ShowNotification('~r~Already Selling ~g~ Joints ~r~ Check your map')
        end, SellingType)
        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
    end
end)

RegisterNetEvent('CR_DrugSales:notification')
AddEventHandler('CR_DrugSales:notification', function(Notification)
    ESX.ShowNotification(Notification)
    PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
end)

RegisterNetEvent('CR_DrugSales:salesblip')
AddEventHandler('CR_DrugSales:salesblip', function(x,y,z)
    SalesBlip = AddBlipForCoord(x, y, z)
    SetBlipSprite(SalesBlip, 1)
    SetBlipScale(SalesBlip, 1.0)
    SetBlipColour(SalesBlip, 43)
    SetBlipRoute(SalesBlip, true)
end)

RegisterNetEvent('CR_DrugSales:killsalesblip')
AddEventHandler('CR_DrugSales:killsalesblip', function()
    RemoveBlip(SalesBlip)
end)

