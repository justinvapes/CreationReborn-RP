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

ESX                 = nil
local PlayerLoaded  = false
local decorName     = nil
local decorInt      = nil
local isTorsoOn     = true
local isPantsOn     = true
local isShoesOn     = true
local isHelmetOn    = true
local isVestOn      = true
local isChainOn     = true
local isMaskOn      = true
local isGlassesOn   = true
local isBagOn       = true
local isEarOn       = true
local ToiletActive  = false
local Windows        = false 
local Windows2       = false
local anchored       = false
local DoingAnima     = false
local disableShuffle = true
local setit          = 0

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

RegisterNetEvent("dexac:HereAreYourDecors")
AddEventHandler("dexac:HereAreYourDecors", function( decorN, decorI)
	decorName = decorN
	decorInt = decorI
end)

function checkIfIsMale()
	local plySkin
	TriggerEvent('skinchanger:getSkin', function(skin)
		plySkin = skin
	end)

	if plySkin.sex == 0 then
		return true
	else
		return false
	end
end

function openActionMenu()

end

RegisterNetEvent("playeractions:Openit")
AddEventHandler("playeractions:Openit", function()

  if not (IsPedSittingInAnyVehicle(PlayerPedId())) then
      local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) 		
      OpenPlayerActionsMenu()
  else
	  OpenVehicleActionsMenu()
   end
end)

function isDetective()
	if ESX.PlayerData then
		if ESX.PlayerData.job.grade_name == 'LSCDetectiveI' then
			return true
		elseif ESX.PlayerData.job.grade_name == 'SSDetectiveII' then
			return true
		elseif ESX.PlayerData.job.grade_name == 'InspDetectiveII' then
			return true
		elseif ESX.PlayerData.job.grade_name == 'SuptDetectiveIII' then
			return true
		elseif ESX.PlayerData.job.grade_name == 'ComDetectiveIII' then
			return true
		elseif ESX.PlayerData.job.grade_name == 'boss' then
			return true
		else
			return false
		end
	end
end
 
function OpenPlayerActionsMenu()

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Player_actions',
    {
      title    = _U('PlayerOptions'),
      align    = 'bottom-right',
	  css      = 'superete',
      elements = {
	    -- {label = ('Misc Options'),       value = 'Miscoptions'},
	    --{label = ('Clothing Options'),   value = 'Toggleclothes'},
		{label = ('Clean Your Vehicle'), value = 'clean_vehicle'},
		--{label = ('Show your drivers license'), value = 'drv_lic'},
		--{label = ('Show your weapons license'), value = 'wep_lic'},
		
      }
    },
    function(data, menu)
	
	if data.current.value == 'Toggleclothes' then
		if ESX.PlayerData then
			if ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'ambulance' or ESX.PlayerData.job.name == 'police' and isDetective() then
				OpenClothesActionsMenu()
			else
				ESX.ShowNotification("You Can Not Use This While On Duty!")
			end
		end
    end
	
	-- if data.current.value == 'Miscoptions' then
	--    OpenActionsMenu()
    -- end	
	
	-- if data.current.value == 'drv_lic' then
	-- 	TriggerEvent('AGN:ShowVehicleLicense')
	-- end	
	
	-- if data.current.value == 'wep_lic' then
	--    TriggerEvent('AGN:ShowWeaponLicense')
    -- end	
   
    if data.current.value == 'clean_vehicle' then
       local coords    = GetEntityCoords(PlayerPedId())
		
        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

        local vehicle = nil
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
     
        if DoesEntityExist(vehicle) then
		    ESX.UI.Menu.CloseAll()
		    exports['progressBars']:startUI(15000, "Cleaning Vehicle")
            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_MAID_CLEAN", 0, true)       
            Wait(15000)
            SetVehicleDirtLevel(vehicle, 0)
			SetVehicleDirtLevel(vehicle, 0)
            ClearPedTasksImmediately(PlayerPedId()) 	
            ESX.ShowNotification("The Vehicle Is Now Clean!")			
         end
       end  
	 end 
   end,
    function(data, menu)
    menu.close()
    end
	)
 end
 
