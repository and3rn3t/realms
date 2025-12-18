--[[
    World Management
    Manages the current realm and realm switching
]]

local World = {}
World.currentRealm = nil
World.realms = {}
World.realmData = {}

-- Initialize world system
function World.init()
    World.currentRealm = nil
    World.realms = {}
    World.realmData = {}
end

-- Register a realm
function World.registerRealm(name, data)
    World.realmData[name] = data
end

-- Load a realm
function World.loadRealm(name)
    local data = World.realmData[name]
    if not data then
        print("Warning: Realm '" .. name .. "' not found")
        return nil
    end

    -- Create realm if not already loaded
    if not World.realms[name] then
        local Realm = require("src.world.Realm")
        local realm = Realm.new(data.name or name, data.width or 800, data.height or 600)
        realm:load()
        World.realms[name] = realm
    end

    World.currentRealm = World.realms[name]
    return World.currentRealm
end

-- Get current realm
function World.getCurrentRealm()
    return World.currentRealm
end

-- Update current realm
function World.update(dt)
    if World.currentRealm then
        World.currentRealm:update(dt)
    end
end

-- Draw current realm
function World.draw()
    if World.currentRealm then
        World.currentRealm:draw()
    end
end

-- Switch to a different realm
function World.switchRealm(name, player)
    local newRealm = World.loadRealm(name)

    if newRealm and player then
        -- Position player in new realm (could be based on portal/entry point)
        player:setPosition(newRealm.width / 2, newRealm.height / 2)

        -- Set up player collision
        if newRealm:getCollisionWorld() then
            player:setCollisionWorld(newRealm:getCollisionWorld())
        end
    end

    return newRealm
end

return World

