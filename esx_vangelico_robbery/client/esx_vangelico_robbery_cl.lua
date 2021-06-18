ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local holdingup = false
local store = ""
local blipRobbery = nil
local brokenWindows = 0
 
function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
  end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function loadAnimDict(dict)  
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end 

RegisterNetEvent('esx_vangelico_robbery:currentlyrobbing')
AddEventHandler('esx_vangelico_robbery:currentlyrobbing', function(robb)
	holdingup = true
	store = robb
end)

RegisterNetEvent('esx_vangelico_robbery:killblip')
AddEventHandler('esx_vangelico_robbery:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_vangelico_robbery:setblip')
AddEventHandler('esx_vangelico_robbery:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'robbery', 0.2)
end)

RegisterNetEvent('esx_vangelico_robbery:toofarlocal')
AddEventHandler('esx_vangelico_robbery:toofarlocal', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	inCircle = false
end)


RegisterNetEvent('esx_vangelico_robbery:robberycomplete')
AddEventHandler('esx_vangelico_robbery:robberycomplete', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_complete'))
	store = ""
	inCircle = false
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.Stores)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 439)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('shop_robbery'))
		EndTextCommandSetBlipName(blip)
	end
end)

animation = false
inCircle = false
soundID = GetSoundId()

local borsa = nil

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
	  TriggerEvent('skinchanger:getSkin', function(skin)
		borsa = skin['bags_1']
	  end)
	  Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
      
	while true do
		local ped = PlayerPedId()
		local pedLoc = GetEntityCoords(ped)

		for k, v in pairs (Config.Stores) do
			local storeLoc = v.position

			if(GetDistanceBetweenCoords(pedLoc, storeLoc.x, storeLoc.y, storeLoc.z, true) < 15.0) then
				if not holdingup then
			
					if(GetDistanceBetweenCoords(pedLoc, storeLoc.x, storeLoc.y, storeLoc.z, true) < 1.0)then
						if (inCircle == false) then
							DisplayHelpText(_U('press_to_rob'))
						end
						inCircle = true
						if IsPedShooting(PlayerPedId()) then
							if Config.NeedBag then
							    if borsa == 40 or borsa == 41 or borsa == 44 or borsa == 45 or borsa == 22 or borsa == 23 then
								
							        ESX.TriggerServerCallback('esx_vangelico_robbery:anycops', function(anycops)
								        if anycops >= Config.CopsRequired then  
											ESX.TriggerServerCallback('CR_Misc:CanRobGCD', function(callback)
												if callback then
													TriggerServerEvent('esx_vangelico_robbery:rob', k)
													PlaySoundFromCoord(soundID, "VEHICLES_HORNS_AMBULANCE_WARNING", storeLoc.x, storeLoc.y, storeLoc.z)                            
												end
											end, 'Vangelico')
								        else
									        TriggerEvent('esx:showNotification', _U('min_police'))
								        end
							        end)									
						        else
							        TriggerEvent('esx:showNotification', _U('need_bag'))
								end	
							end	
                        end
					elseif (GetDistanceBetweenCoords(pedLoc, storeLoc.x, storeLoc.y, storeLoc.z, true) > 1.0)then
						inCircle = false
					end		
				end
			end
		end

		if holdingup then
			for i,v in pairs(Config.WindowLocations) do 
				if(GetDistanceBetweenCoords(pedLoc, v.x, v.y, v.z, true) < 0.75) and not v.isOpen then 
					DrawText3D(v.x, v.y, v.z, '~w~[~g~E~w~] ' .. _U('press_to_collect'), 0.6)
					if IsControlJustPressed(0, 38) then
						animation = true
					    SetEntityCoords(PlayerPedId(), v.x, v.y, v.z-0.95)
					    SetEntityHeading(PlayerPedId(), v.heading)
						v.isOpen = true 
						PlaySoundFromCoord(-1, "Glass_Smash", v.x, v.y, v.z, "", 0, 0, 0)
					    if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
					    RequestNamedPtfxAsset("scr_jewelheist")
					    end
					    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
					    Citizen.Wait(0)
					    end
					    SetPtfxAssetNextCall("scr_jewelheist")
					    StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", v.x, v.y, v.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
					    loadAnimDict("missheist_jewel") 
						TaskPlayAnim(PlayerPedId(), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
					    DrawSubtitleTimed(5000, 1)
					    Citizen.Wait(5000)
						ClearPedTasksImmediately(PlayerPedId())
						hqReward = math.random(1, 100)
						if (hqReward < 10) then
							TriggerServerEvent('esx_vangelico_robbery:giveReward', 'hqdiamond')
						else
							TriggerServerEvent('esx_vangelico_robbery:giveReward')
						end
						PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					    brokenWindows = brokenWindows + 1
					    animation = false

						if brokenWindows == Config.MaxWindows then 
						    for i,v in pairs(Config.Stores) do 
								v.isOpen = false
								brokenWindows = 0
							end
							TriggerServerEvent('esx_vangelico_robbery:endrob', store)
						    ESX.ShowNotification(_U('lester'))
						    holdingup = false
						    StopSound(soundID)
						end
					end
				end	
			end

			local pos2 = Config.Stores[store].position

			if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -622.566, -230.183, 38.057, true) > 11.5 ) then
				TriggerServerEvent('esx_vangelico_robbery:toofar', store)
				holdingup = false
				for i,v in pairs(Config.WindowLocations) do 
					v.isOpen = false
					brokenWindows = 0
				end
				StopSound(soundID)
			end
		end
		Citizen.Wait(1)
	end
end)


RegisterNetEvent('esx_vangelico_robbery:stop')
AddEventHandler('esx_vangelico_robbery:stop', function()
	StopSound(soundID)
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if animation == true then
			if not IsEntityPlayingAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 3) then
				TaskPlayAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 8.0, 8.0, -1, 17, 1, false, false, false)
			end
		end
	end
end)