-- Citizen.CreateThread(function(prop_name, secondaryprop_name)
--   while true do
-- 	Citizen.Wait(500)
		
-- 	if IsPedRagdoll(PlayerPedId()) then 
-- 	   local playerPed = PlayerPedId()
-- 	   local prop_name = prop_name
-- 	   local secondaryprop_name = secondaryprop_name
	   
-- 	   DetachEntity(prop, 1, 1)
-- 	   DeleteObject(prop)
-- 	   DetachEntity(secondaryprop, 1, 1)
-- 	   DeleteObject(secondaryprop)
-- 	end
--   end
-- end)	

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function OpenActionsMenu()

  local playerPed = GetPlayerPed(-1)
  local elements = {
      {label = ('Removethem'),    value = 'Removeall'},
      --{label = ('Umbrella'),      value = 'umbrella'},
      {label = ('Briefcase'),     value = 'brief'},
      {label = ('Briefcase2'),    value = 'brief2'},		
	  {label = ('Cigar Mouth'),   value = 'cigar'},
	  {label = ('Cigar2 Mouth'),  value = 'cigar2'},
	  {label = ('Hold Cigar'),    value = 'holdcigar'},		
	  {label = ('Joint Mouth'),   value = 'joint'},
	  {label = ('Hold Joint'),    value = 'holdjoint'},		
      {label = ('Cig Mouth'),     value = 'cig'},
	  {label = ('Hold Cig'),      value = 'holdcig'},  
  } 
    
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'accessoriesmenu',
    {
      title    = _U('PlayerOptions'),
      align    = 'bottom-right',
	  css      = 'superete',
      elements = elements
    },
    function(data, menu)
    local action = data.current.value

    if data.current.value == 'umbrella' then
		local ad = "amb@world_human_drinking@coffee@male@base"				
		local prop_name = prop_name or 'p_amb_brolly_01'
		local player = PlayerPedId()
				
		 if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
			  loadAnimDict( ad )
			 if ( IsEntityPlayingAnim( player, ad, "base", 3 ) ) then 
				TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
				Wait (100)
				DetachEntity(prop, 1, 1)
				DeleteObject(prop)
				ClearPedSecondaryTask(PlayerPedId())
			else
				local x,y,z = table.unpack(GetEntityCoords(player))
				prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
				DecorSetInt(prop ,decorName,decorInt)
				AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 57005), 0.15, 0.005, -0.02, 80.0, -20.0, 175.0, true, true, false, true, 1, true)
				TaskPlayAnim( player, ad, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			end 
		end 
    end
	
	if data.current.value == 'brief' then
	    local player = PlayerPedId()
	  if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 	       
		   GiveWeaponToPed(player, 0x88C78EB7, 1, false, true);
	 end
   end
   
   	if data.current.value == 'brief2' then
	    local player = PlayerPedId()
	  if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 	       
		   GiveWeaponToPed(player, 0x01B79F17, 1, false, true);
     end
   end
   
    if data.current.value == 'cigar' then
	    local cigar_name = cigar_name or 'prop_cigar_02' --noprop
	    local playerPed = PlayerPedId()
				
		if ( DoesEntityExist( playerPed ) and not IsEntityDead( playerPed )) then 
	     if IsCigar then
		Wait(500)
			DetachEntity(cigar, 1, 1)
			DeleteObject(cigar)
			IsCigar = false
		else
			IsCigar = true
			Wait(500)
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			cigar = CreateObject(GetHashKey(cigar_name), x, y, z+0.2,  true,  true, true)
			DecorSetInt(cigar ,decorName,decorInt)
			AttachEntityToEntity(cigar, playerPed, GetPedBoneIndex(playerPed, 47419), 0.015, -0.0001, 0.003, 55.0, 0.0, -85.0, true, true, false, true, 1, true)
		end     
	  end 
    end
  
    if data.current.value == 'cigar2' then
	    local cigar_name = cigar_name or 'prop_cigar_01' --noprop
	    local playerPed = PlayerPedId()
				
		if ( DoesEntityExist( playerPed ) and not IsEntityDead( playerPed )) then 
		 if IsCigar then
			Wait(500)
			DetachEntity(cigar, 1, 1)
			DeleteObject(cigar)
			IsCigar = false
		else
			IsCigar = true
			Wait(500)
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			cigar = CreateObject(GetHashKey(cigar_name), x, y, z+0.2,  true,  true, true)
			DecorSetInt(cigar ,decorName,decorInt)
			AttachEntityToEntity(cigar, playerPed, GetPedBoneIndex(playerPed, 47419), 0.015, -0.0001, 0.003, 55.0, 0.0, -85.0, true, true, false, true, 1, true)
		end     
	  end	  
	end
	  
	if data.current.value == 'joint' then
	    local cigar_name = cigar_name or 'p_cs_joint_02' --noprop
	    local playerPed = PlayerPedId()
				
		if ( DoesEntityExist( playerPed ) and not IsEntityDead( playerPed )) then 
		 if IsCigar then
			Wait(500)
			DetachEntity(cigar, 1, 1)
			DeleteObject(cigar)
			IsCigar = false
		else
			IsCigar = true
			Wait(500)
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			cigar = CreateObject(GetHashKey(cigar_name), x, y, z+0.2,  true,  true, true)
			DecorSetInt(cigar ,decorName,decorInt)
			AttachEntityToEntity(cigar, playerPed, GetPedBoneIndex(playerPed, 47419), 0.015, -0.009, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
		 end     
	   end
	 end
	   
	if data.current.value == 'holdcigar' then
	    local cigar_name = cigar_name or 'prop_cigar_03' --noprop
		local playerPed = PlayerPedId()
				
		if ( DoesEntityExist( playerPed ) and not IsEntityDead( playerPed )) then 
		 if IsCigar then
			Wait(500)
			DetachEntity(cigar, 1, 1)
			DeleteObject(cigar)
			IsCigar = false
		else
			IsCigar = true
			Wait(500)
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			cigar = CreateObject(GetHashKey(cigar_name), x, y, z+0.2,  true,  true, true)
			DecorSetInt(cigar ,decorName,decorInt)
			AttachEntityToEntity(cigar, playerPed, GetPedBoneIndex(playerPed, 26611), 0.045, -0.05, -0.010, -75.0, 0.0, 65.0, true, true, false, true, 1, true)
		 end     
	    end
	   end
		
	if data.current.value == 'holdjoint' then
	    local cigar_name = cigar_name or 'p_cs_joint_02' --noprop
		local playerPed = PlayerPedId()
				
		if ( DoesEntityExist( playerPed ) and not IsEntityDead( playerPed )) then 
		 if IsCigar then
			Wait(500)
			DetachEntity(cigar, 1, 1)
			DeleteObject(cigar)
			IsCigar = false
		else
			IsCigar = true
			Wait(500)
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			cigar = CreateObject(GetHashKey(cigar_name), x, y, z+0.2,  true,  true, true)
			DecorSetInt(cigar ,decorName,decorInt)
			AttachEntityToEntity(cigar, playerPed, GetPedBoneIndex(playerPed, 26611), 0.035, -0.01, -0.010, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
		end     
	end		
  end
  
    if data.current.value == 'cig' then
	    local cigar_name = cigar_name or 'prop_amb_ciggy_01' --noprop
	    local playerPed = PlayerPedId()
				
		if ( DoesEntityExist( playerPed ) and not IsEntityDead( playerPed )) then 
		 if IsCigar then
			Wait(500)
			DetachEntity(cigar, 1, 1)
			DeleteObject(cigar)
			IsCigar = false
		else
			IsCigar = true
			Wait(500)
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			cigar = CreateObject(GetHashKey(cigar_name), x, y, z+0.2,  true,  true, true)
			DecorSetInt(cigar ,decorName,decorInt)
			AttachEntityToEntity(cigar, playerPed, GetPedBoneIndex(playerPed, 47419), 0.015, -0.009, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
		end     
	  end		
    end
	
	if data.current.value == 'holdcig' then
	    local cigar_name = cigar_name or 'prop_amb_ciggy_01' --noprop
		local playerPed = PlayerPedId()
				
		if ( DoesEntityExist( playerPed ) and not IsEntityDead( playerPed )) then 
		 if IsCigar then
			Wait(500)
			DetachEntity(cigar, 1, 1)
			DeleteObject(cigar)
			IsCigar = false
		else
			IsCigar = true
			Wait(500)
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			cigar = CreateObject(GetHashKey(cigar_name), x, y, z+0.2,  true,  true, true)
			DecorSetInt(cigar ,decorName,decorInt)
			AttachEntityToEntity(cigar, playerPed, GetPedBoneIndex(playerPed, 26611), 0.035, -0.01, -0.010, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
		end     
	  end		
    end	
	
	if data.current.value == 'Removeall' then
	   local playerPed = PlayerPedId()
	   local prop_name = prop_name
	   local secondaryprop_name = secondaryprop_name
	   DetachEntity(prop, 1, 1)
	   DeleteObject(prop)
	   DetachEntity(secondaryprop, 1, 1)
	   DeleteObject(secondaryprop)
	   ClearPedSecondaryTask(PlayerPedId())
    end
  end,
    function(data, menu)
      menu.close()
    end
  )
end


function OpenClothesActionsMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'action_menu',
        {
        title    = 'Items',
	    align    = 'bottom-right',
		css      = 'identity',
        elements = {
			{label = 'Glasses', value = 'glasses'},
		    {label = 'Torso',   value = 'torso'},
		    {label = 'Pants',   value = 'pants'},
		    {label = 'Shoes',   value = 'shoes'},
		    {label = 'Mask',    value = 'mask'},
		    {label = 'Helmet',  value = 'helmet'},
		    {label = 'Bag',     value = 'bag'},
		    {label = 'Ear',     value = 'ear'},
		    {label = 'Chain',   value = 'chain'},
		    {label = 'Vest',    value = 'vest'}
           }
        },
        function(data, menu)
		
        if data.current.value == 'torso' then
		   TriggerEvent('PlayerActions:Torso')
		elseif data.current.value == 'pants' then
		   TriggerEvent('PlayerActions:Pants')
		elseif data.current.value == 'shoes' then
		   TriggerEvent('PlayerActions:Shoes')
		elseif data.current.value == 'helmet' then
		   TriggerEvent('PlayerActions:Helmet')
		elseif data.current.value == 'vest' then
		   TriggerEvent('PlayerActions:Vest')
		elseif data.current.value == 'chain' then
		   TriggerEvent('PlayerActions:Chain')
		elseif data.current.value == 'mask' then
		   TriggerEvent('PlayerActions:Mask')
		elseif data.current.value == 'glasses' then
		   TriggerEvent('PlayerActions:Glasses')
		elseif data.current.value == 'bag' then
		   TriggerEvent('PlayerActions:Bag')
		elseif data.current.value == 'ear' then
		   TriggerEvent('PlayerActions:Ear')
	    end		 
     end,
        function(data, menu)
        menu.close()
     end
    )
end

-- Torso:
RegisterNetEvent('PlayerActions:Torso')
AddEventHandler('PlayerActions:Torso', function()
	local maleSkin = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 15, ['torso_2'] = 0,
		['arms'] = 15
	}
	local notSoMaleSkin = {
		['tshirt_1'] = 14, ['tshirt_2'] = 0,
		['torso_1'] = 15, ['torso_2'] = 0,
		['arms'] = 15
	}

	if checkIfIsMale() == true then
		if isTorsoOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, maleSkin)
			end)
			isTorsoOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 0,
					tshirt_1 = skin.tshirt_1, tshirt_2 = skin.tshirt_2,
					torso_1 = skin.torso_1, torso_2 = skin.torso_2,
					arms = skin.arms
				})
			end)
			isTorsoOn = true
		end
	else
		if isTorsoOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, notSoMaleSkin)
			end)
			isTorsoOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 1,
					tshirt_1 = skin.tshirt_1, tshirt_2 = skin.tshirt_2,
					torso_1 = skin.torso_1, torso_2 = skin.torso_2,
					arms = skin.arms
				})
			end)
			isTorsoOn = true
		end
	end

