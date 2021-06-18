
ESX = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local ShopOpen                = false
local shownotify              = 0 

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if ShopOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)

AddEventHandler('esx_weaponshop:hasEnteredMarker', function(zone)
	if zone == 'GunShop' then 
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu_prompt')
		CurrentActionData = { zone = zone }
		
	elseif zone == 'BlackWeashop' then
	    CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('blackmarket_menu_prompt')
		CurrentActionData = { zone = zone }
	end
end)

AddEventHandler('esx_weaponshop:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
	shownotify = 0	
end)

function OpenShopMenu(zone, area)
	local elements = {}
	ShopOpen = true
	
	local playerPed = PlayerPedId()
	PlayerData = ESX.GetPlayerData()

	for k,v in ipairs(Config.Zones[zone].Items) do
	
		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
		local components, label = {}

		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

		if v.components then
			for i=1, #v.components do
				if v.components[i] then

				local component = weapon.components[i]
				local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)

				if hasComponent then
				   label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('gunshop_owned'))
			   else
				    if v.components[i] > 0 then
					   label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('gunshop_item', ESX.Math.GroupDigits(v.components[i])))
				   else
					   label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('gunshop_free'))
					end
			      end

				table.insert(components, {
					label = label,
					componentLabel = component.label,
					hash = component.hash,
					name = component.name,
					price = v.components[i],
					hasComponent = hasComponent,
					componentNum = i
				   })
				end
			end
		end		

		if hasWeapon and v.components then
			label = ('%s: <span style="color:yellow;">[Owned] - Add Attachments</span>'):format(weapon.label)			
		elseif hasWeapon and not v.components then
			label = ('%s: <span style="color:green;"></span>'):format(weapon.label)
		else
			if v.price > 0 then
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('gunshop_item', ESX.Math.GroupDigits(v.price)))
			else
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('gunshop_free'))
			end
		end
		
		table.insert(elements, {
			label = label,
			weaponLabel = weapon.label,
			name = weapon.name,
			components = components,
			price = v.price,
			hasWeapon = hasWeapon
		 })		
	end
	
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
	
	if area == 'Blackmarket' then
	   title = ('Black Market')
    else
	   title = ('Ammu-Nation')
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gunshop_buy_weapons', {
		title    = title,
		align    = 'bottom-right',
	    css      = 'ammu',
		elements = elements
	}, function(data, menu)

		if data.current.hasWeapon then
			if #data.current.components > 0 then
				OpenWeaponComponentShopMenu(data.current.components, data.current.name, menu, zone)			
			end				
		else
			ESX.TriggerServerCallback('esx_weaponshop:buyWeapon', function(bought)
			if bought then
			
				if data.current.price > 0 then
				   DisplayBoughtScaleform('weapon',data.current.name, ESX.Math.GroupDigits(data.current.price))
				   Citizen.Wait(150)
				   TriggerServerEvent('esx_weaponshop:UpdateLoadout')
			    end						
					PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
					menu.close()
					OpenShopMenu(zone)
					ShopOpen = false
				else
					PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
				end
			end, data.current.name, 1, nil, zone)
		end
	end, function(data, menu)
		 PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		 ShopOpen = false
		 menu.close()
	end)
end

function OpenWeaponComponentShopMenu(components, weaponName, parentShop,zone)
	ShopOpen = true
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gunshop_buy_weapons_components', {
		title    = _U('gunshop_componenttitle'),
		align    = 'bottom-right',
	    css      = 'ammu',
		elements = components
	}, function(data, menu)

		ESX.TriggerServerCallback('esx_weaponshop:buyWeapon', function(bought)
		if bought then
		
			if data.current.price > 0 then
			   DisplayBoughtScaleform('component',data.current.componentLabel, ESX.Math.GroupDigits(data.current.price))
			   Citizen.Wait(150)
			   TriggerServerEvent('esx_weaponshop:UpdateLoadout')
			end
				ShopOpen = false
				menu.close()
				parentShop.close()
				PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
				OpenShopMenu(zone)
			else
				PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
			 end
		  end, weaponName, 2, data.current.componentNum, zone)
	
	end, function(data, menu)
		 PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		 ShopOpen = false
		 menu.close()
	end)
end

