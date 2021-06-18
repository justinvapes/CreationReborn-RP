ESX = nil
local PlayerData = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local HasWeaponSlingOne, SlingWeaponOne, WeaponToSlingOne, AmmoInSlingOne, WeaponInArray, WeaponSlung, PlayerIsDead, IsCivilian = false, nil, nil, 0, false, false, false, false

local CarbineEquipped, ShotgunEquipped, BeanbagEquipped, caron, sgon, bbon = false, false, false, false, false, false

local savedcomps = {}
local savedobjects = {}
local savedmodels = {}

local femaleHash = GetHashKey("mp_f_freemode_01")
local maleHash = GetHashKey("mp_m_freemode_01")

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job

    if ESX.PlayerData.job.name == 'offpolice' then
        for i, model in ipairs(savedmodels) do -- Set component model as NLN
                    
            SetModelAsNoLongerNeeded(model)
        
        end
        
        for i, object in ipairs(savedobjects) do -- Unregister component object
            
            NetworkUnregisterNetworkedEntity(object)
            DeleteObject(object)
        end
        
        if DoesEntityExist(SlingWeaponOne) then -- Remove and unregister main weapon object
            DeleteObject(SlingWeaponOne)
            RemoveWeaponAsset(SlingWeaponOne)
            SetModelAsNoLongerNeeded(SlingWeaponOne)
            NetworkUnregisterNetworkedEntity(SlingWeaponOne)
        end
        
        -- Reset all the tables for later use
        savedcomps = {}
        savedobjects = {}
        savedmodels = {}
        WeaponSlung = false
        HasWeaponSlingOne = false
        SlingWeaponOne = nil
        TriggerServerEvent('CR_WeaponSling:sv:RemoveWep')
    end
end)

--[[
	RegisterCommand("getvest", function(source, args, raw)
		local Ped = PlayerPedId()
		ShowNotification('ID of your Vest is:')
		ShowNotification(GetPedDrawableVariation(Ped,9))
	end)	
]]--

--[[-----------------------------------------------------

			Loop for Persistent Weapons

]]-------------------------------------------------------

-- RegisterCommand(Config.DisablePW, function(source, args, raw) -- Backdoor to disable Persistent WEapons for Civs
-- 	if not IsCivilian then
-- 		IsCivilian = true
-- 		ShowNotification('~o~Civilian Access: Persistent Weapons Disabled')
-- 	elseif IsCivilian then
-- 		IsCivilian = false
-- 		ShowNotification('~o~Civilian Access: Persistent Weapons Enabled')
-- 	end
-- end)

-- Citizen.CreateThread(function()
--     while true do 
--         Citizen.Wait(0)

-- 		if not IsCivilian then

-- 			if Config.PersistentWeapons then
-- 				local Ped = PlayerPedId()
-- 				local Veh = GetVehiclePedIsIn(Ped)
-- 				local CurrentWeapon = GetSelectedPedWeapon(Ped)
			
-- 				if CarbineEquipped then
-- 					SetCurrentPedWeapon(Ped, 'weapon_carbinerifle', true)
-- 				else
-- 					if tostring(CurrentWeapon) == '-2084633992' then
-- 						ShowNotification('~o~You need to unrack your rifle from your cruiser via /ar before you can use it')
-- 						SetCurrentPedWeapon(Ped, 'weapon_unarmed', true)
-- 					end
-- 				end
				
-- 				if ShotgunEquipped then
-- 					SetCurrentPedWeapon(Ped, 'weapon_pumpshotgun', true)
-- 				else
-- 					if tostring(CurrentWeapon) == '487013001' then
-- 						ShowNotification('~o~You need to unrack your shotgun from your cruiser via /sg before you can use it')
-- 						SetCurrentPedWeapon(Ped, 'weapon_unarmed', true)
-- 					end
-- 				end
				
-- 				if BeanbagEquipped and Config.BBOn then
-- 					SetCurrentPedWeapon(Ped, 'weapon_sawnoffshotgun', true)
-- 				else --S2021
-- 					if tostring(CurrentWeapon) == '2017895192' then
-- 						ShowNotification('~o~You need to unrack your beanbag from your cruiser via /bb shotgun before you can use it')
-- 						SetCurrentPedWeapon(Ped, 'weapon_unarmed', true)
-- 					end
-- 				end
-- 			end
-- 		end
--     end
-- end)