end)

-- Pants:
RegisterNetEvent('PlayerActions:Pants')
AddEventHandler('PlayerActions:Pants', function()
	local maleSkin = {
		['pants_1'] = 21, ['pants_2'] = 0
	}
	local notSoMaleSkin = {
		['pants_1'] = 15, ['pants_2'] = 0
	}

	if checkIfIsMale() == true then
		if isPantsOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, maleSkin)
			end)
			isPantsOn = false
			local underwear = math.random(0, 13)
			SetPedComponentVariation(PlayerPedId(), 4, 61, underwear, 2)
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 0,
					pants_1 = skin.pants_1, pants_2 = skin.pants_2
				})
			end)
			isPantsOn = true
		end
	else
		if isPantsOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, notSoMaleSkin)
			end)
			isPantsOn = false
			local underwearF    = math.random(0, 11)
			SetPedComponentVariation(PlayerPedId(), 4, 17, underwearF, 2)
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 1,
					pants_1 = skin.pants_1, pants_2 = skin.pants_2
				})
			end)
			isPantsOn = true
		end
	end

end)

-- Shoes
RegisterNetEvent('PlayerActions:Shoes')
AddEventHandler('PlayerActions:Shoes', function()
	local maleSkin = {
		['shoes_1'] = 34, ['shoes_2'] = 0
	}
	local notSoMaleSkin = {
		['shoes_1'] = 35, ['shoes_2'] = 0
	}

	if checkIfIsMale() == true then
		if isShoesOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, maleSkin)
			end)
			isShoesOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 0,
					shoes_1 = skin.shoes_1, shoes_2 = skin.shoes_2
				})
			end)
			isShoesOn = true
		end
	else
		if isShoesOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, notSoMaleSkin)
			end)
			isShoesOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 1,
					shoes_1 = skin.shoes_1, shoes_2 = skin.shoes_2
				})
			end)
			isShoesOn = true
		end
	end

end)

-- Helmet
RegisterNetEvent('PlayerActions:Helmet')
AddEventHandler('PlayerActions:Helmet', function()
	local maleSkin = {
		['helmet_1'] = -1, ['helmet_2'] = 0
	}
	local notSoMaleSkin = {
		['helmet_1'] = -1, ['helmet_2'] = 0
	}

	if checkIfIsMale() == true then
		if isHelmetOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, maleSkin)
			end)
			isHelmetOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 0,
					helmet_1 = skin.helmet_1, helmet_2 = skin.helmet_2
				})
			end)
			isHelmetOn = true
		end
	else
		if isHelmetOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, notSoMaleSkin)
			end)
			isHelmetOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 1,
					helmet_1 = skin.helmet_1, helmet_2 = skin.helmet_2
				})
			end)
			isHelmetOn = true
		end
	end

end)

-- Vest
RegisterNetEvent('PlayerActions:Vest')
AddEventHandler('PlayerActions:Vest', function()

    if ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'police' then

	local maleSkin = {
		['bproof_1'] = 0, ['bproof_2'] = 0
	}
	local notSoMaleSkin = {
		['bproof_1'] = 0, ['bproof_2'] = 0
	}

	if checkIfIsMale() == true then
		if isVestOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, maleSkin)
			end)
			isVestOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 0,
					bproof_1 = skin.bproof_1, bproof_2 = skin.bproof_2
				})
			end)
			isVestOn = true
		end
	else
		if isVestOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, notSoMaleSkin)
			end)
			isVestOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 1,
					bproof_1 = skin.bproof_1, bproof_2 = skin.bproof_2
				})
			end)
			isVestOn = true
		end
	end
	else
	  ESX.ShowNotification("You Can Not Do This While On Duty!")	
   end
end)

-- Chain
RegisterNetEvent('PlayerActions:Chain')
AddEventHandler('PlayerActions:Chain', function()
	local maleSkin = {
		['chain_1'] = 0, ['chain_2'] = 0
	}
	local notSoMaleSkin = {
		['chain_1'] = 0, ['chain_2'] = 0
	}

	if checkIfIsMale() == true then
		if isChainOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, maleSkin)
			end)
			isChainOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 0,
					chain_1 = skin.chain_1, chain_2 = skin.chain_2
				})
			end)
			isChainOn = true
		end
	else
		if isChainOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, notSoMaleSkin)
			end)
			isChainOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 1,
					chain_1 = skin.chain_1, chain_2 = skin.chain_2
				})
			end)
			isChainOn = true
		end
	end

end)

-- Mask
RegisterNetEvent('PlayerActions:Mask')
AddEventHandler('PlayerActions:Mask', function()
	local maleSkin = {
		['mask_1'] = 0, ['mask_2'] = 0
	}
	local notSoMaleSkin = {
		['mask_1'] = 0, ['mask_2'] = 0
	}

	if checkIfIsMale() == true then
		if isMaskOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, maleSkin)
			end)
			isMaskOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 0,
					mask_1 = skin.mask_1, mask_2 = skin.mask_2
				})
			end)
			isMaskOn = true
		end
	else
		if isMaskOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, notSoMaleSkin)
			end)
			isMaskOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 1,
					mask_1 = skin.mask_1, mask_2 = skin.mask_2
				})
			end)
			isMaskOn = true
		end
	end

end)

-- Glasses
RegisterNetEvent('PlayerActions:Glasses')
AddEventHandler('PlayerActions:Glasses', function()
	local maleSkin = {
		['glasses_1'] = 0, ['glasses_2'] = 0
	}
	local notSoMaleSkin = {
		['glasses_1'] = 5, ['glasses_2'] = 0
	}

	if checkIfIsMale() == true then
		if isGlassesOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, maleSkin)
			end)
			isGlassesOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 0,
					glasses_1 = skin.glasses_1, glasses_2 = skin.glasses_2
				})
			end)
			isGlassesOn = true
		end
	else
		if isGlassesOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, notSoMaleSkin)
			end)
			isGlassesOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 1,
					glasses_1 = skin.glasses_1, glasses_2 = skin.glasses_2
				})
			end)
			isGlassesOn = true
		end
	end
end)

-- Bag
RegisterNetEvent('PlayerActions:Bag')
AddEventHandler('PlayerActions:Bag', function()
	local maleSkin = {
		['bags_1'] = 0, ['bags_2'] = 0
	}
	local notSoMaleSkin = {
		['bags_1'] = 0, ['bags_2'] = 0
	}

	if checkIfIsMale() == true then
		if isBagOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, maleSkin)
			end)
			isBagOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 0,
					bags_1 = skin.bags_1, bags_2 = skin.bags_2
				})
			end)
			isBagOn = true
		end
	else
		if isBagOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, notSoMaleSkin)
			end)
			isBagOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 1,
					bags_1 = skin.bags_1, bags_2 = skin.bags_2
				})
			end)
			isBagOn = true
		end
	end
end)

-- Ear
RegisterNetEvent('PlayerActions:Ear')
AddEventHandler('PlayerActions:Ear', function()
	local maleSkin = {
		['ears_1'] = -1, ['ears_2'] = 0
	}
	local notSoMaleSkin = {
		['ears_1'] = -1, ['ears_2'] = 0
	}

	if checkIfIsMale() == true then
		if isEarOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, maleSkin)
			end)
			isEarOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 0,
					ears_1 = skin.ears_1, ears_2 = skin.ears_2
				})
			end)
			isEarOn = true
		end
	else
		if isEarOn == true then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, notSoMaleSkin)
			end)
			isEarOn = false
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', {
					sex = 1,
					ears_1 = skin.ears_1, ears_2 = skin.ears_2
				})
			end)
			isEarOn = true
		end
	end
end)

RegisterNetEvent('esx-qalle-needs:syncCL')
AddEventHandler('esx-qalle-needs:syncCL', function(ped, need, sex)
    if need == 'pee' then
        Pee(ped, sex)
    else
        Poop(ped)
    end
end)


function Pee(ped, sex)
    local Player = ped
    local PlayerPed = GetPlayerPed(GetPlayerFromServerId(ped))
    local particleDictionary = "core"
    local particleName = "ent_amb_peeing"
    local animDictionary = 'misscarsteal2peeing'
    local animName = 'peeing_loop'
	ToiletActive = true

    RequestNamedPtfxAsset(particleDictionary)

    while not HasNamedPtfxAssetLoaded(particleDictionary) do
        Citizen.Wait(0)
    end

    RequestAnimDict(animDictionary)

    while not HasAnimDictLoaded(animDictionary) do
        Citizen.Wait(0)
    end

    RequestAnimDict('missfbi3ig_0')

    while not HasAnimDictLoaded('missfbi3ig_0') do
        Citizen.Wait(1)
    end

    if sex == 'male' then
	   ToiletActive = true

        SetPtfxAssetNextCall(particleDictionary)

        local bone = GetPedBoneIndex(PlayerPed, 11816)

        local heading = GetEntityPhysicsHeading(PlayerPed)

        TaskPlayAnim(PlayerPed, animDictionary, animName, 8.0, -8.0, -1, 0, 0, false, false, false)

        local effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.2, 0.0, -140.0, 0.0, 0.0, bone, 2.5, false, false, false)

        Wait(3500)

        StopParticleFxLooped(effect, 0)
        ClearPedTasks(PlayerPed)
		ToiletActive = false
    else
        ToiletActive = true
        SetPtfxAssetNextCall(particleDictionary)
        bone = GetPedBoneIndex(PlayerPed, 11816)

        local heading = GetEntityPhysicsHeading(PlayerPed)
        TaskPlayAnim(PlayerPed, 'missfbi3ig_0', 'shit_loop_trev', 8.0, -8.0, -1, 0, 0, false, false, false)
        local effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.55, 0.0, 0.0, 20.0, bone, 2.0, false, false, false)

        Wait(5500)

        Citizen.Wait(100)
        StopParticleFxLooped(effect, 0)
        ClearPedTasks(PlayerPed)
		ToiletActive = false
    end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if ToiletActive == true then
	   DisableControlAction(2, 18, true)
   else
	   Citizen.Wait(250)
    end
  end
end)

--Smoking
RegisterNetEvent('esx_basicneeds:OnSmokeCigarett')
AddEventHandler('esx_basicneeds:OnSmokeCigarett', function()
	prop_name = prop_name or 'ng_proc_cigarette01a' ---used cigarett prop for now. Tired of trying to place object.
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped, true))
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
	DecorSetInt(prop ,decorName,decorInt)
	local boneIndex = GetPedBoneIndex(ped, 64017)
			
    if not IsEntityPlayingAnim(ped, "amb@world_human_smoking@male@male_b@idle_a", "idle_a", 3) then
        RequestAnimDict("amb@world_human_smoking@male@male_b@idle_a")
        while not HasAnimDictLoaded("amb@world_human_smoking@male@male_b@idle_a") do
            Citizen.Wait(100)
        end

		Wait(100)
		AttachEntityToEntity(prop, ped, boneIndex, 0.015, 0.0100, 0.0250, 0.024, -100.0, 40.0, true, true, false, true, 1, true)
        TaskPlayAnim(ped, 'amb@world_human_smoking@male@male_b@idle_a', 'idle_a', 8.0, 8.0, -1, 49, 0, 0, 0, 0)
        Wait(2000)
        while IsEntityPlayingAnim(ped, "amb@world_human_smoking@male@male_b@idle_a", "idle_a", 3) do
            Wait(1)
			hintToDisplay('Press ~INPUT_PICKUP~ To Stop ~b~Smoking')
			if IsControlPressed(0, 38) then
				Citizen.Wait(2000)
				ClearPedSecondaryTask(ped)
				DeleteObject(prop)
                break
            end
        end
    end
end)

RegisterNetEvent('PlayerActions:UseHandcuffKeys')
AddEventHandler('PlayerActions:UseHandcuffKeys', function()

    local player, distance = ESX.Game.GetClosestPlayer()
	local ClosestPlayer = GetPlayerPed(player)

    if distance ~= -1 and distance <= 1.5 then
	 if IsPedCuffed(ClosestPlayer) then
			
		TriggerEvent("mythic_progbar:client:progress", {
        name = "Unlocking Handcuffs",
        duration = 5500,
        label = "Unlocking Handcuffs",
        useWhileDead = false,
        canCancel = false,
					
        controlDisables = {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
       },
        animation = {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
       },

       }, function(status)
		ClearPedTasks(PlayerPedId())	   
	    TriggerServerEvent('80586cd0-4d96-c4c9-8058-1dd3678d14d53', GetPlayerServerId(player))
		TriggerServerEvent('PlayerActions:message', GetPlayerServerId(player), 'You Have Just Been Un Cuffed')
		TriggerServerEvent('PlayerActions:RemoveHKeys')
        ESX.ShowNotification("HandCuffs ~r~Removed")			
     end)	 	 
	else
		ESX.ShowNotification("That Person Has No Handcuffs On")	
     end
	else
		ESX.ShowNotification("No Players Nearby")	
     end
end)


