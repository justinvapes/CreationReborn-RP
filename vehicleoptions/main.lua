local isUiOpen = false 
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false
Traction = 0
CruiseC  = 0
tc              = false
cruse           = false

IsCar = function(veh)
        local vc = GetVehicleClass(veh)
        return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end 

Fwv = function (entity)
        local hr = GetEntityHeading(entity) + 90.0
        if hr < 0.0 then hr = 360.0 + hr end
        hr = hr * 0.0174533
        return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end
 
 
-- Citizen.CreateThread(function()
--   while true do
--   Citizen.Wait(0)
  
--     local ped = GetPlayerPed(-1)
--     local car = GetVehiclePedIsIn(ped)
    
--     if car ~= 0 and (wasInCar or IsCar(car)) then
--       wasInCar = true
--              if isUiOpen == false and not IsPlayerDead(PlayerId()) then
--                 SendNUIMessage({
--             	   displayWindow = 'true'
--             	   })
--                 isUiOpen = true 			
--             end

--       if beltOn then DisableControlAction(0, 75) end

--       speedBuffer[2] = speedBuffer[1]
--       speedBuffer[1] = GetEntitySpeed(car)
      
--       if speedBuffer[2] ~= nil 
--          and not beltOn
--          and GetEntitySpeedVector(car, true).y > 1.0  
--          and speedBuffer[1] > 19.25 
--          and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
         
--         local co = GetEntityCoords(ped)
--         local fw = Fwv(ped)
--         SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
--         SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
--         Citizen.Wait(1)
--         SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
--       end
        
--       velBuffer[2] = velBuffer[1]
--       velBuffer[1] = GetEntityVelocity(car)
      
--     elseif wasInCar then
--       wasInCar = false
--       beltOn = false
--       speedBuffer[1], speedBuffer[2] = 0.0, 0.0
--              if isUiOpen == true and not IsPlayerDead(PlayerId()) then
--                 SendNUIMessage({
--             	   displayWindow = 'false'
--             	   })
--                 isUiOpen = false 
--             end
--     end
    
--   end
-- end)

-- local beltOn = true
-- RegisterKeyMapping('seatbelt', 'Seatbelt', 'keyboard', 'k')
-- RegisterCommand('seatbelt', function()  
--   local ped = GetPlayerPed(-1)
--   local car = GetVehiclePedIsIn(ped)
--   if car ~= 0 and IsCar(car) then
--     if beltOn then 
--       beltOn = true
--   -- TriggerEvent("pNotify:SendNotification", {text = "Seatbelt On", type = "success", timeout = 1400, layout = "centerLeft"})
--       exports['mythic_notify']:DoHudText('success', 'Seatbelt On')
--       SendNUIMessage({
--         displayWindow = 'false'
--         })
--       isUiOpen = true 
--     else 
--       beltOn = false
--   -- TriggerEvent("pNotify:SendNotification", {text = "Seatbelt Off", type = "error", timeout = 1400, layout = "centerLeft"}) 
--       exports['mythic_notify']:DoHudText('error', 'Seatbelt Off')
--       SendNUIMessage({
--         displayWindow = 'true'
--         })
--       isUiOpen = true  
--     end  
--   end
-- end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(100)
--         if IsPlayerDead(PlayerId()) and isUiOpen == true then
--             SendNUIMessage({
--                     displayWindow = 'false'
--                })
--             isUiOpen = false
--         end    

--     end
-- end)   

RegisterCommand("engine", function(source)
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  local driver = GetPedInVehicleSeat(veh, -1)

  if driver == PlayerPedId() then
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
  end
end)

RegisterCommand("hood", function(source)
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  local driver = GetPedInVehicleSeat(veh, -1)

  if driver == PlayerPedId() then
   if GetVehicleDoorAngleRatio(veh, 4) > 0.0 then 
        SetVehicleDoorShut(veh, 4, false)            
     else
        SetVehicleDoorOpen(veh, 4, false)             
     end 
  end
end)

