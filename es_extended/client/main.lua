
local isLoadoutLoaded, isPaused, isPlayerSpawned, isDead = false, false, false, false
local lastLoadout, pickups = {}, {}
local loadout        = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerLoaded = true
	ESX.PlayerData = xPlayer
end)

AddEventHandler('playerSpawned', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	local playerPed = PlayerPedId()

	-- Restore position
	if ESX.PlayerData.lastPosition then
		SetEntityCoords(playerPed, ESX.PlayerData.lastPosition.x, ESX.PlayerData.lastPosition.y, ESX.PlayerData.lastPosition.z)
	end

	if isDead == true then
		ESX.PlayerData.loadout = loadout
		TriggerServerEvent('esx:updateLoadout', loadout)
	end

	TriggerEvent('esx:restoreLoadout') -- restore loadout

	isLoadoutLoaded = true
	isPlayerSpawned = true
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('skinchanger:loadDefaultModel', function()
	isLoadoutLoaded = false
end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function()
	local playerPed = PlayerPedId()
	local ammoTypes = {}

	RemoveAllPedWeapons(playerPed, true)

	for k,v in ipairs(ESX.PlayerData.loadout) do
		local weaponName = v.name
		local weaponHash = GetHashKey(weaponName)

		GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
		local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

		for k2,v2 in ipairs(v.components) do
			local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash

			GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed, weaponHash, v.ammo)
			ammoTypes[ammoType] = true
		end
	end

	isLoadoutLoaded = true
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for k,v in ipairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end

	if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('account_' .. account.name, {
			money = ESX.Math.GroupDigits(account.money)
		})
	end
end)

RegisterNetEvent('ESX:Alerts')
AddEventHandler('ESX:Alerts', function(alername, msg, sound)
   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~'..alername, '[~b~'..ESX.Game.GetPedRPNames().. '~s~] '..msg, mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, sound)		       
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item.name then
			ESX.PlayerData.inventory[k] = item
			break
		end
	end

	ESX.UI.ShowInventoryItemNotification(true, item, count)

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)

	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item.name then
			ESX.PlayerData.inventory[k] = item
			break
		end
	end

	ESX.UI.ShowInventoryItemNotification(false, item, count)

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)
	--AddAmmoToPed(playerPed, weaponHash, ammo) possibly not needed
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	RemoveWeaponFromPed(playerPed, weaponHash)

	if ammo then
		local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
		local finalAmmo = math.floor(pedAmmo - ammo)
		SetPedAmmo(playerPed, weaponHash, finalAmmo)
	else
		SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
	end
end)


RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

-- Commands
RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(pos)
	pos.x = pos.x + 0.0
	pos.y = pos.y + 0.0
	pos.z = pos.z + 0.0

	RequestCollisionAtCoord(pos.x, pos.y, pos.z)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(pos.x, pos.y, pos.z)
		Citizen.Wait(1)
	end

	SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('job', {
			job_label   = job.label,
			grade_label = job.grade_label
		})
	end
end)

RegisterNetEvent('esx:loadIPL')
AddEventHandler('esx:loadIPL', function(name)
	Citizen.CreateThread(function()
		LoadMpDlcMaps()
		RequestIpl(name)
	end)
end)

RegisterNetEvent('esx:unloadIPL')
AddEventHandler('esx:unloadIPL', function(name)
	Citizen.CreateThread(function()
		RemoveIpl(name)
	end)
end)

RegisterNetEvent('esx:playAnim')
AddEventHandler('esx:playAnim', function(dict, anim)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end

		TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, 20000, 0, 1, true, true, true)
	end)
end)

RegisterNetEvent('esx:playEmote')
AddEventHandler('esx:playEmote', function(emote)
	Citizen.CreateThread(function()

		local playerPed = PlayerPedId()

		TaskStartScenarioInPlace(playerPed, emote, 0, false);
		Citizen.Wait(20000)
		ClearPedTasks(playerPed)

	end)
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	ESX.Game.SpawnVehicle(model, coords, 90.0, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
	end)
end)

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	ESX.Game.SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end)

RegisterNetEvent('esx:pickup')
AddEventHandler('esx:pickup', function(id, label, player)
	local ped     = GetPlayerPed(GetPlayerFromServerId(player))
	local coords  = GetEntityCoords(ped)
	local forward = GetEntityForwardVector(ped)
	local x, y, z = table.unpack(coords + forward * -2.0)

	ESX.Game.SpawnLocalObject('prop_money_bag_01', {
		x = x,
		y = y,
		z = z - 2.0,
	}, function(obj)
		SetEntityAsMissionEntity(obj, true, false)
		PlaceObjectOnGroundProperly(obj)

		pickups[id] = {
			id = id,
			obj = obj,
			label = label,
			inRange = false,
			coords = {
				x = x,
				y = y,
				z = z
			}
		}
	end)
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(id)
  
	ESX.Game.DeleteObject(pickups[id].obj)
	pickups[id] = nil
	Wait(500)
	TriggerServerEvent("ReLoadInv")
end)

