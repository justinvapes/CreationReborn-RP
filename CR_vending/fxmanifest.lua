fx_version 'cerulean'
game 'gta5'

author 'JustDelta'
description 'Fancy a beverage?'
version '1.0.0'

dependencies {
    "PolyZone"
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'config.lua',
    'client.lua',
}

server_scripts {
    'config.lua',
    'server.lua'
}