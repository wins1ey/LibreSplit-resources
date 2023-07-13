process('jetsetradio.exe')

local current = {isLoading, newGame, rankingScreen, bossGraffiti}
local old = {isLoading, newGame, bossGraffiti}

function state()
    old.newGame = current.newGame
    old.rankingScreen = current.rankingScreen
    old.bossGraffiti = current.bossGraffiti

    current.isLoading = readAddress('bool', 0x58FAAC)
    current.newGame = readAddress('bool', 0x75A278)
    current.rankingScreen = readAddress('bool', 0x58FB1C)
    current.bossGraffiti = readAddress('int', 0x55D2B8)
end

function startup()
    refreshRate = 62
end

function start()
    return old.newGame and not current.newGame
end

function split()
    return old.bossGraffiti ~= 7 and current.bossGraffiti == 7 or not old.rankingScreen and current.rankingScreen
end

function isLoading()
    return current.isLoading
end
