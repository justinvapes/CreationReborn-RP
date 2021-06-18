ESX = nil
local PlayerData = {}
local MenuOpened = false
local Bet = Config.AllowedBets[1]
local Result = ""
local Racing = false
local InRace = false
local AnnounceString = false
local LastFor = 5
local Pos = 0
local CountDown = 3
local CanGo = false
local AllowedToStart = false
local FinishedDrag = true

Citizen.CreateThread(function()
	LoadInterior(GetInteriorAtCoords(1155.38, 3108.49, 40.54))
end)

local Racers = {
	[1] = false,
	[2] = false
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while not ESX.IsPlayerLoaded() do 
		Citizen.Wait(500)
	end
	
	if ESX.IsPlayerLoaded() then
		
		local Tree = GetHashKey('dragtree')	
		
		while not HasModelLoaded(Tree) do
		   RequestModel(Tree)
		   Citizen.Wait(1)  
		end

		local Dragtree = CreateObject(Tree, 1129.307, 3101.063, 41.28, 0, 0, 0)
		DecorSetInt(Dragtree ,decorName,decorInt)
		SetEntityHeading(Dragtree, 104.68)
		SetEntityCollision(Dragtree, true, true)
		FreezeEntityPosition(Dragtree, true)
		SetModelAsNoLongerNeeded(Tree)
	end    
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

function DrawM(hint, type, x, y, z)
   ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.8)
end

RegisterNetEvent('CR_Dragstrip:ActivateTree')
AddEventHandler('CR_Dragstrip:ActivateTree', function()

    AllowedToStart = true
	
	AddReplaceTexture("dragstrip", "reflector", "dragstrip", "rgba#343434ff") 

    Citizen.Wait(1000)	
	AddReplaceTexture("dragstrip", "readylights", "dragstrip", "StageLights") 
	
	Citizen.Wait(2000)				
	AddReplaceTexture("dragstrip", "stage1", "dragstrip", "495_67261")
	Citizen.Wait(500)
	AddReplaceTexture("dragstrip", "stage2", "dragstrip", "495_67261")
	Citizen.Wait(500)
	AddReplaceTexture("dragstrip", "stage3", "dragstrip", "495_67261")
	
	Citizen.Wait(500)	
	AddReplaceTexture("dragstrip", "greenlights", "dragstrip", "green")
	CanGo = true
	
	Citizen.Wait(2500)		
    AddReplaceTexture("dragstrip", "readylights",  "dragstrip", "rgba#343434ff")		
	AddReplaceTexture("dragstrip", "stage1", "dragstrip", "rgba#343434ff")
	AddReplaceTexture("dragstrip", "stage2", "dragstrip", "rgba#343434ff")
	AddReplaceTexture("dragstrip", "stage3", "dragstrip", "rgba#343434ff")
	AddReplaceTexture("dragstrip", "greenlights",  "dragstrip", "rgba#343434ff")
	AddReplaceTexture("dragstrip", "reflector",    "dragstrip", "reflector")
	AddReplaceTexture("dragstrip", "prestageleft",  "dragstrip", "rgba#343434ff")
	AddReplaceTexture("dragstrip", "prestageright",  "dragstrip", "rgba#343434ff")
	AllowedToStart = false
end)


RegisterNetEvent('CR_Dragstrip:ActivatePreStage')
AddEventHandler('CR_Dragstrip:ActivatePreStage', function(State, Position)
	
	if State == true then
	
	    if Position == 'Left' then
	       AddReplaceTexture("dragstrip", "prestageleft",  "dragstrip", "rgba#343434ff")	
       else
	       AddReplaceTexture("dragstrip", "prestageright",  "dragstrip", "rgba#343434ff")	
	    end			
	else	
       if Position == 'Left' then
	       AddReplaceTexture("dragstrip", "prestageleft", "dragstrip", "StageLights") 	
       else
	       AddReplaceTexture("dragstrip", "prestageright", "dragstrip", "StageLights") 	
	    end	
	end
end)

function OpenRaceMenu()
	MenuOpened = true
	
	local elements = {}
	
	for i,v in ipairs(Config.AllowedBets) do
		table.insert(elements, {label = "$".. v, value = v})
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bet',
	{
		title    = "Change Bet",
		align    = 'bottom-right',
		css      = 'superete',
		elements = elements
	}, function(data, menu)
	
		if data.current.value then
			ESX.TriggerServerCallback('CR_Drags:EditBet', function(success)
				if success then
					MenuOpened = false
					menu.close()
					local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~RACE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] New Bet Value Has Been Set..', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
				end
			end, data.current.value)
		end
	end, function(data, menu)
		MenuOpened = false
		menu.close()
	end)
end

function JoinRace(pos)

	ESX.TriggerServerCallback('CR_Drags:JoinRace', function(success)
		if success then
		
		if pos == 1 then
		   TriggerServerEvent('CR_Dragstrip:ActivatePreStage', false, 'Left')
		else
		   TriggerServerEvent('CR_Dragstrip:ActivatePreStage', false, 'Right')
		end   	
			Pos = pos
			InRace = true
		else
			local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~RACE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You have no money', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
		end
	end, pos)