function DisplayBoughtScaleform(type, item, price)
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')
	local sec = 4

	if type == 'component' then
		text = _U('gunshop_bought', item, ESX.Math.GroupDigits(price))
		text2 = nil
		text3 = nil
	elseif type == 'weapon' then
		text2 = ESX.GetWeaponLabel(item)
		text = _U('gunshop_bought', text2, ESX.Math.GroupDigits(price))
		text3 = GetHashKey(item)
	end

	BeginScaleformMovieMethod(scaleform, 'SHOW_WEAPON_PURCHASED')
	PushScaleformMovieMethodParameterString(text)
	
	if text2 then
	   PushScaleformMovieMethodParameterString(text2)
	elseif text3 then
	   PushScaleformMovieMethodParameterInt(text3)
	end
	
	PushScaleformMovieMethodParameterString('')
	PushScaleformMovieMethodParameterInt(100)
	EndScaleformMovieMethod()
	PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)

	Citizen.CreateThread(function()
		while sec > 0 do
			Citizen.Wait(0)
			sec = sec - 0.01	
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end
	end)
end

-- Create Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones) do
	  if v.Legal then
	    for i = 1, #v.Locations, 1 do
		
		local blip = AddBlipForCoord(v.Locations[i])

		 SetBlipSprite (blip, 110)
		 SetBlipDisplay(blip, 4)
		 SetBlipScale  (blip, 1.0)
		 SetBlipColour (blip, 81)
		 SetBlipAsShortRange(blip, true)
		 BeginTextCommandSetBlipName("STRING")
		 AddTextComponentSubstringPlayerName(_U('map_blip'))
		 EndTextCommandSetBlipName(blip)
	  end
    end
  end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Locations, 1 do
				if (Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Locations[i], true) < Config.DrawDistance) then
					DrawMarker(Config.Type, v.Locations[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, true, false, false, false)
				end
			end
		end				
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker, currentZone = false, nil

		for k,v in pairs(Config.Zones) do
			for i=1, #v.Locations, 1 do
				if GetDistanceBetweenCoords(coords, v.Locations[i], true) < 0.5 then
					isInMarker, ShopItems, currentZone, LastZone = true, v.Items, k, k
				end
			end
		end
				
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_weaponshop:hasEnteredMarker', currentZone)
		end
		
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_weaponshop:hasExitedMarker', LastZone)
		end
	end
end)

--Key Controls
Citizen.CreateThread(function()
	while true do
	  local sleep = 250
			
		if CurrentAction ~= nil then	
		   sleep = 5
			
			if shownotify == 0 then
			   ESX.ShowHelpNotification(CurrentActionMsg)
			end
			
			if IsControlJustReleased(0, 38) then
			   shownotify = 1
				
				if CurrentAction == 'shop_menu' then
					if Config.LicenseEnable and Config.Zones[CurrentActionData.zone].Legal then
						
						ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
							if hasWeaponLicense then
								
								local inventory = ESX.GetPlayerData().inventory
								local count  = 0
								
								for i=1, #inventory, 1 do
									if inventory[i].name == 'WeaponLicense' then
									   count = inventory[i].count
									end
								end

								if (count > 0) then			 					  
									OpenMenu(CurrentActionData.zone)	   
								else
									OpenLicMenu(CurrentActionData.zone)
								end
							else
								OpenBuyLicenseMenu(CurrentActionData.zone)
							end			  
						end, GetPlayerServerId(PlayerId()), 'weapon')	
					else
						OpenMenu(CurrentActionData.zone, 'Blackmarket')	   
					end	            		
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

--Buy License
function OpenBuyLicenseMenu(zone)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_license', {
		title = _U('buy_license'),
		align    = 'bottom-right',
	    css      = 'ammu',
		elements = {
			{label = _U('no'), value = 'no'},
			{label = _U('yes', ('<span style="color: green;">%s</span>'):format((_U('shop_menu_item', ESX.Math.GroupDigits(Config.LicensePrice))))), value = 'yes'},
		}
	}, function(data, menu)
	
	 if data.current.value == 'yes' then	
	 			
		ESX.TriggerServerCallback('esx_weaponshop:buyLicense', function(bought)
		if bought then
		   menu.close()
		   OpenMenu(zone)
		   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~WEAPON SHOP ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] You Now Have Your Weapon License", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)   
		end
	  end)
	end
	
	if data.current.value == 'no' then	
	   menu.close()
	   shownotify = 0
	end
  end, function(data, menu)
	   menu.close()
	   shownotify = 0
   end)
end

