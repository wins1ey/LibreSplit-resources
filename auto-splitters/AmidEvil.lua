process('AmidEvil-Win64-Shipping.exe')

local old = {start, loading, menuStage, paused}
local current = {start, loading, menuStage, paused}

function startup()
    refreshRate = 120
end

function state()
    old.start = current.start
    old.loading = current.loading
    old.menuStage = current.menuStage
    old.paused = current.paused

    current.start = readAddress('byte', 0x2BAFFD0)
    current.loading = readAddress('byte', 0x2E76B0C)
    current.menuStage = readAddress('byte', 0x2F75F14)
    current.paused = readAddress('byte', 0x2B95A68)
end

function start()
    if current.start == 0 and old.start == 2 then
        return true
    end
end

function isLoading()
    return (current.loading == 1 or (current.menuStage == 3 and current.paused == 4))
end

function split()
    if (current.menuStage == 3 and old.menuStage == 2) and current.paused ~= 28 and current.paused ~= 3 then
        return true
    end
end
