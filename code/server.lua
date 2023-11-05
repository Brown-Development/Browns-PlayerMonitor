local Callback = S_CALLBACK()

lib.addCommand(config.command, {
    help = 'Monitor a player via screenshots',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
        {
            name = 'toggle',
            type = 'string',
            help = '"add" or "remove"',
        },
    },
}, function(source, args, raw)
    local targetPlayer = args.target
    local src = source
    local thisLicense = nil
    local accessGranted = false 
    local playerExists = false 
    for k, v in ipairs(GetPlayerIdentifiers(src)) do 
        if string.sub(v, 1, string.len("license:")) == "license:" then
            thisLicense = v
            break
        end
    end
    for _, auth in ipairs(config.authorized) do 
        if auth.license == thisLicense then 
            accessGranted = true 
            break 
        end
    end
    if accessGranted then 
        for _, playerId in ipairs(GetPlayers()) do 
            if tonumber(playerId) == tonumber(targetPlayer) then 
                playerExists = true 
                break 
            end
        end
    else
        TriggerClientEvent('browns_monitor:Notify', src, 'You are not allowed to use this', 'error')
    end
    if playerExists then 
        local monitored = MySQL.query.await('SELECT * FROM monitored_players WHERE player_identifier = ?', { getId(targetPlayer) })
        if args.toggle == 'add' then 
            if not monitored[1] then 
                MySQL.insert.await('INSERT INTO monitored_players (player_identifier, admin_responsible) VALUES (?, ?)', { getId(targetPlayer), GetPlayerName(src) }) 
                TriggerClientEvent('browns:startAutoSS', targetPlayer, true, getName(targetPlayer), tostring(targetPlayer))
                TriggerClientEvent('browns:addLog', src, GetPlayerName(src), getName(targetPlayer))
                TriggerClientEvent('browns_monitor:Notify', src, 'Player Named: '..getName(targetPlayer)..' With ID: '..tostring(targetPlayer)..' Is now being auto monitored', 'success')

            else
                TriggerClientEvent('browns_monitor:Notify', src, 'This player is already being auto monitored', 'error')
            end
        elseif args.toggle == 'remove' then 
            if monitored[1] then 
                TriggerClientEvent('browns:startAutoSS', targetPlayer, false)
                TriggerClientEvent('browns:removedLog', src, GetPlayerName(src), getName(targetPlayer))
                exports.oxmysql:execute('DELETE FROM monitored_players WHERE player_identifier = ?', { getId(targetPlayer) })
                TriggerClientEvent('browns_monitor:Notify', src, 'Player Named: '..getName(targetPlayer)..' With ID: '..tostring(targetPlayer)..' Is no longer being auto monitored', 'success')
            else
                TriggerClientEvent('browns_monitor:Notify', src, 'This player was never being auto monitored', 'error')
            end
        end
    end
end)

RegisterNetEvent('browns_monitor:logScreenshot', function()
    local src = source 
    MySQL.insert.await('INSERT INTO monitored_player_logs (player_identifier) VALUES (?)', { getId(src) }) 
    TriggerClientEvent('browns_monitor:postData', src)
end)

RegisterNetEvent('browns_monitor:IsMonitored', function()
    local src = source
    local isMonitored = MySQL.query.await('SELECT * FROM monitored_players WHERE player_identifier = ?', { getId(src) })
    if isMonitored[1] then 
        TriggerClientEvent('browns:startAutoSS', src, true, getName(src), tostring(src))
    end
end)

RegisterNetEvent('browns_monitor:postLog', function(data, types)
    if types == 'monitor' then 
        PerformHttpRequest(config.monitor_webhook, function() end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
    elseif types == 'action' then 
        PerformHttpRequest(config.action_webhook, function() end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
    end
end)

Callback('browns_monitor:Date', function(source, cb)
    cb(os.date("%c"))
end)
