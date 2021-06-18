RegisterNetEvent("esx_inventoryhud:openMotelsInventoryBed3")
AddEventHandler(
    "esx_inventoryhud:openMotelsInventoryBed3",
    function(data)
        setPropertyMotelDataBed3(data)
        openMotelInventoryBed3()
    end
)

function refreshPropertyMotelBedInventory3()
    ESX.TriggerServerCallback(
        "lsrp-motels3:getPropertyInventoryBed",
        function(inventory)
            setPropertyMotelDataBed3(inventory)
        end,
        ESX.GetPlayerData().identifier
    )
end

function setPropertyMotelDataBed3(data)

    SendNUIMessage(
                {
                    action = "setInfoText",
                    text = "Bed3 Stash"
                }
            )

    items = {}

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

function openMotelInventoryBed3()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "motelsbed3"
        }
    )
    SetNuiFocus(true, true)
end

RegisterNUICallback(
    "PutIntoMotelBed3",
    function(data, cb)
	
    if IsPedSittingInAnyVehicle(playerPed) then
       return
     end

     if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

      if data.item.type == "item_weapon" then
         count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
       end

        TriggerServerEvent("lsrp-motels3:putItemBed", ESX.GetPlayerData().identifier, data.item.type, data.item.name, count)
		Deposited = 'Stored'
		into      = 'Into'
	    place     = 'Motel-3 Bed'
        TriggerServerEvent('CR_Properytog', GetPlayerName(PlayerId()) .. ' ' .. Deposited ..  ' x' .. count .. ' ' .. data.item.name..  ' ' .. into, place)
     end

        TriggerServerEvent("RefreshInv")
        Wait(10)
        refreshPropertyMotelBedInventory3()
        Wait(10)
        loadPlayerInventory()
        cb("ok")
		Wait(500)
		TriggerServerEvent("ReLoadInv")
    end
)

RegisterNUICallback(
    "TakeFromMotelBed3",
    function(data, cb)
	
    if IsPedSittingInAnyVehicle(playerPed) then
       return
     end

     if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("lsrp-motels3:getItemBed", ESX.GetPlayerData().identifier, data.item.type, data.item.name, tonumber(data.number))
      end
		
		Deposited = 'Removed'
	    into      = 'From'
	    place     = 'Motel-3 Bed'
        TriggerServerEvent('CR_Properytog', GetPlayerName(PlayerId()) .. ' ' .. Deposited ..  ' x' .. data.number .. ' ' .. data.item.name..  ' ' .. into, place)

        TriggerServerEvent("RefreshInv")
        Wait(10)
        refreshPropertyMotelBedInventory3()
        Wait(10)
        loadPlayerInventory()
        cb("ok")
		Wait(500)
		TriggerServerEvent("ReLoadInv")
    end
)
