fx_version 'bodacious'
author 'Brown Development'
description 'Browns Player Monitor (Screenshot)'
game 'gta5'
lua54 'yes'
client_scripts {
    'code/client.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'code/server.lua'
}
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'code/shared.lua'
}
dependencies {
    'oxmysql',
    'ox_lib',
    'screenshot-basic'
}