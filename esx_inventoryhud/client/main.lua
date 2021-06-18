local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                   = nil
isInInventory         = false
local PlayerLoaded    = false
local isDead          = false
local isHotbar        = false
local Acceptpromt     = false
local fastItemsHotbar = {}

local fastWeapons = {
	[1] = nil,
	[2] = nil,
	[3] = nil,
    [4] = nil,
    [5] = nil
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
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
  SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
end)

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		DisableControlAction(0, Keys["1"])
		DisableControlAction(0, Keys["2"])
		DisableControlAction(0, Keys["3"])
		DisableControlAction(0, Keys["4"])
		DisableControlAction(0, Keys["5"])
		
		--if IsControlJustReleased(0, Config.OpenControl) and IsInputDisabled(0) and not isDead then
			
		if IsDisabledControlJustReleased(1, Keys["1"]) and not PoliceCheck(State) then 
			if fastWeapons[1] ~= nil then
			   TriggerServerEvent("esx:useItem", fastWeapons[1])
			end
			
		elseif IsDisabledControlJustReleased(1, Keys["2"]) and not PoliceCheck(State) then
			if fastWeapons[2] ~= nil then
			   TriggerServerEvent("esx:useItem", fastWeapons[2])
			end
			
		elseif IsDisabledControlJustReleased(1, Keys["3"]) and not PoliceCheck(State) then
			if fastWeapons[3] ~= nil then
			   TriggerServerEvent("esx:useItem", fastWeapons[3])
			end
			
		elseif IsDisabledControlJustReleased(1, Keys["4"]) and not PoliceCheck(State) then
			if fastWeapons[4] ~= nil then
			   TriggerServerEvent("esx:useItem", fastWeapons[4])
			end
			
		elseif IsDisabledControlJustReleased(1, Keys["5"]) and not PoliceCheck(State) then
			if fastWeapons[5] ~= nil then
			   TriggerServerEvent("esx:useItem", fastWeapons[5])
			end
		end
	end
end)

RegisterKeyMapping('openinv', 'Open Inventory', 'keyboard', 'F2')
RegisterCommand('openinv', function()
    if not isDead then
        openInventory()
        TriggerEvent("esx_inventoryhud:SetDisplay")
        Citizen.Wait(1000)
    end
end)

function PoliceCheck(State)

    if IsPedSittingInAnyVehicle(PlayerPedId()) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		
        if (GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()) then
            if GetVehicleClass(vehicle) == 18 then
               return true
            end
        end
    end
end

function openInventory()
    loadPlayerInventory()
    isInInventory = true
    SendNUIMessage(
        {
            action = "display",
            type = "normal"
        }
    )
    SetNuiFocus(true, true)
end

function closeInventory()
    isInInventory = false
    SendNUIMessage(
        {
            action = "hide"
        }
    )
    SetNuiFocus(false, false)
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
       closeInventory()    
    end
end)

-------------------------------------------------------------
----Start of calculations and checks for inventory duping----
-------------------------------------------------------------
--local OpenCount = {}
local OpenCount = 0
local OpeningTotal

RegisterNUICallback("InventoryType",function(EventType) 			
	CurrentInventoryType = EventType.type	
end)

RegisterNetEvent('esx_inventoryhud:OpenTotal')
AddEventHandler('esx_inventoryhud:OpenTotal', function(Total, plate)

    if plate ~= nil then    
       VehiclePlate = plate
    end
	
	ESX.TriggerServerCallback("esx_inventoryhud:WeaponCount",function(data)
	    Invweapons = data.weapons		
    end)
	
	Citizen.Wait(700)	
    OpeningTotal = #Invweapons + Total
    OpenCount = OpeningTotal
    --table.insert(OpenCount, OpeningTotal)
    print('Total Combined Weapons When Opening ['..CurrentInventoryType..'] = '..OpeningTotal)	
end)

