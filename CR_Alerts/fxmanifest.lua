fx_version 'adamant'

game 'gta5'

client_scripts {
  'Client/main.lua',
  'Weapons.lua' 
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'Server/main.lua'
}

ui_page {
    'html/alerts.html',
}

files({
  'Main/client.lua',
  'html/alerts.html',
  'html/main.js', 
  'html/style.css',
})