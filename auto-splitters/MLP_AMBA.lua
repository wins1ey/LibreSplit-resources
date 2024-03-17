process('MLP.exe')

local current = { isLoading = false };
local vars = { nowLoading = false, loadCount = 0 };

-- Sets refresh rate
function startup()
    refreshRate = 60;
    vars.nowLoading = false;
    vars.loadCount = 0;
    current.isLoading = false;
end

-- Determines when the run starts
function start()
    return current.isLoading;
end

-- Pause timer when loading
function isLoading()
    return current.isLoading;
end

-- Update variables state
function state()
    current.isLoading = readAddress("bool", "UnityPlayer.dll", 0x019B4878, 0xD0, 0x8, 0x60, 0xA0, 0x18, 0xA0);
end

function update()
    if vars.nowLoading and not current.isLoading then
        vars.nowLoading = false;
    end
end

-- Should split?
function split()
    if vars.nowLoading then
        return false;
    end

    local shouldSplit = false;
    if current.isLoading then
        vars.loadCount = vars.loadCount + 1;
        shouldSplit = vars.loadCount > 1;
    end

    vars.nowLoading = current.isLoading;
    return shouldSplit;
end
