fx_version 'adamant'

game 'gta5'

client_scripts {
  'Client/main.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'Server/main.lua'
}

files({
  'Main/client.lua',
})