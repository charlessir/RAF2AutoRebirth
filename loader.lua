-- CONFIG
_G.AutoRebirthConfig = {
    AutoStart = true,        -- start automatically
    QueueOnTeleport = true,  -- auto run after rebirth teleport
    CountRebirths = true,    -- track rebirth count
    TeleportDelay = 1        -- delay before teleport
}

-- LOAD SCRIPT
loadstring(game:HttpGet("https://github.com/charlessir/RAF2AutoRebirth/raw/refs/heads/main/source.lua"))()
