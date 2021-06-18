ESX                  = nil
local PlayerLoaded   = false
local AlertTime      = 0
local zoneNames      = {AIRP = "Los Santos International Airport",ALAMO = "Alamo Sea",ALTA = "Alta",ARMYB = "Fort Zancudo",BANHAMC = "Banham Canyon Dr",BANNING = "Banning",BAYTRE = "Baytree Canyon", BEACH = "Vespucci Beach",BHAMCA = "Banham Canyon",BRADP = "Braddock Pass",BRADT = "Braddock Tunnel",BURTON = "Burton",CALAFB = "Calafia Bridge",CANNY = "Raton Canyon",CCREAK = "Cassidy Creek",CHAMH = "Chamberlain Hills",CHIL = "Vinewood Hills",CHU = "Chumash",CMSW = "Chiliad Mountain State Wilderness",CYPRE = "Cypress Flats",DAVIS = "Davis",DELBE = "Del Perro Beach",DELPE = "Del Perro",DELSOL = "La Puerta",DESRT = "Grand Senora Desert",DOWNT = "Downtown",DTVINE = "Downtown Vinewood",EAST_V = "East Vinewood",EBURO = "El Burro Heights",ELGORL = "El Gordo Lighthouse",ELYSIAN = "Elysian Island",GALFISH = "Galilee",GALLI = "Galileo Park",golf = "GWC and Golfing Society",GRAPES = "Grapeseed",GREATC = "Great Chaparral",HARMO = "Harmony",HAWICK = "Hawick",HORS = "Vinewood Racetrack",HUMLAB = "Humane Labs and Research",JAIL = "Bolingbroke Penitentiary",KOREAT = "Little Seoul",LACT = "Land Act Reservoir",LAGO = "Lago Zancudo",LDAM = "Land Act Dam",LEGSQU = "Legion Square",LMESA = "La Mesa",LOSPUER = "La Puerta",MIRR = "Mirror Park",MORN = "Morningwood",MOVIE = "Richards Majestic",MTCHIL = "Mount Chiliad",MTGORDO = "Mount Gordo",MTJOSE = "Mount Josiah",MURRI = "Murrieta Heights",NCHU = "North Chumash",NOOSE = "N.O.O.S.E",OCEANA = "Pacific Ocean",PALCOV = "Paleto Cove",PALETO = "Paleto Bay",PALFOR = "Paleto Forest",PALHIGH = "Palomino Highlands",PALMPOW = "Palmer-Taylor Power Station",PBLUFF = "Pacific Bluffs",PBOX = "Pillbox Hill",PROCOB = "Procopio Beach",RANCHO = "Rancho",RGLEN = "Richman Glen",RICHM = "Richman",ROCKF = "Rockford Hills",RTRAK = "Redwood Lights Track",SanAnd = "San Andreas",SANCHIA = "San Chianski Mountain Range",SANDY = "Sandy Shores",SKID = "Mission Row",SLAB = "Stab City",STAD = "Maze Bank Arena",STRAW = "Strawberry",TATAMO = "Tataviam Mountains",TERMINA = "Terminal",TEXTI = "Textile City",TONGVAH = "Tongva Hills",TONGVAV = "Tongva Valley",VCANA = "Vespucci Canals",VESP = "Vespucci",VINE = "Vinewood",WINDF = "Ron Alternates Wind Farm",WVINE = "West Vinewood",ZANCUDO = "Zancudo River",ZP_ORT = "Port of South Los Santos",ZQ_UAR = "Davis Quartz"}

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
end)

AddEventHandler('playerSpawned', function()
   AlertTime = 0
   TriggerServerEvent('CR_Alerts:spawned')
end)

RegisterNetEvent('wf_alerts:SendAlert')
AddEventHandler('wf_alerts:SendAlert', function(type, data, length)
  
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
	 if not IsEntityDead(PlayerPedId()) then	 
       SendNUIMessage({action = 'display', style = type, info = data, length = length})
       PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
    end
  end
end)

RegisterNetEvent('wf_alerts:SendAlertTracker')
AddEventHandler('wf_alerts:SendAlertTracker', function(type, data, length)  
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
	 if not IsEntityDead(PlayerPedId()) then	 
       SendNUIMessage({action = 'display', style = type, info = data, length = length})
       PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
    end
  end
end)

RegisterNetEvent('esx_policejob:trackerTaken')
AddEventHandler('esx_policejob:trackerTaken', function()
	local Street = playerStreetsLocation	
 	TriggerServerEvent('wf_alerts:server:TrackerTaken', Street)
end)

function GetTheStreet()

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
	
    currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
    zone = tostring(GetNameOfZone(x, y, z))
    playerStreetsLocation = zoneNames[tostring(zone)]

    if not zone then
        zone = "UNKNOWN"
        zoneNames['UNKNOWN'] = zone
    elseif not zoneNames[tostring(zone)] then
        local undefinedZone = zone .. " " .. x .. " " .. y .. " " .. z
        zoneNames[tostring(zone)] = "Undefined Zone"
    end

    if intersectStreetName ~= nil and intersectStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | " .. zoneNames[tostring(zone)]
    elseif currentStreetName ~= nil and currentStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | " .. zoneNames[tostring(zone)]
    else
        playerStreetsLocation = zoneNames[tostring(zone)]
   end
end

Citizen.CreateThread(function()
    while true do
       Citizen.Wait(1000)
       GetTheStreet()
   end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
		
		if IsEntityDead(PlayerPedId()) and AlertTime == 0 then
		   Citizen.Wait(500)
		   local DeathReason, Killer, DeathCauseHash, Weapon
		   local code = 'Code 9'
           local name = 'Officer Down = ' 
		   local Street = playerStreetsLocation	
		   local PedKiller = GetPedSourceOfDeath(PlayerPedId())
		   DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())
		   Weapon = WeaponNames[tostring(DeathCauseHash)]
		   
		   if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
			  Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
			  Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
		   end
			
			if (Killer == PlayerId()) then
				DeathReason = 'Cause Of Death - [committed suicide]'
			elseif (Killer == nil) then
				DeathReason = 'Cause Of Death - [Unknown]'
			else	
			
				if IsMelee(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Murdered]'
				elseif IsTorch(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Torched]'
				elseif IsKnife(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [knifed]'
				elseif IsPistol(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Pistoled]'
				elseif IsSub(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Riddled]'
				elseif IsRifle(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Rifled]'
				elseif IsLight(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Machine Gunned]'
				elseif IsShotgun(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Shotgunned]'
				elseif IsSniper(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Sniped]'
				elseif IsHeavy(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Obliterated]'
				elseif IsMinigun(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Shredded]'
				elseif IsBomb(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Bombed]'
				elseif IsVeh(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Mowed Over]'
				elseif IsVK(DeathCauseHash) then
					DeathReason = 'Cause Of Death - [Ran-Over]'
				else
					DeathReason = 'Cause Of Death - [killed]'
				 end
			 end
					
		 TriggerServerEvent('wf_alerts:server:DeathNotification', 'officer-down', code, name, DeathReason, Street)
		 Killer = nil
		 DeathReason = nil
		 DeathCauseHash = nil
		 Weapon = nil
		 AlertTime = 1
	  end
	else
	  Citizen.Wait(500)
    end		
  end
end)

function IsMelee(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsTorch(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsKnife(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsPistol(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_PISTOL50', 'WEAPON_COMBATPISTOL'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSub(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsRifle(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsLight(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsShotgun(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSniper(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsHeavy(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsMinigun(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsBomb(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVeh(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVK(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end