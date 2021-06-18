ESX                          = nil
local TrailerHandle          = 0
local Trailer                = 0
local wait                   = 500
local Ramp                   = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	    AddTextEntry("Instructiontrailer", Config.Message)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
wait = 500
end)

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
   wait = 500
end)

--Thauler Trailer
Citizen.CreateThread(function()  
	while true do
	  Citizen.Wait(wait)
				
	local myCoord = GetEntityCoords(PlayerPedId())	
	local TrailerHandle
				
	vehicles = ESX.Game.GetVehiclesInArea(myCoord, 4.0)
				
	if #vehicles > 0 then
	
	    for i = 1, #vehicles do
		
		    local v = vehicles[i]
		    Model = GetEntityModel(v)
		   
		   if Model == 1200192514 then
	          TrailerHandle = v
			  wait = 500
		   end
	    end
	else 
		Citizen.Wait(500)
	 end
					
	Trailer = TrailerHandle	
	
	if Trailer ~= 0 then
		
        coords = GetOffsetFromEntityInWorldCoords(Trailer, -2.0,  2.0, -1.0)	
		coords2 = GetOffsetFromEntityInWorldCoords(Trailer, 0.0,  1.5, -0.1)
		coords3 = GetOffsetFromEntityInWorldCoords(Trailer, 0.0, -1.5, -0.1)	
		   
		 if coords ~= nil then  
		   
		   local Hauler = vector3(coords.x, coords.y, coords.z + 1)
		   local dist = #(myCoord - Hauler)
							
			if dist < 1.5 then
			   wait = 5
			   DrawMarker(21, coords.x, coords.y, coords.z + 1, 0, 0, 0, 0, 0, 0, 0.401, 0.401, 0.4001, 255, 0, 0, 200, 0, 0, 0, 0)
											
				if dist < 0.7 then			
			       BeginTextCommandDisplayHelp("Instructiontrailer")
				   EndTextCommandDisplayHelp(0, 0, 1, -1)
							
							
				if IsControlJustPressed(0, 38) then--Lower/Raise Ramps								
				    TrailerSync = VehToNet(Trailer)
				    TriggerServerEvent("CR_Towing:RampSync", TrailerSync, Model)
				end
														
				if IsControlJustPressed(0, 74) then--H Back
				   local clostestvehicle = GetClosestVehicle(coords3.x, coords3.y, coords3.z, 3.0, 0, 127)
				   TaskWarpPedIntoVehicle(PlayerPedId(), clostestvehicle, -1)
				end	
							
				if IsControlJustPressed(0, 47) then--G Front
				   local clostestvehicle = GetClosestVehicle(coords2.x, coords2.y, coords2.z, 3.0, 0, 127)
				   TaskWarpPedIntoVehicle(PlayerPedId(), clostestvehicle, -1)
		        end								
		     end
		 else
		    wait = 500
	    end	 
	  end
    end	
  end
end)

