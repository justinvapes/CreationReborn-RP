ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(50)
    end
end)

Citizen.CreateThread(function()
    -- Coffee Machines
    exports['bt-target']:AddTargetModel(Config.CoffeeMachine["models"], {
        options = {
            {
                event = {"delta_vending:BuyCoffee", Config.CoffeeMachine["items"][1]},
                icon = "fas fa-coffee",
                label = ("Purchase Latte - $" .. Config.Costs["Coffee"]),
            },
            {
                event = {"delta_vending:BuyCoffee", Config.CoffeeMachine["items"][2]},
                icon = "fas fa-coffee",
                label = ("Purchase Cappuccino - $" .. Config.Costs["Coffee"]),
            },
            {
                event = {"delta_vending:BuyCoffee", Config.CoffeeMachine["items"][3]},
                icon = {"fas fa-coffee"},
                label = ("Purchase Mocha - $" .. Config.Costs["Coffee"]),
            },
            {
                event = {"delta_vending:BuyCoffee", Config.CoffeeMachine["items"][4]},
                icon = "fas fa-coffee",
                label = ("Purchase Iced Coffee - $" .. Config.Costs["Coffee"]),
            },
            {
                event = {"delta_vending:KickMachine", 'coffee'},
                icon = "fas fa-shoe-prints",
                label = "Kick Machine - ARGH"
            }
        },
        job = {"all"},
        distance = 1
    })

    -- Drink Machine
    exports['bt-target']:AddTargetModel(Config.DrinkMachine["models"], {
        options = {
            {
                event = {"delta_vending:BuyDrink", Config.DrinkMachine["items"][3]},
                icon = "fas fa-glass-whiskey",
                label = ("Purchase Sprite - $" .. Config.Costs["Drinks"]),
            },
            {
                event = {"delta_vending:BuyDrink", Config.DrinkMachine["items"][2]},
                icon = "fas fa-glass-whiskey",
                label = ("Purchase Coke Zero- $" .. Config.Costs["Drinks"]),
            },
            {
                event = {"delta_vending:BuyDrink", Config.DrinkMachine["items"][1]},
                icon = "fas fa-glass-whiskey",
                label = ("Purchase Pepsi - $" .. Config.Costs["Drinks"]),
            },
            {
                event = {"delta_vending:KickMachine", 'drink'},
                icon = "fas fa-shoe-prints",
                label = "Kick Machine - ARGH"
            }
        },
        job = {"all"},
        distance = 1.0
    })

    -- Snack Machine
    exports['bt-target']:AddTargetModel(Config.SnackMachine["models"], {
        options = {
            {
                event = {"delta_vending:BuySnack", Config.SnackMachine["items"][2]},
                icon = "fas fa-stroopwafel",
                label = ("Purchase Donut - $" .. Config.Costs["Snacks"]),
            },
            {
                event = {"delta_vending:BuySnack", Config.SnackMachine["items"][1]},
                icon = "fas fa-cookie",
                label = ("Purchase Potato Chips - $" .. Config.Costs["Snacks"]),
            },
            {
                event = {"delta_vending:BuySnack", Config.SnackMachine["items"][3]},
                icon = "fas fa-brain",
                label = ("Purchase Nuggets - $" .. Config.Costs["Snacks"]),
            },
            {
                event = {"delta_vending:KickMachine", 'snack'},
                icon = "fas fa-shoe-prints",
                label = "Kick Machine - ARGH"
            }
        },
        job = {"all"},
        distance = 1.0
    })
end)

local kicked = {}

RegisterNetEvent('delta_vending:BuyCoffee')
AddEventHandler('delta_vending:BuyCoffee', function(product)
    local inventory = ESX.GetPlayerData().inventory
    local itemCount = 0
    for i=1, #inventory, 1 do
        if inventory[i].name == product[1] then
            itemCount = inventory[i].count
        end        
    end

    if itemCount >= Config.MaxCount then
        exports['mythic_notify']:DoHudText('error', 'You can\'t carry any more of these.')
        return
    end

    ESX.TriggerServerCallback('delta_vending:affordability', function(response)
        if response then
            local badLuckChance = math.random(1, 100)
            if badLuckChance >= Config.VendingMachineScamChance then
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "Coffee Vending Machine",
                    duration = 3000,
                    label = ("Dispensing " .. product[2]),
                    useWhileDead = false,
                    canCancel = true,
        
                    controlDisables = {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(status)
                    if not status then
                        TriggerServerEvent('delta_vending:buyItem', product[1])
                    end
                end)
            else
                exports['mythic_notify']:DoHudText('error', 'The vending machine seems to have taken your money')
            end
        else
            exports['mythic_notify']:DoHudText('error', 'You do not have enough cash on you to pay for this')
        end
    end, Config.Costs["Coffee"])
end)