RegisterCommand("boot", function(source)
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  local driver = GetPedInVehicleSeat(veh, -1)

  if driver == PlayerPedId() then
     if GetVehicleDoorAngleRatio(veh, 5) > 0.0 then 
        SetVehicleDoorShut(veh, 5, false)	   
     else
        SetVehicleDoorOpen(veh, 5, false)	   
     end	 
  end
end)

RegisterCommand("windows", function(source)
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  local driver = GetPedInVehicleSeat(veh, -1)

  if driver == PlayerPedId() then
     if Windows == 0 then		
        Windows = 1
        RollDownWindow(veh, 0)
        RollDownWindow(veh, 1)
        RollDownWindow(veh, 2)
        RollDownWindow(veh, 3)	   	       		   
     else	 
        Windows = 0	
        RollUpWindow(veh, 0)
        RollUpWindow(veh, 1)
        RollUpWindow(veh, 2)
        RollUpWindow(veh, 3)	   
     end
  end
end)

RegisterCommand("doors", function(source)
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  local driver = GetPedInVehicleSeat(veh, -1)

  if driver == PlayerPedId() then
     -- Hood	
     if GetVehicleDoorAngleRatio(veh, 4) > 0.0 then 
        SetVehicleDoorShut(veh, 4, false)            
     else
        SetVehicleDoorOpen(veh, 4, false)             
     end
     
     --FR Door 
     if GetVehicleDoorAngleRatio(veh, 1) > 0.0 then 
        SetVehicleDoorShut(veh, 1, false)            
     else
        SetVehicleDoorOpen(veh, 1, false)             
     end

     --FL Door
     if GetVehicleDoorAngleRatio(veh, 0) > 0.0 then 
        SetVehicleDoorShut(veh, 0, false)            
     else
        SetVehicleDoorOpen(veh, 0, false)             
     end
     
     --BR Door
     if GetVehicleDoorAngleRatio(veh, 3) > 0.0 then 
        SetVehicleDoorShut(veh, 3, false)            
     else
        SetVehicleDoorOpen(veh, 3, false)             
     end 
     
     --BL Door		
     if GetVehicleDoorAngleRatio(veh, 2) > 0.0 then 
        SetVehicleDoorShut(veh, 2, false)            
     else
        SetVehicleDoorOpen(veh, 2, false)             
     end	

     --Trunk
     if GetVehicleDoorAngleRatio(veh, 5) > 0.0 then 
        SetVehicleDoorShut(veh, 5, false)	   
     else
        SetVehicleDoorOpen(veh, 5, false)	   
     end	 
  end
end)

RegisterCommand("traction", function(source)
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  local driver = GetPedInVehicleSeat(veh, -1)

  if driver == PlayerPedId() then
     if Traction == 0 then		
        Traction = 1	
        tc = true
        TractionC()       		   
     else	 
        Traction = 0	
        tc = false
        exports['mythic_notify']:DoHudText('error', 'Traction Control [Disabled]')  	   
     end
  end
end)

RegisterKeyMapping('cruise', 'Cruise Control', 'keyboard', 'b')

RegisterCommand("cruise", function(source)
  local veh = GetVehiclePedIsIn(PlayerPedId(),false)
  local driver = GetPedInVehicleSeat(veh, -1)
 
  if driver == PlayerPedId() then
     vel = GetVehicleWheelSpeed(veh, 1)
     if vel > Config.Minspeed and vel < Config.Maxspeed then	
        if CruiseC == 0 then		
           CruiseC = 1	
           cruse = true
           Cruise()      		   
        else	 
           CruiseC = 0	
           cruse = false
           exports['mythic_notify']:DoHudText('error', 'Cruise Control [Disabled]')  	   
        end
     else	  
        exports['mythic_notify']:DoHudText('error', 'To [Slow] Or [Fast] To Activate')  
     end
  end
end)