--Enclosed Trailer
Citizen.CreateThread(function()  
	while true do
	  Citizen.Wait(wait)
				
	local myCoord = GetEntityCoords(PlayerPedId())	
	local TrailerHandle
				
	vehicles = ESX.Game.GetVehiclesInArea(myCoord, 4.0)
				
    if #vehicles > 0 then
	
		for i = 1, #vehicles do
		
		    local v = vehicles[i]
		    Model = GetEntityModel(v)
		   
		    if Model == -1831138000 then
	           TrailerHandle = v
			   wait = 500
		    end
	    end
	else 
		Citizen.Wait(500)
	 end
					
	Trailer = TrailerHandle	
	
	if Trailer ~= 0 then
		
		coords  = GetOffsetFromEntityInWorldCoords(Trailer, 2.0, 2.3, -1.0)
		coords2 = GetOffsetFromEntityInWorldCoords(Trailer, 0.0,  1.5, -0.1)
		coords3 = GetOffsetFromEntityInWorldCoords(Trailer, 0.0, -3.2, -0.1)	
		   
		 if coords ~= nil then  
		   
		   local Enclosed = vector3(coords.x, coords.y, coords.z + 1)
		   local dist = #(myCoord - Enclosed)
							
			if dist < 1.5 then
			   wait = 5
			   DrawMarker(21, coords.x, coords.y, coords.z + 1, 0, 0, 0, 0, 0, 0, 0.401, 0.401, 0.4001, 255, 0, 0, 200, 0, 0, 0, 0)
											
				if dist < 0.7 then			
			       BeginTextCommandDisplayHelp("Instructiontrailer")
				   EndTextCommandDisplayHelp(0, 0, 1, -1)
							
							
				if IsControlJustPressed(0, 38) then--Lower/Raise Ramps								
				    TrailerSync = VehToNet(Trailer)
				    TriggerServerEvent("CR_Towing:RampSync", TrailerSync, Model)
				end
														
				if IsControlJustPressed(0, 74) then--H Back
				   local clostestvehicle = GetClosestVehicle(coords3.x, coords3.y, coords3.z, 3.0, 0, 127)
				   TaskWarpPedIntoVehicle(PlayerPedId(), clostestvehicle, -1)
				end	
							
				if IsControlJustPressed(0, 47) then--G Front
				   local clostestvehicle = GetClosestVehicle(coords2.x, coords2.y, coords2.z, 3.0, 0, 127)
				   TaskWarpPedIntoVehicle(PlayerPedId(), clostestvehicle, -1)
		        end								
		     end
		 else
		    wait = 500
	    end	 
	  end
    end	
  end
end)


--TowTrucks
Citizen.CreateThread(function()  
	while true do
	  Citizen.Wait(wait)
				
	local myCoord = GetEntityCoords(PlayerPedId())	
	local TrailerHandle
				
	vehicles = ESX.Game.GetVehiclesInArea(myCoord, 4.0)
				
	if #vehicles > 0 then
	
		for i = 1, #vehicles do
		
		    local v = vehicles[i]
		    Model = GetEntityModel(v)
		   
		    if Model == -2082482105 then
	           TrailerHandle = v
			   wait = 500
		    end
	    end
	else 
		Citizen.Wait(500)
	 end
					
	Trailer = TrailerHandle	
	
	if Trailer ~= 0 then
		
		coords = GetOffsetFromEntityInWorldCoords(Trailer, -1.5,  0.5, -1.0)
		coords2 = GetOffsetFromEntityInWorldCoords(Trailer, 0.0,  -2.0, -0.1)
		coords3 = GetOffsetFromEntityInWorldCoords(Trailer, 0.0, -3.0, -0.1)	
		   
		 if coords ~= nil then  
		   
		    local Towtruck1 = vector3(coords.x, coords.y, coords.z + 1)
		    local dist = #(myCoord - Towtruck1)
							
			if dist < 1.5 then
			   wait = 5
			   DrawMarker(21, coords.x, coords.y, coords.z + 1, 0, 0, 0, 0, 0, 0, 0.401, 0.401, 0.4001, 255, 0, 0, 200, 0, 0, 0, 0)
											
				if dist < 0.7 then			
			       BeginTextCommandDisplayHelp("Instructiontrailer")
				   EndTextCommandDisplayHelp(0, 0, 1, -1)
							
							
				if IsControlJustPressed(0, 38) then--Lower/Raise Ramps				
				    Trailer2 = VehToNet(Trailer)
				    TriggerServerEvent("CR_Towing:TowTruckRampSync", Trailer2)
				end
														
				if IsControlJustPressed(0, 74) then--H Back
				   local clostestvehicle = GetClosestVehicle(coords3.x, coords3.y, coords3.z, 3.0, 0, 127)
				   TaskWarpPedIntoVehicle(PlayerPedId(), clostestvehicle, -1)
				end	
							
				if IsControlJustPressed(0, 47) then--G Front
				   local clostestvehicle = GetClosestVehicle(coords2.x, coords2.y, coords2.z, 3.0, 0, 127)
				   TaskWarpPedIntoVehicle(PlayerPedId(), clostestvehicle, -1)
		        end								
		     end
		 else
		    wait = 500
	    end	 
	  end
    end	
  end
end)