function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


--DriveBy
Citizen.CreateThread(function()
while true do
	Citizen.Wait(0)

	local playerPed = GetPlayerPed(-1)
		
	if IsPedInAnyVehicle(playerPed, false) then
	   local vehicle = GetVehiclePedIsIn(playerPed, false)

	if GetPedInVehicleSeat(vehicle, -1) == playerPed then
	   if (GetEntitySpeed(vehicle) * 2.236936) < 10.0 then
		   SetPlayerCanDoDriveBy(PlayerId(), true)
	   else
		   SetPlayerCanDoDriveBy(PlayerId(), false)
        end
	  end
	else
	    Citizen.Wait(250)
    end
  end
end)

-- Idle Camera
Citizen.CreateThread(function()
    while true do	
      Citizen.Wait(1000) 
	  
      N_0xf4f2c0d4ee209e20() 
      N_0x9e4cfff989258472() 
   end
end)

--No Pistol Whip
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
			
        if IsPedArmed(PlayerPedId(), 6) then
	       DisableControlAction(1, 140, true)
       	   DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)		   
		else
		    Citizen.Wait(250)
        end
    end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500) 
	
	-- Alter Weapon Damages
    --N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.3)
	--N_0x4757f00bc6323cfe(-1553120962, 0.0) --Vehicles
	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_REVOLVER"), 0.3)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MARKSMANPISTOL"), 0.3)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PUMPSHOTGUN"), 1.8)
	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SWEEPERSHOTGUN"), 0.0)
	--N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SAWNOFFSHOTGUN"), 0.0)
	--N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BULLPUPSHOTGUN"), 0.0)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTSHOTGUN"), 0.0)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MUSKET"), 0.0)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYSHOTGUN"), 0.0)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_DBSHOTGUN"), 0.0)
	--N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYSNIPER"), 0.0)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYSNIPER_MK2"), 0.0)
	-- N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MARKSMANRIFLE"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GRENADELAUNCHER"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GRENADELAUNCHER_SMOKE"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_RPG"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MINIGUN"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FIREWORK"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_RAILGUN"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HOMINGLAUNCHER"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMPACTLAUNCHER"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SPECIALCARBINE_MK2"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BULLPUPRIFLE_MK2"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PUMPSHOTGUN_MK2"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MARKSMANRIFLE_MK2"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_RAYPISTOL"), 0.0)			
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_RAYCARBINE"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_RAYMINIGUN"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_DIGISCANNER"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BULLPUPRIFLE"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMPACTRIFLE"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CARBINERIFLE_MK2"), 0.0)	
	--N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ADVANCEDRIFLE"), 0.0)	
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTRIFLE_MK2"), 0.0)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MINISMG"), 0.0)	
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SMG"), 0.0)	
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SMG_MK2"), 0.0)	
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTSMG"), 0.0)	
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MG"), 0.0)	
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATMG"), 0.0)	
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATMG_MK2"), 0.0)   
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATPDW"), 0.0)	 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GRENADE"), 0.0)	 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_STICKYBOMB"), 0.0)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNOWBALL"), 0.0)	  

    --Remove Weapons From Wheel
    N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_SWEEPERSHOTGUN"), false)	
	-- N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_SAWNOFFSHOTGUN"), false)
	--N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_BULLPUPSHOTGUN"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_ASSAULTSHOTGUN"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_MUSKET"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_HEAVYSHOTGUN"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_DBSHOTGUN"), false)
	--N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_HEAVYSNIPER"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_HEAVYSNIPER_MK2"), false)
	-- N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_MARKSMANRIFLE"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_GRENADELAUNCHER"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_GRENADELAUNCHER_SMOKE"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_RPG"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_MINIGUN"), false)
	--N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_FIREWORK"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_RAILGUN"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_HOMINGLAUNCHER"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_COMPACTLAUNCHER"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_SPECIALCARBINE_MK2"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_BULLPUPRIFLE_MK2"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN_MK2"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_MARKSMANRIFLE_MK2"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_RAYPISTOL"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_RAYCARBINE"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_RAYMINIGUN"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_DIGISCANNER"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_BULLPUPRIFLE"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_COMPACTRIFLE"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_CARBINERIFLE_MK2"), false)
	--N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_ADVANCEDRIFLE"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_ASSAULTRIFLE_MK2"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_MINISMG"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_SMG"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_SMG_MK2"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_ASSAULTSMG"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_MG"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_COMBATMG"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_COMBATMG_MK2"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_COMBATPDW"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_GRENADE"), false)
	N_0xb4771b9aaf4e68e4(PlayerPedId(), GetHashKey("WEAPON_STICKYBOMB"), false)
  end
end)

RegisterNetEvent('CR_Actions:OpenMenu')
AddEventHandler('CR_Actions:OpenMenu', function()

 if (IsPedSittingInAnyVehicle(PlayerPedId())) then
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) 

    if (GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()) then 
        OpenVehicleActionsMenu()
    else
		ESX.ShowNotification("You Must Be The Driver To Use This")
	 end
    else
        OpenPlayerActionsMenu()	
     end
end)
 
function OpenVehicleActionsMenu()

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vehicle_actions', --F1 Main Menu
    {
      title    = _U('VehicleOptions'),
      align    = 'bottom-right',
	  css      = 'gps',
      elements = {
		{label = _U('neon'),              value = 'Open_Neontoggle'},
		{label = _U('HeadLightsTog'),     value = 'ToggleHeadLights'},
		{label =   ('HeadLight Colour'),  value = 'HeadLightscol'},
		{label = _U('Interior_Light'),    value = 'ToggleInteriorLight'},
        {label = _U('Vehicle_Doors'),     value = 'Open_Doors'},
		{label = _U('Vehicle_Windows'),   value = 'Open_Windows'},		
		{label = _U('Preset_Waypoints'),  value = 'Waypoints'},
		{label = _U('Sell_Vehicle'),      value = 'Give_Keys'},		
      }
    },
    function(data, menu)
	
    if data.current.value == 'ToggleInteriorLight' then
       local veh = GetVehiclePedIsUsing(PlayerPedId())
       toggleInteriorLights(PlayerPedId(), veh)	   
    end
		    	   	   
	if data.current.value == 'Open_Neontoggle' then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			NeonSync = VehToNet(vehicle)	   	   
			TriggerServerEvent("CR_VehicleActions:NeonSync", NeonSync)	
    end
         
	if data.current.value == 'Give_Keys' then		
       v = GetVehiclePedIsIn(PlayerPedId(), false)	
	if GetPedInVehicleSeat(v, -1) == PlayerPedId() then
	   checkCar(GetVehiclePedIsIn(PlayerPedId(), false)) 
	end     
  end
		   	   
	if data.current.value == 'ToggleLower' then
	   togglesuspention()		
    end  
	
