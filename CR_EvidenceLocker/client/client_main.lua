ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
    while PlayerData == nil do
        PlayerData = ESX.GetPlayerData()
        Citizen.Wait(1)
    end

    Citizen.Wait(5000)
    PlayerData = ESX.GetPlayerData()
end)

local HasAlreadyEnteredMarker, LastZone = false, nil
local elDraw = false
local accessAllowed = false

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    --print(ESX.DumpTable(job))
    if PlayerData.job.name == "police" then
        for k, v in pairs(Config.allowedRanks) do
            if PlayerData.job.grade == v then
                accessAllowed = true
                return
            end
        end
    else
        accessAllowed = false
    end
end)

AddEventHandler('CR_EvidenceLocker:enteredMarker', function(zone)
    if zone == 'evidencelocker' then
        CurrentAction = "evidencelocker"
    end
end)

AddEventHandler('CR_EvidenceLocker:leftMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

function OpenLocker()
    if PlayerData.job ~= nil and PlayerData.job.name == "police" then
        local elements = {}
        local elements2 = {}
        ESX.TriggerServerCallback('CR_EvidenceLocker:getInventory', function(result)

            table.insert(elements, {label = "Put items into the evidence locker >>", value = "deposit"})

            for i=1, #result.items, 1 do -- Player Items
            
                local invitem = result.items[i]
        
                if invitem.count > 0 then
                    table.insert(elements2, { label = invitem.label .. ' | ' .. invitem.count .. ' on your person', type = "item_standard", count = invitem.count, value = invitem.name})
                end
            end

            if result.money > 0 then -- Player Money
                table.insert(elements2, { label = 'Dirty Money | $'.. result.money, type = "item_account", value = result.money})
            end
            
            local invitem = result.accounts -- Locker Money

            if accessAllowed == true then
                if invitem.money > 0 then
                    table.insert(elements, { label = 'Dirty Money | $'.. invitem.money, type = "item_account", value = invitem.money})
                end
            end

            for i=1, #result.loadout, 1 do -- Player Weapons
                local weapon = result.loadout[i]

                table.insert(elements2, {
                    label = ESX.GetWeaponLabel(weapon.name) .. ' [' .. weapon.ammo .. ']',
                    type  = 'item_weapon',
                    value = weapon.name,
                    ammo  = weapon.ammo
                })
            end

            if accessAllowed == true then
                for i=1, #result.locker, 1 do -- Locker Items
                
                    local invitem = result.locker[i]
            
                    if invitem.count > 0 and invitem.label ~= nil then
                        table.insert(elements, { label = invitem.label .. ' | ' .. invitem.count .. ' currently in the evidence locker',
                        type = 'item_standard',
                        count = invitem.count,
                        value = invitem.name})
                    end
                end
            end

            if accessAllowed == true then
                for i=1, #result.weapons, 1 do -- Locker Weapons
                    local weapon = result.weapons[i]
                    -- print(ESX.DumpTable(weapon))
                    if weapon.ammo == nil then
                        weapon.ammo = 0
                    end
        
                    table.insert(elements, {
                        label = ESX.GetWeaponLabel(weapon.name) .. ' [' .. weapon.ammo .. ']',
                        type  = 'item_weapon',
                        value = weapon.name,
                        count  = weapon.ammo
                    })
                end
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'evidence_locker', {title= "Evidence Locker", align = 'bottom-right', css = 'entreprise', elements=elements},
                function(data, menu)
                    if data.current.value == "deposit" then
                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'evidence_deposit', {title= "Items", align = 'bottom-right', css = 'entreprise', elements=elements2},
                            function(data2, menu2)
                                if data2.current.type then
                                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit', {
                                        title = "Enter amount to deposit into the evidence locker"
                                    }, function(data3, menu3)

                                        local count = tonumber(data3.value)
                                        local itemName = data2.current.value
                                        local invcount = data2.current.count
            
                                        if data2.current.type == "item_standard" and invcount ~= nil and count > invcount then
                                            ESX.ShowNotification('~r~You can\'t deposit more than you have in your inventory')
                                            menu3.close()
                                            menu2.close()
                                            menu.close()
                                        elseif data2.current.type == "item_account" and itemName >= count then
                                            menu3.close()
                                            menu2.close()
                                            menu.close()
                                            TriggerServerEvent('CR_EvidenceLocker:depositEvidence', data2.current.type, itemName, count)
                                        else
                                            menu3.close()
                                            menu2.close()
                                            menu.close()
                                            TriggerServerEvent('CR_EvidenceLocker:depositEvidence', data2.current.type, itemName, count)
                                        end

                                    end, 
                                    function(data3, menu3)
                                        menu3.close()
                                    end)
                                end
                            end, function(data2, menu2)
                            menu2.close()
                        end)
                    else
                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw', {
                            title = "Enter amount to take out of evidence locker"
                        }, function(data2, menu2)

                            local count = tonumber(data2.value)
                            local itemName = data.current.value
                            local invcount = data.current.count

                            if invcount ~= nil and count ~= nil and count > invcount then
                                ESX.ShowNotification('~r~You can\'t withdraw more than what is in the evidence locker')
                                menu2.close()
                                menu.close()
                            elseif data.current.type == "item_account" and itemName >= count then
                                menu2.close()
                                menu.close()
                                if accessAllowed then
                                    TriggerServerEvent('CR_EvidenceLocker:withdrawEvidence', data.current.type, itemName, count)
                                else
                                    exports['mythic_notify']:DoHudText('error', 'You are not authorised to access the Evidence Locker - Speak to CID or Cabinet...')
                                end
                            else
                                menu2.close()
                                menu.close()
                                if accessAllowed then
                                    TriggerServerEvent('CR_EvidenceLocker:withdrawEvidence', data.current.type, itemName, count)
                                else
                                    exports['mythic_notify']:DoHudText('error', 'You are not authorised to access the Evidence Locker - Speak to CID or Cabinet...')
                                end
                            end

                        end, 
                        function(data2, menu2)
                            menu2.close()
                        end)
                    end
                end,function(data, menu) menu.close() 
            end)
        end)
    else
        exports['mythic_notify']:DoHudText('error', 'You are not police.')
    end