--[[-----------------------------------------------------

			/ar | /sg | /bb commands for Persistent Weapons

]]-------------------------------------------------------

-- RegisterCommand(Config.TakeAR, function(source, args, rawCommand)
--     if (GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 18) and not WeaponSlung then
--         CarbineEquipped = true
--         ShotgunEquipped = false
-- 		BeanbagEquipped = false
--     elseif (GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) ~= 18) then
--         ShowNotification('~r~You Must be in a Police Vehicle to rack/unrack your Carbine Rifle')
--         return
--     end
                
--     if CarbineEquipped and not caron and not WeaponSlung then
--         ShowNotification('~g~Carbine Rifle Equipped')
--         GiveWeapon('weapon_carbinerifle') --S2021
--         AddWeaponComponent('weapon_carbinerifle', 'component_at_ar_flsh')
--         AddWeaponComponent('weapon_carbinerifle', 'component_at_ar_afgrip')
-- 		AddWeaponComponent('weapon_carbinerifle', 'COMPONENT_AT_SCOPE_MEDIUM')
--         RemoveWeaponFromPed(PlayerPedId(), 'weapon_pumpshotgun')
--         RemoveWeaponFromPed(PlayerPedId(), 'weapon_sawnoffshotgun')
-- 		caron = true
-- 		sgon = false
-- 		bbon = false
-- 	elseif WeaponSlung then
-- 		ShowNotification('~r~Please unsling your rifle before racking it or changing your weapon.')
--     elseif CarbineEquipped and caron and not WeaponSlung then
--         ShowNotification('~y~Carbine Rifle Unequipped')
--         RemoveWeaponFromPed(PlayerPedId(), 'weapon_carbinerifle')
-- 		caron = false
-- 	end
-- end)

-- RegisterCommand(Config.TakeSG, function(source, args, rawCommand)
--     if (GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 18) and not WeaponSlung then
--         CarbineEquipped = false
--         ShotgunEquipped = true
-- 		BeanbagEquipped = false
--     elseif (GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) ~= 18) then
--         ShowNotification('~r~You Must be in a Police Vehicle to rack/unrack your Shotgun')
--         return
--     end
                
--     if ShotgunEquipped and not sgon and not WeaponSlung then
--         ShowNotification('~g~Shotgun Equipped')
--         GiveWeapon('weapon_pumpshotgun')
--         AddWeaponComponent('weapon_pumpshotgun', 'component_at_ar_flsh')
-- 		RemoveWeaponFromPed(PlayerPedId(), 'weapon_carbinerifle')
--         RemoveWeaponFromPed(PlayerPedId(), 'weapon_sawnoffshotgun')
-- 		sgon = true
-- 		caron = false
-- 		bbon = false
-- 	elseif WeaponSlung then
-- 		ShowNotification('~r~Please unsling your rifle before racking it or changing your weapon.')
--     elseif ShotgunEquipped and sgon and not WeaponSlung then
--         ShowNotification('~y~Shotgun Unequipped') --S2021
--         RemoveWeaponFromPed(PlayerPedId(), 'weapon_pumpshotgun')
-- 		sgon = false
-- 	end
-- end)

-- if Config.BBOn then -- Checks if BeanBag is enabled from config 

-- 	RegisterCommand(Config.TakeBB, function(source, args, rawCommand)
-- 		if (GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 18) and not WeaponSlung then
-- 			CarbineEquipped = false
-- 			ShotgunEquipped = false
-- 			BeanbagEquipped = true
-- 		elseif (GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) ~= 18) then
-- 			ShowNotification('~r~You Must be in a Police Vehicle to rack/unrack your beanbag Shotgun')
-- 			return
-- 		end
					
