-- Define the variable used to open/close the tab

local decorName        = nil
local decorInt         = nil
local civ             = {}


RegisterNetEvent("dexac:HereAreYourDecors")
AddEventHandler("dexac:HereAreYourDecors", function( decorN, decorI)
	decorName = decorN
	decorInt = decorI
end)

local tabEnabled = false
local tabLoaded = true --false

function REQUEST_NUI_FOCUS(bool)
    SetNuiFocus(bool, bool) -- focus, cursor
    if bool == true then
        SendNUIMessage({showtab = true})
    else
        SendNUIMessage({hidetab = true})
    end
    return bool
end

RegisterNUICallback(
    "tablet-bus",
    function(data)
        -- Do tablet hide shit
        if data.load then
            --print("Loaded the tablet")
            tabLoaded = true
        elseif data.hide then
            --print("Hiding the tablet")
            SetNuiFocus(false, false) -- Don't REQUEST_NUI_FOCUS here
            tabEnabled = false
        elseif data.click then
        -- if u need click events
        end
    end
)

Citizen.CreateThread(function()
    while(true) do
        inVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
		swimming  = IsPedSwimming(PlayerPedId())
		shooting  = IsPedShooting(PlayerPedId())
		climing   = IsPedClimbing(PlayerPedId())
		cuffed    = IsPedCuffed(PlayerPedId())
		diving    = IsPedDiving(PlayerPedId())
		falling   = IsPedFalling(PlayerPedId())
		jumping   = IsPedJumping(PlayerPedId())
		jumpveh   = IsPedJumpingOutOfVehicle(PlayerPedId())
		onfoot    = IsPedOnFoot(PlayerPedId())
		running   = IsPedRunning(PlayerPedId())
		Scenario  = IsPedUsingAnyScenario(PlayerPedId())
		FreeFall  = IsPedInParachuteFreeFall(PlayerPedId())
        Citizen.Wait(500)
    end
end)


local active = 0
RegisterNetEvent('Tab:Open')
AddEventHandler('Tab:Open', function()
active = 1
end)

Citizen.CreateThread(
    function()
        -- Wait for nui to load or just timeout
        local l = 0
        local timeout = false
        while not tabLoaded do
            Citizen.Wait(0)
            l = l + 1
            if l > 500 then
                tabLoaded = true --
                timeout = true
            end
        end

        if timeout == true then
            --print("Failed to load tablet nui...")
        -- return ---- Quit
        end

        --print("::The client lua for tablet loaded::")

        REQUEST_NUI_FOCUS(false) -- This is just in case the resources restarted whilst the NUI is focused.

        while true do
		
		if not inVehicle and not swimming and not shooting and not climing and not cuffed and not diving and not falling and not jumping and not jumpveh and onfoot and not running and not Scenario and not FreeFall then
		
            if active == 1 then
			    active = 0
				civ.Tablet(true)
                tabEnabled = not tabEnabled -- Toggle tablet visible state
                REQUEST_NUI_FOCUS(tabEnabled)
                --print("The tablet state is: " .. tostring(tabEnabled))
                Citizen.Wait(0)
            end
		  end
            if (tabEnabled) then
                local ped = GetPlayerPed(-1)
                DisableControlAction(0, 1, tabEnabled) -- LookLeftRight
                DisableControlAction(0, 2, tabEnabled) -- LookUpDown
                DisableControlAction(0, 24, tabEnabled) -- Attack
                DisablePlayerFiring(ped, tabEnabled) -- Disable weapon firing
                DisableControlAction(0, 142, tabEnabled) -- MeleeAttackAlternate
                DisableControlAction(0, 106, tabEnabled) -- VehicleMouseControlOverride
            end
            Citizen.Wait(0)
        end
    end
)


Citizen.CreateThread(function()
  while true do
    Wait(0)
    if not tabEnabled then
     civ.Tablet(false)	  	  
    end
  end
end)

 civ.Tablet = function(boolean)
	if boolean then
		civ.LoadModels({ GetHashKey("prop_cs_tablet") })

		civ.TabletEntity = CreateObject(GetHashKey("prop_cs_tablet"), GetEntityCoords(PlayerPedId()), true)
		DecorSetInt(civ.TabletEntity ,decorName,decorInt)
		AttachEntityToEntity(civ.TabletEntity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.03, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)	
		civ.LoadModels({ "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a" })	
		TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 3.0, -8, -1, 63, 0, 0, 0, 0 )
	
		Citizen.CreateThread(function()
			while DoesEntityExist(civ.TabletEntity) do
				Citizen.Wait(5)
	
				if not IsEntityPlayingAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 3) then
					TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 3.0, -8, -1, 63, 0, 0, 0, 0 )
				end
			end
			ClearPedTasks(PlayerPedId())
		end)
	else
		DeleteEntity(civ.TabletEntity)
	end
end

civ.LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		if not civ.CachedModels then
			civ.CachedModels = {}
		end

		table.insert(civ.CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)	
				Citizen.Wait(10)
			end    
		end
	end
end

civ.UnloadModels = function()
	for modelIndex = 1, #civ.CachedModels do
		local model = civ.CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end
	end
end