RegisterNUICallback("NUIFocusOff",function() 
	
	if CurrentInventoryType == 'trunk' then
		
		local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))   
		local vehicle = GetClosestVehicle(x, y, z, 3.0, 0, 71)
		SetVehicleDoorShut(vehicle, 5, false, false)
		
		ESX.TriggerServerCallback("esx_inventoryhud:WeaponCount",function(data)
			Invweapons = data.weapons		
		end)
			
		ESX.TriggerServerCallback("esx_trunk:getInventoryV",function(inventory)
			Trunkweapons = inventory.weapons  
		end, VehiclePlate)
		
		Citizen.Wait(700)
		
		ClosingTotal = #Invweapons + #Trunkweapons 
		print('Total Combined Weapons When Closing [' ..CurrentInventoryType.. '] = ' ..ClosingTotal)
		
		--for i=1, #OpenCount do
			
			--if OpenCount[i] ~= ClosingTotal then		   			
           --    NewAmount = ClosingTotal - OpenCount[i] 
            if OpeningTotal ~= ClosingTotal then		   			
                NewAmount = ClosingTotal - OpeningTotal 
				
				if NewAmount > 2 then
				   TriggerServerEvent('CR_Detection:InventoryDupe', CurrentInventoryType, ClosingTotal, OpeningTotal)
				end
			end
		--	break
		--end
		
	elseif CurrentInventoryType == 'motels' then
		
		ESX.TriggerServerCallback("esx_inventoryhud:WeaponCount",function(data)
			Invweapons = data.weapons		
		end)
		
		ESX.TriggerServerCallback("lsrp-motels:getPropertyInventory", function(cb)
			MotelInventory = cb.weapons			
		end,ESX.GetPlayerData().identifier)
		
		Citizen.Wait(700)	
		ClosingTotal = #Invweapons + #MotelInventory 
		print('Total Combined Weapons When Closing [' ..CurrentInventoryType.. '] = ' ..ClosingTotal)
		
		--for i=1, #OpenCount do
			
			-- if OpenCount[i] ~= ClosingTotal then 
			--    NewAmount = ClosingTotal - OpenCount[i] 
            if OpeningTotal ~= ClosingTotal then		   			
                NewAmount = ClosingTotal - OpeningTotal 
				
				if NewAmount > 2 then
				   TriggerServerEvent('CR_Detection:InventoryDupe', CurrentInventoryType, ClosingTotal, OpeningTotal)
				end
		--	end
		--	break
		end
		
	elseif CurrentInventoryType == 'motelsbed' then
		
		ESX.TriggerServerCallback("esx_inventoryhud:WeaponCount",function(data)
			Invweapons = data.weapons		
		end)
		
		ESX.TriggerServerCallback("lsrp-motels:getPropertyInventoryBed", function(cb)
			MotelBedInventory = cb.weapons			
		end,ESX.GetPlayerData().identifier)
		
		Citizen.Wait(700)	
		ClosingTotal = #Invweapons + #MotelBedInventory 
		print('Total Combined Weapons When Closing [' ..CurrentInventoryType.. '] = ' ..ClosingTotal)
		
		--for i=1, #OpenCount do
			
			-- if OpenCount[i] ~= ClosingTotal then 
			--    NewAmount = ClosingTotal - OpenCount[i] 
            if OpeningTotal ~= ClosingTotal then		   			
                NewAmount = ClosingTotal - OpeningTotal 
				
				if NewAmount > 2 then
				   TriggerServerEvent('CR_Detection:InventoryDupe', CurrentInventoryType, ClosingTotal, OpeningTotal)
				end
			-- end
			-- break
		end
		
	elseif CurrentInventoryType == 'motels2' then
		
		ESX.TriggerServerCallback("esx_inventoryhud:WeaponCount",function(data)
			Invweapons = data.weapons		
		end)
		
		ESX.TriggerServerCallback("lsrp-motels2:getPropertyInventory", function(cb)
			Motel2Inventory = cb.weapons			
		end,ESX.GetPlayerData().identifier)
		
		Citizen.Wait(700)		
		ClosingTotal = #Invweapons + #Motel2Inventory 
		print('Total Combined Weapons When Closing [' ..CurrentInventoryType.. '] = ' ..ClosingTotal)
		
		--for i=1, #OpenCount do
			
			-- if OpenCount[i] ~= ClosingTotal then 
			--    NewAmount = ClosingTotal - OpenCount[i] 
            if OpeningTotal ~= ClosingTotal then		   			
                NewAmount = ClosingTotal - OpeningTotal 
				
				if NewAmount > 2 then
				   TriggerServerEvent('CR_Detection:InventoryDupe', CurrentInventoryType, ClosingTotal, OpeningTotal)
				end
		--	end
		--	break
		end
		
	elseif CurrentInventoryType == 'motelsbed2' then
		
		ESX.TriggerServerCallback("esx_inventoryhud:WeaponCount",function(data)
			Invweapons = data.weapons		
		end)
		
		ESX.TriggerServerCallback("lsrp-motels2:getPropertyInventoryBed", function(cb)
			Motel2BedInventory = cb.weapons			
		end,ESX.GetPlayerData().identifier)
		
		Citizen.Wait(700)		
		ClosingTotal = #Invweapons + #Motel2BedInventory 
		print('Total Combined Weapons When Closing [' ..CurrentInventoryType.. '] = ' ..ClosingTotal)
		
		--for i=1, #OpenCount do
			
			-- if OpenCount[i] ~= ClosingTotal then 
			--    NewAmount = ClosingTotal - OpenCount[i] 
            if OpeningTotal ~= ClosingTotal then		   			
                NewAmount = ClosingTotal - OpeningTotal 
				
				if NewAmount > 2 then
			       TriggerServerEvent('CR_Detection:InventoryDupe', CurrentInventoryType, ClosingTotal, OpeningTotal)
				end
		--	end
		--	break
		end
		
	elseif CurrentInventoryType == 'motels3' then
		
		ESX.TriggerServerCallback("esx_inventoryhud:WeaponCount",function(data)
			Invweapons = data.weapons		
		end)
		
		ESX.TriggerServerCallback("lsrp-motels3:getPropertyInventory", function(cb)
			Motel3Inventory = cb.weapons			
		end,ESX.GetPlayerData().identifier)
		
		Citizen.Wait(700)		
		ClosingTotal = #Invweapons + #Motel3Inventory 
		print('Total Combined Weapons When Closing [' ..CurrentInventoryType.. '] = ' ..ClosingTotal)
		
		--for i=1, #OpenCount do
			
			-- if OpenCount[i] ~= ClosingTotal then 
			--    NewAmount = ClosingTotal - OpenCount[i] 
            if OpeningTotal ~= ClosingTotal then		   			
                NewAmount = ClosingTotal - OpeningTotal 
				
				if NewAmount > 2 then
				   TriggerServerEvent('CR_Detection:InventoryDupe', CurrentInventoryType, ClosingTotal, OpeningTotal)
				end
		--	end
		--	break
		end
		
	elseif CurrentInventoryType == 'motelsbed3' then
		
		ESX.TriggerServerCallback("esx_inventoryhud:WeaponCount",function(data)
			Invweapons = data.weapons		
		end)
		
		ESX.TriggerServerCallback("lsrp-motels3:getPropertyInventoryBed", function(cb)
			Motel3BedInventory = cb.weapons			
		end,ESX.GetPlayerData().identifier)
		
		Citizen.Wait(700)		
		ClosingTotal = #Invweapons + #Motel3BedInventory 
		print('Total Combined Weapons When Closing [' ..CurrentInventoryType.. '] = ' ..ClosingTotal)
		
		--for i=1, #OpenCount do
			
			-- if OpenCount[i] ~= ClosingTotal then 
			--    NewAmount = ClosingTotal - OpenCount[i] 
            if OpeningTotal ~= ClosingTotal then		   			
                NewAmount = ClosingTotal - OpeningTotal 
				
				if NewAmount > 2 then
				   TriggerServerEvent('CR_Detection:InventoryDupe', CurrentInventoryType, ClosingTotal, OpeningTotal)
				end
		--	end
		--	break
		end	   
	end 	 
	closeInventory()
    --table.remove(OpenCount)
    OpenCount = 0
