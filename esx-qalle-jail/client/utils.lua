function LoadAnim(animDict)
	RequestAnimDict(animDict)

	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

function LoadModel(model)
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

function Cutscene()
	DoScreenFadeOut(100)

	Citizen.Wait(250)
	
	male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
	femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
	 
    if male or femalemale then
  
	TriggerEvent('skinchanger:getSkin', function(skin)
		if male then
			local clothesSkin = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,
				['torso_1']  = 22, ['torso_2']  = 0,
				['arms']     = 0,
				['pants_1']  = 27, ['pants_2']  = 2,
				['shoes_1']  = 4,  ['shoes_2']  = 2,
				['mask_1']   = 0,  ['mask_2']   = 0,
		        ['helmet_1'] = -1,  ['helmet_2'] = 0,
				['bags_1']   = 0,  ['bags_2']   = 0,
				['chain_1']  = 0,  ['chain_2']  = 0,
			} 
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		else
			local clothesSkin = {
				['tshirt_1'] = 2,  ['tshirt_2'] = 0,
				['torso_1']  = 79, ['torso_2']  = 2,
				['arms']     = 14,
				['pants_1']  = 3,  ['pants_2']  = 15,
				['shoes_1']  = 1,  ['shoes_2']  = 0,
				['mask_1']   = 0,  ['mask_2']   = 0,
		        ['helmet_1'] = -1,  ['helmet_2'] = 0,
				['bags_1']   = 0,  ['bags_2']   = 0,
				['chain_1']  = 0,  ['chain_2']  = 0,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end
      end)
	end

	LoadModel(-1320879687)

	local PolicePosition = Config.Cutscene["PolicePosition"]
	local Police = CreatePed(5, -1320879687, PolicePosition["x"], PolicePosition["y"], PolicePosition["z"], PolicePosition["h"], false)
	TaskStartScenarioInPlace(Police, "WORLD_HUMAN_PAPARAZZI", 0, false)

	local PlayerPosition = Config.Cutscene["PhotoPosition"]
	local PlayerPed = PlayerPedId()
	SetEntityCoords(PlayerPed, PlayerPosition["x"], PlayerPosition["y"], PlayerPosition["z"] - 1)
	SetEntityHeading(PlayerPed, PlayerPosition["h"])
	FreezeEntityPosition(PlayerPed, true)

	Cam()

	Citizen.Wait(1000)
	DoScreenFadeIn(100)
	Citizen.Wait(10000)
	DoScreenFadeOut(250)
	
	local Randomcell = math.random(1, 4) 
	
	if Randomcell == 1 then 
	   JailPosition = {x = 478.07,  y = -1014.33, z = 26.27}
	
	elseif Randomcell == 2 then 
		JailPosition = {x = 480.99,  y = -1014.33, z = 26.27}
	
	elseif Randomcell == 3 then 
		JailPosition = {x = 483.77,  y = -1014.33, z = 26.27}
	   
	elseif Randomcell == 4 then 
		JailPosition = {x = 486.73,  y = -1014.33, z = 26.27}	   
	end
	
	SetEntityCoords(PlayerPedId(), JailPosition.x, JailPosition.y, JailPosition.z)
	
	DeleteEntity(Police)
	SetModelAsNoLongerNeeded(-1320879687)
	
	Citizen.Wait(1000)
	DoScreenFadeIn(250)
	RenderScriptCams(false,  false,  0,  true,  true)
	FreezeEntityPosition(PlayerPed, false)
	DestroyCam(Config.Cutscene["CameraPos"]["cameraId"])
	InJail()
end

function Cam()
	local CamOptions = Config.Cutscene["CameraPos"]

	CamOptions["cameraId"] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(CamOptions["cameraId"], CamOptions["x"], CamOptions["y"], CamOptions["z"])
	SetCamRot(CamOptions["cameraId"], CamOptions["rotationX"], CamOptions["rotationY"], CamOptions["rotationZ"])

	RenderScriptCams(true, false, 0, true, true)
end