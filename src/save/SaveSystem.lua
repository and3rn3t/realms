--[[
    Save/Load System
    Handles game state persistence
]]

local SaveSystem = {}
SaveSystem.saveData = {}

-- Initialize save system
function SaveSystem.init()
    SaveSystem.saveData = {}
end

-- Save game
function SaveSystem.save(slot, gameState)
    SaveSystem.saveData[slot] = {
        timestamp = os.time(),
        data = gameState,
    }
    
    -- Try to use bitser if available
    local success, bitser = pcall(require, "libs.bitser")
    if success and bitser then
        local data = bitser.dumps(SaveSystem.saveData[slot])
        love.filesystem.write("save_" .. slot .. ".dat", data)
    else
        -- Fallback: JSON (would need json.lua)
        print("Save system: bitser not available, using memory only")
    end
end

-- Load game
function SaveSystem.load(slot)
    -- Try to use bitser if available
    local success, bitser = pcall(require, "libs.bitser")
    if success and bitser then
        local data = love.filesystem.read("save_" .. slot .. ".dat")
        if data then
            SaveSystem.saveData[slot] = bitser.loads(data)
            return SaveSystem.saveData[slot]
        end
    end
    
    -- Fallback: memory
    return SaveSystem.saveData[slot]
end

return SaveSystem

