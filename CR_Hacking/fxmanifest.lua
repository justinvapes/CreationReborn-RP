fx_version 'adamant'

game 'gta5'

client_scripts {
  'client/cl.lua',
  '@es_extended/locale.lua',
}

server_scripts {
	'server/server.lua',
	'@es_extended/locale.lua',	
} 


files({
  'Main/client.lua',
})



dependency 'es_extended'
