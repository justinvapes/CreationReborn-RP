RegisterNetEvent("esx_inventoryhud:openMotelsInventory2")
AddEventHandler(
    "esx_inventoryhud:openMotelsInventory2",
    function(data)
        setPropertyMotelData2(data)
        openMotelInventory2()
    end
)

function refreshPropertyMotelInventory2()
    ESX.TriggerServerCallback(
        "lsrp-motels2:getPropertyInventory",
        function(inventory)
            setPropertyMotelData2(inventory)
        end,
        ESX.GetPlayerData().identifier
    )
end

function setPropertyMotelData2(data)
    items = {}

    SendNUIMessage(
                {
                    action = "setInfoText",
                    text = "Motel2 Inventory"
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

function openMotelInventory2()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "motels2"
        }
    )
    SetNuiFocus(true, true)
end

RegisterNUICallback(
    "PutIntoMotel2",
    function(data, cb)
	
    if IsPedSittingInAnyVehicle(playerPed) then
       return
    end

     if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

     if data.item.type == "item_weapon" then
        count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
      end

        TriggerServerEvent("lsrp-motels2:putItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, count)
     end

        TriggerServerEvent("RefreshInv")
        Wait(10)
        refreshPropertyMotelInventory2()
        Wait(10)
        loadPlayerInventory()
        cb("ok")
		Wait(500)
		TriggerServerEvent("ReLoadInv")
    end
)

RegisterNUICallback(
    "TakeFromMotel2",
    function(data, cb)
	
    if IsPedSittingInAnyVehicle(playerPed) then
       return
    end

     if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("lsrp-motels2:getItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, tonumber(data.number))
     end
		


        TriggerServerEvent("RefreshInv")
        Wait(10)
        refreshPropertyMotelInventory2()
        Wait(10)
        loadPlayerInventory()
        cb("ok")
		Wait(500)
		TriggerServerEvent("ReLoadInv")
    end
)