end)
-------------------------------------------------------------
----End of calculations and checks for inventory duping----
-------------------------------------------------------------

RegisterNUICallback("GetNearPlayers",function(data, cb)
        local playerPed = PlayerPedId()
        local players = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 1.5)
        local foundPlayers = false
        local elements = {}
				
        for i = 1, #players, 1 do
            if players[i] ~= PlayerId() then
                foundPlayers = true

                table.insert(
                    elements,
                    {
                      label = GetPlayerName(players[i]),
                      player = GetPlayerServerId(players[i])
                    }
                  )
              end
          end

        if not foundPlayers then
            exports['mythic_notify']:DoHudText('error', _U("players_nearby"))
            -- exports.pNotify:SendNotification(
            --     {
            --         text = _U("players_nearby"),
            --         type = "error",
            --         timeout = 3000,
            --         layout = "bottomCenter",
            --         queue = "inventoryhud"
            --     }
            -- )
        else
            SendNUIMessage(
                {
                    action = "nearPlayers",
                    foundAny = foundPlayers,
                    players = elements,
                    item = data.item
                }
            )
        end

        cb("ok")
    end
)

RegisterNUICallback("UseItem", function(data, cb)

        TriggerServerEvent("esx:useItem", data.item.name)

        if shouldCloseInventory(data.item.name) then
            closeInventory()
        else
            Citizen.Wait(10)
			TriggerServerEvent("RefreshInv")
            loadPlayerInventory()
        end
        cb("ok")
    end
)

