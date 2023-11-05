local CORES = config.framework

function getCore()
    if CORES == 'esx' then 
        return exports['es_extended']:getSharedObject()
    elseif CORES == 'qb-core' then 
        return exports['qb-core']:GetCoreObject()
    end
end

function getName(source)
    local xPlayer = getPlayer(source)
    if CORES == 'qb-core' then 
        return tostring(xPlayer.PlayerData.charinfo.firstname)..' '..tostring(xPlayer.PlayerData.charinfo.lastname)
    elseif CORES == 'esx' then 
        return tostring(xPlayer.getName())
    end 
end

function getId(source)
    local xPlayer = getPlayer(source)
    if CORES == 'qb-core' then 
        return xPlayer.PlayerData.citizenid
    elseif CORES == 'esx' then 
        return xPlayer.getIdentifier()
    end
end

function C_CALLBACK()
    local _CORE = getCore()
    if CORES == 'qb-core' then 
        return _CORE.Functions.TriggerCallback
    elseif CORES == 'esx' then
        return _CORE.TriggerServerCallback
    end 
end

function S_CALLBACK()
    local _CORE = getCore()
    if CORES == 'qb-core' then 
        return _CORE.Functions.CreateCallback
    elseif CORES == 'esx' then 
        return _CORE.RegisterServerCallback
    end 
end

function onPlayerLoaded()
    if CORES == 'qb-core' then 
        return 'QBCore:Client:OnPlayerLoaded'
    elseif CORES == 'esx' then 
        return 'esx:playerLoaded'
    end
end

function getPlayer(source)
    local _CORE = getCore()
    if CORES == 'qb-core' then 
        return _CORE.Functions.GetPlayer(source)
    elseif CORES == 'esx' then 
        return _CORE.GetPlayerFromId(source)
    end
end