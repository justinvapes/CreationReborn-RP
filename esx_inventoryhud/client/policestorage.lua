

RegisterNetEvent("esx_policejob:OpenWeaponStorage")
AddEventHandler("esx_policejob:OpenWeaponStorage",
    function(data)
        setPoliceData(data)
        OpenPoliceStorage()
    end
)

function refreshPoliceStorageInventory()
    ESX.TriggerServerCallback("esx_policejob:WeaponStorage", function(inventory)
        setPoliceData(inventory)
    end,ESX.GetPlayerData().identifier)
end

function setPoliceData(data)
    items = {}

    SendNUIMessage(
                {
                action = "setInfoText",
                text = "Police Inventory"
                }
            )

    local policeWeapons = data.weapons

    for i = 1, #policeWeapons, 1 do
        local weapon = policeWeapons[i]

        if policeWeapons[i].name ~= "WEAPON_UNARMED" then
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

function OpenPoliceStorage()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "police"
        }
    )
    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoPolice",function(data, cb)
    --print(ESX.DumpTable(data))
	
    if IsPedSittingInAnyVehicle(playerPed) then
       return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

      if data.item.type == "item_weapon" then
        count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
     end

        TriggerServerEvent("esx_policejob:PutWeapon", ESX.GetPlayerData().identifier, data.item.type, data.item.name, count)
     end

        TriggerServerEvent("RefreshInv")
        Wait(10)
        refreshPoliceStorageInventory()
        Wait(10)
        loadPlayerInventory()
        cb("ok")
		Wait(500)
		TriggerServerEvent("ReLoadInv")
    end
)

RegisterNUICallback("TakeFromPolice",function(data, cb)
	
    if IsPedSittingInAnyVehicle(playerPed) then
       return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        --print('yo')
        TriggerServerEvent("esx_policejob:GetWeapon", ESX.GetPlayerData().identifier, data.item.type, data.item.name, tonumber(data.number))
      end
      
        TriggerServerEvent("RefreshInv")
        Wait(10)
        refreshPoliceStorageInventory()
        Wait(10)
        loadPlayerInventory()
        cb("ok")
		Wait(500)
		TriggerServerEvent("ReLoadInv")
    end
)
