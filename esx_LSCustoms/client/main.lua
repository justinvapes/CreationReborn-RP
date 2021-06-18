ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local lsMenuIsShowed = false
local isInLSMarker	 = false
local myCar 		 = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('esx_LSCustoms:installMod')
AddEventHandler('esx_LSCustoms:installMod', function()
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	myCar = ESX.Game.GetVehicleProperties(vehicle)
	TriggerServerEvent('esx_LSCustoms:refreshOwnedVehicle', myCar)
end)

RegisterNetEvent('esx_LSCustoms:cancelInstallMod')
AddEventHandler('esx_LSCustoms:cancelInstallMod', function()
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	ESX.Game.SetVehicleProperties(vehicle, myCar)
end)

function OpenVehicleExtrasMenu()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local availableExtras = {}

    if not DoesEntityExist(vehicle) then
        return
    end

    for i=0, 12 do
        if DoesExtraExist(vehicle, i) then
            local state = IsVehicleExtraTurnedOn(vehicle, i) == 1

            table.insert(availableExtras, {
                label = ('Extra <span style="color:darkgoldenrod;">%s</span>: %s'):format(i, GetExtraLabel(state)),
                state = state,
                extraId = i
            })
        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_extras', {
        title    = 'Vehicle Extras',
        align    = 'bottom-right',
		css      = 'identity',
        elements = availableExtras
    }, function(data, menu)
        ToggleVehicleExtra(vehicle, data.current.extraId, data.current.state)
		if data.current.modType == nil then
			mod = 'Extras: ' .. data.current.extraId 
		else
			mod = data.current.modType
		end
		plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
		if plate == nil then
			plate = 'Unknown'
		end
		TriggerServerEvent('LSCustomsPartsLog', mod, plate)
		TriggerServerEvent("esx_LSCustoms:buyMod", 0)

        menu.close()
        OpenVehicleExtrasMenu()
    end, function(data, menu)
        menu.close()
    end)
end

function ToggleVehicleExtra(vehicle, extraId, extraState)
    SetVehicleExtra(vehicle, extraId, extraState)
end

function GetExtraLabel(state)
    if state then
        return '<span style="color:green;">Enabled</span>'
    elseif not state then
        return '<span style="color:darkred;">Disabled</span>'
    end
end

function OpenLSMenu(elems, menuname, menutitle, parent)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), menuname,
		{
			title = menutitle,
			align    = 'bottom-right',
			css      = 'identity',
			elements = elems
		},
		function(data, menu) -- on validate
			local isRimMod = false
			local isExtras = false
			if data.current.modType == "modFrontWheels" then
				isRimMod = true
			end
			if data.current.modType == 'modExtras' then
				isExtras = true
				OpenVehicleExtrasMenu()
			end
			local found = false
			if not isExtras then
				for k,v in pairs(Config.Menus) do
					if k == data.current.modType or isRimMod then
						if data.current.label == _U('by_default') or string.match(data.current.label, _U('installed')) then
							ESX.ShowNotification(_U('already_own') .. data.current.label)
						else
							if isRimMod then
								mod = data.current.modType
								if mod == nil then
									mod = 'Unknown'
								end
								local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
								if plate == nil then
									plate = 'Unknown'
								end
								TriggerServerEvent('LSCustomsPartsLog', mod, plate)
								TriggerServerEvent("esx_LSCustoms:buyMod", data.current.price)
							else
								mod = data.current.modType
								if mod == nil then
									mod = 'Unknown'
								end
								local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
								if plate == nil then
									plate = 'Unknown'
								end
								if mod == 'color1' or mod == 'color2' or mod == 'pearlescentColor' or mod == 'interiorColor' or mod == 'dashboardColor' then
									mod = mod .. ' - ' .. data.current.color
								end
								TriggerServerEvent('LSCustomsPartsLog', mod, plate)
								TriggerServerEvent("esx_LSCustoms:buyMod", v.price)
							end
						end
						menu.close()
						found = true
						break
					end
				end
				if not found then
					GetAction(data.current)
				end
			end
		end,
		function(data, menu) -- on cancel
			menu.close()
			TriggerEvent('esx_LSCustoms:cancelInstallMod')
			
			local playerPed = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			
			SetVehicleDoorsShut(vehicle, false)
			
			if parent == nil then
				lsMenuIsShowed = false
				local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				FreezeEntityPosition(vehicle, false)
				myCar = nil
			end
		end,
		function(data, menu) -- on change
			UpdateMods(data.current)
		end
	)