RegisterNetEvent('delta_vending:BuySnack')
AddEventHandler('delta_vending:BuySnack', function(product)
    local inventory = ESX.GetPlayerData().inventory
    local itemCount = 0
    for i=1, #inventory, 1 do
        if inventory[i].name == product[1] then
            itemCount = inventory[i].count
        end        
    end

    if itemCount >= Config.MaxCount then
        exports['mythic_notify']:DoHudText('error', 'You can\'t carry any more of these.')
        return
    end

    ESX.TriggerServerCallback('delta_vending:affordability', function(response)
        if response then
            local badLuckChance = math.random(1, 100)
            if badLuckChance >= Config.VendingMachineScamChance then
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "Snack Vending Machine",
                    duration = 3000,
                    label = ("Dispensing " .. product[2]),
                    useWhileDead = false,
                    canCancel = true,
        
                    controlDisables = {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(status)
                    if not status then
                        TriggerServerEvent('delta_vending:buyItem', product[1])
                    end
                end)
            else
                exports['mythic_notify']:DoHudText('error', 'The vending machine seems to have taken your money')
            end
        else
            exports['mythic_notify']:DoHudText('error', 'You do not have enough cash on you to pay for this')
        end
    end, Config.Costs["Snacks"])
end)

-- DRINKS
RegisterNetEvent('delta_vending:BuyDrink')
AddEventHandler('delta_vending:BuyDrink', function(product)
    local inventory = ESX.GetPlayerData().inventory
    local itemCount = 0
    for i=1, #inventory, 1 do
        if inventory[i].name == product[1] then
            itemCount = inventory[i].count
        end        
    end

    if itemCount >= Config.MaxCount then
        exports['mythic_notify']:DoHudText('error', 'You can\'t carry any more of these.')
        return
    end

    ESX.TriggerServerCallback('delta_vending:affordability', function(response)
        if response then
            local badLuckChance = math.random(1, 100)
            if badLuckChance >= Config.VendingMachineScamChance then
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "Drink Vending Machine",
                    duration = 3000,
                    label = ("Dispensing " .. product[2]),
                    useWhileDead = false,
                    canCancel = true,
        
                    controlDisables = {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(status)
                    if not status then
                        TriggerServerEvent('delta_vending:buyItem', product[1])
                    end
                end)
            else
                exports['mythic_notify']:DoHudText('error', 'The vending machine seems to have taken your money')
            end
        else
            exports['mythic_notify']:DoHudText('error', 'You do not have enough cash on you to pay for this')
        end
    end, Config.Costs["Drinks"])
end)