if data.current.value == 'HeadLightscol' then 
				
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_vehicle_actions7',
    {
      title    = _U('Headlight Colour'),
      align    = 'bottom-right',
	  css      = 'gps',
      elements = {
	  {label = ('Default'),            value = 'HDefault'},
	  {label = ('White'),              value = 'HWhite'},
	  {label = ('Blue'),               value = 'HBlue'},
	  {label = ('Electric Blue'),      value = 'HElectric'},
	  {label = ('Mint Green'),         value = 'HMint'},
	  {label = ('Lime Green'),         value = 'HLime'},
      {label = ('Yellow'),             value = 'HYellow'},
	  {label = ('Golden Shower'),      value = 'HGolden'},
	  {label = ('Orange'),             value = 'HOrange'},
	  {label = ('Red'),                value = 'HRed'},
	  {label = ('Pony Pink'),          value = 'HPony'},
	  {label = ('Hot Pink'),           value = 'HHot'},	  
	  {label = ('Purple'),             value = 'HPurple'},
	  {label = ('Blacklight'),         value = 'HBlacklight'},
      },
    },
    function(data6, menu6)
	
	if data6.current.value == 'HDefault' then
	   local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, -1)
	end	
	if data6.current.value == 'HWhite' then
	   local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 0)
	end	
	if data6.current.value == 'HBlue' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 1)
	end	
	if data6.current.value == 'HElectric' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 2)
	end	
	if data6.current.value == 'HMint' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 3)
	end	
	if data6.current.value == 'HLime' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 4)
	end	
	if data6.current.value == 'HYellow' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 5)
	end	
	if data6.current.value == 'HGolden' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 6)
	end	
	if data6.current.value == 'HOrange' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 7)
	end	
	if data6.current.value == 'HRed' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 8)
	end	
	if data6.current.value == 'HPony' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 9)
	end	
	if data6.current.value == 'HHot' then
	   local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 10)
	end	
	if data6.current.value == 'HPurple' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 11)
	end	
	if data6.current.value == 'HBlacklight' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
       SetVehicleHeadlightsColour(vehicle, 12)
	end	
  end,
     function(data6, menu6)
     menu6.close()
     end
    )
end	
	
if data.current.value == 'Waypoints' then --Waypoint Actions Sub Menu
				
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_vehicle_actions6',
    {
      title    = _U('WaypointMenu'),
      align    = 'bottom-right',
	  css      = 'gps',
      elements = {
	  {label = ('Clear Waypoint'),       value = 'ClearWaypoint'},
	  {label = ('Police Department'),         value = 'GotoPD'},
	  {label = ('EMS'),        value = 'GotoEMS'},
	  {label = ('Vanilla Unicorn'),      value = 'GotoUnicorn'},
	  {label = ('Larrys Laundromat'),    value = 'GotoLaundro'},
	  {label = ("Benny's Motorworks"),           value = 'GotoBennys'},
      {label = ('LS Customs'),       value = 'GotoCustoms'},
	  {label = ('Vic Roards'),           value = 'GotoVRoads'},
	  {label = ('Nightclub'),  value = 'GotoNightclub'},
	  {label = ('Airport'),              value = 'GotoAirport'},
	  {label = ('Centre Garage'),        value = 'GotoGarage1'},
      },
    },
    function(data5, menu5)
	
	if data5.current.value == 'ClearWaypoint' then
        SetWaypointOff()
		notify("Waypoint ~g~Cleared")
	end	
	if data5.current.value == 'GotoPD' then
        local coord = PD
        SetNewWaypoint(coord[1], coord[2])
		notify("Waypoint Set To ~g~Police Department")
	end	
	if data5.current.value == 'GotoEMS' then
        local coord = EMS
        SetNewWaypoint(coord[1], coord[2])
		notify("Waypoint Set To ~g~EMS")
	end		  
    if data5.current.value == 'GotoUnicorn' then
        local coord = Unicorn
        SetNewWaypoint(coord[1], coord[2])
		notify("Waypoint Set To ~g~Vanilla Unicorn")
	end	
	if data5.current.value == 'GotoBennys' then
        local coord = Bennys
        SetNewWaypoint(coord[1], coord[2])
		notify("Waypoint Set To ~g~Hardline Repairs")
	end	
	if data5.current.value == 'GotoCustoms' then
        local coord = LSCustoms
        SetNewWaypoint(coord[1], coord[2])
		notify("Waypoint Set To ~g~LS Customs")
	end	
	if data5.current.value == 'GotoVRoads' then
        local coord = VicRoads
        SetNewWaypoint(coord[1], coord[2])
		notify("Waypoint Set To ~g~Vic Roads")
	end	
	if data5.current.value == 'GotoNightclub' then
        local coord = Nightclub
        SetNewWaypoint(coord[1], coord[2])
		notify("Waypoint Set To ~g~Nightclub")
	end	
    if data5.current.value == 'GotoAirport' then
        local coord = Airport
        SetNewWaypoint(coord[1], coord[2])
		notify("Waypoint Set To ~g~Airport")
	end		
	if data5.current.value == 'GotoGarage1' then
        local coord = Garage1
        SetNewWaypoint(coord[1], coord[2])
		notify("Waypoint Set To ~g~Centre Garage")
	end		
  end,
     function(data5, menu5)
      menu5.close()
   end
   )
end	 	
	 	 	   	  		
if data.current.value == 'ToggleHeadLights' then --Headlight Actions Sub Menu
				
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_vehicle_actions4',
    {
      title    = _U('VehicleHeadlights'),
      align    = 'bottom-right',
	  css      = 'gps',
      elements = {
	    {label = _U('SetBright0'),   value = 'Set_Bright0'},
        {label = _U('SetBright1'),   value = 'Set_Bright1'},
	    {label = _U('SetBright2'),   value = 'Set_Bright2'},
		{label = _U('SetBright3'),   value = 'Set_Bright3'},
		{label = _U('SetBright4'),   value = 'Set_Bright4'},
		{label = _U('SetBright5'),   value = 'Set_Bright5'},
      },
    },
    function(data4, menu4)
		  
    if data4.current.value == 'Set_Bright0' then
       toggleLight0()
	end		  		  
    if data4.current.value == 'Set_Bright1' then
       toggleLight1()
	end		  
    if data4.current.value == 'Set_Bright2' then
       toggleLight2()  
	end	  
    if data4.current.value == 'Set_Bright3' then
       toggleLight3()  
	end		  
	if data4.current.value == 'Set_Bright4' then
       toggleLight4()  
	end
    if data4.current.value == 'Set_Bright5' then
       toggleLight5()  
	end    
  end,
    function(data4, menu4)
    menu4.close()
    end
    )
 end
									
if data.current.value == 'Open_Windows' then --Window Actions Sub Menu
		
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_vehicle_actions3',
    {
      title    = _U('Vehiclewindows'),
      align    = 'bottom-right',
	  css      = 'gps',
      elements = {
        {label = _U('ToggAllwindows'),   value = 'Open_Allwindows'},
	    {label = _U('ToggFrontwindows'),   value = 'Front_windows'},
       },
    },
    function(data3, menu3)
		  		  
    if data3.current.value == 'Open_Allwindows' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   Windows = not Windows;
		
	if Windows then
	    RollDownWindow(vehicle, 0)
	    RollDownWindow(vehicle, 1)
	    RollDownWindow(vehicle, 2)
	    RollDownWindow(vehicle, 3)
	else
	    RollUpWindow(vehicle, 0)
	    RollUpWindow(vehicle, 1)
	    RollUpWindow(vehicle, 2)
	    RollUpWindow(vehicle, 3)
      end
	end
	 
    if data3.current.value == 'Front_windows' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   Windows2 = not Windows2;
	   
	if Windows2 then
	    RollDownWindow(vehicle, 0)
	    RollDownWindow(vehicle, 1)		
	else	
	    RollUpWindow(vehicle, 0)
	    RollUpWindow(vehicle, 1)	
      end	
    end		 				  
  end,
     function(data3, menu3)
     menu3.close()
     end
    )