--TowTrucks
Citizen.CreateThread(function()  
	while true do
	  Citizen.Wait(wait)
				
	local myCoord = GetEntityCoords(PlayerPedId())	
	local TrailerHandle
				
	vehicles = ESX.Game.GetVehiclesInArea(myCoord, 4.0)
				
	if #vehicles > 0 then
	
		    for i = 1, #vehicles do
			
		    local v = vehicles[i]
			Model = GetEntityModel(v)
		   
		    if Model == -167381299 then
	           TrailerHandle = v
			   wait = 500
		    end
	    end
	else 
		Citizen.Wait(500)
	 end
					
	Trailer = TrailerHandle	
	
	if Trailer ~= 0 then
		
		coords = GetOffsetFromEntityInWorldCoords(Trailer, -1.5,  0.5, -1.0)
		coords2 = GetOffsetFromEntityInWorldCoords(Trailer, 0.0,  -2.0, -0.1)
		coords3 = GetOffsetFromEntityInWorldCoords(Trailer, 0.0, -3.0, -0.1)	
		   
		 if coords ~= nil then  

		    local Towtruck2 = vector3(coords.x, coords.y, coords.z + 1)
		    local dist = #(myCoord - Towtruck2)
							
			if dist < 1.5 then
			   wait = 5
			   DrawMarker(21, coords.x, coords.y, coords.z + 1, 0, 0, 0, 0, 0, 0, 0.401, 0.401, 0.4001, 255, 0, 0, 200, 0, 0, 0, 0)
											
				if dist < 0.7 then			
			       BeginTextCommandDisplayHelp("Instructiontrailer")
				   EndTextCommandDisplayHelp(0, 0, 1, -1)
							
							
				if IsControlJustPressed(0, 38) then--Lower/Raise Ramps				
				    Trailer2 = VehToNet(Trailer)
				    TriggerServerEvent("CR_Towing:TowTruckRampSync", Trailer2)
				end
														
				if IsControlJustPressed(0, 74) then--H Back
				   local clostestvehicle = GetClosestVehicle(coords3.x, coords3.y, coords3.z, 3.0, 0, 127)
				   TaskWarpPedIntoVehicle(PlayerPedId(), clostestvehicle, -1)
				end	
							
				if IsControlJustPressed(0, 47) then--G Front
				   local clostestvehicle = GetClosestVehicle(coords2.x, coords2.y, coords2.z, 3.0, 0, 127)
				   TaskWarpPedIntoVehicle(PlayerPedId(), clostestvehicle, -1)
		        end								
		     end
		 else
		    wait = 500
	    end	 
	  end
    end	
  end
end)

