-----Created By GigaBytes For AustralisGamingNetwork-----

ESX = nil
local PlayerLoaded = false
local group

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()

    while group == nil do       
        Citizen.Wait(250) 
        ESX.TriggerServerCallback('CR_Misc:GetGroup', function(g)
            group = g
        end)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	group = g
end)

--Blip Detection--
Citizen.CreateThread(function()
	
	while ESX == nil do
	   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	   Citizen.Wait(250)
	end
	
	while not ESX.IsPlayerLoaded() do 
	   Citizen.Wait(250) 
	end
	
	while true do
		Citizen.Wait(10000)
		
		ESX.TriggerServerCallback('CheckPlayerJobAndGroup', function(cb)
            if cb then  
                
                if not exports["gcphone"]:hasBlips() then
				
                    local players = GetActivePlayers()
                    
                    for i = 1, #players, 1 do
                        ped = GetPlayerPed(players[i])
                        blip = GetBlipFromEntity(ped)
                        
                        if DoesBlipExist(blip) then
                        TriggerServerEvent('CR_Detection:Ban', GetPlayerServerId(PlayerId()),'Was Just Caught With Blips On Players!')
                        end
                    end
                
                end
			end
		end)
	end
end)

--Infinity Ammo Detection--
Citizen.CreateThread(function()
  local oldAmmo = 0
  local newAmmo = 0

  while true do 
    Citizen.Wait(0)
		
    if IsPedShooting(GetPlayerPed(-1)) then
	
       local _, weapon = GetCurrentPedWeapon(GetPlayerPed(-1), 1)
	   local weapHash = GetSelectedPedWeapon(PlayerPedId())
	   local labelName = GET_WEAPON_LABEL(weapHash)
       newAmmo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon, 1)
		
	    if weapon ~= 911657153 and weapon ~= 101631238 and weapon ~= 883325847 and weapon ~= -1569615261 then --WEAPON_STUNGUN/WEAPON_FIREEXTINGUISHER/WEAPON_PETROLCAN
		
        if newAmmo == oldAmmo then
           TriggerServerEvent('CR_Detection:InfinityAmmo', labelName)
       else
           oldAmmo = newAmmo
	    end
      end
    else
	   Citizen.Wait(500)
    end
  end
end)
--Infinity Ammo Detection--

--Teleport Detection--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if group == "user" and group ~= nil then	
            
            if (IsPedSittingInAnyVehicle(PlayerPedId())) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) 
                
                if (GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()) then 
                    
                    local firstCoord = GetEntityCoords(PlayerPedId())
                    Citizen.Wait(2000) 		
                    local secondCoord = GetEntityCoords(PlayerPedId())
                    
                    local Dist = GetDistanceBetweenCoords(firstCoord, secondCoord, false)
                    
                    if Dist > 500.0 then
                        TriggerServerEvent('CR_Detection:BanPlayer', Dist)		   
                    end	
                end
            else
                Citizen.Wait(500)
            end
        end
    end
end)

--Lua Detection--
local AGN = {
  'esx_policejob:handcuff',
  'esx_policejob:drag',
  'esx_policejob:putInVehicle',
  'esx_policejob:OutVehicle',  
  'esx_drugs:startHarvestCoke',
  'esx_drugs:startTransformCoke',
  'esx_drugs:startSellCoke',
  'esx_drugs:startHarvestMeth',
  'esx_drugs:startTransformMeth',
  'esx_drugs:startSellMeth',
  'esx_drugs:startHarvestWeed',
  'esx_drugs:startTransformWeed',
  'esx_drugs:startSellWeed',
  'esx_drugs:startHarvestOpium',
  'esx_drugs:startTransformOpium',
  'esx_drugs:startSellOpium', 
  'esx_drugs:freezePlayer',  
  'esx_drugs:hasExitedMarker', 
  'esx_drugs:hasEnteredMarker',  
  'esx_truckerjob:pay',
  'esx_weashop:buyItem',  
  'esx_weashop:clipcli',
  'esx_society:openBossMenu',
  'esx:spawnVehicle',  
  'esx_ambulancejob:revive',  
  'esx_firejob:revive', 
  'esx_skin:openSaveableMenu',  
  'esx_thief:stealPlayerItem', 
  'es_admin:teleportUser',
  'es_admin:all', 
  'esx_jobs:caution', 
  'esx_status:set', 
  'esx_jailer:sendToJail', 
  'esx_weashop:buyLicense', 
  'esx_joblisting:setJob', 
  'esx_vehicleshop:setVehicleOwned',
  'esx_vehicleshop:setVehicleOwnedPlayerId',
  'esx_vehicleshop:setVehicleOwnedSociety',
  'esx_vehicleshop:sellVehicle',
  'esx_vehicleshop:rentVehicle',
  'esx_vehicleshop:setVehicleForAllPlayers',
  'esx_vehicleshop:setVehicle',
  'esx_vehicleshop:putStockItems',
  'esx_vehicleshop:buyVehicle',
  'esx_vehicleshop:buyVehicleSociety',
  'esx_vehicleshop:getPersonnalVehicles',
  'esx_vehicleshop:getCommercialVehicles',
  'esx_vehicleshop:getRentedVehicles',
  'esx_vehicleshop:giveBackVehicle',
  'esx_vehicleshop:resellVehicle',
  'esx_vehicleshop:getStockItems',
  'esx_vehicleshop:getPlayerInventory',
  'esx_vehicleshop:openPersonnalVehicleMenu',
  'esx_vehicleshop:esx:lowmoney',
  'esx_vehicleshop:esx:lowmoney2', 
  "esx_policejob:giveWeapon", 
  "esx-qalle-jail:jailPlayer", 
  "esx_slotmachine:sv:2", 
  "esx_ambulancejob:revive",
  "esx:giveInventoryItem",
  "DiscordBot:playerDied",
  "esx_billing:sendBill",
  "esx_society:setJobSalary", 
  'bank:deposit',
  'bank:withdraw',
  'bank:transfer', 
  'esx_dmvschool:addLicense',  
}

