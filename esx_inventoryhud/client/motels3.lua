RegisterNetEvent("esx_inventoryhud:openMotelsInventory3")
AddEventHandler(
    "esx_inventoryhud:openMotelsInventory3",
    function(data)
        setPropertyMotelData3(data)
        openMotelInventory3()
    end
)

function refreshPropertyMotelInventory3()
    ESX.TriggerServerCallback(
        "lsrp-motels3:getPropertyInventory",
        function(inventory)
            setPropertyMotelData3(inventory)
        end,
        ESX.GetPlayerData().identifier
    )
end

function setPropertyMotelData3(data)
    items = {}

    SendNUIMessage(
                {
                    action = "setInfoText",
                    text = "Motel3 Inventory"
                }
            )

    local blackMoney = data.blackMoney
    local propertyItems = data.items
    local propertyWeapons = data.weapons

    if blackMoney > 0 then
        accountData = {
            label = _U("black_money"),
            count = blackMoney,
            type = "item_account",
            name = "black_money",
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    for i = 1, #propertyItems, 1 do
        local item = propertyItems[i]

        if item.count > 0 then
            item.type = "item_standard"
            item.usable = false
            item.rare = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    for i = 1, #propertyWeapons, 1 do
        local weapon = propertyWeapons[i]

        if propertyWeapons[i].name ~= "WEAPON_UNARMED" then
            table.insert(
                items,
                {
                    label = ESX.GetWeaponLabel(weapon.name),
                    count = weapon.ammo,
                    limit = -1,
                    type = "item_weapon",
                    name = weapon.name,
                    usable = false,
                    rare = false,
                    canRemove = false
                }
            )
        end
    end

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openMotelInventory3()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "motels3"
        }
    )
    SetNuiFocus(true, true)
end

RegisterNUICallback(
    "PutIntoMotel3",
    function(data, cb)
	
    if IsPedSittingInAnyVehicle(playerPed) then
       return
    end

     if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

      if data.item.type == "item_weapon" then
         count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
      end

         TriggerServerEvent("lsrp-motels3:putItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, count)
	     Deposited = 'Stored'
		 into      = 'Into'
		 place     = 'Motel-3 Draw'
         TriggerServerEvent('CR_Properytog', GetPlayerName(PlayerId()) .. ' ' .. Deposited ..  ' x' .. count .. ' ' .. data.item.name..  ' ' .. into, place)
        end

        TriggerServerEvent("RefreshInv")
        Wait(10)
        refreshPropertyMotelInventory3()
        Wait(10)
        loadPlayerInventory()
        cb("ok")
		Wait(500)
		TriggerServerEvent("ReLoadInv")
    end
)

RegisterNUICallback(
    "TakeFromMotel3",
    function(data, cb)
	
    if IsPedSittingInAnyVehicle(playerPed) then
       return
    end

     if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("lsrp-motels3:getItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, tonumber(data.number))
      end
		
		Deposited = 'Removed'
	    into      = 'From'
	    place     = 'Motel-3 Draw'
        TriggerServerEvent('CR_Properytog', GetPlayerName(PlayerId()) .. ' ' .. Deposited ..  ' x' .. data.number .. ' ' .. data.item.name..  ' ' .. into, place)

        TriggerServerEvent("RefreshInv")
        Wait(10)
        refreshPropertyMotelInventory3()
        Wait(10)
        loadPlayerInventory()
        cb("ok")
		Wait(500)
		TriggerServerEvent("ReLoadInv")
    end
)
