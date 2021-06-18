fx_version 'adamant'

game 'gta5'

client_scripts {
  '@es_extended/locale.lua',
  'locales/fr.lua',
  'client/main.lua',
  'config.lua'	
}

server_scripts {
  '@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'locales/fr.lua',
  'server/main.lua',
  'config.lua'
}