function OpenLicMenu()

	ESX.UI.Menu.CloseAll()

	local elements = {
	    {label = "No Thanks", value = 'no'},
		{label = "Buy New Card For 50?", value = 'yes'},		
	}
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'dmv_menu',
		{
			title    = 'Buy A New License Card?',
			align    = 'bottom-right',
			css      = 'superete',
			elements = elements,
		},
		function(data, menu)
		menu.close()
			
		if(data.current.value == 'yes') then
		
		ESX.TriggerServerCallback('AGN:CheckLicenseCard', function(qtty)  	 
	    if qtty == 0 then
		
		 TriggerServerEvent("esx_weaponshop:CheckMoney")		  		   		   				  
	  else
	      exports['mythic_notify']:DoHudText('error', 'You Already Have One Of These On You')
	 end
   end, 'WeaponLicense')
			
	    elseif(data.current.value == 'no') then
		menu.close()		
	 end
	end,
	   function(data, menu)
		menu.close()
	 end
	)
end  

--Main Menu
function OpenMenu(zone, area)

    local elements = {}
	
	if area == 'Blackmarket' then
	   title = ('Black Market')
    else
	   title = ('Ammu-Nation')
    end
 
    table.insert(elements, {label = ('Buy Weapons'), value = 'BuyWep'})
	table.insert(elements, {label = ('Buy Ammo'), value = 'BuyAmmo'})

    ESX.UI.Menu.CloseAll()
	
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Ammunition_actions', 
    {
        title    = title,
	    align    = 'bottom-right',
	    css      = 'ammu',
        elements = elements
    },
    function(data, menu)
	
    if data.current.value == 'BuyWep' then  
       OpenShopMenu(zone, area)    
    end
		 	
    if data.current.value == 'BuyAmmo' then 

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_vehicle_actions2',
    {
        title    = title,
	    align    = 'bottom-right',
	    css      = 'ammu',		
		elements = {
		  {label = _U('Pistol')..'<span style="color:green;"> $150 </span>', value = 'Pistol'},
		  {label = _U('Smg')..'<span style="color:green;"> $250 </span>', value = 'Smg'},
		  {label = _U('Shotgun')..'<span style="color:green;"> $350 </span>', value = 'Shotgun'},
		  {label = _U('Rifle')..'<span style="color:green;"> $450 </span>', value = 'Rifle'},
		  {label = _U('Sniper')..'<span style="color:green;"> $1000 </span>', value = 'Sniper'},
	    }	
    },
    function(data2, menu2)
		  		    
    if data2.current.value == 'Pistol' then
	   BuyAmmo('Pistol', area)
    elseif data2.current.value == 'Smg' then
	   BuyAmmo('Smg', area)
    elseif data2.current.value == 'Shotgun' then
	   BuyAmmo('Shotgun', area)
	elseif data2.current.value == 'Rifle' then
	   BuyAmmo('Rifle', area)
    elseif data2.current.value == 'Sniper' then
	   BuyAmmo('Sniper', area)			   
	end		 
  end,
    function(data2, menu2)
          menu2.close()
	      shownotify = 0
       end
      )
   end	  	  
 end,
    function(data, menu)
         menu.close()
	     shownotify = 0
      end
    )
end

--Buy Ammo
function BuyAmmo(Weapon, area)

  local elements = {}
  
    if area == 'Blackmarket' then
	   title = ('Black Market')
    else
	   title = ('Ammu-Nation')
    end

  if Weapon == 'Pistol' then
     table.insert(elements, {label = ('Are You Sure You Want To Buy This Ammo?'), value = 'Pistol'})
  elseif Weapon == 'Smg' then
     table.insert(elements, {label = ('Are You Sure You Want To Buy This Ammo?'), value = 'Smg'})
  elseif Weapon == 'Shotgun' then
     table.insert(elements, {label = ('Are You Sure You Want To Buy This Ammo?'), value = 'Shotgun'})
  elseif Weapon =='Rifle' then
     table.insert(elements, {label = ('Are You Sure You Want To Buy This Ammo?'), value = 'Rifle'})
  elseif Weapon =='Sniper' then
     table.insert(elements, {label = ('Are You Sure You Want To Buy This Ammo?'), value = 'Sniper'})	 
  end

  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Ammunition_actions',
    {
      title    = title,
	  align    = 'bottom-right',
	  css      = 'ammu',
      elements = elements
    },
    function(data, menu)
   
    if data.current.value == 'Pistol' then
	   TriggerServerEvent('esx_weaponshop:Ammoclip', 'Pistol', 150)	   
	   menu.close()
	elseif data.current.value == 'Smg' then
	   TriggerServerEvent('esx_weaponshop:Ammoclip', 'Smg', 250)
	   menu.close()
	elseif data.current.value == 'Shotgun' then
	   TriggerServerEvent('esx_weaponshop:Ammoclip', 'Shotgun', 350)
	   menu.close()
	elseif data.current.value == 'Rifle' then
	   TriggerServerEvent('esx_weaponshop:Ammoclip', 'Rifle', 450)
	   menu.close()
	elseif data.current.value == 'Sniper' then
	   TriggerServerEvent('esx_weaponshop:Ammoclip', 'Sniper', 1000)
	   menu.close()   
    end	  
 end,
    function(data, menu)
      menu.close()
   end
   )
