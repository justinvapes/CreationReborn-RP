Config = {}

-- Script locale (only .Lua)
Config.Locale = 'en'

Config.FixePhone = {
}

-- TEMPORARILY ONLY WORKS IN es_extended 1.1 and older, Fixing this in the next couple of days, forgot something in the code. --

Config.newESX = false -- True = ESX 1.2(v1final), False = ESX 1.1 and older. (NOT WORKING YET, FORGOT SOMETHING IN CODE, HAVE TO FIND IT)

Config.KeyOpenClose = 243 -- F1
Config.KeyTakeCall  = 38  -- E

Config.UseMumbleVoIP = true -- Use Frazzle's Mumble-VoIP Resource (Recommended!) https://github.com/FrazzIe/mumble-voip
Config.UseTokoVoIP   = false

Config.ShowNumberNotification = true -- Show Number or Contact Name when you receive new SMS

Config.ShareRealtimeGPSDefaultTimeInMs = 1000 * 60 -- Set default realtime GPS sharing expiration time in milliseconds
Config.ShareRealtimeGPSJobTimer = 10 -- Default Job GPS Timer (Minutes)

-- Optional Features (Can all be set to true or false.)
Config.ItemRequired = true -- If true, must have the item "phone" to use it.
Config.NoPhoneWarning = true -- If true, the player is warned when trying to open the phone that they need a phone. To edit this message go to the locales for your language.

-- Optional Discord Logging
Config.UseDiscordLogging = false -- Work in progress. Functions are limited to twitter.
Config.Discord_Webhook = 'https://discord.com/api/webhooks/' -- Set Discord Webhook. See https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks