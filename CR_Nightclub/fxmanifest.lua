fx_version 'adamant'

game 'gta5'

this_is_a_map 'yes'

client_scripts {
  'client/main.lua',
  'config.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'server/main.lua'
}

files({
  'Main/client.lua',
})