--Traction Control
function TractionC() 

  local veh        = GetVehiclePedIsIn(PlayerPedId(),false)
  local drivebias  = GetVehicleHandlingFloat(veh,"CHandlingData", "fDriveBiasFront")
  local vehicle    = GetVehiclePedIsIn(PlayerPedId())
  oldvalue         = GetVehicleHandlingFloat(vehicle,'CHandlingData','fLowSpeedTractionLossMult')	
  exports['mythic_notify']:DoHudText('success', 'Traction Control [Activated]')

  if not HasStreamedTextureDictLoaded('cctcimages') then
	 RequestStreamedTextureDict('cctcimages', true)
	 while not HasStreamedTextureDictLoaded('cctcimages') do
	 Wait(0)
  end
end
 
  repeat  
   Wait(0)
  
	if tcacting == true then
 else
   if vehicle ~= 0 then
	SetVehicleHandlingField(vehicle,'CHandlingData','fLowSpeedTractionLossMult',oldvalue)	
	SetVehicleEngineTorqueMultiplier(veh, 1.0)
   end
 end
 
  var1 = 1.0		
  mod1 = 0.0	
  newvalue5 = oldvalue
  tcacting = false	

  wh1 = GetVehicleWheelSpeed(veh,0)
  wh1 = (GetVehicleWheelSpeed(veh,1) + wh1) / 2 
  wh2 = (GetVehicleWheelSpeed(veh,1) + wh1) / 2 
  wh3 = GetVehicleWheelSpeed(veh,2)
  wh4 = GetVehicleWheelSpeed(veh,3) 
  throttle = 0.0 
  wheelave = (GetVehicleWheelSpeed(veh,0) + GetVehicleWheelSpeed(veh,1) + GetVehicleWheelSpeed(veh,2) + GetVehicleWheelSpeed(veh,3)) / 4
 
  if Config.OnScreendisplayTC == true then
     DrawRect(UITC.x + 0.01 ,UITC.y + 0.04 ,0.05,0.01,0,0,0,255)
  end
  
    steerang = GetVehicleSteeringAngle(veh)
	
  if steerang > 1 then
	 mod1 = steerang / 20
	 
  elseif steerang < -1.0 then
	steerang = steerang - steerang*2
	mod1 = steerang / 20
  end
	
  if wh1 > (wheelave + 0.05 + mod1) then
	var1 = 1.0 / ((wh1 - (wheelave + 0.00 + mod1) )- 0.04) *Config.action
	newvalue5 = oldvalue * var1
	tcacting = true
	
	elseif  wh2 > (wheelave + 0.05 + mod1) then
	var1 = 1.0 / ((wh2 - (wheelave + 0.00 + mod1) )- 0.04) *Config.action
	newvalue5 = oldvalue * var1 
	tcacting = true
	
	elseif  wh3 > (wheelave + 0.05 + mod1) then
	var1 = 1.0 / ((wh3 - (wheelave + 0.00 + mod1) )- 0.04) *Config.action
	newvalue5 = oldvalue * var1
	tcacting = true
	
	elseif  wh4 > (wheelave + 0.05 + mod1) then
	var1 = 1.0 / ((wh4 - (wheelave + 0.00 + mod1) )- 0.04) *Config.action
	newvalue5 = oldvalue * var1
	tcacting = true	
 end
 
    if tcacting == true then
	if newvalue5 > 0.0 and newvalue5 < oldvalue  then
      if vehicle ~= 0 then
	   SetVehicleHandlingField(vehicle,'CHandlingData','fLowSpeedTractionLossMult',newvalue5)
	   newvalue5 = oldvalue * var1
      end
		
	elseif newvalue5 > oldvalue then	
      if vehicle ~= 0 then
	   newvalue5 = oldvalue * var1
	   SetVehicleHandlingField(vehicle,'CHandlingData','fLowSpeedTractionLossMult',newvalue5)
		end

	elseif newvalue5 < 0.0 then
      if vehicle ~= 0 then
	   newvalue5 = 0.01
	   SetVehicleHandlingField(vehicle,'CHandlingData','fLowSpeedTractionLossMult',newvalue5)
      end
	end
		
	if var1 < 1.0 then
	   SetVehicleEngineTorqueMultiplier(veh, var1)
	   
    if var1 < 0.98 then
	   drawbox(UITC.x - 0.01 ,UITC.y + 0.04,0,255)
	end
	
	if var1 < 0.7 then
	   drawbox(UITC.x - 0.00 ,UITC.y + 0.04 ,100,200)
	end
			
	if var1 < 0.5 then
	   drawbox(UITC.x + 0.01 ,UITC.y + 0.04 ,150,200)
	end
			
    if var1 < 0.3 then
	   drawbox(UITC.x + 0.02 ,UITC.y + 0.04 ,150,100)
	end
			
	if var1 < 0.2 then
	   drawbox(UITC.x + 0.03 ,UITC.y + 0.04,233,0)
	end
			
	else
	  var1 = 1.0
	  SetVehicleEngineTorqueMultiplier(veh, var1)
   end