end

function UpdateMods(data)
	
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		
	if data.modType ~= nil then
		local props = {}

		--Citizen.Trace('modType: ' .. data.modType)
		--Citizen.Trace('modNum: ' .. json.encode(data.modNum))

		if data.wheelType ~= nil then
			props['wheels'] = data.wheelType
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'neonColor' then
			props['neonEnabled'] = {true, true, true, true}
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'tyreSmokeColor' then
			props['modSmokeEnabled'] = true
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		end
		props[data.modType] = data.modNum
		if data.modType == 'modFrontWheels' then
			props['modBackWheels'] = data.modNum
		end
		ESX.Game.SetVehicleProperties(vehicle, props)
	end
end

function GetAction(data)
	local elements  = {}
	local menuname  = ''
	local menutitle = ''
	local parent    = nil

	local playerPed = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local currentMods = ESX.Game.GetVehicleProperties(vehicle)

	if data.value == 'modTrunk' or
		data.value == 'modHydrolic' then
		SetVehicleDoorOpen(vehicle, 5, false)
		--SetVehicleDoorOpen(vehicle, 5, false)
		
	elseif data.value == 'modEngineBlock' or
	    data.value == 'modAirFilter' then
	    SetVehicleDoorOpen(vehicle, 4, false)
		
	elseif data.value == 'modDoorSpeaker' then
		SetVehicleDoorOpen(vehicle, 0, false)
		SetVehicleDoorOpen(vehicle, 1, false)
		SetVehicleDoorOpen(vehicle, 2, false)
		SetVehicleDoorOpen(vehicle, 3, false)
	else
		SetVehicleDoorsShut(vehicle, false)
	end
	
	for k,v in pairs(Config.Menus) do

		if data.value == k then

			menuname  = k
			menutitle = v.label
			parent    = v.parent

			if v.modType ~= nil then

				if v.modType == 22 then
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = false})
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' or v.modType == 'dashboardColor' or v.modType == 'interiorColor' then
					local num = myCar[v.modType]
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = num})
				else
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = -1})
				end
				
				if v.modType == 17 then
					table.insert(elements, {label = " " .. _U('no_turbo'), modType = k, modNum = false})
				end

				if v.modType == 14 then -- HORNS
					for j = 0, 51, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetHornName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							_label = GetHornName(j) .. ' - <span style="color:green;">$' .. v.price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 'plateIndex' then -- PLATES
					for j = 0, 5, 1 do
						local _label = ''
						if j == currentMods.plateIndex then
							_label = GetPlatesName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							_label = GetPlatesName(j) .. ' - <span style="color:green;">$' .. v.price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 22 then -- XENON
					local _label = ''
					if currentMods.modXenon then
						_label = 'Xénon - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						_label = 'Xénon - <span style="color:green;">$' .. v.price .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- NEON & SMOKE COLOR
					local neons = GetNeons()
					for i=1, #neons, 1 do
						table.insert(elements,
							{
								label = '<span style="color:rgb(' .. neons[i].r .. ',' .. neons[i].g .. ',' .. neons[i].b .. ');">' .. neons[i].label .. ' </span>',
								modType = k,
								modNum = { neons[i].r, neons[i].g, neons[i].b }
							}
						)
					end
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' or v.modType == 'interiorColor' or v.modType =='dashboardColor' then -- RESPRAYS
					local colors = GetColors(data.color)
					for j = 1, #colors, 1 do
						local _label = ''
						_label = colors[j].label .. ' - <span style="color:green;">$' .. v.price .. ' </span>'
						table.insert(elements, {label = _label, modType = k, modNum = colors[j].index, color = colors[j].label})
					end
				elseif v.modType == 'windowTint' then -- WINDOWS TINT
					for j = 1, 5, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetWindowName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							_label = GetWindowName(j) .. ' - <span style="color:green;">$' .. v.price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 23 then -- WHEELS RIM & TYPE
					local props = {}

					props['wheels'] = v.wheelType
					ESX.Game.SetVehicleProperties(vehicle, props)

					local modCount = GetNumVehicleMods(vehicle, v.modType)
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							local _label = ''
							if j == currentMods.modFrontWheels then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. v.price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = 'modFrontWheels', modNum = j, wheelType = v.wheelType, price = v.price})
						end
					end
				elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- UPGRADES
					for j = 0, modCount-1, 1 do
						local _label = ''
						if j == currentMods[k] then
							_label = _U('level') .. j .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							_label = _U('level') .. j .. ' - <span style="color:green;">$' .. v.price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 17 then -- TURBO
					local _label = ''
					if currentMods.modTurbo then
						_label = 'Turbo - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						_label = 'Turbo - <span style="color:green;">$' .. v.price .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				else
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- BODYPARTS
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							local _label = ''
							if j == currentMods[k] then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. v.price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = k, modNum = j})
						end
					end
				end
			else
				if data.value == 'primaryRespray' or data.value == 'secondaryRespray' or data.value == 'pearlescentRespray' or data.value == 'dashboardRespray' or data.value == 'interiorRespray' or data.value == 'modFrontWheelsColor' then
					for i=1, #Config.Colors, 1 do
						if data.value == 'primaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color1', color = Config.Colors[i].value})
						elseif data.value == 'secondaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color2', color = Config.Colors[i].value})
						elseif data.value == 'pearlescentRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'pearlescentColor', color = Config.Colors[i].value})
						elseif data.value == 'dashboardRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'dashboardColor', color = Config.Colors[i].value})
						elseif data.value == 'interiorRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'interiorColor', color = Config.Colors[i].value})
						elseif data.value == 'modFrontWheelsColor' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'wheelColor', color = Config.Colors[i].value})
						end
					end
				else
					for l,w in pairs(v) do
						if l ~= 'label' and l ~= 'parent' then
							table.insert(elements, {label = w, value = l})
						end
					end
				end
			end
			break
		end
	end

	table.sort(elements, function(a, b)
		return a.label < b.label
	end)

	OpenLSMenu(elements, menuname, menutitle, parent)
