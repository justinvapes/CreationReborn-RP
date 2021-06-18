Citizen.CreateThread(function()
	while true do
        --This is the Application ID (Replace this with you own)
		SetDiscordAppId(765469524757577748)

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('creationreborn_-_light')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('Creation Reborn FiveM')
       
        --Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('creationreborn_-_light')

        --Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('Creation Reborn FiveM')

        --It updates every one minute just in case.
		Citizen.Wait(60000)
	end
end)