RegisterNUICallback("DropItem", function(data, cb)

        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end
		
		TriggerEvent('DPEmotes:CancelEmote')
		local lib, anim = 'random@domestic', 'pickup_low'
		   										
	    ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	    end)
		Citizen.Wait(500)

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            TriggerServerEvent("esx:removeInventoryItem", data.item.type, data.item.name, data.number)
        end
		
		if data.item.name == 'pdgps' then	
		 if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then	
		   TriggerEvent('CR_DutyBlips:RemoveBlip')				
		else end
	  end
	  				
        TriggerServerEvent("RefreshInv")
        Wait(10)
        loadPlayerInventory()		
        cb("ok")
		Wait(500)
		TriggerServerEvent("ReLoadInv")
    end
 )
 
 
RegisterNUICallback("GiveItem", function(data, cb)

    if IsPedSittingInAnyVehicle(PlayerPedId()) then
	   ESX.ShowNotification("You ~r~Can't ~w~Do This When In A Vehicle")
       return
    end

        local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 1.5)
        local foundPlayer = false
		
        for i = 1, #players, 1 do
            if players[i] ~= PlayerId() then
                if GetPlayerServerId(players[i]) == data.player then
                   foundPlayer = true
                end
            end
        end

        if foundPlayer then
            local count = tonumber(data.number)
			local Me = GetPlayerServerId(PlayerId())	

            if data.item.type == "item_weapon" then
               count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end
					
				closeInventory()    	
				TriggerServerEvent('esx_inventoryhud:Accept', data.player, Me, data.item.type, data.item.name, count)
							   						   															  				  					          
				TriggerServerEvent("RefreshInv")
				Citizen.Wait(10)
				loadPlayerInventory()
				Citizen.Wait(500)
				TriggerServerEvent("ReLoadInv")						   
        else
            exports['mythic_notify']:DoHudText('error', _U('player_nearby'))
            -- exports.pNotify:SendNotification(
            --     {
            --     text = _U("player_nearby"),
            --     type = "error",
            --     timeout = 3000,
            --     layout = "bottomCenter",
            --     queue = "inventoryhud"
            --     }
            -- )
        end
    cb("ok")
end)

