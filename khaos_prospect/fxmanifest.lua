fx_version 'adamant'
game 'gta5'

description 'Khaos Prospect'

version '1.1.0'

ui_page 'html/ui.html'

client_scripts {
	'config.lua',
	'client/cl_main.lua',
}

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/sv_main.lua',
}

dependency {
	'es_extended',
	'esx_society',
	'esx_billing',
}

files {
    'html/ui.html',
    'html/css/main.css',
    'html/js/app.js',
}