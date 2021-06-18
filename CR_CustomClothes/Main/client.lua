ESX                = nil
local Times        = 0
local Times2       = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
 while true do
 
   local sleep = 1000 		
   local playerPos = GetEntityCoords(PlayerPedId())	
	   
	for i = 1, #Config.SicarioCloakRoom do
	
	    local SicCloak = vector3(Config.SicarioCloakRoom[i].x, Config.SicarioCloakRoom[i].y, Config.SicarioCloakRoom[i].z)
		local distance = #(playerPos - SicCloak)
					 
		if distance <= 7 then
		   sleep = 5
		   DrawMarker(21, Config.SicarioCloakRoom[i].x, Config.SicarioCloakRoom[i].y, Config.SicarioCloakRoom[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.301, 0.301, 0.3001, 255, 0, 0, 200, false, true, 2, true, false, false, false)
        end
		 
		if distance <= 0.5 then
		   hintToDisplay('~y~Press ~w~ ~INPUT_CONTEXT~ To Open The ~b~CloakRoom')
		   Times = 1
				
			if IsControlJustPressed(0, 38) then
			
				ESX.TriggerServerCallback('AGN:SicarioCheck', function(Sicario) 
			    if Sicario == true then				 
					local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~LSC ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Opening Cloakroom Please Wait', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
			    	OpenSicarioCloakRoom()
			   else   				   
				   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~LSC ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Are Not A Member', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
			    end
			  end)	
			end	
        else
		    if Times == 1 then
		       ESX.UI.Menu.CloseAll()
			   Times = 0
		   end
         end 			 
	  end
	  	  
	for i = 1, #Config.PaleRidersCloakRoom do
		
	    local SicCloak = vector3(Config.PaleRidersCloakRoom[i].x, Config.PaleRidersCloakRoom[i].y, Config.PaleRidersCloakRoom[i].z)
		local distance = #(playerPos - SicCloak)
			 
		if distance <= 7 then
		   sleep = 5
		   DrawMarker(21, Config.PaleRidersCloakRoom[i].x, Config.PaleRidersCloakRoom[i].y, Config.PaleRidersCloakRoom[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.301, 0.301, 0.3001, 255, 0, 0, 200, false, true, 2, true, false, false, false)
        end
		 
		if distance <= 0.5 then
		   hintToDisplay('~y~Press ~w~ ~INPUT_CONTEXT~ To Open The ~b~CloakRoom')
		   Times2 = 1
				
			if IsControlJustPressed(0, 38) then
			
			    ESX.TriggerServerCallback('AGN:PaleRidersMemberCheck', function(PaleRiderMember) 
			    if PaleRiderMember then				 
				   OpenPaleRidersCloakRoom()
				   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PALE RIDER ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Opening Cloakroom Please Wait', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
			   else   				   
				   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PALE RIDER ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Are Not A Pale Rider Member', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
			    end
			  end)	
			end	
        else
		    if Times2 == 1 then
		       ESX.UI.Menu.CloseAll()
			   Times2 = 0
		   end
         end 			 
	  end  	  	  	  
	  Citizen.Wait(sleep)
   end
end)

function OpenSicarioCloakRoom()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'Sicario_CloakRoom',
        {
        title    = 'Clothes',
	    align    = 'bottom-right',
		css      = 'superete',
        elements = {
		    {label = 'Remove Hoodie', value = 'Remove'},
			{label = 'Black Hoodie [Sicario]',  value = 'Black_Hoodie'},
			{label = 'White Hoodie [Sicario]',  value = 'White_Hoodie'},
			{label = 'White Hoodie [LSC]', value = 'White_HoodieR'},
			{label = 'Black Hoodie [LSC]', value = 'Black_HoodieR'},
            }
        },
        function(data, menu)
		
        if data.current.value == 'Black_Hoodie' then
		   SetBlackHoodie(data.current.value)
		elseif data.current.value == 'Black_HoodieR' then
		   SetBlackHoodieR(data.current.value)  
        elseif data.current.value == 'White_Hoodie' then
		   SetWhiteHoodie(data.current.value)
		elseif data.current.value == 'White_HoodieR' then
		   SetWhiteHoodieR(data.current.value)   
        elseif data.current.value == 'Remove' then
		   SetNone(data.current.value)
	    end			 
    end,
       function(data, menu)
       menu.close()
	   currentopen = false
    end
   )
end