RegisterNetEvent("esx_inventoryhud:DoAnim")	
AddEventHandler("esx_inventoryhud:DoAnim", function()
	
   RequestAnimDict('mp_common')
				
	while not HasAnimDictLoaded('mp_common') do
	   Citizen.Wait(10)
	end
   
	TriggerEvent('RPAnimations:CancelAnims')
	ClearPedTasksImmediately(PlayerPedId())

	TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake2_a', 8.0, -8.0, -1, 0, 0, false, false, false)
	Citizen.Wait(2200)
	ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent("esx_inventoryhud:Accept")	
AddEventHandler("esx_inventoryhud:Accept", function(Me, PlayersName, itemtype, itemname, count)
	
	local You = GetPlayerServerId(PlayerId())
	local Name = PlayersName		
	Acceptpromt = true
	
	Citizen.CreateThread(function()	
		while Acceptpromt do
			Citizen.Wait(0)
			
			local TCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(Me)))
			local MCoord = GetEntityCoords(PlayerPedId())
			
			local ThierCoords = vector3(TCoords.x, TCoords.y, TCoords.z)
			local MyCoords = vector3(MCoord.x, MCoord.y, MCoord.z)
			
			local dist = #(ThierCoords - MyCoords)
			
			if dist < 1.5 then
				
				HelpTextMessage = "~b~Press ~INPUT_CONTEXT~ ~s~To ~y~Accept ~s~[x" ..count.. " ~b~"..itemname.."~s~(s)] From [~g~" ..Name.."~s~]~n~~n~"	
				HelpTextMessage = HelpTextMessage .. "~b~Press ~s~~INPUT_DETONATE~ To ~r~Deny ~s~[x" ..count.. " ~b~"..itemname.."~s~(s)] From [~g~" ..Name.."~s~]"	
				
				AddTextEntry("Instructions", HelpTextMessage)		
				BeginTextCommandDisplayHelp("Instructions")
				EndTextCommandDisplayHelp(0, 0, 1, -1)
				
				if IsControlJustReleased(0, 38) then
					TriggerServerEvent("64dk3-94jdh-fjth48-d345ri", You, Me, itemtype, itemname, count)
					TriggerServerEvent('esx_inventoryhud:DoAnim', Me)
					Acceptpromt = false
					
					RequestAnimDict('mp_common')
					
					while not HasAnimDictLoaded('mp_common') do
						Citizen.Wait(10)
					end
					
					TriggerEvent('RPAnimations:CancelAnims')
					ClearPedTasksImmediately(PlayerPedId())
					
					TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake2_a', 8.0, -8.0, -1, 0, 0, false, false, false)
					Citizen.Wait(2200)
					ClearPedTasksImmediately(PlayerPedId())
					
				elseif IsControlJustReleased(0, 47) then   
					Acceptpromt = false	
					ESX.ShowNotification('You ~r~Denied ~s~[~y~x' ..count.. ' ~b~'..itemname..'~s~(s)] From [~g~' ..Name..'~s~]')
					TriggerServerEvent('esx_inventoryhud:Denied', Me, itemname, count)			   
				end	
			else
				Acceptpromt = false	
				ESX.ShowNotification('Action ~r~Cancelled~s~.. Distance Too Far')
				TriggerServerEvent('esx_inventoryhud:DeniedTooFar', Me)				   
			end	
		end
	end)
end)	

RegisterNUICallback("PutIntoFast", function(data, cb)

    if data.item.slot ~= nil then
       fastWeapons[data.item.slot] = nil
    end
	
    fastWeapons[data.slot] = data.item.name
    loadPlayerInventory()
    cb("ok")
end)

RegisterNUICallback("TakeFromFast", function(data, cb)

    fastWeapons[data.item.slot] = nil
	
    if string.find(data.item.name, "WEAPON_", 1) ~= nil and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(data.item.name) then
        TriggerEvent('conde-inventoryhud:closeinventory', _source)
        RemoveWeapon(data.item.name)
     end
    loadPlayerInventory()
    cb("ok")
end)

function shouldCloseInventory(itemName)
    for index, value in ipairs(Config.CloseUiItems) do
        if value == itemName then
            return true
        end
    end
    return false
end