RegisterNetEvent('delta_vending:KickMachine')
AddEventHandler('delta_vending:KickMachine', function(vendingMachineType)
    local vendingMachine, freeItem, canKick = nil, nil, true
    local playerPed = PlayerPedId()
    local playerPos = vector3(GetEntityCoords(playerPed, true))
    local rageChance = math.random(1, 100)
    local copChance = math.random(1, 100)
    loadAnimDict('melee@knife@streamed_core')

    if vendingMachineType == 'snack' then
        freeItem = math.random(1, #Config.SnackMachine["items"])
        for k, machine in ipairs(Config.SnackMachine["models"]) do
            vendingMachine = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 2.0, machine, false, false, false)
        end

        for i = 1, #kicked do
            if kicked[i] == vendingMachine then
                canKick = false
            end
        end

        if (DoesEntityExist(vendingMachine) and canKick) then
            TaskPlayAnim(playerPed, "melee@knife@streamed_core", "kick_close_b", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
            Citizen.Wait(2500)
            ClearPedTasksImmediately(playerPed)
            TriggerServerEvent('delta_vending:vendingTimer', vendingMachine)
            table.insert(kicked, vendingMachine)
            if rageChance <= Config.RageSuccessChance then
                local inventory = ESX.GetPlayerData().inventory
                local itemCount = 0
                for i=1, #inventory, 1 do
                    if inventory[i].name == Config.SnackMachine["items"][freeItem][1] then
                        itemCount = inventory[i].count
                    end        
                end

                if itemCount >= Config.MaxCount then
                    return
                end
                TriggerServerEvent('delta_vending:buyItem', Config.SnackMachine["items"][freeItem][1])
            else
                if copChance <= Config.RageCopChance then
                    TriggerServerEvent("mdt:newCall", 'A vending machine alarm has been triggered at this location', -1, playerPos)
                end
            end
        else
            exports['mythic_notify']:DoHudText('error', 'The vending machine is broken')
        end
    elseif vendingMachineType == 'drink' then
        freeItem = math.random(1, #Config.DrinkMachine["items"])
        for k, machine in ipairs(Config.DrinkMachine["models"]) do
            vendingMachine = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 2.0, machine, false, false, false)
        end

        for i = 1, #kicked do
            if kicked[i] == vendingMachine then
                canKick = false
            end
        end

        if (DoesEntityExist(vendingMachine) and canKick) then
            TaskPlayAnim(playerPed, "melee@knife@streamed_core", "kick_close_b", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
            Citizen.Wait(2500)
            ClearPedTasksImmediately(playerPed)
            TriggerServerEvent('delta_vending:vendingTimer', vendingMachine)
            table.insert(kicked, vendingMachine)
            if rageChance < Config.RageSuccessChance then 
                local inventory = ESX.GetPlayerData().inventory
                local itemCount = 0
                for i=1, #inventory, 1 do
                    if inventory[i].name == Config.DrinkMachine["items"][freeItem][1] then
                        itemCount = inventory[i].count
                    end        
                end

                if itemCount >= Config.MaxCount then
                    return
                end
                TriggerServerEvent('delta_vending:buyItem', Config.DrinkMachine["items"][freeItem][1])
            else
                if copChance <= Config.RageCopChance then
                    TriggerServerEvent("mdt:newCall", 'A vending machine alarm has been triggered at this location', -1, playerPos)
                end
            end
        else
            exports['mythic_notify']:DoHudText('error', 'The vending machine is broken')
        end
    elseif vendingMachineType == 'coffee' then
        freeItem = math.random(1, #Config.CoffeeMachine["items"])
        for k, machine in ipairs(Config.CoffeeMachine["models"]) do
            vendingMachine = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 2.0, machine, false, false, false)
        end

        for i = 1, #kicked do
            if kicked[i] == vendingMachine then
                canKick = false
            end
        end

        if (DoesEntityExist(vendingMachine) and canKick) then
            TaskPlayAnim(playerPed, "melee@knife@streamed_core", "kick_close_b", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
            Citizen.Wait(2500)
            ClearPedTasksImmediately(playerPed)
            TriggerServerEvent('delta_vending:vendingTimer', vendingMachine)
            table.insert(kicked, vendingMachine)
            if rageChance < Config.RageSuccessChance then 
                local inventory = ESX.GetPlayerData().inventory
                local itemCount = 0
                for i=1, #inventory, 1 do
                    if inventory[i].name == Config.CoffeeMachine["items"][freeItem][1] then
                        itemCount = inventory[i].count
                    end        
                end

                if itemCount >= Config.MaxCount then
                    return
                end
                TriggerServerEvent('delta_vending:buyItem', Config.CoffeeMachine["items"][freeItem][1])
            else
                if copChance <= Config.RageCopChance then
                    TriggerServerEvent("mdt:newCall", 'A vending machine alarm has been triggered at this location', -1, playerPos)
                end
            end
        else
            exports['mythic_notify']:DoHudText('error', 'The vending machine is broken')
        end
    end
end)

-- Taken from Basic Needs, just to allow for different positions to be used for models
RegisterNetEvent('delta_vending:onDrink')
AddEventHandler('delta_vending:onDrink', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_ld_flow_bottle'
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)

            --if prop_name == 'p_amb_coffeecup_01' then
                AttachEntityToEntity(prop, playerPed, boneIndex, 0.10, 0.028, 0.001, 10.0, 100.0, 0.0, true, true, false, true, 1, true)
            --end

            ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
                TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
            end)
        end)
    end
end)

RegisterNetEvent('delta_vending:onEat')
AddEventHandler('delta_vending:onEat', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_burger_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

function loadAnimDict(dict)  
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

RegisterNetEvent('delta_vending:removeVendingTimer')
AddEventHandler('delta_vending:removeVendingTimer', function(object)
    for i = 1, #kicked do
        if kicked[i] == object then
            table.remove(kicked, i)
        end
    end
end)