end

-- Main Thread
Citizen.CreateThread(function()
    --local ped = PlayerPedId()
    local locker = vector3(Config.EvidenceLockerLocation.x, Config.EvidenceLockerLocation.y, Config.EvidenceLockerLocation.z)

    while true do
        if PlayerData.job ~= nil and PlayerData.job.name == "police" then
            local ped = PlayerPedId()
            Citizen.Wait(1000)

            local playerCoords = GetEntityCoords(ped, false)
            local IsInMarker = false
            local CurrentZone = nil
            elDraw = false

            local lockerDist = #(playerCoords - locker)
                
            if lockerDist < 3 then
                elDraw = true
                if lockerDist < 1.8 then
                    IsInMarker = true
                    CurrentZone = 'evidencelocker'
                end
            end

            if (IsInMarker and not HasAlreadyEnteredMarker) or (IsInMarker and LastZone ~= CurrentZone) then
                HasAlreadyEnteredMarker = true
                LastZone = CurrentZone
                TriggerEvent('CR_EvidenceLocker:enteredMarker', CurrentZone)
            end
            if (not IsInMarker and HasAlreadyEnteredMarker) then
                HasAlreadyEnteredMarker = false
                TriggerEvent('CR_EvidenceLocker:leftMarker', LastZone)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if (elDraw ~= nil) and (elDraw) then
            DrawText3D(Config.EvidenceLockerLocation.x, Config.EvidenceLockerLocation.y, Config.EvidenceLockerLocation.z, "[~g~E~w~] to open the Evidence Locker")
        else
            Citizen.Wait(1000)
        end
    end
end)

-- Key Thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if(CurrentAction) then
            if (IsControlJustPressed(0, 38)) then
                if CurrentAction == 'evidencelocker' then
                    OpenLocker()
                else
                    exports['mythic_notify']:DoHudText('error', 'You are not authorised to access the Evidence Locker - Speak to CID or Cabinet...')
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