function shouldSkipAccount(accountName)
    for index, value in ipairs(Config.ExcludeAccountsList) do
        if value == accountName then
            return true
        end
    end
    return false
end

function loadPlayerInventory()
    ESX.TriggerServerCallback(
        "esx_inventoryhud:getPlayerInventory",
        function(data)
            items = {}
            fastItems = {}
            inventory = data.inventory
            accounts = data.accounts
            money = data.money
            weapons = data.weapons

            if Config.IncludeCash and money ~= nil and money > 0 then
                moneyData = {
                    label = _U("cash"),
                    name = "cash",
                    type = "item_money",
                    count = money,
                    usable = false,
                    rare = false,
                    limit = -1,
                    canRemove = true
                }

                table.insert(items, moneyData)
            end

            if Config.IncludeAccounts and accounts ~= nil then
                for key, value in pairs(accounts) do
                    if not shouldSkipAccount(accounts[key].name) then
                        local canDrop = accounts[key].name ~= "bank"

                        if accounts[key].money > 0 then
                            accountData = {
                                label = accounts[key].label,
                                count = accounts[key].money,
                                type = "item_account",
                                name = accounts[key].name,
                                usable = false,
                                rare = false,
                                limit = -1,
                                canRemove = canDrop
                            }
                            table.insert(items, accountData)
                        end
                    end
                end
            end


            if inventory ~= nil then
                for key, value in pairs(inventory) do
                    if inventory[key].count <= 0 then
                        inventory[key] = nil
                    else
                        inventory[key].type = "item_standard"
                        local founditem = false
                        for slot, item in pairs(fastWeapons) do
                            if item == inventory[key].name then
                                table.insert(
                                        fastItems,
                                        {
                                            label = inventory[key].label,
                                            count = inventory[key].count,
                                            weight = 0,
                                            type = "item_standard",
                                            name = inventory[key].name,
                                            usable = inventory[key].usable,
                                            rare = inventory[key].rare,
                                            canRemove = true,
                                            slot = slot
                                        }
                                )
                                founditem = true
                                break
                            end
                            end
                            if founditem == false then
                             table.insert(items, inventory[key])

                        end
                    end
                end
            end

            if Config.IncludeWeapons and weapons ~= nil then
                for key, value in pairs(weapons) do
                    local weaponHash = GetHashKey(weapons[key].name)
                    local playerPed = PlayerPedId()
                    if weapons[key].name ~= "WEAPON_UNARMED" then
                        local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                        table.insert(
                            items,
                            {
                                label = weapons[key].label,
                                count = ammo,
                                limit = -1,
                                type = "item_weapon",
                                name = weapons[key].name,
                                usable = false,
                                rare = false,
                                canRemove = true
                            }
                        )
                    end
                end
            end

            fastItemsHotbar =  fastItems
            SendNUIMessage(
                {
                    action = "setItems",
                    itemList = items,
                    fastItems = fastItems
                }
            )
        end,
        GetPlayerServerId(PlayerId())
    )
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            if isInInventory then
                local playerPed = PlayerPedId()
                DisableControlAction(0, 1, true) -- Disable pan
                DisableControlAction(0, 2, true) -- Disable tilt
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                DisableControlAction(0, 25, true) -- Aim
                DisableControlAction(0, 263, true) -- Melee Attack 1
                DisableControlAction(0, Keys["W"], true) -- W
                DisableControlAction(0, Keys["A"], true) -- A
                DisableControlAction(0, 31, true) -- S (fault in Keys table!)
                DisableControlAction(0, 30, true) -- D (fault in Keys table!)

                DisableControlAction(0, Keys["R"], true) -- Reload
                DisableControlAction(0, Keys["SPACE"], true) -- Jump
                DisableControlAction(0, Keys["Q"], true) -- Cover
                DisableControlAction(0, Keys["TAB"], true) -- Select Weapon
                DisableControlAction(0, Keys["F"], true) -- Also 'enter'?

                DisableControlAction(0, Keys["F1"], true) -- Disable phone
                DisableControlAction(0, Keys["F2"], true) -- Inventory
                DisableControlAction(0, Keys["F3"], true) -- Animations
                DisableControlAction(0, Keys["F6"], true) -- Job

                DisableControlAction(0, Keys["V"], true) -- Disable changing view
                DisableControlAction(0, Keys["C"], true) -- Disable looking behind
                DisableControlAction(0, Keys["X"], true) -- Disable clearing animation
                DisableControlAction(2, Keys["P"], true) -- Disable pause screen

                DisableControlAction(0, 59, true) -- Disable steering in vehicle
                DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
                DisableControlAction(0, 72, true) -- Disable reversing in vehicle

                DisableControlAction(2, Keys["LEFTCTRL"], true) -- Disable going stealth

                DisableControlAction(0, 47, true) -- Disable weapon
                DisableControlAction(0, 264, true) -- Disable melee
                DisableControlAction(0, 257, true) -- Disable melee
                DisableControlAction(0, 140, true) -- Disable melee
                DisableControlAction(0, 141, true) -- Disable melee
                DisableControlAction(0, 142, true) -- Disable melee
                DisableControlAction(0, 143, true) -- Disable melee
                DisableControlAction(0, 75, true) -- Disable exit vehicle
                DisableControlAction(27, 75, true) -- Disable exit vehicle
            end
        end
    end
)

