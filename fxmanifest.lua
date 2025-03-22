fx_version 'cerulean'
game 'gta5'

name 'Vpeche'
description 'Système de pêche avancé pour FiveM/ESX'
author 'Joris'
version '1.0.0'

shared_script 'config.lua'
client_scripts {
 	'RageUI/RMenu.lua',
    'RageUI/menu/RageUI.lua',
    'RageUI/menu/Menu.lua',
    'RageUI/menu/MenuController.lua',
    'RageUI/components/*.lua',
    'RageUI/menu/elements/*.lua',
    'RageUI/menu/items/*.lua',
    'RageUI/menu/panels/*.lua',
    'RageUI/menu/windows/*.lua',
    'client.lua'
}

server_script 'server.lua'

dependencies {
    'es_extended',
}