RegisterNetEvent(tostring(onPlayerLoaded()))
AddEventHandler(tostring(onPlayerLoaded()), function(xPlayer)
    if string.find(onPlayerLoaded(), 'esx') then local thisCore = getCore() thisCore.PlayerData = xPlayer while not thisCore.IsPlayerLoaded() do Citizen.Wait(0) end end
    TriggerServerEvent('browns_monitor:IsMonitored')
end)

local monitor = false
local name = nil
local id = nil
local Callback = C_CALLBACK()

RegisterNetEvent('browns:startAutoSS', function(toggle, player, serverId)
    monitor = toggle
    name = player
    id = serverId
end)

RegisterNetEvent('browns:removedLog', function(admin, freeplayer)
    Callback('browns_monitor:Date', function(date)
        local embedData = {
            {
                ["title"] = 'Admin Action (Remove Player)',
                ["color"] = 16711680,
                ["footer"] = {
                    ["text"] = date,
                },
                ["description"] = 'A **Administrator** Removed a Player from being auto monitored'..'\n'..'**Admin Name:** '..admin..'\n'..'**Player Removed:** '..freeplayer,
            }
        }
        local removeData = {username = 'Browns Player Monitor', embeds = embedData, avatar_url = 'https://i.imgur.com/MgsZv5w.png'}
        TriggerServerEvent('browns_monitor:postLog', removeData, 'action')
    end)
end)

RegisterNetEvent('browns:addLog', function(admin, freeplayer)
    Callback('browns_monitor:Date', function(date)
        local embedData = {
            {
                ["title"] = 'Admin Action (Add Player)',
                ["color"] = 38656,
                ["footer"] = {
                    ["text"] = date,
                },
                ["description"] = 'A **Administrator** Added a Player to be auto monitored'..'\n'..'**Admin Name:** '..admin..'\n'..'**Player Added:** '..freeplayer,
            }
        }
        local addData = {username = 'Browns Player Monitor', embeds = embedData, avatar_url = 'https://i.imgur.com/MgsZv5w.png'}
        TriggerServerEvent('browns_monitor:postLog', addData, 'action')
    end)
end)

RegisterNetEvent('browns_monitor:postData', function()
    Callback('browns_monitor:Date', function(date)
        local embedData = {
            {
                ["title"] = 'Auto Screenshot Taken',
                ["color"] = 38656,
                ["footer"] = {
                    ["text"] = date,
                },
                ["description"] = 'A auto monitor screenshot was taken'..'\n'..'**Name:** '..name..'\n'..'**ID:** '..id..'\n'..'**Attached Screenshot:** *see below*',
            }
        }
        local postData = {username = 'Browns Player Monitor', embeds = embedData, avatar_url = 'https://i.imgur.com/MgsZv5w.png'}
        TriggerServerEvent('browns_monitor:postLog', postData, 'monitor')
        exports['screenshot-basic']:requestScreenshotUpload(config.monitor_webhook, 'files[]')
    end)
end)

RegisterNetEvent('browns_monitor:Notify', function (message, types)
    lib.notify({
        id = 'browns_monitor',
        title = 'Browns Player Monitor',
        description = message,
        duration = 5000,
        position = 'top',
        type = types,
        style = {
            backgroundColor = '#FF0000',
            color = '#FFFFFF',
            ['.description'] = {
              color = '#FFFFFF'
            }
        },
    })
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(60000 * config.screenshot_timer)
        if monitor then 
            TriggerServerEvent('browns_monitor:logScreenshot')
        end 
    end
end)
