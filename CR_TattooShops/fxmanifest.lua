fx_version 'adamant'

game 'gta5'


files({
  'Main/client.lua',
  'Overlays/mpheist3_overlays.xml',
  'Overlays/mpvinewood_overlays.xml',
  'Overlays/mpcustom_overlays.xml',
  'Overlays/mpcustomskull_overlays.xml',
})


server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/tattooList.lua',
	'client/main.lua'
}


data_file 'PED_OVERLAY_FILE' 'Overlays/mpheist3_overlays.xml'
data_file 'PED_OVERLAY_FILE' 'Overlays/mpvinewood_overlays.xml'
data_file 'PED_OVERLAY_FILE' 'Overlays/mpcustom_overlays.xml'
data_file 'PED_OVERLAY_FILE' 'Overlays/mpcustomskull_overlays.xml'