end
	
	if IsPedInAnyVehicle(PlayerPedId(),true) == false then
	   tc = false
	   Traction = 0
	   Windows  = 0
    end

    until tc == false
    if vehicle ~= 0 then
      SetVehicleHandlingField(vehicle,'CHandlingData','fLowSpeedTractionLossMult',oldvalue)
    end
    Wait(500)
end

function drawbox(x,y,r,g)
   if Config.OnScreendisplayTC == true then	
	  DrawRect(x,y,0.01,0.01,r,g,0,255)
   end
end

function Cruise()
  local veh =	GetVehiclePedIsIn(PlayerPedId(), false)
  vel = GetVehicleWheelSpeed(veh, 1)
  exports['mythic_notify']:DoHudText('success', 'Cruise Control [Activated]')

  if not HasStreamedTextureDictLoaded('cctcimages') then
    RequestStreamedTextureDict('cctcimages', true)
    while not HasStreamedTextureDictLoaded('cctcimages') do
      Wait(0)
    end
  end
	if vel > Config.Minspeed and vel < Config.Maxspeed then
    local speed = vel * 2.237	
  repeat
  Wait(0)
	 
	local vel2 = GetVehicleWheelSpeed(veh, 1)
	
	if vel2 < 0.001 then
	   vel2 = 0.01
	end

	local diff  = vel + 0.2 - vel2
	local throttle = 0.2
	
	if diff  > 1.0 then
	   throttle = 1.0
   else
	   throttle = diff
	end

	if not IsControlPressed(0, 76) and throttle > 0.01 then
	   SetControlNormal(0, 71, throttle)
	end

    if throttle < 0.001 then
	   throttle = 0.0
	end

	local curspeed = GetVehicleWheelSpeed(veh, 1) * 2.237
   speed = vel * 2.237

	if Config.OnScreendisplayCC then
	   local sr = toint((throttle*255)) - 10
	   local sg = 255 - sr + 10
	   sg = toint(sg)				
	   DrawRect(UI.x + 0.06, UI.y - 0.03, throttle/12, 0.01, sr, sg, 0, 255)
	end

   if IsControlJustPressed(0, 316) then
      vel = vel + 0.277778
   elseif IsControlJustPressed(0, 317) then
      vel = vel - 0.277778
   end

	if IsControlJustPressed(0, 8) then
	   cruse = false
	   CruiseC  = 0
	   exports['mythic_notify']:DoHudText('error', 'Cruise Control [Disabled]')
	   
    if IsPedInAnyVehicle(PlayerPedId(),true) == false then
	   cruse = false
	   CruiseC  = 0
	end
  end
	 until cruse == false
	 Wait(500)
  end
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.ceil(num * mult - 0.5) / mult end
end

function toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

function isTCon()
  return tcacting
end