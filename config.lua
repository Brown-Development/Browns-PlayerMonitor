config = {}

config.framework = 'qb-core' -- 'qb-core' or 'esx'

config.command = 'ssmonitor' -- command to monitor players

config.screenshot_timer = 1 -- (in minutes) how often will the players screenshot be logged

config.monitor_webhook = '' -- the webhook where screenshots of players who are monitored are posted

config.action_webhook = '' -- the webhook where admin actions are logged (lets you know who added/removed player monitors)

config.authorized = { -- player licenses who are authorized to use the command to monitor players
    {license = 'license:1234567890abcdefghijklmnopqrstuvwxyz'}, 
    -- {license = ''}, -- add as many as you want...
}