function OpenPaleRidersCloakRoom()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'PaleRiders_CloakRoom',
        {
        title    = 'Vests',
	    align    = 'bottom-right',
		css      = 'superete',
        elements = {
		    {label = 'Remove Vest', value = 'Remove'},
			{label = 'Prospect Vest', value = 'Prospect'},
			{label = 'Member Vest', value = 'Member'},
            }
        },
        function(data, menu)
		
        if data.current.value == 'Prospect' then
		   SetProspectVest(data.current.value)
			   
        elseif data.current.value == 'Member' then				 
		   SetMemeberVest(data.current.value)		

        elseif data.current.value == 'Remove' then
		   SetNone(data.current.value)
	    end			 
    end,
       function(data, menu)
       menu.close()
	   currentopen = false
    end
   )
end

--Black Hoodie
function SetBlackHoodie(Type)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
	
        if Config.Clothes[Type].male ~= nil then
           TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[Type].male)
		   Citizen.Wait(500)		   
		   TriggerEvent('skinchanger:getSkin', function(skin)
		   TriggerServerEvent('esx_skin:save', skin)
		end)
      end	  
    else	
        if Config.Clothes[Type].female ~= nil then
           TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[Type].female)
		   Citizen.Wait(500)		   
		   TriggerEvent('skinchanger:getSkin', function(skin)
		   TriggerServerEvent('esx_skin:save', skin)
		end)
      end
    end
  end)
end

--Black Hoodie Renegade
function SetBlackHoodieR(Type)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
	
        if Config.Clothes[Type].male ~= nil then
           TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[Type].male)
		   Citizen.Wait(500)		   
		   TriggerEvent('skinchanger:getSkin', function(skin)
		   TriggerServerEvent('esx_skin:save', skin)
		end)
      end	  
    else	
        if Config.Clothes[Type].female ~= nil then
           TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[Type].female)
		   Citizen.Wait(500)		   
		   TriggerEvent('skinchanger:getSkin', function(skin)
		   TriggerServerEvent('esx_skin:save', skin)
		end)
      end
    end
  end)
end

--White Hoodie
function SetWhiteHoodie(Type)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
	
        if Config.Clothes[Type].male ~= nil then
           TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[Type].male)
		   Citizen.Wait(500)		   
		   TriggerEvent('skinchanger:getSkin', function(skin)
		   TriggerServerEvent('esx_skin:save', skin)
		end)
      end	  
    else	
        if Config.Clothes[Type].female ~= nil then
           TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[Type].female)
		   Citizen.Wait(500)		   
		   TriggerEvent('skinchanger:getSkin', function(skin)
		   TriggerServerEvent('esx_skin:save', skin)
		end)
      end
    end
  end)
end

--White Hoodie
function SetWhiteHoodieR(Type)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
	
        if Config.Clothes[Type].male ~= nil then
           TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[Type].male)
		   Citizen.Wait(500)		   
		   TriggerEvent('skinchanger:getSkin', function(skin)
		   TriggerServerEvent('esx_skin:save', skin)
		end)
      end	  
    else	
        if Config.Clothes[Type].female ~= nil then
           TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[Type].female)
		   Citizen.Wait(500)		   
		   TriggerEvent('skinchanger:getSkin', function(skin)
		   TriggerServerEvent('esx_skin:save', skin)
		end)
      end
    end
  end)
end

--Prospect Vest
function SetProspectVest(Type)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
	
        if Config.Clothes[Type].male ~= nil then
           TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[Type].male)		   
		   Citizen.Wait(500)		   
		   TriggerEvent('skinchanger:getSkin', function(skin)
		   TriggerServerEvent('esx_skin:save', skin)
		end)
      end	  
    end
  end)
end

--Member Vest
function SetMemeberVest(Type)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
	
        if Config.Clothes[Type].male ~= nil then
           TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[Type].male)		   
		   Citizen.Wait(500)		   
		   TriggerEvent('skinchanger:getSkin', function(skin)
		   TriggerServerEvent('esx_skin:save', skin)
		end)
      end	  
    end
  end)
end

--None
function SetNone(Type)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
	
        if Config.Clothes[Type].male ~= nil then
           TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[Type].male)		   
		   Citizen.Wait(500)		   
		   TriggerEvent('skinchanger:getSkin', function(skin)
		   TriggerServerEvent('esx_skin:save', skin)
		end)
      end	  
    else	
        if Config.Clothes[Type].female ~= nil then
           TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[Type].female)		   
		   Citizen.Wait(500)		   
		   TriggerEvent('skinchanger:getSkin', function(skin)
		   TriggerServerEvent('esx_skin:save', skin)
	    end)
      end
    end
  end)
end

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end