end

function LeaveRace(pos)

	ESX.TriggerServerCallback('CR_Drags:LeaveRace', function(success)
		if success then
			local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~RACE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Just Left The Race', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
			InRace = false
		end
	end, pos)
end

function Announce(winner)

	if winner then
	   AnnounceString = "you win: $" .. Bet*2
	   Result = "~g~Winner"
	   PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS", 1)
	   Citizen.Wait(LastFor * 1000)
	   AnnounceString = false
   else
	   AnnounceString = "you lose: $" .. Bet
	   Result = "~r~Loser"
	   PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS", 1)
	   Citizen.Wait(LastFor * 1000)
	   AnnounceString = false
	end
end

RegisterNetEvent("CR_Drags:BetEdited")
AddEventHandler("CR_Drags:BetEdited", function (prize)
	Bet = prize
end)

RegisterNetEvent("CR_Drags:EditPos")
AddEventHandler("CR_Drags:EditPos", function (pos, state)
	Racers[pos] = state
end)

RegisterNetEvent("CR_Drags:StartDrag")
AddEventHandler("CR_Drags:StartDrag", function ()
    SetEntityHealth(PlayerPedId(), 200)
	Racing = true
	TriggerServerEvent('CR_Dragstrip:ActivateTree')
end)

RegisterNetEvent("CR_Drags:Result")
AddEventHandler("CR_Drags:Result", function(result)
	Racing = false
	InRace = false
	CanGo = false
	Pos = 0
	Announce(result)
end)

Citizen.CreateThread(function()	
	while true do
		Citizen.Wait(0)
		
		--DrawMarker(27, Config.FinishLine.x, Config.FinishLine.y, Config.FinishLine.z + 0.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 80.000, 80.000, 0.700, 0, 255, 0, 200, false, true, 2, true, false, false, false)
							
		if InRace and not Racing and Pos ~= 0 then
			ESX.ShowHelpNotification("~y~Press ~s~~INPUT_PICKUP~ To ~g~Cancel")
			
			if IsControlJustPressed(0, 38) then
			   			   
		      if Pos == 1 then 
			     TriggerServerEvent('CR_Dragstrip:ActivatePreStage', true, 'Left')
             else
				 TriggerServerEvent('CR_Dragstrip:ActivatePreStage', true, 'Right')
             end
                LeaveRace(Pos)
			    Citizen.Wait(750)
			end
			
			local MyCoords = GetEntityCoords(PlayerPedId())	
			local Racer1Marker = vector3(Config.Pos[1].x, Config.Pos[1].y, Config.Pos[1].z)
			local Racer1Dist = #(MyCoords - Racer1Marker)
			
			local Racer2Marker = vector3(Config.Pos[2].x, Config.Pos[2].y, Config.Pos[2].z)
		    local Racer2Dist = #(MyCoords - Racer2Marker)
								
			if Racers[1] and not Racing and Racer1Dist > 5 then
			   LeaveRace(Pos)			   
			   TriggerServerEvent('CR_Dragstrip:ActivatePreStage', true, 'Left')
			end
			
			if Racers[2] and not Racing and Racer2Dist > 5 then
			   LeaveRace(Pos)
			   TriggerServerEvent('CR_Dragstrip:ActivatePreStage', true, 'Right')
			end
		end
		
		if Racing then
			
			local MyCoords = GetEntityCoords(PlayerPedId())	
			local FinishLine = vector3(Config.FinishLine.x, Config.FinishLine.y, Config.FinishLine.z)
			local FinishLineDist = #(MyCoords - FinishLine)
			
			DisableControlAction(0, 72,  true) 
			DisableControlAction(0, 55,  true)
									
			if Racers[1] and Racers[2] and FinishLineDist < 80 then				   
			   TriggerServerEvent("CR_Drags:SendResult")
			   Racing = false
			   FinishedDrag = false
			end

           	local ReverseLine = vector3(Config.ReverseLine.x, Config.ReverseLine.y, Config.ReverseLine.z)
			local ReverseLineDist = #(MyCoords - ReverseLine)
			
			if Racers[1] and Racers[2] and ReverseLineDist < 10 then
			   TriggerServerEvent("CR_Drags:JumpedTheLine")
			   Racing = false
			end
						
			if CanGo == false then 
				
				local Pos1 = GetEntityCoords(PlayerPedId())
				Citizen.Wait(1)
				local Pos2 = GetEntityCoords(PlayerPedId())	
                local Positions = #(Pos1 - Pos2)
				
				if Positions > 0.01 then
				   Racing = false
				   TriggerServerEvent("CR_Drags:JumpedTheLine")				   
				end
			end			
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
							
		local MyCoords = GetEntityCoords(PlayerPedId())	
		local BetMarker = vector3(Config.Marker.x, Config.Marker.y, Config.Marker.z)
		local BetMarkerDist = #(MyCoords - BetMarker)
		
		if BetMarkerDist < 25 then
			
			if BetMarkerDist < 10 and not Racers[1] and not Racers[2] then		
			   DrawMarker(29, Config.Marker.x, Config.Marker.y, Config.Marker.z + 0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.700, 0.700, 0.700, 0, 255, 0, 200, false, true, 2, true, false, false, false)
				
				if BetMarkerDist < 2 and not Racers[1] and not Racers[2] then			
				   DrawM('[~y~Press ~s~[~b~E~s~] To Change The ~g~Wager~s~] = ~b~$' ..Bet, 27, Config.Marker.x, Config.Marker.y, Config.Marker.z)
					
					if IsControlJustPressed(0, 38) then
					   OpenRaceMenu()
					end		
				end
			end
			
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) 
				
				if (GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()) then 
					
					local Racer1Marker = vector3(Config.Pos[1].x, Config.Pos[1].y, Config.Pos[1].z)
					local Racer1Dist = #(MyCoords - Racer1Marker)
					
					if Racer1Dist < 4 and not Racers[1] then
					   DrawM('[~y~Press ~s~[~b~E~s~] To ~g~Enter ~s~The ~b~Drag Race~s~] ~r~LANE 1', 27, Config.Pos[1].x, Config.Pos[1].y, Config.Pos[1].z)
						
						if IsControlJustPressed(0, 38) then
						
                            if AllowedToStart == false then
							   JoinRace(1)
							   CanGo = false							   
							   Citizen.Wait(750)
						   else
							   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~RACE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Wait For The Lights To Reset..', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
						    end	
                        end						
				    end
					
					local Racer2Marker = vector3(Config.Pos[2].x, Config.Pos[2].y, Config.Pos[2].z)
					local Racer2Dist = #(MyCoords - Racer2Marker)
					
					if Racer2Dist < 4 and not Racers[2] then
					   DrawM('[~y~Press ~s~[~b~E~s~] To ~g~Enter ~s~The ~b~Drag Race~s~] ~r~LANE 2', 27, Config.Pos[2].x, Config.Pos[2].y, Config.Pos[2].z)
						
						if IsControlJustPressed(0, 38) then
						
						    if AllowedToStart == false then
							   JoinRace(2)
							   CanGo = false							   
							   Citizen.Wait(750)
						   else
							   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~RACE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Wait For The Lights To Reset..', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
						    end	
                        end						
					end	
				end		
			end
		else
			Citizen.Wait(500)		
		end
	end
