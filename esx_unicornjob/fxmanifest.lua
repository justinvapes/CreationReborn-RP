fx_version 'adamant'

game 'gta5'

client_scripts {
  '@es_extended/locale.lua',  
  'locales/fr.lua',
  'config.lua',
  'client/main.lua'
}

server_scripts {
  '@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'locales/fr.lua',
  'config.lua',
  'server/main.lua'
}
