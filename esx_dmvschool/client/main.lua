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

ESX                     = nil
local CurrentAction     = nil
local CurrentActionMsg  = nil
local CurrentActionData = nil
local Licenses          = {}
local CurrentTest       = nil
local CurrentTestType   = nil
local CurrentVehicle    = nil
local CurrentCheckPoint = 0
local LastCheckPoint    = -1
local CurrentBlip       = nil
local CurrentZoneType   = nil
local DriveErrors       = 0
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, true)
end

function StartTheoryTest()
	CurrentTest = 'theory'

	SendNUIMessage({
		openQuestion = true
	})

	ESX.SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)

	TriggerServerEvent('221ab737-b915-4a2e-8a2c-6e6e795ca610', Config.Prices['dmv'])
end

function StopTheoryTest(success)
	CurrentTest = nil

	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)

	if success then
	    ESX.ShowNotification(_U('passed_test'))
		Citizen.Wait(1000)
		TriggerServerEvent('d663466c-c816-413f-8166-ded3d0ceca5b', 'Drivers_License')						
	else
		ESX.ShowNotification(_U('failed_test'))
	end
end



function OpenDMVSchoolMenu()

	local elements = {}
	
    table.insert(elements, {label = (('%s: <span style="color:green;">%s</span>'):format(_U('theory_test'), _U('school_item', ESX.Math.GroupDigits(Config.Prices['dmv'])))),value = 'theory_test'})
		

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dmvschool_actions', {
		title    = _U('driving_school'),
		elements = elements,
		align    = 'bottom-right',
	    css      = 'superete',
	}, function(data, menu)
	
		if data.current.value == 'theory_test' then
			menu.close()
			StartTheoryTest()
			
		elseif data.current.value == 'NewCard' then
		OpenSubMenu()				
		end		
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'dmvschool_menu'
		CurrentActionMsg  = _U('press_open_menu')
		CurrentActionData = {}
	end)
end


function OpenSubMenu()

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
		
		 TriggerServerEvent("esx_dmvschool:CheckMoney")		  		   		   				  
	  else
	      exports['mythic_notify']:DoHudText('error', 'You Already Have One Of These On You')
	 end
   end, 'VehicleLicense')
			
	    elseif(data.current.value == 'no') then
		menu.close()		
	 end
	end,
	   function(data, menu)
		menu.close()
	 end
	)
end  


RegisterNetEvent('esx_dmvschool:Success')
AddEventHandler('esx_dmvschool:Success', function()
	
 TriggerEvent("mythic_progbar:client:progress", {
        name = "renting_motel",
        duration = 5500,
        label = "Signing Paperwork",
        useWhileDead = false,
        canCancel = true,
					
        controlDisables = {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
       },
        animation = {
        animDict = "missheistdockssetup1clipboard@idle_a",
        anim = "idle_a",
       },
        prop = {
        model = "prop_notepad_01"	
        }
     }, function(status)		                     
		ClearPedTasks(PlayerPedId())
	    TriggerServerEvent("esx_dmvschool:BuyNewCard")
      end)   	
end)

RegisterNUICallback('question', function(data, cb)
	SendNUIMessage({
		openSection = 'question'
	})

	cb()
end)

RegisterNUICallback('close', function(data, cb)
	StopTheoryTest(true)
	cb()
end)

RegisterNUICallback('kick', function(data, cb)
	StopTheoryTest(false)
	cb()
end)

AddEventHandler('esx_dmvschool:hasEnteredMarker', function(zone)
	if zone == 'DMVSchool' then
		CurrentAction     = 'dmvschool_menu'
		CurrentActionMsg  = _U('press_open_menu')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_dmvschool:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('esx_dmvschool:loadLicenses')
AddEventHandler('esx_dmvschool:loadLicenses', function(licenses)
	Licenses = licenses
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.DMVSchool.Pos.x, Config.Zones.DMVSchool.Pos.y, Config.Zones.DMVSchool.Pos.z)

	SetBlipSprite (blip, 408)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.2)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('driving_school_blip'))
	EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    while(true) do
        inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
		coords    = GetEntityCoords(PlayerPedId())
        Citizen.Wait(500)
    end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)


		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(100)

		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_dmvschool:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_dmvschool:hasExitedMarker', LastZone)
		end
	end
end)

-- Block UI
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if CurrentTest == 'theory' then

			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		else
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'dmvschool_menu' then
				
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
	
               if hasLicense then
                OpenSubMenu()
            else
                OpenDMVSchoolMenu()
             end		
            end, GetPlayerServerId(PlayerId()), 'Drivers_License')								
		 end
				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)


Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("ig_abigail"))
    while not HasModelLoaded(GetHashKey("ig_abigail")) do
      Wait(1)
    end
      local DMVPED =  CreatePed(4, 0x400AEC41, -211.74, -1927.58, 26.77, 307.99, false, true)
      SetEntityHeading(DMVPED, 307.99)
      FreezeEntityPosition(DMVPED, true)
      SetEntityInvincible(DMVPED, true)
      SetBlockingOfNonTemporaryEvents(DMVPED, true)
	  SetModelAsNoLongerNeeded(DMVPED)
end)