end)

function ParachuteModel(model)
	for _, listedCar in pairs(Config.carlist) do
	 if model == GetHashKey(listedCar) then
		return true
	  end
	end
	return false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) 
        local carModel = GetEntityModel(vehicle)
		
		if IsPedInAnyVehicle(PlayerPedId(), false) and ParachuteModel(carModel) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), -1) == PlayerPedId()) then
					
			if DoesExtraExist(vehicle, 2) then
				
				local speedkph 	= 300 
				local speeed 	= speedkph/3.6
			
				if FinishedDrag == false and GetEntitySpeed(vehicle) >= speeed and IsControlPressed(0, 8) then
				   ExtraSync = VehToNet(vehicle)
				   TriggerServerEvent('CR_Dragstrip:ToggleExtra', ExtraSync, true)				   
				   SetVehicleHandbrake(vehicle, true)
				   setit   = 1
                   FinishedDrag = true				   
				end
				
				if setit == 1 and IsVehicleStopped(vehicle) then
				   TriggerServerEvent('CR_Dragstrip:ToggleExtra', ExtraSync, false)		
				   setit = 0
				   SetVehicleHandbrake(vehicle, false)
				end 
			else
			   Citizen.Wait(250)				
			end	  
		else
			Citizen.Wait(250)
		end
	end
end)

RegisterNetEvent('CR_Dragstrip:ToggleExtra')
AddEventHandler('CR_Dragstrip:ToggleExtra', function(ExtraSync, state)

    SyncedExtra = NetToVeh(ExtraSync)
	
    if state then
       SetVehicleAutoRepairDisabled(SyncedExtra, true)
       SetVehicleExtra(SyncedExtra, 2, false) 	 
   else 
	   SetVehicleAutoRepairDisabled(SyncedExtra, true)
	   SetVehicleExtra(SyncedExtra, 2, true)
	end
end)

function Initialize(scaleform)
	local scaleform = RequestScaleformMovie(scaleform)
	
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
	
	PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString(Result)
	PushScaleformMovieFunctionParameterString(AnnounceString)
	PopScaleformMovieFunctionVoid()
	return scaleform
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		
		if AnnounceString then
		   scaleform = Initialize("mp_big_message_freemode")
		   DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
		end
	end
end)

Citizen.CreateThread(function()

	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	local DragBlip = AddBlipForCoord(1102.72, 3093.87, 42.36)
	SetBlipAsShortRange(DragBlip, true)
	SetBlipSprite(DragBlip, 127) 
	SetBlipColour(DragBlip, 4) 
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Drag Strip")
	EndTextCommandSetBlipName(DragBlip)
end)