RegisterNetEvent('esx:pickupWeapon')
AddEventHandler('esx:pickupWeapon', function(weaponPickup, weaponName, ammo)
	local playerPed = PlayerPedId()
	local pickupCoords = GetOffsetFromEntityInWorldCoords(playerPed, 2.0, 0.0, 0.5)
	local weaponHash = GetHashKey(weaponPickup)

	CreateAmbientPickup(weaponHash, pickupCoords, 0, ammo, 1, false, true)
end)

RegisterNetEvent('esx:createPickup')
AddEventHandler('esx:createPickup', function(pickupId, label, playerId, type, name, components, tintIndex)

	local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
	local entityCoords, forward, pickupObject = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
	local objectCoords = (entityCoords + forward * 1.2)
		
	if type == 'item_standard' then
		
	    for i = 1, #Config.FoodList do
            if name == Config.FoodList[i] then
			    ESX.Game.SpawnLocalObject('prop_paper_bag_01', objectCoords, function(obj)
				    pickupObject = obj
				end)			   
	        end
        end
		
		for i = 1, #Config.DrinkList do
            if name == Config.DrinkList[i] then
                ESX.Game.SpawnLocalObject('prop_paper_bag_01', objectCoords, function(obj)
				    pickupObject = obj
				end)			   
	        end
        end
	
	    for i = 1, #Config.DrugList do
            if name == Config.DrugList[i] then
                 ESX.Game.SpawnLocalObject('prop_paper_bag_small', objectCoords, function(obj)
				    pickupObject = obj
				end)			   
	        end
        end	
		
		for i = 1, #Config.SmallBoxList do
            if name == Config.SmallBoxList[i] then
			    ESX.Game.SpawnLocalObject('prop_cs_box_clothes', objectCoords, function(obj)
				    pickupObject = obj
				end)
	        end
        end
		
		for i = 1, #Config.BigBoxList do
            if name == Config.BigBoxList[i] then
                ESX.Game.SpawnLocalObject('hei_prop_heist_box', objectCoords, function(obj)
				    pickupObject = obj
				end)			   
	        end
        end
		
		for i = 1, #Config.AmmoClip do
            if name == Config.AmmoClip[i] then
                ESX.Game.SpawnLocalObject('prop_box_ammo01a', objectCoords, function(obj)
				    pickupObject = obj
				end)			   
	        end
        end
				
	elseif type == 'item_money' then  
		ESX.Game.SpawnLocalObject('prop_cash_pile_01', objectCoords, function(obj)
		    pickupObject = obj
		end)
				
	elseif type == 'item_account' then  
		ESX.Game.SpawnLocalObject('prop_cash_pile_01', objectCoords, function(obj)
		    pickupObject = obj
		end)
		
		
	elseif type == 'item_weapon' then
		
	    for i = 1, #Config.PistolList do
            if name == Config.PistolList[i] then
                ESX.Game.SpawnLocalObject('prop_box_guncase_01a', objectCoords, function(obj)
		            pickupObject = obj
		        end)			   
	        end
        end
		
		for i = 1, #Config.SmgList do
            if name == Config.SmgList[i] then
			    ESX.Game.SpawnLocalObject('prop_box_guncase_01a', objectCoords, function(obj)
		            pickupObject = obj
		        end)
	        end
        end
		
		for i = 1, #Config.ShotgunList do
            if name == Config.ShotgunList[i] then
			    ESX.Game.SpawnLocalObject('prop_box_guncase_03a', objectCoords, function(obj)
		            pickupObject = obj
		        end)
	        end
        end
		
		for i = 1, #Config.RifleList do
            if name == Config.RifleList[i] then
                ESX.Game.SpawnLocalObject('prop_box_guncase_03a', objectCoords, function(obj)
		            pickupObject = obj
		        end)			   
	        end
        end
		
		for i = 1, #Config.SniperList do
            if name == Config.SniperList[i] then
                ESX.Game.SpawnLocalObject('prop_box_guncase_03a', objectCoords, function(obj)
		            pickupObject = obj
		        end)			   
	        end
        end
  
        for i = 1, #Config.SmallList do
            if name == Config.SmallList[i] then
                ESX.Game.SpawnLocalObject('prop_box_guncase_02a', objectCoords, function(obj)
		            pickupObject = obj
		        end)			   
	        end
        end  
		
		for i = 1, #Config.RandomList do
            if name == Config.RandomList[i] then
                ESX.Game.SpawnLocalObject('prop_box_guncase_02a', objectCoords, function(obj)
		            pickupObject = obj
		        end)			   
	        end
        end
    end
	
	while not pickupObject do
	   Citizen.Wait(10)
	end

	SetEntityAsMissionEntity(pickupObject, true, false)
	PlaceObjectOnGroundProperly(pickupObject)
	FreezeEntityPosition(pickupObject, true)
	SetEntityCollision(pickupObject, false,true)

	pickups[pickupId] = {
		id = pickupId,
		obj = pickupObject,
		label = label,
		inRange = false,
		coords = objectCoords
	}
end)