--Car Towing
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(8)
		
	if IsPedInAnyVehicle(PlayerPedId(),  false) then
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
		
        if Vehicle ~= nil then
		
           local Vcoords = GetOffsetFromEntityInWorldCoords(Vehicle, 1.0, 0.0, -1.5)
		   local VWorldCoords = GetEntityCoords(Vehicle)
           local Trailer = GetVehicleInDirection(VWorldCoords, Vcoords)
		   local Vpos = GetEntityCoords(Vehicle, true)
           local AttachIt = GetOffsetFromEntityGivenWorldCoords(Trailer, Vpos.x, Vpos.y, Vpos.z)
                
	        if GetDisplayNameFromVehicleModel(GetEntityModel(Trailer)) == "thauler" then --Trailer
                if IsEntityAttached(Vehicle) then 
			
                if IsControlJustReleased(1, 51) then 
				   SetEntityInvincible(Vehicle, true)
				   DetachEntity(Vehicle, false, true)
				   Citizen.Wait(5)
				   AttachEntityToEntity(Vehicle, Trailer, -1, AttachIt.x, AttachIt.y, AttachIt.z, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
				   Citizen.Wait(5)
				   DetachEntity(Vehicle, false, true)
				   SetEntityInvincible(Vehicle, false)
			    end					
                    Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") 
				    Citizen.InvokeNative(0x5F68520888E69014, "Press ~INPUT_CONTEXT~ To Detach The Vehicle ~n~") 
			        Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)
               else		
			   
                    if IsControlJustReleased(1, 51) then 						   
				       AttachEntityToEntity(Vehicle, Trailer, -1, AttachIt.x, AttachIt.y, AttachIt.z, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
					   SetVehicleEngineOn(Vehicle, false, true)
					   Citizen.Wait(50)
			
					   if IsEntityAttached(Vehicle) then 
					      local Telecord = GetOffsetFromEntityInWorldCoords(Trailer, -2.0,  1.9, 0.1)
					      SetEntityCoords(PlayerPedId(), Telecord.x, Telecord.y, Telecord.z)
					  else
						  AttachEntityToEntity(Vehicle, Trailer, -1, AttachIt.x, AttachIt.y, AttachIt.z, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
						  local Telecord = GetOffsetFromEntityInWorldCoords(Trailer, -2.0,  1.9, 0.1)
					      SetEntityCoords(PlayerPedId(), Telecord.x, Telecord.y, Telecord.z)
					   end
                    end						
                    Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") 
					Citizen.InvokeNative(0x5F68520888E69014, "Press ~INPUT_CONTEXT~ To Attach The Vehicle ~n~") 
					Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1) 
		        end
				
			elseif GetDisplayNameFromVehicleModel(GetEntityModel(Trailer)) == "enclosed" then --Enclosed
                if IsEntityAttached(Vehicle) then 
			
                if IsControlJustReleased(1, 51) then 
				   SetEntityInvincible(Vehicle, true)
				   DetachEntity(Vehicle, false, true)
				   Citizen.Wait(5)
				   AttachEntityToEntity(Vehicle, Trailer, -1, AttachIt.x, AttachIt.y, AttachIt.z, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
				   Citizen.Wait(5)
				   DetachEntity(Vehicle, false, true)
				   SetEntityInvincible(Vehicle, false)
			    end					
                    Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") 
				    Citizen.InvokeNative(0x5F68520888E69014, "Press ~INPUT_CONTEXT~ To Detach The Vehicle ~n~") 
			        Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)
               else		
			   
                    if IsControlJustReleased(1, 51) then 						   
				       AttachEntityToEntity(Vehicle, Trailer, -1, AttachIt.x, AttachIt.y, AttachIt.z, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
					   SetVehicleEngineOn(Vehicle, false, true)
					   Citizen.Wait(50)
			
					   if IsEntityAttached(Vehicle) then 
					      local Telecord = GetOffsetFromEntityInWorldCoords(Trailer, 2.0,  2.0, 0.1)
					      SetEntityCoords(PlayerPedId(), Telecord.x, Telecord.y, Telecord.z)
					  else
						  AttachEntityToEntity(Vehicle, Trailer, -1, AttachIt.x, AttachIt.y, AttachIt.z, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
						  local Telecord = GetOffsetFromEntityInWorldCoords(Trailer, 2.0,  2.0, 0.1)
					      SetEntityCoords(PlayerPedId(), Telecord.x, Telecord.y, Telecord.z)
					   end
                    end						
                    Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") 
				    Citizen.InvokeNative(0x5F68520888E69014, "Press ~INPUT_CONTEXT~ To Attach The Vehicle ~n~") 
				    Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1) 
		       end	

            elseif GetDisplayNameFromVehicleModel(GetEntityModel(Trailer)) == "f100tow" or GetDisplayNameFromVehicleModel(GetEntityModel(Trailer)) == "f100Rapid" then 
                if IsEntityAttached(Vehicle) then 
			
                if IsControlJustReleased(1, 51) then 
				   SetEntityInvincible(Vehicle, true)
				   DetachEntity(Vehicle, false, true)
				   Citizen.Wait(5)
				   AttachEntityToEntity(Vehicle, Trailer, -1, AttachIt.x, AttachIt.y, AttachIt.z, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
				   Citizen.Wait(5)
				   DetachEntity(Vehicle, false, true)
				   SetEntityInvincible(Vehicle, false)
			    end					
                    Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") 
				    Citizen.InvokeNative(0x5F68520888E69014, "Press ~INPUT_CONTEXT~ To Detach The Vehicle ~n~") 
			        Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)
               else		
			   
                    if IsControlJustReleased(1, 51) then 						   
				       AttachEntityToEntity(Vehicle, Trailer, -1, AttachIt.x, AttachIt.y, AttachIt.z, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
					   SetVehicleEngineOn(Vehicle, false, true)
					   Citizen.Wait(50)
			
					   if IsEntityAttached(Vehicle) then 
					      local Telecord = GetOffsetFromEntityInWorldCoords(Trailer, -2.0,  0.5, 0.1)
					      SetEntityCoords(PlayerPedId(), Telecord.x, Telecord.y, Telecord.z)
					  else
						  AttachEntityToEntity(Vehicle, Trailer, -1, AttachIt.x, AttachIt.y, AttachIt.z, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
						  local Telecord = GetOffsetFromEntityInWorldCoords(Trailer, -2.0,  0.5, 0.1)
					      SetEntityCoords(PlayerPedId(), Telecord.x, Telecord.y, Telecord.z)
					   end
                    end						
                    Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") 
				    Citizen.InvokeNative(0x5F68520888E69014, "Press ~INPUT_CONTEXT~ To Attach The Vehicle ~n~") 
				    Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1) 
		         end			   
              end
           end
	   else 
		 Citizen.Wait(1000)
      end
   end
end)

--Jestski Towing--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
		
	if IsPedInAnyBoat(PlayerPedId()) then	
	    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
		
        if Vehicle ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(Vehicle)) == "wake2302" or GetDisplayNameFromVehicleModel(GetEntityModel(Vehicle)) == "wake230"then 
                local Vcoords = GetOffsetFromEntityInWorldCoords(Vehicle, 1.0, 0.0, -1.0)
				local VWorldCoords = GetEntityCoords(Vehicle)
                local Trailer = GetVehicleInDirection(VWorldCoords, Vcoords)
                
				if GetDisplayNameFromVehicleModel(GetEntityModel(Trailer)) == "JetskiT" then
                    if IsEntityAttached(Vehicle) then 
                        if IsControlJustReleased(1, 51) then 
							DetachEntity(Vehicle, false, true)
						end
                        Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") 
						Citizen.InvokeNative(0x5F68520888E69014, "Press ~INPUT_CONTEXT~ To Detach The JetSki") 
						Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)
                    else
                        if IsControlJustReleased(1, 51) then 
							AttachEntityToEntity(Vehicle, Trailer, 20, 0.0, -1.185, -0.21, 0.0, 0.0, 0.0, false, false, true, false, 20, true)
							TaskLeaveVehicle(PlayerPedId(), Vehicle, 64)
                        end
                        Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") 
						Citizen.InvokeNative(0x5F68520888E69014, "Press ~INPUT_CONTEXT~ To Attach The JetSki") 
						Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1) 
			         end
                  end
		       end
            end
	    else 
		  Citizen.Wait(1000)
      end
   end
