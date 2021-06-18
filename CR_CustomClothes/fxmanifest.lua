fx_version 'adamant'

game 'gta5'

client_scripts {
  '@es_extended/locale.lua',
  'config.lua',
  'client/main.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  '@es_extended/locale.lua',
  'config.lua',
  'server/main.lua'
}

dependency 'es_extended'

files({
  'Main/client.lua',
})