-- 		if BeanbagEquipped and not bbon and not WeaponSlung then
-- 			ShowNotification('~g~Beanbag Shotgun Equipped')
-- 			GiveWeapon('weapon_sawnoffshotgun')
-- 			RemoveWeaponFromPed(PlayerPedId(), 'weapon_carbinerifle')
-- 			RemoveWeaponFromPed(PlayerPedId(), 'weapon_pumpshotgun')
-- 			sgon = false
-- 			caron = false
-- 			bbon = true
-- 		elseif WeaponSlung then
-- 		ShowNotification('~r~Please unsling your rifle before racking it or changing your weapon.')
-- 		elseif BeanbagEquipped and bbon and not WeaponSlung then
-- 			ShowNotification('~y~Beanbag Shotgun Unequipped')
-- 			RemoveWeaponFromPed(PlayerPedId(), 'weapon_sawnoffshotgun')
-- 			bbon = false
-- 		end
-- 	end)
	
-- end

--[[-----------------------------------------------------

			Check for player death

]]-------------------------------------------------------

Citizen.CreateThread(function()

	while true do
		
		if IsPedDeadOrDying(PlayerPedId(), 1) then
			sling(true)		
		end
		Citizen.Wait(1000)
	end
end)


--[[-----------------------------------------------------

			MAIN SLING FUNCTION

]]-------------------------------------------------------

-- RegisterCommand("weptest", function(source, args)
--     ESX.TriggerServerCallback('CR_WeaponSling:sv:returnWeapons', function(returnWep)
-- 		if returnWep then
-- 			local wepData = json.decode(returnWep)
			
-- 			GiveWeaponToPed(PlayerPedId(), wepData.weapon, wepData.ammo, true, false)

-- 			for k, comp in ipairs(wepData.weaponComps) do
-- 				AddWeaponComponent(wepData.weapon, comp)
-- 			end
-- 			TriggerServerEvent('CR_WeaponSling:sv:RemoveWep')
-- 		end
-- 	end)
-- end, false)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(50)
	end
	PlayerData = ESX.GetPlayerData()
	
	Citizen.Wait(5000)

	ESX.TriggerServerCallback('CR_WeaponSling:sv:returnWeapons', function(returnWep)
		if returnWep then
			if (PlayerData.job.name == 'offpolice') or (PlayerData.job.name == 'police') then return end -- Dont give weapons back to police.. i hate this but whats the alternative? exclude police weapons from saving?

			local wepData = json.decode(returnWep)	
			GiveWeaponToPed(PlayerPedId(), wepData.weapon, wepData.ammo, true, false)

			for k, comp in ipairs(wepData.weaponComps) do
				AddWeaponComponent(wepData.weapon, comp)
			end

			TriggerServerEvent('CR_WeaponSling:sv:RemoveWep') -- Remove weapon from DB
		end
	end)
end)

RegisterCommand(Config.SlingMain, function(source, args, raw) -- Calls fucntion when /s in chat
sling()
end)

RegisterCommand(Config.SlingAbbr, function(source, args, raw) -- Calls fucntion when /sling in chat
sling()
end)