RegisterNetEvent('esx:spawnPed')
AddEventHandler('esx:spawnPed', function(model)
	model           = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end

		CreatePed(5, model, x, y, z, 0.0, true, false)
	end)
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function()
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()

	if IsPedInAnyVehicle(playerPed, true) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	end

	if DoesEntityExist(vehicle) then
		ESX.Game.DeleteVehicle(vehicle)
	end
end)

 RegisterNetEvent('money:toggleoff')
AddEventHandler('money:toggleoff', function(show)
	TriggerEvent('es:setMoneyDisplay', 0.0)
    ESX.UI.HUD.SetDisplay(0.0)
end)

 RegisterNetEvent('money:toggleon')
AddEventHandler('money:toggleon', function(show)
	TriggerEvent('es:setMoneyDisplay', 1.0)
    ESX.UI.HUD.SetDisplay(1.0)
end)


-- Save loadout
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(250)
		local playerPed      = PlayerPedId()
		loadout        = {}
		local loadoutChanged = false

		if IsPedDeadOrDying(playerPed) then
			isLoadoutLoaded = false
		end

		for k,v in ipairs(Config.Weapons) do
			local weaponName = v.name
			local weaponHash = GetHashKey(weaponName)
			local weaponComponents = {}

			if HasPedGotWeapon(playerPed, weaponHash, false) and weaponName ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)

				for k2,v2 in ipairs(v.components) do
					if HasPedGotWeaponComponent(playerPed, weaponHash, v2.hash) then
						table.insert(weaponComponents, v2.name)
					end
				end

				if not lastLoadout[weaponName] or lastLoadout[weaponName] ~= ammo then
					loadoutChanged = true
				end

				lastLoadout[weaponName] = ammo

				table.insert(loadout, {
					name = weaponName,
					ammo = ammo,
					label = v.label,
					components = weaponComponents
				})
			else
				if lastLoadout[weaponName] then
					loadoutChanged = true
				end

				lastLoadout[weaponName] = nil
			end
		end

		if loadoutChanged and isLoadoutLoaded then
			ESX.PlayerData.loadout = loadout
			TriggerServerEvent('esx:updateLoadout', loadout)
		end
	end
end)


-- Disable wanted level
if Config.DisableWantedLevel then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			local playerId = PlayerId()
			if GetPlayerWantedLevel(playerId) ~= 0 then
				SetPlayerWantedLevel(playerId, 0, false)
				SetPlayerWantedLevelNow(playerId, false)
			end
		end
	end)
end

-- Pickups
Citizen.CreateThread(function()
	while true do
		
	    local sleep = 500
		local coords = GetEntityCoords(PlayerPedId())
		
		for k,v in pairs(pickups) do
		    local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if distance < 5 then
				local label = v.label
				sleep = 5

				if distance < 1 then
				   sleep = 5
				   label = ('%s~n~%s'):format(label, _U('threw_pickup_prompt'))
				   
					if IsControlJustReleased(0, 38) then

						if (closestDistance == -1 or closestDistance > 3) and not v.inRange and IsPedOnFoot(PlayerPedId()) then
							v.inRange = true
																			
							TriggerEvent('DPEmotes:CancelEmote')														
                            local dict, anim = 'random@domestic', 'pickup_low'
		   										
	                        ESX.Streaming.RequestAnimDict(dict)
	                        TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
	                   
	                        Citizen.Wait(500)
							TriggerServerEvent('esx:onPickup', v.id)
							PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
						 end
					 end					
				 end

				ESX.Game.Utils.DrawText3D({
					x = v.coords.x,
					y = v.coords.y,
					z = v.coords.z + 0.25
				}, label, 1.2, 1)
				
			elseif v.inRange then
				v.inRange = false
			end
		end
	   Citizen.Wait(sleep)
	end
end)

-- Last position
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerPed = PlayerPedId()

		if ESX.PlayerLoaded and isPlayerSpawned then
			local coords = GetEntityCoords(playerPed)

			if not IsEntityDead(playerPed) then
				ESX.PlayerData.lastPosition = {x = coords.x, y = coords.y, z = coords.z}
			end
		end

		if IsEntityDead(playerPed) and isPlayerSpawned then
			isPlayerSpawned = false
		end
	end
end)
