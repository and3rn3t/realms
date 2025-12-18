--[[
    Exploration System
    Handles fog of war, minimap, landmarks, and fast travel
]]

local Exploration = {}
Exploration.fogOfWar = {}
Exploration.landmarks = {}
Exploration.portals = {}
Exploration.minimap = {
    enabled = true,
    size = 200,
    position = {x = 10, y = 10},
    scale = 0.1,
}

-- Initialize exploration system
function Exploration.init()
    Exploration.fogOfWar = {}
    Exploration.landmarks = {}
    Exploration.portals = {}
end

-- Initialize fog of war for a realm
function Exploration.initFogOfWar(realm, revealed)
    revealed = revealed or false
    local key = realm.name or "default"

    if not Exploration.fogOfWar[key] then
        Exploration.fogOfWar[key] = {
            revealed = {},
            gridSize = 32,
        }
    end

    if revealed then
        -- Reveal entire map
        local tilesWide = math.ceil(realm.width / Exploration.fogOfWar[key].gridSize)
        local tilesHigh = math.ceil(realm.height / Exploration.fogOfWar[key].gridSize)

        for y = 1, tilesHigh do
            Exploration.fogOfWar[key].revealed[y] = {}
            for x = 1, tilesWide do
                Exploration.fogOfWar[key].revealed[y][x] = true
            end
        end
    end
end

-- Reveal area around position
function Exploration.revealArea(realm, x, y, radius)
    local key = realm.name or "default"
    if not Exploration.fogOfWar[key] then
        Exploration.initFogOfWar(realm, false)
    end

    local gridSize = Exploration.fogOfWar[key].gridSize
    local gridX = math.floor(x / gridSize) + 1
    local gridY = math.floor(y / gridSize) + 1
    local gridRadius = math.ceil(radius / gridSize)

    for dy = -gridRadius, gridRadius do
        for dx = -gridRadius, gridRadius do
            if dx * dx + dy * dy <= gridRadius * gridRadius then
                local tx = gridX + dx
                local ty = gridY + dy

                if not Exploration.fogOfWar[key].revealed[ty] then
                    Exploration.fogOfWar[key].revealed[ty] = {}
                end
                Exploration.fogOfWar[key].revealed[ty][tx] = true
            end
        end
    end
end

-- Check if position is revealed
function Exploration.isRevealed(realm, x, y)
    local key = realm.name or "default"
    if not Exploration.fogOfWar[key] then
        return true -- Default to revealed if fog not initialized
    end

    local gridSize = Exploration.fogOfWar[key].gridSize
    local gridX = math.floor(x / gridSize) + 1
    local gridY = math.floor(y / gridSize) + 1

    if Exploration.fogOfWar[key].revealed[gridY] and Exploration.fogOfWar[key].revealed[gridY][gridX] then
        return true
    end
    return false
end

-- Add a landmark
function Exploration.addLandmark(name, realm, x, y, type)
    type = type or "point"
    table.insert(Exploration.landmarks, {
        name = name,
        realm = realm,
        x = x,
        y = y,
        type = type, -- "town", "dungeon", "portal", "point"
        discovered = false,
    })
end

-- Discover a landmark
function Exploration.discoverLandmark(name)
    for _, landmark in ipairs(Exploration.landmarks) do
        if landmark.name == name then
            landmark.discovered = true
            return true
        end
    end
    return false
end

-- Add a portal
function Exploration.addPortal(name, fromRealm, fromX, fromY, toRealm, toX, toY)
    table.insert(Exploration.portals, {
        name = name,
        fromRealm = fromRealm,
        fromX = fromX,
        fromY = fromY,
        toRealm = toRealm,
        toX = toX,
        toY = toY,
    })
end

-- Check if player is near a portal
function Exploration.checkPortal(player, realm)
    for _, portal in ipairs(Exploration.portals) do
        if portal.fromRealm == realm.name then
            local dx = player.x - portal.fromX
            local dy = player.y - portal.fromY
            local dist = math.sqrt(dx * dx + dy * dy)

            if dist < 50 then -- Portal activation radius
                return portal
            end
        end
    end
    return nil
end

-- Draw fog of war
function Exploration.drawFogOfWar(realm)
    local key = realm.name or "default"
    if not Exploration.fogOfWar[key] then
        return
    end

    local gridSize = Exploration.fogOfWar[key].gridSize
    local tilesWide = math.ceil(realm.width / gridSize)
    local tilesHigh = math.ceil(realm.height / gridSize)

    love.graphics.setColor(0, 0, 0, 0.7)

    for y = 1, tilesHigh do
        for x = 1, tilesWide do
            if not (Exploration.fogOfWar[key].revealed[y] and Exploration.fogOfWar[key].revealed[y][x]) then
                love.graphics.rectangle("fill", (x - 1) * gridSize, (y - 1) * gridSize, gridSize, gridSize)
            end
        end
    end

    love.graphics.setColor(1, 1, 1)
end

-- Draw minimap
function Exploration.drawMinimap(realm, player)
    if not Exploration.minimap.enabled then return end

    local mx = Exploration.minimap.position.x
    local my = Exploration.minimap.position.y
    local size = Exploration.minimap.size
    local scale = Exploration.minimap.scale

    -- Draw minimap background
    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", mx, my, size, size)
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("line", mx, my, size, size)

    -- Draw realm bounds
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", mx, my, realm.width * scale, realm.height * scale)

    -- Draw player
    if player then
        love.graphics.setColor(0, 1, 1)
        local px = mx + player.x * scale
        local py = my + player.y * scale
        love.graphics.circle("fill", px, py, 3)
    end

    -- Draw landmarks
    for _, landmark in ipairs(Exploration.landmarks) do
        if landmark.realm == realm.name and landmark.discovered then
            love.graphics.setColor(1, 1, 0)
            local lx = mx + landmark.x * scale
            local ly = my + landmark.y * scale
            love.graphics.circle("fill", lx, ly, 2)
        end
    end

    -- Draw portals
    for _, portal in ipairs(Exploration.portals) do
        if portal.fromRealm == realm.name then
            love.graphics.setColor(0, 1, 0)
            local px = mx + portal.fromX * scale
            local py = my + portal.fromY * scale
            love.graphics.circle("fill", px, py, 4)
        end
    end

    love.graphics.setColor(1, 1, 1)
end

-- Get landmarks in realm
function Exploration.getLandmarks(realm)
    local result = {}
    for _, landmark in ipairs(Exploration.landmarks) do
        if landmark.realm == realm.name then
            table.insert(result, landmark)
        end
    end
    return result
end

return Exploration

