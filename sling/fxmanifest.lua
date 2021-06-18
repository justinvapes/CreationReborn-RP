fx_version 'cerulean'

game 'gta5'

title 'Weapon Sling'
description 'Weapon Sling Script, Sting & Dragon 5PD 2021'
author 'Sting / Sting#0100 Discord'
version 'v1.0'

client_scripts {
	'Config.lua',
    'client.lua',
}

server_scripts {
	'Config.lua',
    '@mysql-async/lib/MySQL.lua',
	'server.lua',
}

exports {
    'IsWeaponSlung',
    'SlungWeapon',
}