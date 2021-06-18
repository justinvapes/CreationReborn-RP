ESX               = nil
landscapingValue  = nil
roadworksValue    = nil
weedValue         = nil
auspostValue      = nil
fightingValue     = nil
staminaValue      = nil

local EnabledMenu = false

Citizen.CreateThread(function()
  while ESX == nil do
     TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
     Citizen.Wait(0)
  end
end)

function round2(num, numDecimalPlaces)
	local mult = 10^(0)
	return math.floor(num * mult + 0.5) 
end

function staminaCheck()
	if staminaValue == nil then
		ESX.TriggerServerCallback('AGNSkill:getSkills', function(roadworks, landscaping, auspost, weed, fighting, stamina)
		
			landscapingValue = landscaping
			roadworksValue   = roadworks
			weedValue        = weed
			auspostValue     = auspost
			fightingValue    = fighting
			staminaValue     = stamina
	
			StatSetInt("MP0_STRENGTH",         round2(fighting), true)
			StatSetInt("MP0_STAMINA",          round2(stamina), true)
			StatSetInt('MP0_LUNG_CAPACITY',    round2(stamina), true)
			
			
			StatSetInt('MP0_SHOOTING_ABILITY', 0, true)
			StatSetInt('MP0_WHEELIE_ABILITY',  0, true)
			StatSetInt('MP0_DRIVING_ABILITY',  0, true)
			StatSetInt('MP0_STEALTH_ABILITY',  0, true)
			StatSetInt('MP0_FLYING_ABILITY',   100, true)
			return round2(staminaValue)
		end)
	end
    return round2(staminaValue)
end


RegisterNetEvent('AGNSkill:sendPlayerSkills')
AddEventHandler('AGNSkill:sendPlayerSkills', function(roadworks, landscaping, auspost, weed, fighting, stamina)
	landscapingValue = landscaping
	roadworksValue   = roadworks
	weedValue        = weed
	auspostValue     = auspost
	fightingValue    = fighting
	staminaValue     = stamina
	
	StatSetInt("MP0_STRENGTH",         round2(fighting), true)
	StatSetInt("MP0_STAMINA",          round2(stamina), true)
	StatSetInt('MP0_LUNG_CAPACITY',    round2(stamina), true)
	
	
	StatSetInt('MP0_SHOOTING_ABILITY', 0, true)
	StatSetInt('MP0_WHEELIE_ABILITY',  0, true)
	StatSetInt('MP0_DRIVING_ABILITY',  0, true)
	StatSetInt('MP0_STEALTH_ABILITY',  0, true)
	StatSetInt('MP0_FLYING_ABILITY',   100, true)
end)

function EnableGui(enable)
	if roadworksValue == nil or landscapingValue == nil or weedValue == nil or auspostValue == nil or fightingValue == nil or staminaValue == nil then
	
		ESX.TriggerServerCallback('AGNSkill:getSkills', function(roadworks, landscaping, auspost, weed, fighting, stamina)
		
		landscapingValue = landscaping
		roadworksValue   = roadworks
		weedValue        = weed
		auspostValue     = auspost
		fightingValue    = fighting
		staminaValue     = stamina

		StatSetInt("MP0_STRENGTH",         round2(fighting), true)
		StatSetInt("MP0_STAMINA",          round2(stamina), true)
		StatSetInt('MP0_LUNG_CAPACITY',    round2(stamina), true)
		
		
		StatSetInt('MP0_SHOOTING_ABILITY', 0, true)
		StatSetInt('MP0_WHEELIE_ABILITY',  0, true)
		StatSetInt('MP0_DRIVING_ABILITY',  0, true)
		StatSetInt('MP0_STEALTH_ABILITY',  0, true)
		StatSetInt('MP0_FLYING_ABILITY',   100, true)

	SendNUIMessage({
		type        = "enableui",
		enable      = enable,
		roadworks   = roadworksValue,
		landscaping = landscapingValue,
		auspost     = auspostValue,
		weed        = weedValue,
		fighting    = fightingValue, 
		stamina     = staminaValue
	  })
   end)
   
 else	
	
	SetNuiFocus(enable)
	guiEnabled = enable

	SendNUIMessage({
		type         = "enableui",
		enable       = enable,
		roadworks    = roadworksValue,
		landscaping  = landscapingValue,
		auspost      = auspostValue,
		weed         = weedValue,
		fighting     = fightingValue, 
		stamina      = staminaValue
	  })
   end
end

-- Citizen.CreateThread(function()
-- 	while true do

--         if guiEnabled then

--           if IsDisabledControlJustReleased(0, 170) then
-- 		     EnabledMenu = true
		  
--             SendNUIMessage({
--               type = "click"
--             })			
--          end
		 
-- 		else
-- 			if IsDisabledControlJustReleased(0, 170) then
-- 			   EnableGui(true)
-- 			   EnabledMenu = true
-- 			   SetNuiFocus(true, true)
-- 			end
--         end
--         Citizen.Wait(1)
--     end
-- end)

RegisterNUICallback('quit', function(data, cb)
  EnableGui(false)
  EnabledMenu = false
  SetNuiFocus(false, false)
end)

AddEventHandler("CR_Skills:openMenu", function()
		EnableGui(true)
		EnabledMenu = true
		SetNuiFocus(true, true)
end)

Citizen.CreateThread( function()	
 while true do 
    Citizen.Wait(1)

	if EnabledMenu == true then
       DisableControlAction(0, 1, true) -- LookLeftRight
       DisableControlAction(0, 2, true) -- LookUpDown
       DisableControlAction(0, 24, true) -- Attack         
       DisableControlAction(0, 142, true) -- MeleeAttackAlternate
       DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
	   DisableControlAction(0, 288, true) -- F1
	   DisableControlAction(0, 289, true) -- F2
	   DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
    end
  end 
end)