end)

RegisterNetEvent('CR_Towing:RampSync')
AddEventHandler('CR_Towing:RampSync', function(TrailerSync, Model)
SyncedTrailer = NetToVeh(TrailerSync)

 if Model == 1200192514 then

    Ramp = not Ramp; 
	
    if Ramp then
       RemoveVehicleMod(SyncedTrailer, 2) 
	   SetVehicleMod(SyncedTrailer, 0)
   else
       SetVehicleMod(SyncedTrailer, 2)
       RemoveVehicleMod(SyncedTrailer, 0)  
    end
else	
	Ramp = not Ramp; 
	
    if Ramp then
       SetVehicleMod(SyncedTrailer, 2)
       RemoveVehicleMod(SyncedTrailer, 0)
   else
       SetVehicleMod(SyncedTrailer, 0)
       RemoveVehicleMod(SyncedTrailer, 2)  
    end	
  end
end)

RegisterNetEvent('CR_Towing:TowTruckRampSync')
AddEventHandler('CR_Towing:TowTruckRampSync', function(TruckSync)

    SyncedTruck = NetToVeh(TruckSync)
    Ramp = not Ramp; 
	
    if Ramp then
       SetVehicleMod(SyncedTruck, 2)
       RemoveVehicleMod(SyncedTruck, 0)
	   FreezeEntityPosition(SyncedTruck, false)
   else
       SetVehicleMod(SyncedTruck, 0)
       RemoveVehicleMod(SyncedTruck, 2) 
       FreezeEntityPosition(SyncedTruck, true)	   
    end
end)

function GetVehicleInDirection(cFrom, cTo)
    local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end