end


-- Display markers
Citizen.CreateThread(function ()
  while true do
    Wait(0)

    local coords = GetEntityCoords(GetPlayerPed(-1))

    for k,v in pairs(Config.Zones) do
      if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
      end
    end
  end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local playerPed = GetPlayerPed(-1)
		if IsPedInAnyVehicle(playerPed, false) then
			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local currentZone = nil
			local zone 		  = nil
			local lastZone    = nil
			if (PlayerData.job ~= nil and PlayerData.job.name == 'mecano2') or Config.IsMecanoJobOnly == false then

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				  
					isInLSMarker  = true
                    TriggerEvent('CR_VehKm:Inzone')
					SetTextComponentFormat("STRING")
					AddTextComponentString(v.Hint)
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)

					break
				else
					isInLSMarker  = false
					TriggerEvent('CR_VehKm:NotInzone')
				end
			end
		end

			if IsControlJustReleased(0, 38) and not lsMenuIsShowed and isInLSMarker then
				lsMenuIsShowed = true

				local vehicle = GetVehiclePedIsIn(playerPed, false)
				FreezeEntityPosition(vehicle, true)

				myCar = ESX.Game.GetVehicleProperties(vehicle)

				ESX.UI.Menu.CloseAll()
				GetAction({value = 'main'})
			end

			if isInLSMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				TriggerEvent('CR_VehKm:Inzone')
			end

			if not isInLSMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('CR_VehKm:NotInzone')
			end

		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if lsMenuIsShowed then
            DisableControlAction(0, 75, true) -- F
            -- DisableControlAction(0, 86, true) -- E
        end
    end
end)
