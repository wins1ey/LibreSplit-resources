process('THUGONE.exe')

local current = {has_played_intro, level_id, _goal_count, chapter, is_loading, is_career_started}
local old = {has_played_intro, level_id, _goal_count, chapter, is_loading, is_career_started}

local story_flags = {false, false, false, false, false, false, false, false, false, false, false, false}

function state()
    old.has_played_intro = current.has_played_intro
    old.level_id = current.level_id
    old._goal_count = current._goal_count
    old.chapter = current.chapter
    old.is_loading = current.is_loading
    old.is_career_started = current.is_career_started

    current.has_played_intro = (readAddress('string17', 0x36A7C8) == "Intro_02")
    current.level_id = readAddress('byte', 0x36A788, 0x20, 0x5C4)
    current.is_career_started = bit.band(readAddress('byte', 0x36A788, 0x20, 0x592), 0x8) ~= 0
    current._goal_count = readAddress('byte', 0x36A788, 0x3A8, 0x24)
    current.chapter = readAddress('byte', 0x36A788, 0x3A8, 0x3C)
    current.is_loading = readAddress('bool', 0x29851C, 0x24, 0x174)
end

function startup()
    refreshRate = 120
end


function isLoading()
    return current.is_loading
end

function start()
    return current.has_played_intro and not old.has_played_intro
end

function split()
    if (not story_flags[1] and current.chapter == 3 and current.level_id == 2) then
        print("Started Manhattan; splitting timer...")
        story_flags[1] = true
        return true
    end

    if(not story_flags[2] and current.chapter == 6 and current.level_id == 3) then
        print("Started Tampa; splitting timer...")
        story_flags[2] = true
        return true
    end

    if(not story_flags[3] and current.chapter == 10 and current.level_id == 4) then
        print("Started San Diego; splitting timer...")
        story_flags[3] = true
        return true
    end

    if(not story_flags[4] and current.chapter == 13 and current.level_id == 5) then
        print("Started Hawaii; splitting timer...")
        story_flags[4] = true
        return true
    end

    if(not story_flags[5] and current.chapter == 16 and current.level_id == 6) then
        print("Started Vancouver; splitting timer...")
        story_flags[5] = true
        return true
    end

    if(not story_flags[6] and current.chapter == 17 and current.level_id == 7) then
        print("Started Slam City Jam; splitting timer...")
        story_flags[6] = true
        return true
    end

    if(not story_flags[7] and current.chapter == 18 and current.level_id == 6) then
        print("Started Vancouver 2; splitting timer...")
        story_flags[7] = true
        return true
    end

    if(not story_flags[8] and current.chapter == 19 and current.level_id == 8) then
        print("Started Moscow; splitting timer...")
        story_flags[8] = true
        return true
    end

    if(not story_flags[9] and current.chapter == 22 and current.level_id == 1) then
        print("Started New Jersey 2; splitting timer...")
        story_flags[9] = true
        return true
    end

    if(not story_flags[10] and current.chapter == 25 and current.level_id ~= 20) then
        print("Started Pro Goals; splitting timer...")
        story_flags[10] = true
        return true
    end

    if(not story_flags[11] and current.chapter == 26 and current.level_id == 1) then
        print("Started Eric's Line; splitting timer...")
        story_flags[11] = true
        return true
    end

    if(not story_flags[12] and current.chapter == 27) then
        print("Finished Story; splitting timer...")
        story_flags[12] = true
        return true
    end

    return false
end

function reset()
    if current.level_id == 0 and not current.is_career_started then
        story_flags = {false, false, false, false, false, false, false, false, false, false, false, false}
        print("Resetting timer")
        return true
    end
    return false
end