for i=1, #AGN, 1 do
  AddEventHandler(AGN[i], function()
    TriggerServerEvent('7cc52639-ae86-421c-831e-a8d5a5aea06c', AGN[i])	
  end)
end

--Spawned And Attached Object Protection--
CageObjs = {
    "prop_gold_cont_01",
    "p_cablecar_s",
    "stt_prop_stunt_tube_l",
    "stt_prop_stunt_track_dwuturn",
    "p_crahsed_heli_s",
    "prop_rock_4_big2",
    "prop_beachflag_le",
    "prop_fnclink_05crnr1",
    "xs_prop_hamburgher_wl",
    "sr_prop_spec_tube_xxs_01a",
    "prop_fnclink_05crnr1",
    "p_spinning_anus_s",
    "xs_prop_chips_tube_wl",
    "xs_prop_plastic_bottle_wl",
    "prop_windmill_01",
    "stt_prop_stunt_soccer_ball",
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
		
        local ped = PlayerPedId()
        local handle, object = FindFirstObject()
        local finished = false
		
        repeat
            Wait(1000)
			
            if IsEntityAttached(object) and DoesEntityExist(object) then
                if GetEntityModel(object) == GetHashKey("prop_acc_guitar_01") then
                    ReqAndDelete(object, true)
                end
            end
			
            for i=1,#CageObjs do
                if GetEntityModel(object) == GetHashKey(CageObjs[i]) then
                    ReqAndDelete(object, false)
                end
            end
			
        finished, object = FindNextObject(handle)
        until not finished
        EndFindObject(handle)
    end
end)

function ReqAndDelete(object, detach)

    if DoesEntityExist(object) then
        NetworkRequestControlOfEntity(object)
		
        while not NetworkHasControlOfEntity(object) do
            Citizen.Wait(1)
        end
		
        if detach then
            DetachEntity(object, 0, false)
        end
		
       SetEntityCollision(object, false, false)
       SetEntityAlpha(object, 0.0, true)
       SetEntityAsMissionEntity(object, true, true)
       SetEntityAsNoLongerNeeded(object)
       DeleteEntity(object)
    end
end

--Spawned And Attached Object Protection--
RegisterNetEvent('CR_Detection:PlaySound')
AddEventHandler('CR_Detection:PlaySound', function(g)
   PlaySoundFrontend(-1, "DELETE","HUD_DEATHMATCH_SOUNDSET", 1)
end)

local WEAPON_HASH_TO_LABEL = {
    [tostring(GetHashKey('WEAPON_UNARMED'))] = 'Unarmed',
	[tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
	[tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
	[tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer',
	[tostring(GetHashKey('WEAPON_BAT'))] = 'Baseball Bat',
	[tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Golf Club',
    [tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Crowbar',
	[tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistol',
	[tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Combat Pistol',
	[tostring(GetHashKey('WEAPON_APPISTOL'))] = 'AP Pistol',
	[tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol .50',
	[tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
	[tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
	[tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Assault Rifle',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carbine Rifle',
	[tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Advanced Rifle',
	[tostring(GetHashKey('WEAPON_MG'))] = 'MG',
	[tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG',
	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun',
	[tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed-Off Shotgun',
	[tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun',
	[tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
	[tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Stun Gun',
	[tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Heavy Sniper',
	[tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Smoke Grenade Launcher',
	[tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
	[tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
	[tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
	[tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
	[tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
	[tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
	[tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
	[tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Tear Gas',
	[tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
	[tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
	[tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Fire Extinguisher',
	[tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',
	[tostring(GetHashKey('OBJECT'))] = 'Object',
	[tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
	[tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare',
	[tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
	[tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
	[tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
	[tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Car',
	[tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle',
	[tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
	[tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
	[tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol',
	[tostring(GetHashKey('WEAPON_DAGGER'))] = 'Antique Cavalry Dagger',
	[tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
	[tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Heavy Pistol',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Special Carbine',
	[tostring(GetHashKey('WEAPON_MUSKET'))] = 'Musket',
	[tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework Launcher',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun',
	[tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
	[tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
	[tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
	[tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW',
	[tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
	[tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
	[tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
	[tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
	[tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
	[tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun',
	[tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Compact Rifle',
	[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
	[tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Heavy Revolver',
	[tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire',
	[tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
	[tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Run over by Car',
	[tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
	[tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
	[tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
	[tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
	[tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
	[tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
	[tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
	[tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
	[tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle',
	[tostring(GetHashKey('WEAPON_ASSAULTSNIPER'))] = 'Assault Sniper',
	[tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
	[tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
	[tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
	[tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Automatic Shotgun',
	[tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battle Axe',
	[tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
	[tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
	[tostring(GetHashKey('WEAPON_PIPEBOMB'))] = 'Pipebomb',
	[tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
	[tostring(GetHashKey('WEAPON_WRENCH'))] = 'Wrench',
	[tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
	[tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
	[tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar',
}
function GET_WEAPON_LABEL(hash)

    if(type(hash) ~= "string") then
        hash = tostring(hash)
    end

    local label = WEAPON_HASH_TO_LABEL[hash]
    if label ~= nil then
        return label
    end
    Citizen.Trace("Error reversing weapon hash \"" .. hash .. "\". Maybe it's not been added yet?")
    return "WT_INVALID" 
end