function comma_value(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
  end

RegisterNetEvent('esx_inventoryhud:SetDisplay')
AddEventHandler('esx_inventoryhud:SetDisplay', function(xPlayer) 

    local data = ESX.GetPlayerData()
    local accounts = data.accounts
	local job = data.job
	
    for k,v in pairs(accounts) do
        local account = v
		
        if account.name == "bank" then
            SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..comma_value(account.money)})
        elseif account.name == "black_money" then
            SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..comma_value(account.money)})
        end
    end
	
    SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
    SendNUIMessage({action = "setValue", key = "money", value = "$"..comma_value(data.money)})
		
		
    if ESX.PlayerData.job.grade_name == 'boss' then
     
    ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
	     SendNUIMessage({action = "setValue", key = "society", value = "$"..comma_value(money)})
    end, ESX.PlayerData.job.name)
  end	
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
    if account.name == "bank" then
        SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..comma_value(account.money)})
    elseif account.name == "black_money" then
        SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..comma_value(account.money)})
    end
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(e)
    SendNUIMessage({action = "setValue", key = "money", value = "$"..comma_value(e)})
end)

RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)

function playerAnimations(entity, dict, anim, prop)
    RequestAnimDict(dict)
    
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
        RequestAnimDict(dict)
    end
    
    if prop == nil then
        TaskPlayAnim(entity, dict, anim, 3.0, 1.0, -1, 49, 0, 0, 0, 0)
    else
        RequestModel(prop)
        while not HasModelLoaded(GetHashKey(prop)) do
            Citizen.Wait(0)
        end
        
        local pC = GetOffsetFromEntityInWorldCoords(entity, 0.0, 0.0, 0.0)
        local modelSpawn = CreateObject(GetHashKey(prop), pC.x, pC.y, pC.z, true, true, true)
        prop_net = ObjToNet(modelSpawn)
        SetNetworkIdExistsOnAllMachines(prop_net, true)
        NetworkSetNetworkIdDynamic(prop_net, true)
        SetNetworkIdCanMigrate(prop_net, false)
        
        AttachEntityToEntity(modelSpawn, entity, GetPedBoneIndex(entity, 0x6f06), 0.0, 0.0,0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        
        TaskPlayAnim(entity, dict, anim, 3.0, 1.0, -1, 49, 0, 0, 0, 0)
        SetModelAsNoLongerNeeded(modelSpawn)
    end
end

RegisterNetEvent('esx_inventoryhud:clearfastitems')
AddEventHandler('esx_inventoryhud:clearfastitems', function()
    fastWeapons = {
        [1] = nil,
        [2] = nil,
        [3] = nil,
        [4] = nil,
        [5] = nil
    }
    RemoveAllPedWeapons(PlayerPedId(), true)
end)