end


RegisterNetEvent('esx_weaponshop:Success')
AddEventHandler('esx_weaponshop:Success', function()

    PlaySoundFrontend(-1, "DELETE","HUD_DEATHMATCH_SOUNDSET", 1)
   
end)

RegisterNetEvent('esx_weaponshop:UseAmmoClip')
AddEventHandler('esx_weaponshop:UseAmmoClip', function(Type)


    if IsPedArmed(PlayerPedId(), 4) then  
       hash = GetSelectedPedWeapon(PlayerPedId())
	   Ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), hash, 1)

        if hash ~= nil then
		
		  if Ammo < 2400 then
	  
	        if Type == 'PistolClip' then
		
		    for i = 1, #Config.PistolList do
             if hash == GetHashKey(Config.PistolList[i]) then
                AddAmmoToPed(GetPlayerPed(-1), hash, 50)
			    TriggerServerEvent('esx_weaponshop:RemoveClip','PistolClip')
                ESX.ShowNotification("Used 1x Pistol Ammo Clip")	
             end
		  end
		
		elseif Type == 'SmgClip' then				
		    for i = 1, #Config.SmgList do
              if hash == GetHashKey(Config.SmgList[i]) then
                AddAmmoToPed(GetPlayerPed(-1), hash, 50)
                ESX.ShowNotification("Used 1x Smg Ammo Clip")	
                TriggerServerEvent('esx_weaponshop:RemoveClip','SmgClip')
             end
		  end
		
		elseif Type == 'ShotgunClip' then		   
		    for i = 1, #Config.ShotgunList do
             if hash == GetHashKey(Config.ShotgunList[i]) then
                AddAmmoToPed(GetPlayerPed(-1), hash, 50)
                ESX.ShowNotification("Used 1x Shotgun Ammo Clip")	
                TriggerServerEvent('esx_weaponshop:RemoveClip','ShotgunClip')
             end
		   end 
		
		elseif Type == 'RifleClip' then   
	        for i = 1, #Config.RifleList do
             if hash == GetHashKey(Config.RifleList[i]) then
                AddAmmoToPed(GetPlayerPed(-1), hash, 50)
                ESX.ShowNotification("Used 1x Rifle Ammo Clip")	
                TriggerServerEvent('esx_weaponshop:RemoveClip','RifleClip')
             end
		   end

        elseif Type == 'SniperClip' then   
	        for i = 1, #Config.SniperList do
             if hash == GetHashKey(Config.SniperList[i]) then
                AddAmmoToPed(GetPlayerPed(-1), hash, 50)
                ESX.ShowNotification("Used 1x Sniper Ammo Clip")	
                TriggerServerEvent('esx_weaponshop:RemoveClip','SniperClip')
             end
		   end		   
         end
	   else
        ESX.ShowNotification("This Weapon Has Reached Max Ammo")
	    end
    else
        ESX.ShowNotification("This Type Of Ammunition Is Not Suitable")
     end
  else
    ESX.ShowNotification("You Have No Weapon In Your Hand")
   end  
end)

Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("mp_m_exarmy_01"))	
    while not HasModelLoaded(GetHashKey("mp_m_exarmy_01")) do
      Wait(1)
    end
	
	for _, Peds in pairs(Config.PedLocations) do
	
     local WeaponShopPed = CreatePed(4, 0x45348DBB, Peds.x, Peds.y, Peds.z, Peds.heading, false, true)
     SetEntityHeading(WeaponShopPed, Peds.heading)
     FreezeEntityPosition(WeaponShopPed, true)
     SetEntityInvincible(WeaponShopPed, true)
     SetBlockingOfNonTemporaryEvents(WeaponShopPed, true)
	 SetModelAsNoLongerNeeded(WeaponShopPed)
  end
end)