end
	
if data.current.value == 'Open_Doors' then --Door Actions Sub Menu

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_vehicle_actions2',
    {
      title    = _U('VehicleDoors'),
      align    = 'bottom-right',
	  css      = 'gps',
      elements = {
        {label = _U('Hood'),     value = 'Open_Hood'},
	    {label = _U('Trunk'),    value = 'Open_Trunk'},
	    {label = _U('FRDoor'),   value = 'Open_FRDoor'},
	    {label = _U('FLDoor'),   value = 'Open_FLDoor'},
		{label = _U('BRDoor'),   value = 'Open_BRDoor'},
		{label = _U('BLDoor'),   value = 'Open_BLDoor'},
		{label = _U('RHood'),    value = 'Remove_Hood'},
       },
    },
    function(data2, menu2)
		  		  
    if data2.current.value == 'Open_Hood' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if GetVehicleDoorAngleRatio(vehicle, 4) > 0.0 then 
       SetVehicleDoorShut(vehicle, 4, false)            
    else
       SetVehicleDoorOpen(vehicle, 4, false)             
     end
   end
 
	if data2.current.value == 'Remove_Hood' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
       SetVehicleDoorBroken(vehicle, 4, 1);      
     end
	
	if data2.current.value == 'Open_Trunk' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	   Model = GetEntityModel(vehicle)
	   
	if Model == -1227131821 then   
	
        if GetVehicleDoorAngleRatio(vehicle, 5) > 0.0 then 
           SetVehicleDoorShut(vehicle, 5, false)
	       Wait(100)
           RemoveVehicleMod(vehicle, 2)	 	   
       else  
           SetVehicleDoorOpen(vehicle, 5, false)
           Wait(300)
           SetVehicleMod(vehicle, 2)		   
        end	  
	else	
	    if GetVehicleDoorAngleRatio(vehicle, 5) > 0.0 then 
           SetVehicleDoorShut(vehicle, 5, false)	   
       else
           SetVehicleDoorOpen(vehicle, 5, false)	   
        end	 
     end
  end
 	   
	if data2.current.value == 'Open_FRDoor' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if GetVehicleDoorAngleRatio(vehicle, 1) > 0.0 then 
       SetVehicleDoorShut(vehicle, 1, false)            
    else
       SetVehicleDoorOpen(vehicle, 1, false)             
     end
   end
	 
	if data2.current.value == 'Open_FLDoor' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 then 
       SetVehicleDoorShut(vehicle, 0, false)            
    else
       SetVehicleDoorOpen(vehicle, 0, false)             
     end
   end
	    
    if data2.current.value == 'Open_BRDoor' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if GetVehicleDoorAngleRatio(vehicle, 3) > 0.0 then 
       SetVehicleDoorShut(vehicle, 3, false)            
    else
       SetVehicleDoorOpen(vehicle, 3, false)             
     end		   
   end
	   
	if data2.current.value == 'Open_BLDoor' then
       local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)			
    if GetVehicleDoorAngleRatio(vehicle, 2) > 0.0 then 
       SetVehicleDoorShut(vehicle, 2, false)            
    else
       SetVehicleDoorOpen(vehicle, 2, false)             
     end
   end			 
 end,
      function(data2, menu2)
      menu2.close()
   end
   )
  end	  	  
end,
    function(data, menu)
    menu.close()
    end
   )
end

function toggleLight0()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	SetVehicleLightMultiplier(vehicle, 1.0)		   
end
function toggleLight1()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	SetVehicleLightMultiplier(vehicle, 2.5)		   
end
function toggleLight2()  
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)  
	SetVehicleLightMultiplier(vehicle, 5.0)		   
end
function toggleLight3() 
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)   
	SetVehicleLightMultiplier(vehicle, 7.5)		   
end
function toggleLight4()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	SetVehicleLightMultiplier(vehicle, 10.0)		   
end
 function toggleLight5()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	SetVehicleLightMultiplier(vehicle, 15.0)		   
end
  
RegisterNetEvent("esx_darcoche:Dar")
AddEventHandler("esx_darcoche:Dar", function()
	DarCoche()
end)

function DarCoche()
	local coords    = GetEntityCoords(PlayerPedId())

	if IsPedInAnyVehicle(PlayerPedId(),  false) then
		vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	else
		vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
	end
	
	local plate = GetVehicleNumberPlateText(vehicle)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	
	ESX.TriggerServerCallback('esx_darcoche:requestPlayerCars', function(isOwnedVehicle)

     if isOwnedVehicle then	
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

      if closestPlayer == -1 or closestDistance > 3.0 then
         ESX.ShowNotification('No players nearby!')
     else
        --  ESX.ShowNotification('You Have Now Transfered Your Vehicle With The Plate ~g~'..vehicleProps.plate..'!')
        --  TriggerServerEvent('esx_darcoche:setVehicleOwnedPlayerId', GetPlayerServerId(closestPlayer), vehicleProps)
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sellcar', {
			title = 'sellcar'
		}, function(data, menu)
			local amount = tonumber(data.value)

			if amount == nil then
				ESX.ShowNotification(_U('invalid_amount'))
			else
				menu.close()
				TriggerServerEvent('cr_actions:sellvehicle', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), vehicleProps, amount)
			end
		end, function(data, menu)
			menu.close()
		end)
     end
   else
		ESX.ShowNotification('~r~You Do Not Own This Vehicle')
	  end
   end, GetVehicleNumberPlateText(vehicle))
end

RegisterNetEvent("cr_actions:opensalesmenu")
AddEventHandler("cr_actions:opensalesmenu", function(OwnerServerId, SalesServerId, vehicleProps, Price)
	ESX.UI.Menu.CloseAll()
	local elements = {
		{label = "Are You Sure You Want To Pay:<span style='color:green'> $" .. Price .. "</span> For the car with the plate: " .. vehicleProps.plate, value = 'no'},
		{label = "Yes", value = 'yes'},
		{label = "No", value = 'no'},
	}
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'sales_menu',
		{
			title    = 'Vehicle Transfer',
			align    = 'bottom-right',
			css      = 'gps',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'yes') then
				TriggerServerEvent('cr_actions:sellvehicle2', OwnerServerId, SalesServerId, vehicleProps, Price)
				--print(GetPlayerServerId(PlayerId()))
				--TriggerEvent('esx_darcoche:Dar')					
			end
			if(data.current.value == 'no') then
				--print(GetPlayerServerId(PlayerId()))
				menu.close()				
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end)
 
carblacklist = { 
   -- 'CustomNova',
   -- 'cmaloo',
   -- 'arcticlux',
   -- 'vlwalky',
   -- 'vkhdt',
   -- 'vkorig',
   -- '96gtsr',
   -- 'W427',
   -- '06gto',
   -- 'racechevelle',  
   -- 'civic',
   -- 'hoonigan',
   -- '351gt',
   -- 'Ghoonigan',  
   -- 'cmaverick',
   -- 'torana',
   -- 'torana2',
   -- 'sandman',
   -- 'sandman2',  
   -- 'xygt',
   -- 'xygt2',
   -- 'bt1',
   -- 'slturbo', 
   -- 'dragbt1',   
   -- 'cvfgts'  
}

