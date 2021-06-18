ESX = nil
local Interaction = false

Citizen.CreateThread(function()

	while ESX == nil do
	   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	   Citizen.Wait(0)
	end
	
	while not ESX.IsPlayerLoaded() do Citizen.Wait(250) end	
	while ESX.GetPlayerData().job == nil do Citizen.Wait(10) end
	
	if ESX.IsPlayerLoaded() then
	   Start() 
	end
	
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function Start()
	
	Plants = {}
	timer = GetGameTimer()
	
	ESX.TriggerServerCallback('CR_WeedPlant:GetData', function(plants)  
		Plants = plants or {}
		
		for k = 1,#Plants,1 do
			local v = Plants[k]
			
			if v then				
				local hk      = GetHashKey(Objects[v.Stage])
				local zOffset = GetPlantZ(v) 
				
				v.Object = CreateObject(hk, v.Position.x, v.Position.y, v.Position.z + zOffset, false, false, false)   
				SetEntityAsMissionEntity(v.Object,true)
				FreezeEntityPosition(v.Object,true)
			end
		end
		iR = true
	end)
	
	while not iR do 
	   Citizen.Wait(0) 
	end
	
	Citizen.CreateThread(function() 
	   PerSecThread() 
	end)
	Citizen.CreateThread(function() 
	   FiveSecThread() 
	end)
	Citizen.CreateThread(function() 
	   PerFrameThread()
	end)	
end

function PerSecThread()
	while true do
	   Wait(1000)
	   GrowthHandlerFast()	   
	end
end

function FiveSecThread()
	local tick = 0
	
	while true do
		Wait(5000)
		tick = tick + 1
		GrowthHandlerSlow()
		
		if tick % 4 == 0 then 
		   SyncCheck() 
		end
	end
end

function PerFrameThread()	
	while true do
	   sleepFrameThread = 1000
	   InputHandler()	
	   TextHandler()
	   Citizen.Wait(sleepFrameThread)
	end
end

function InputHandler()
	
	if not Plants then return end		
	if not #Plants then return end
	
	if CanHarvest or PolText then 
		sleepFrameThread = 0
		
		if IsControlJustPressed(0, 38) and (GetGameTimer() - timer) > 200 and not CurInteracting then
			
			local inventory = ESX.GetPlayerData().inventory
			local plyId = ESX.GetPlayerData().identifier
			local count  = 0
			
			for i=1, #inventory, 1 do
				if inventory[i].name == 'scissors' then
				   count = inventory[i].count
				end
			end
			
			if (count > 0) then	
				if Plants[CurKey].Owner == plyId then
					Citizen.CreateThread(function()
					
						Interaction = true
						CurInteracting = true
						
						local plyPed = GetPlayerPed(-1)								
						local dict, anim = 'anim@amb@business@weed@weed_inspecting_lo_med_hi@', 'weed_stand_checkingleaves_idle_01_inspector'	
						local dict2, anim2 = 'amb@prop_human_bum_bin@base', 'base'	
						
						TaskTurnPedToFaceEntity(plyPed, Plants[CurKey].Object, -1)	
						
						ESX.Streaming.RequestAnimDict(dict)		
						TaskPlayAnim(plyPed, dict ,anim ,8.0, -2.0, 10000, 1, 0, false, false, false)
						Citizen.Wait(11000)
						
						ESX.Streaming.RequestAnimDict(dict2)
						TaskPlayAnim(plyPed, dict2 ,anim2 ,8.0, -2.0, 10000, 1, 0, false, false, false)
						Citizen.Wait(10000)
						
						local syncData = (CanHarvest or PolText)
						timer = GetGameTimer()
						
						SetEntityAsMissionEntity(syncData.Object,false)
						FreezeEntityPosition(syncData.Object,false)
						
						TriggerServerEvent("CR_WeedPlant:PlantSync", syncData.Object)
															
						Interaction = false
						Sync(Plants[CurKey], true)
						Plants[CurKey] = false
						CanHarvest = false
						PolText = false
						CurInteracting = false
					end)
				else
					local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLANT ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Not your plant cannot harvest!', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
				end
			 else
				 local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLANT ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Need Scissors To Harvest The Plant', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		       
		      end
		   end
		
		if IsControlJustPressed(0, 47) and (GetGameTimer() - timer) > 200 and not CurInteracting then
		    
			Citizen.CreateThread(function()
			    Interaction = true
				CurInteracting = true
				
				local plyPed = GetPlayerPed(-1)
			    local dict, anim = 'amb@prop_human_bum_bin@base', 'base'	
				
				TaskTurnPedToFaceEntity(plyPed, Plants[CurKey].Object, -1)	
								
				ESX.Streaming.RequestAnimDict(dict)
				TaskPlayAnim(plyPed, dict ,anim ,8.0, -2.0, 5000, 1, 0, false, false, false)
				Citizen.Wait(5000)
				
				local syncData = (CanHarvest or PolText)
				timer = GetGameTimer()
				
				SetEntityAsMissionEntity(syncData.Object,false)
				FreezeEntityPosition(syncData.Object,false)
				
				if syncData['closest'] then
					TriggerServerEvent("CR_WeedPlant:PlantSync", syncData['closest'].Object)
				else
					TriggerServerEvent("CR_WeedPlant:PlantSync", syncData.Object)
				end
							
				Interaction = false
				Sync(Plants[CurKey], true)
				Plants[CurKey] = false
				CanHarvest = false
				PolText = false
				CurInteracting = false
			end)
		end
	end
end

RegisterNetEvent('CR_WeedPlant:PlantSync')
AddEventHandler('CR_WeedPlant:PlantSync', function(PlantSync)
    DeleteObject(PlantSync)
end)

function TextHandler()

    if Interaction == false then
	
	if not Plants then 
	   CanHarvest = false 
	   CurText = false 
	   PolText = false 
	   CurKey = false 
	   return 
	end
	
	if not #Plants then 
	   CanHarvest = false 
	   CurText = false 
	   PolText = false 
	   CurKey = false 
	   return
	end
	
	local plyPed = GetPlayerPed(-1)
	local plyPos = GetEntityCoords(plyPed)
	local plyId = ESX.GetPlayerData().identifier
	local closest, closestDist, closestKey
	
	for k = 1,#Plants,1 do
		local v = Plants[k]
		
		if v then					
			local Plants = vector3(v.Position.x, v.Position.y, v.Position.z)        
			local dist = #(plyPos - Plants)
			
			if not closest or dist < closestDist then
			   closestDist = dist
			   closest = v
			   closestKey = k
			end			
		end
	end
	
	if not closest then 
	   CanHarvest = false 
	   CurText = false 
	   PolText = false 
	   CurKey = false 
	   return 
	end
	
	if closestDist > InteractDist then 
	   CanHarvest = false 
	   CurText = false 
	   PolText = false 
	   CurKey = false 
	   return 
	end
	
	if closest.Owner == plyId then
		sleepFrameThread = 0
		if closest.Gender == "Male" then
		DrawM('[ Sex: ~b~Male ~s~]', 27, closest.Position.x, closest.Position.y, closest.Position.z)
	else
		sleepFrameThread = 0
		DrawM('[ Sex: ~p~Female ~s~]', 27, closest.Position.x, closest.Position.y, closest.Position.z - 0.3)
		end
		
		local colGrowth = GetValColour(closest.Growth)	
		DrawM("[Growth~s~ = " ..colGrowth..''..math.ceil(closest.Growth)..'%~s~ ]', 27, closest.Position.x, closest.Position.y, closest.Position.z - 0.7)
		
		if closest.Growth >= 99.99 then 
			
			if ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'police' then
			DrawM('[~y~Press ~s~[~b~E~s~] To ~g~Harvest~s~] ', 27, closest.Position.x, closest.Position.y, closest.Position.z - 0.8)
			CanHarvest = closest
		else
			CanHarvest = false
			end
		end
		
		local colQual = GetValColour(closest.Quality)
		local Quality = tonumber(string.format("%." .. (1) .. "f", closest.Quality))
		DrawM("[Quality~s~ = " ..colQual..''..Quality..'~s~ ]', 27, closest.Position.x, closest.Position.y, closest.Position.z - 0.6)
		
		local colFert = GetValColour(closest.Food)
		DrawM(colFert..'Fertilizer ~s~% ]', 27, closest.Position.x, closest.Position.y, closest.Position.z - 0.4)
		
		local colWater = GetValColour(closest.Water)
		DrawM(colWater..'Water ~s~% ]', 27, closest.Position.x, closest.Position.y, closest.Position.z - 0.5) 	
	else
		DrawM('[~y~Press ~s~[~b~G~s~] To ~g~Destroy~s~] ', 27, closest.Position.x, closest.Position.y, closest.Position.z - 0.8)
		PolText = {closest = closest}
	end	
	    CurKey = closestKey
	end
end

function GetValColour(v)

	if not v then 
	   return "[ ~s~"; 
	end
	
	if v >= 95.0 then 
		return "[ ~p~"
	elseif v >= 80.0 then 
		return "[ ~b~"
	elseif v >= 60.0 then 
		return "[ ~g~"
	elseif v >= 40.0 then 
		return "[ ~y~"
	elseif v >= 20.0 then 
		return "[ ~o~"
	elseif v >= 0.0 then 
		return "[ ~r~"
	else 
		return "[ ~s~"
	end
end

function GetQualColour(v)

	if not v then 
	   return "~s~"; 
	end
	
	if v >= 5.0 then 
		return "~b~"
	elseif v >= 4.0 then 
		return "~g~"
	elseif v >= 3.0 then 
		return "~y~"
	elseif v >= 2.0 then 
		return "~o~"
	elseif v >= 1.0 then 
		return "~y~"
	elseif v >= 0.0 then 
		return "~r~"
	else 
		return "~s~"
	end
end

function GrowthHandlerSlow()
	
	if not Plants then return end	
	if not #Plants then return	  end
	
	local plyData = ESX.GetPlayerData()
	local plyId = plyData.identifier
	
	for k = 1,#Plants,1 do
		local v = Plants[k]
		
		if v and v.Owner and v.Owner == plyId then
		   GrowPlantSlow(v,k)
		end
	end
end

function GrowPlantSlow(plant,key)
	
	if not Plants then return end	
	if not Plants[key] then return end	
	if Plants[key] ~= plant then return end
	
	local divider = 95.0 / #Objects
	local targetStage = math.max(1,math.floor(plant.Growth / divider))
	
	if plant.Stage ~= math.min(targetStage,7) then
	   plant.Stage = targetStage
	   SetEntityAsMissionEntity(plant.Object,false)
	   FreezeEntityPosition(plant.Object,false)
		
	   local hk      = GetHashKey(Objects[plant.Stage])
	   local zOffset = GetPlantZ(plant) 
		
	   DeleteObject(plant.Object)
	   plant.Object = CreateObject(hk, plant.Position.x, plant.Position.y, plant.Position.z + zOffset, false, false, false)   
	   SetEntityAsMissionEntity(plant.Object,true)
	   FreezeEntityPosition(plant.Object,true)		
	   Sync(plant,false)
	end
end

function GrowthHandlerFast()
	
	if not Plants then return;	   end	
	if not #Plants then return; end
	
	local plyData = ESX.GetPlayerData()
	local plyId = plyData.identifier
	
	for k = 1,#Plants,1 do
		local v = Plants[k]
		
		if v and v.Owner and v.Owner == plyId then
		   GrowPlantFast(v,k)
		end
	end
end

function GrowPlantFast(plant,key)
	
	if not Plants then return end	
	if not Plants[key] then return end
	if Plants[key] ~= plant then return end
	
	plant.Food = math.max(0.0,plant.Food - FoodDrainSpeed)
	plant.Water = math.max(0.0,plant.Water - WaterDrainSpeed)
	
	if plant.Food > 80.0 and plant.Water > 80.0 then
		plant.Quality = math.min(100.0,plant.Quality + (QualityGainSpeed * 2))
		plant.Growth = math.min(100.0,plant.Growth + (GrowthGainSpeed * 2))
	elseif plant.Food > 50 and plant.Water > 50 then
		plant.Quality = math.min(100.0,plant.Quality + (QualityGainSpeed / 2))
		plant.Growth = math.min(100.0,plant.Growth + GrowthGainSpeed)  
	elseif plant.Food > 0.5 and plant.Water > 0.5 then
		plant.Growth = math.min(100.0,plant.Growth + (GrowthGainSpeed / 2))
	end
	
	if (plant.Food+20.0) < plant.Quality or (plant.Water+20.0) < plant.Quality then
	   plant.Quality = math.max(0.0,plant.Quality - QualityDrainSpeed)
	end
end

function SyncCheck()
	
	if not Plants then return end
	
	local plyPed = GetPlayerPed(-1)
	local plyPos = GetEntityCoords(plyPed)
	local closestPos = GetEntityCoords(plyPed)
	
	local plys = ESX.Game.GetPlayers()
	local closestPly,closestDist
	
	for k = 1,#plys,1 do
		local ped = GetPlayerPed(plys[k])
		
		if ped ~= plyPed then  
		   local dist = #(plyPos - GetEntityCoords(ped))
			
			if not closestPly or dist < closestPly then
			   closestDist = dist
			   closestPly = ped
			end
		end
	end
	
	local plyData = ESX.GetPlayerData()
	for k = 1,#Plants,1 do
		local v = Plants[k]
		
		if v and v.Owner == plyData.identifier then 
		   Sync(v) 
		   local str = "SyncPlant-Send-"..k
		end
	end
end

function SpawnWorld(plant, k)
	
	if (not plant) then return end
	
	Plants = Plants or {}
	
	if Plants[k] then
	   local hk   = GetHashKey(Objects[plant.Stage])
	   local zOffset = GetPlantZ(Plants[k])
		
	   Plants[k].Object = CreateObject(hk, plant.Position.x, plant.Position.y, plant.Position.z + zOffset, false, false, false)            
	   FreezeEntityPosition(Plants[k].Object,true)
	   SetEntityAsMissionEntity(Plants[k].Object,true)
   else 
	   Plants[k] = plant
	   local hk   = GetHashKey(Objects[plant.Stage])
	   local zOffset = GetPlantZ(Plants[k])
		
	   Plants[k].Object = CreateObject(hk, plant.Position.x, plant.Position.y, plant.Position.z + zOffset, false, false, false)            
	   FreezeEntityPosition(Plants[k].Object,true)
	   SetEntityAsMissionEntity(Plants[k].Object,true)
	end
end

function SyncHandler(plant, delete)
	
	if not plant and not delete then return end
	
	local plyPed = GetPlayerPed(-1)
	local plyPos = GetEntityCoords(plyPed)
	
	if delete then
		if Plants then
			if #Plants then
				
				for k = 1, #Plants, 1 do
					local v = Plants[k]
					
					if v and v.Position then
						if (math.floor(v.Position.x) == math.floor(plant.Position.x)) and (math.floor(v.Position.y) == math.floor(plant.Position.y)) then
							DeleteObject(Plants[k].Object)
							Plants[k] = false
							return
						end
					end
				end
			end
		end
	else
		local plyData = ESX.GetPlayerData()
		local PlantPos = vector3(plant.Position.x, plant.Position.y, plant.Position.z) 
		local dist = #(plyPos - PlantPos)
		
		if dist < SyncDist then
			if Plants and #Plants and #Plants > 0 then			
			   local didSpawn = false
				
				for k = 1,#Plants,1 do
					if Plants[k] then
					   local v = Plants[k]   
						
						if v then     
							if v.Position.x == plant.Position.x and v.Position.y == plant.Position.y then					
								if plant.Owner ~= plyData.identifier then
								
								   local zOffset = GetPlantZ(plant)
								   FreezeEntityPosition(Plants[k].Object,false)
								   SetEntityAsMissionEntity(Plants[k].Object,false)
								   DeleteObject(Plants[k].Object)
								   
								   local hk   = GetHashKey(Objects[plant.Stage])
								   Plants[k] = plant
								   Plants[k].Object = CreateObject(hk, plant.Position.x, plant.Position.y, plant.Position.z + zOffset, false, false, false)      
								   FreezeEntityPosition(Plants[k].Object,true)
								   SetEntityAsMissionEntity(Plants[k].Object,true)
								   didSpawn = true
							   else 
								   didSpawn = true
								end
							end
						end
					end
				end
				if not didSpawn then 			
				   SpawnWorld(plant,#Plants+1)				
				end
			else
			   SpawnWorld(plant,1)			
			end
		end
	end
end

function GetPlantZ(plant)
	
	if plant.Stage <= 3 then 
	   return -1.0
   else 
	   return -3.5
	end
end

function UseItem(item)
	
	if not Plants then return end	
	if not #Plants then return end
	
	local ped = GetPlayerPed(-1)
	local id = ESX.GetPlayerData().identifier
	local closest,closestDist
	
	for k = 1,#Plants,1 do
		local v = Plants[k]
		
		if v then			
			local vPos = vector3(v.Position.x, v.Position.y, v.Position.z) 
			local dist = #(vPos - GetEntityCoords(ped))
			
			if not closestDist or dist < closestDist then
			   closestDist = dist
			   closest = v
			end
		end
	end
	
	if not closest or not closestDist then return end
	if closest.Owner ~= id then
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLANT ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Not your plant!', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
		return
	end

	if closestDist < InteractDist then 	
		
		if item.Type == "Water" then
		
			if closest.Water < 100 then			
			   TriggerServerEvent('RemoveItem:Water')			
			   closest.Water = closest.Water + (item.Quality * 100)
			   closest.Quality = closest.Quality + item.Quality
		   else
			   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLANT ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Max Water Level Reached', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)			   
			end
			
		elseif item.Type == "LowGradeFood" then	
		
			if closest.Food < 100 then
			   TriggerServerEvent('RemoveItem:LowGradeFood')	
			   closest.Food = closest.Food + (item.Quality * 100)
			   closest.Quality = closest.Quality + item.Quality
		   else
			   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLANT ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Max Food Level Reached', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)			   
			end
			
		elseif item.Type == "HighGradeFood" then	
		
			if closest.Food < 100 then
			   TriggerServerEvent('RemoveItem:HighGradeFood')	
			   closest.Food = closest.Food + (item.Quality * 100)
			   closest.Quality = closest.Quality + item.Quality
		   else
			   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLANT ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Max Food Level Reached', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
			end			
		end		
	end	
	Sync(closest)
end

function UseSeed(seed)
	
	if not seed then return end
	
	Plants          = Plants or {}
	local ply       = GetPlayerPed(-1)
	local plyPos    = GetEntityCoords(ply)
	local k         = math.max(1, #Plants +1)
	local hk        = GetHashKey(Objects[1])
	local dmin,dmax = GetModelDimensions(hk)
	local pos       = GetOffsetFromEntityInWorldCoords(ply, 0, dmax.y *5,0)
	local npos      = {x = pos.x, y = pos.y, z = plyPos.z}
	local go        = CreateObject(hk, npos.x, npos.y,npos.z - 1.0, false, false, false)  
	local frozen    = FreezeEntityPosition(go, true)
	local mission   = SetEntityAsMissionEntity(go, true)
	local plyData   = ESX.GetPlayerData()
	Plants[k]       = seed
	
	Plants[k]["Object"]   = go
	Plants[k]["Position"] = npos
	Plants[k]["Owner"]    = (plyData.identifier)
	Sync(Plants[k])	
	ReleaseModel(hk)
end

function Sync(plant, delete)
   TriggerServerEvent('CR_WeedPlant:SyncPlant',plant, delete)
end

function UseBag(canUse, msg)
	
	Citizen.CreateThread(function()
		local plyPed = GetPlayerPed(-1)
		if canUse then TaskStartScenarioInPlace(plyPed, "PROP_HUMAN_PARKING_METER", 0, true); end
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLANT ALERT', '[~b~'..ESX.Game.GetPedRPNames()..' '..msg, mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
		Wait(5000)
	    ClearPedTasksImmediately(plyPed)
	end)
end

function LoadModel(model, wait)
	
	local hk = GetHashKey(model)
	
	if wait then
		while not HasModelLoaded(hk) do 
		   Citizen.Wait(0)
		   RequestModel(hk)
		end
	else
	   RequestModel(hk)
	end
	return true
end

function ReleaseModel(model)
	
	local hk = GetHashKey(model)
	
	if HasModelLoaded(hk) then 
	   SetModelAsNoLongerNeeded(hk)
	end
	return true
end

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.6)
end

RegisterNetEvent('CR_WeedPlant:UseSeed')
AddEventHandler('CR_WeedPlant:UseSeed', function(seed) 	
	if iR then 
	   UseSeed(seed)
	end 
end)

RegisterNetEvent('CR_WeedPlant:UseItem')
AddEventHandler('CR_WeedPlant:UseItem', function(item) 	
	if iR then 
	   UseItem(item) 
	end 
end)

RegisterNetEvent('CR_WeedPlant:SyncPlant')
AddEventHandler('CR_WeedPlant:SyncPlant', function(plant, del) 	
	if iR then 
	   SyncHandler(plant, del) 
	end 
end)

RegisterNetEvent('CR_WeedPlant:UseBag')
AddEventHandler('CR_WeedPlant:UseBag', function(canUse,msg) 
	UseBag(canUse,msg) 
end)