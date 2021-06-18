fx_version 'cerulean'
game 'gta5'

author 'JustDelta_'
description 'Evidence Locker for Police/CID'

client_scripts {
    'client/client_main.lua',
    'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/server_main.lua'
}