function checkCar(car)
    if car then
	   carModel = GetEntityModel(car)
	   carName = GetDisplayNameFromVehicleModel(carModel)
	   
	if isCarBlacklisted(carModel) then
	   ESX.ShowNotification("Server Rule! You Can Not Sell This Vehicle!")	
	  else 
	   reparation()	
	 end
   end
 end

function isCarBlacklisted(model)
	for _, blacklistedCar in pairs(carblacklist) do
	 if model == GetHashKey(blacklistedCar) then
		return true
	  end
	end
	return false
end
   
function reparation()

	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = "Are You Sure You Want To Transfer This Vehicle? <span style='color:red'>This will cost </span><span style='color:green'>$1000</span>", value = 'yes'},
	}
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'delete_menu',
		{
			title    = 'Vehicle Transfer',
			align    = 'bottom-right',
			css      = 'gps',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'yes') then
				--print(GetPlayerServerId(PlayerId()))
				TriggerEvent('esx_darcoche:Dar')					
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end  
  
function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function toggleInteriorLights(ped, veh)
    if IsPedInVehicle(ped, veh, false) then
        if IsVehicleInteriorLightOn(veh) then
            SetVehicleInteriorlight(veh, false)
        else
            SetVehicleInteriorlight(veh, true)
        end
    else
		ESX.ShowNotification("You Must Be In A Vehicle To Use This")	
    end
end

local Anchored = false
Citizen.CreateThread(function()
	while true do
		Wait(10)
							
	if IsPedInAnyBoat(PlayerPedId()) then
		local Vehicle = GetVehiclePedIsIn(PlayerPedId(), 0)
		local speedkph 	= 20
	    local speeed 	= speedkph/3.6		
		
	    if IsControlJustPressed(0, 47) and not IsBoatAnchoredAndFrozen(Vehicle) then
		
		if GetEntitySpeed(Vehicle) < speeed then		 
	       SetBoatAnchor(Vehicle , true)
		   SetBoatFrozenWhenAnchored(Vehicle , true)
		   ESX.ShowNotification("Anchor Has Been Dropped")	
		   Anchored = true
	   else
		   ESX.ShowNotification("You Are Going To Fast To Anchor")	
		end 
		 
	elseif IsControlJustPressed(0, 47) and IsBoatAnchoredAndFrozen(Vehicle) then
		   SetBoatAnchor(Vehicle , false)
		   SetBoatFrozenWhenAnchored(Vehicle , false)
		   ESX.ShowNotification("Anchor Has Been Retrieved")
           Anchored = false		   
	     end
	else
	     Citizen.Wait(1000)
      end
   end
end)
 
--Seat shuffle
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(PlayerPedId(), false) and disableShuffle then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), 0) == PlayerPedId() then
				if GetIsTaskActive(PlayerPedId(), 165) then
				   SetPedIntoVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 0)
				end
			end
		else
	        Citizen.Wait(1000)
		end
	end
end)

--Vehicle Damage
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if IsPedInAnyVehicle(PlayerPedId(), false) then
		   local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
			
			if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
			   local health = GetVehicleBodyHealth(playerVeh)
				
				if health <= 600 then
				   SetVehicleEngineHealth(playerVeh, 1)	
				end			   
				if health <= 500 then 
				   SetVehicleEngineOn(playerVeh, false, true)
				   SetVehicleUndriveable(playerVeh, true)
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()--Stop People Kicking Drivers Out Of Vehicles When Entering By Holding F
   while true do
      Citizen.Wait(250)
	  
	    if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then         		
		   DisableControlAction(0, 23,  true)    
		end		
    end
end)

RegisterNetEvent('CR_VehicleActions:syncNeons')
AddEventHandler('CR_VehicleActions:syncNeons', function(NeonSync)
    SyncedNeons = NetToVeh(NeonSync)
	
	Neons = {0, 1, 2, 3}
 
    for i = 1, #Neons do
	    if IsVehicleNeonLightEnabled(SyncedNeons, Neons[i]) then		
	       SetVehicleNeonLightEnabled(SyncedNeons, Neons[i], false)
       else
	       SetVehicleNeonLightEnabled(SyncedNeons, Neons[i], true)             
        end
	end
end)

RegisterKeyMapping('actionsmenu', 'Action Menu', 'keyboard', 'F1')

RegisterCommand('actionsmenu', function()

local elements = {}

if (IsPedSittingInAnyVehicle(PlayerPedId())) then
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) 
    if (GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()) then 
		table.insert(elements, {label = 'Vehicle Actions',    value = 'actions'})
	end
else
	table.insert(elements, {label = 'Player Actions',    value = 'actions'})
	table.insert(elements, {label = 'Animations',    value = 'animations'})
end

table.insert(elements, {label = 'Invoices',    value = 'invoice'})
table.insert(elements, {label = 'Keys',     value = 'keys'})
table.insert(elements, {label = 'Skills',    value = 'skills'})
table.insert(elements, {label = 'Information Tablet',    value = 'tab'})
table.insert(elements, {label = 'Collections',    value = 'collections'})
table.insert(elements, {label = 'Uber Delivery',    value = 'uber'})
		
ESX.UI.Menu.CloseAll()
ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'actionmenu',
	{
	title    = 'Action Menu',
	align    = 'bottom-right',
	elements = elements
	},
	function(data, menu)

	if data.current.value == 'actions' then
		menu.close()
		TriggerEvent('CR_Actions:OpenMenu')	
	elseif data.current.value == 'animations' then
		menu.close()
	    TriggerEvent("DPEmotes:Open")--Animations
	elseif data.current.value == 'invoice' then
		menu.close()
		TriggerEvent("esx_billing:OpenMenu")--Invoices
	elseif data.current.value == 'keys' then
		menu.close()
		TriggerEvent("loaf_keysystem:openMenu")
	elseif data.current.value == 'skills' then
		menu.close()
		TriggerEvent("CR_Skills:openMenu")
	elseif data.current.value == 'tab' then
		menu.close()
		TriggerEvent("Tab:Open")
	elseif data.current.value == 'collections' then
		menu.close()
		TriggerEvent("CR_Collector:OpenMenu")
	elseif data.current.value == 'uber' then
		menu.close()
		TriggerEvent("civlife_uberdelivery:start")
	end    

	end,
	function(data, menu)
	menu.close()
	end
)
end, false)

RegisterNetEvent('AGN:ShowVehicleLicense')
AddEventHandler('AGN:ShowVehicleLicense', function()

    local player, distance = ESX.Game.GetClosestPlayer()	
	  
    if distance ~= -1 and distance <= 3.0 then
	   TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'Drivers_License')
   else
	   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~SELF ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] No players Nearby, Showing Yourself', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
	   TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'Drivers_License')
	end
end)

RegisterNetEvent('AGN:ShowWeaponLicense')
AddEventHandler('AGN:ShowWeaponLicense', function(job)

    local player, distance = ESX.Game.GetClosestPlayer()
  
    if distance ~= -1 and distance <= 3.0 then
	   TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')	   	  		  
   else
       local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~SELF ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] No players Nearby, Showing Yourself', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
       TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')		
    end	
end)