function sling(PlayerIsDead) --Main /sling function
	
	local player = PlayerPedId()

	if GetEntityModel(player) == maleHash or GetEntityModel(player) == femaleHash then
	
		--print ("ped check debug")
		
		for wephash, wepmodel in pairs(Config.weaponlist) do
		
			if GetSelectedPedWeapon(player) == wephash then
				WeaponInArray = true
				
				if not HasWeaponSlingOne then
					
					-- Save weapon in hand and its ammo
					WeaponToSlingOne = GetSelectedPedWeapon(player)
					AmmoInSlingOne = GetAmmoInPedWeapon(player, WeaponToSlingOne)
					
					
					-- Request weapon asset and wait for it
					RequestWeaponAsset(WeaponToSlingOne)					
					if not HasWeaponAssetLoaded(WeaponToSlingOne) then
					
						while not HasWeaponAssetLoaded(WeaponToSlingOne) do
						
							RequestWeaponAsset(WeaponToSlingOne)
							Citizen.Wait(0)
							print ("S2021 Waiting for asset loop")
						end
					end	
		
					-- Check once again if weapon is on list, then create weapon as object, register it on net 
					for wephash, wepmodel in pairs(Config.weaponlist) do
						
						if GetSelectedPedWeapon(player) == wephash then
							SlingWeaponOne = CreateObject(GetHashKey(wepmodel), 1.0, 1.0, 1.0, true, true, true)
		
							NetworkRegisterEntityAsNetworked(ObjToNet(SlingWeaponOne))
							netID = NetworkGetNetworkIdFromEntity(SlingWeaponOne)
							
							SetNetworkIdCanMigrate(netID, true)
							SetNetworkIdExistsOnAllMachines(netID, true)
							NetworkSetNetworkIdDynamic(netID, false)
							NetworkRequestControlOfEntity(SlingWeaponOne)	
						end
					end
		
					-- Check if weapon is front or back, then check what vest person has and attach appropriately in regard to Config file.
					
					if GetEntityModel(player) == maleHash then -- Check if ped is male, proceed if true
						--ShowNotification('~y~WepSling DEBUG: Male ped detected')
						for i, weaponback in ipairs(Config.weaponlistback) do
							if WeaponToSlingOne == weaponback then -- Attach on back
								--print("Weapononback")
								for vest, pos in pairs(Config.BackSlingVestsMale) do
								
									if GetPedDrawableVariation(player,9) == vest then
									
										AttachEntityToEntity(SlingWeaponOne, player, GetPedBoneIndex(player, 24816), pos.xpos, pos.ypos, pos.zpos, pos.xrot, pos.yrot, pos.zrot, 1, 1, 0, 0, 2, 1)
										
										break
									else
									
										AttachEntityToEntity(SlingWeaponOne, player, GetPedBoneIndex(player, 24816), Config.BackSlingElseMale.xpos, Config.BackSlingElseMale.ypos, Config.BackSlingElseMale.zpos, Config.BackSlingElseMale.xrot, Config.BackSlingElseMale.yrot, Config.BackSlingElseMale.zrot, 1, 1, 0, 0, 2, 1)
									
									end
								end
								break
							else
								
								for vest, pos in pairs(Config.FrontSlingVestsMale) do
									--print("Weapononfront")
									if GetPedDrawableVariation(player,9) == vest then
									
										AttachEntityToEntity(SlingWeaponOne, player, GetPedBoneIndex(player, 24816), pos.xpos, pos.ypos, pos.zpos, pos.xrot, pos.yrot, pos.zrot, 1, 1, 0, 0, 2, 1)
										
										break
									else
										AttachEntityToEntity(SlingWeaponOne, player, GetPedBoneIndex(player, 24816), Config.FrontSlingElseMale.xpos, Config.FrontSlingElseMale.ypos, Config.FrontSlingElseMale.zpos, Config.FrontSlingElseMale.xrot, Config.FrontSlingElseMale.yrot, Config.FrontSlingElseMale.zrot, 1, 1, 0, 0, 2, 1)							
									end
								end
							end
						end	
						
					elseif GetEntityModel(player) == femaleHash then -- Proceed if ped not male
						--ShowNotification('~y~WepSling DEBUG: Female ped detected')
						for i, weaponback in ipairs(Config.weaponlistback) do
							if WeaponToSlingOne == weaponback then -- Attach on back
								--print("Weapononback")
								for vest, pos in pairs(Config.BackSlingVestsFemale) do
								
									if GetPedDrawableVariation(player,9) == vest then
									
										AttachEntityToEntity(SlingWeaponOne, player, GetPedBoneIndex(player, 24816), pos.xpos, pos.ypos, pos.zpos, pos.xrot, pos.yrot, pos.zrot, 1, 1, 0, 0, 2, 1)
										
										break
									else
									
										AttachEntityToEntity(SlingWeaponOne, player, GetPedBoneIndex(player, 24816), Config.BackSlingElseFemale.xpos, Config.BackSlingElseFemale.ypos, Config.BackSlingElseFemale.zpos, Config.BackSlingElseFemale.xrot, Config.BackSlingElseFemale.yrot, Config.BackSlingElseFemale.zrot, 1, 1, 0, 0, 2, 1)
									
									end
								end
								break
							else
								
								for vest, pos in pairs(Config.FrontSlingVestsFemale) do
									--print("Weapononfront")
									if GetPedDrawableVariation(player,9) == vest then
									
										AttachEntityToEntity(SlingWeaponOne, player, GetPedBoneIndex(player, 24816), pos.xpos, pos.ypos, pos.zpos, pos.xrot, pos.yrot, pos.zrot, 1, 1, 0, 0, 2, 1)
										
										break
									else
										AttachEntityToEntity(SlingWeaponOne, player, GetPedBoneIndex(player, 24816), Config.FrontSlingElseFemale.xpos, Config.FrontSlingElseFemale.ypos, Config.FrontSlingElseFemale.zpos, Config.FrontSlingElseFemale.xrot, Config.FrontSlingElseFemale.yrot, Config.FrontSlingElseFemale.zrot, 1, 1, 0, 0, 2, 1)							
									end
								end
							end
						end				
					end
					
					-- Register weapon object as networked
					NetworkRegisterEntityAsNetworked(ObjToNet(SlingWeaponOne))
					NetworkRequestControlOfEntity(SlingWeaponOne)	
					netId = NetworkGetNetworkIdFromEntity(SlingWeaponOne)
					SetNetworkIdCanMigrate(netId, true)
					SetNetworkIdExistsOnAllMachines(netId, true)
					NetworkSetNetworkIdDynamic(netId, false)
					NetworkRequestControlOfEntity(SlingWeaponOne)
					
					dummyval = 1 -- Do not dare fucking touch

					-- Create a magazine object, attach it to weapon and register it
					for component, model in pairs(Config.componentlistclips) do
						
						if HasPedGotWeaponComponent(player, WeaponToSlingOne, component) then
					
							local handle = CreateObject(GetHashKey(model), 1.0, 1.0, 1.0, true, true, false)
					
							AttachEntityToEntity(handle, SlingWeaponOne, GetEntityBoneIndexByName(SlingWeaponOne,"WAPClip"), 10, 0, 0, 0, 0, 0, 1, 1, 0, 0, 2, 1)
							
							-- Register created component object in network
							NetworkRegisterEntityAsNetworked(ObjToNet(handle))
							local netIDc = NetworkGetNetworkIdFromEntity(handle)
							
							SetNetworkIdCanMigrate(netIDc, true) --S2021
							SetNetworkIdExistsOnAllMachines(netIDc, true)
							NetworkSetNetworkIdDynamic(netIDc, false)
							
							NetworkRequestControlOfEntity(handle)
							
							-- Save component, model and Object ID for later use
							table.insert(savedcomps, dummyval, component)
							table.insert(savedmodels, dummyval, model)
							table.insert(savedobjects, dummyval, handle)
							
							-- Increase dummyval XD
							dummyval = dummyval+1
							
						end
					end	
					
					-- Create a scope object, attach it to weapon and register it
					for component, model in pairs(Config.componentlistscopes) do
						
						if HasPedGotWeaponComponent(player, WeaponToSlingOne, component) then
					
							local handle = CreateObject(GetHashKey(model), 1.0, 1.0, 1.0, true, true, false)
					
							AttachEntityToEntity(handle, SlingWeaponOne, GetEntityBoneIndexByName(SlingWeaponOne,"WAPScop"), 10, 0, 0, 0, 0, 0, 1, 1, 0, 0, 2, 1)
							
							-- Register created component object in network
							NetworkRegisterEntityAsNetworked(ObjToNet(handle))
							local netIDc = NetworkGetNetworkIdFromEntity(handle)
							
							SetNetworkIdCanMigrate(netIDc, true) --S2021
							SetNetworkIdExistsOnAllMachines(netIDc, true)
							NetworkSetNetworkIdDynamic(netIDc, false)
							
							NetworkRequestControlOfEntity(handle)
							
							-- Save component, model and Object ID for later use
							table.insert(savedcomps, dummyval, component)
							table.insert(savedmodels, dummyval, model)
							table.insert(savedobjects, dummyval, handle)
							
							-- Increase dummyval XD
							dummyval = dummyval+1
							
						end
					end	
					
					-- Create a grip object, attach it to weapon and register it
					for component, model in pairs(Config.componentlistgrip) do
						
						if HasPedGotWeaponComponent(player, WeaponToSlingOne, component) then
					
							local handle = CreateObject(GetHashKey(model), 1.0, 1.0, 1.0, true, true, false)
					
							AttachEntityToEntity(handle, SlingWeaponOne, GetEntityBoneIndexByName(SlingWeaponOne,"WAPGrip"), 10, 0, 0, 0, 0, 0, 1, 1, 0, 0, 2, 1)
							
							-- Register created component object in network
							NetworkRegisterEntityAsNetworked(ObjToNet(handle))
							local netIDc = NetworkGetNetworkIdFromEntity(handle)
							
							SetNetworkIdCanMigrate(netIDc, true) --S2021
							SetNetworkIdExistsOnAllMachines(netIDc, true)
							NetworkSetNetworkIdDynamic(netIDc, false)
							
							NetworkRequestControlOfEntity(handle)
							
							-- Save component, model and Object ID for later use
							table.insert(savedcomps, dummyval, component)
							table.insert(savedmodels, dummyval, model)
							table.insert(savedobjects, dummyval, handle)
							
							-- Increase dummyval XD
							dummyval = dummyval+1
							
						end
					end					
					
					-- Create a barrel object, attach it to weapon and register it (yes, it's that fucked up that barrel doesnt have its own bone and we'd need to hand correct most of guns)
					for component, model in pairs(Config.componentlistbarrels) do
						
						if HasPedGotWeaponComponent(player, WeaponToSlingOne, component) then

							local handle = CreateObject(GetHashKey(model), 1.0, 1.0, 1.0, true, true, false)
							
							if WeaponToSlingOne == -86904375 then -- Offset for Carbine Mk2		
								AttachEntityToEntity(handle, SlingWeaponOne, GetEntityBoneIndexByName(SlingWeaponOne,"WAPSupp"), -0.1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 2, 1)
							elseif WeaponToSlingOne == -1768145561 then -- Offset for Special Carbine Mk2
								AttachEntityToEntity(handle, SlingWeaponOne, GetEntityBoneIndexByName(SlingWeaponOne,"WAPSupp"), -0.10, 0, 0, 0, 0, 0, 1, 1, 0, 0, 2, 1)							
							else --Default attachment 							
								AttachEntityToEntity(handle, SlingWeaponOne, GetEntityBoneIndexByName(SlingWeaponOne,"WAPSupp"), -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 0, 1)			
							end
							-- Register created component object in network
							NetworkRegisterEntityAsNetworked(ObjToNet(handle))
							local netIDc = NetworkGetNetworkIdFromEntity(handle)
							
							SetNetworkIdCanMigrate(netIDc, true) --S2021
							SetNetworkIdExistsOnAllMachines(netIDc, true)
							NetworkSetNetworkIdDynamic(netIDc, false)
							
							NetworkRequestControlOfEntity(handle)
							
							-- Save component, model and Object ID for later use
							table.insert(savedcomps, dummyval, component)
							table.insert(savedmodels, dummyval, model)
							table.insert(savedobjects, dummyval, handle)
							
							-- Increase dummyval XD
							dummyval = dummyval+1
							
						end
					end					
					-- Create a suppressor/muzzle object, attach it to weapon and register it
					for component, model in pairs(Config.componentlistsupps) do
						
						if HasPedGotWeaponComponent(player, WeaponToSlingOne, component) then
					
							local handle = CreateObject(GetHashKey(model), 1.0, 1.0, 1.0, true, true, false)
							
							if WeaponToSlingOne == 2024373456 then -- Offset for Assault SMG	
								AttachEntityToEntity(handle, SlingWeaponOne, GetEntityBoneIndexByName(SlingWeaponOne,"WAPSupp"), -0.09, 0, 0, 0, 0, 0, 1, 1, 0, 0, 2, 1)
							
							elseif WeaponToSlingOne == -86904375 then -- Offset for Carbine Mk2
								AttachEntityToEntity(handle, SlingWeaponOne, GetEntityBoneIndexByName(SlingWeaponOne,"WAPSupp"), 0.134, 0, 0, 0, 0, 0, 1, 1, 0, 0, 2, 1)
								
							elseif WeaponToSlingOne == -1768145561 then -- Offset for Special Carbine Mk2
								AttachEntityToEntity(handle, SlingWeaponOne, GetEntityBoneIndexByName(SlingWeaponOne,"WAPSupp"), 0.04, 0, 0, 0, 0, 0, 1, 1, 0, 0, 2, 1)
								
							else --Default attachment on 0,0
								AttachEntityToEntity(handle, SlingWeaponOne, GetEntityBoneIndexByName(SlingWeaponOne,"WAPSupp"), 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 2, 1)						
							end
							-- Register created component object in network
							NetworkRegisterEntityAsNetworked(ObjToNet(handle))
							local netIDc = NetworkGetNetworkIdFromEntity(handle)
							
							SetNetworkIdCanMigrate(netIDc, true) --S2021
							SetNetworkIdExistsOnAllMachines(netIDc, true)
							NetworkSetNetworkIdDynamic(netIDc, false)
							
							NetworkRequestControlOfEntity(handle)
							
							-- Save component, model and Object ID for later use
							table.insert(savedcomps, dummyval, component)
							table.insert(savedmodels, dummyval, model)
							table.insert(savedobjects, dummyval, handle)
							
							-- Increase dummyval XD
							dummyval = dummyval+1
							
						end
					end					
					
					-- Create a flashlight object, attach it to weapon and register it
					for component, model in pairs(Config.componentlistflash) do
						
						if HasPedGotWeaponComponent(player, WeaponToSlingOne, component) then
					
							local handle = CreateObject(GetHashKey(model), 1.0, 1.0, 1.0, true, true, false)
					
							AttachEntityToEntity(handle, SlingWeaponOne, GetEntityBoneIndexByName(SlingWeaponOne,"WAPFlshLasr"), 10, 0, 0, 0, 0, 0, 1, 1, 0, 0, 2, 1)
							
							-- Register created component object in network
							NetworkRegisterEntityAsNetworked(ObjToNet(handle))
							local netIDc = NetworkGetNetworkIdFromEntity(handle)
							
							SetNetworkIdCanMigrate(netIDc, true) --S2021
							SetNetworkIdExistsOnAllMachines(netIDc, true)
							NetworkSetNetworkIdDynamic(netIDc, false)
							
							NetworkRequestControlOfEntity(handle)
							
							-- Save component, model and Object ID for later use
							table.insert(savedcomps, dummyval, component)
							table.insert(savedmodels, dummyval, model)
							table.insert(savedobjects, dummyval, handle)
							
							-- Increase dummyval XD
							dummyval = dummyval+1
							
						end
					end
					
					dummyval = 1
					
					-- Remove actual weapon from player and set him to unarmed
					RemoveWeaponFromPed(player, WeaponToSlingOne)
					TriggerServerEvent('CR_WeaponSling:sv:AddWep', WeaponToSlingOne, AmmoInSlingOne, savedcomps)
					HasWeaponSlingOne = true
					SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
					ShowNotification("You slung your weapon.")
					WeaponSlung = true
					break
				end
				
			elseif HasWeaponSlingOne and GetSelectedPedWeapon(player) == `WEAPON_UNARMED` then -- Unsling part
				ShowNotification("You unslung your weapon.")
				HasWeaponSlingOne = false
				WeaponInArray = true
				
				for i, model in ipairs(savedmodels) do -- Set component model as NLN
					
					SetModelAsNoLongerNeeded(model)
				
				end
				
				for i, object in ipairs(savedobjects) do -- Unregister component object
					
					NetworkUnregisterNetworkedEntity(object)
					DeleteObject(object)
					
				end
				
				if DoesEntityExist(SlingWeaponOne) then -- Remove and unregister main weapon object

					DeleteObject(SlingWeaponOne)
					RemoveWeaponAsset(SlingWeaponOne)
					SetModelAsNoLongerNeeded(SlingWeaponOne)
					NetworkUnregisterNetworkedEntity(SlingWeaponOne)
					
				end
				
				GiveWeaponToPed(player, WeaponToSlingOne, AmmoInSlingOne, false) -- Give weapon back to player
				TriggerServerEvent('CR_WeaponSling:sv:RemoveWep')
				SetCurrentPedWeapon(player, WeaponToSlingOne, true)	--Select this weapon
				SetPedAmmo(player, WeaponToSlingOne, AmmoInSlingOne) -- Give ammo back to player
				
				for i, comp in ipairs(savedcomps) do -- Give attachments back to player

					GiveWeaponComponentToPed(player, WeaponToSlingOne, comp)
				end
				
				-- Reset all the tables for later use
				savedcomps = {}
				savedobjects = {}
				savedmodels = {}
				WeaponSlung = false
				break
				
			elseif HasWeaponSlingOne and GetSelectedPedWeapon(player) ~= `WEAPON_UNARMED` then
				ShowNotification("Please unsling your weapon with empty hands.")
				WeaponInArray = true
				break	
				
			elseif HasWeaponSlingOne and PlayerIsDead then
				-- ShowNotification("Player died, removing slung weapon.(Debug message)")  --                             REMOVE IT WHEN GOING LIVE
				
				-- Shortened copy of unsling but without give back part
				TriggerServerEvent('CR_WeaponSling:sv:RemoveWep') -- Remove weapon from DB
				HasWeaponSlingOne = false
				WeaponInArray = true
				
				for i, model in ipairs(savedmodels) do -- Set component model as NLN
					
					SetModelAsNoLongerNeeded(model)
				
				end
				
				for i, object in ipairs(savedobjects) do -- Unregister component object
					
					NetworkUnregisterNetworkedEntity(object)
					DeleteObject(object)
					
				end
				
				if DoesEntityExist(SlingWeaponOne) then -- Remove and unregister main weapon object

					DeleteObject(SlingWeaponOne)
					RemoveWeaponAsset(SlingWeaponOne)
					SetModelAsNoLongerNeeded(SlingWeaponOne)
					NetworkUnregisterNetworkedEntity(SlingWeaponOne)
					
				end
				
				-- Reset all the tables for later use
				savedcomps = {}
				savedobjects = {}
				savedmodels = {}
				WeaponSlung = false
			end
		end
		if not WeaponInArray and PlayerIsDead then 
			-- ShowNotification("Please equip correct weapon first.")
		end
		WeaponInArray = false	
	
	else
		ShowNotification('~y~Weapon Sling works only for MP Peds! Create MP Ped to use it!')
	end
end		

--[[-----------------------------------------------------

			Misc Functions

]]-------------------------------------------------------

function GiveWeapon(Hash)
    GiveWeaponToPed(PlayerPedId(), GetHashKey(Hash), 999, false)
end

function AddWeaponComponent(Weapon, Component)
    if HasPedGotWeapon(PlayerPedId(), Weapon, false) then
        GiveWeaponComponentToPed(PlayerPedId(), Weapon, GetHashKey(Component))
    end
end

function ShowNotification( text )
	SetNotificationTextEntry( "STRING" )
	AddTextComponentString( text )
	DrawNotification( false, false )
end

function msg(text)
	TriggerEvent("chatMessage", "5PD Weapon Sling", {255, 4, 1}, text)
end  


function IsWeaponSlung()
	return WeaponSlung
end


function SlungWeapon()
	return WeaponToSlingOne
end