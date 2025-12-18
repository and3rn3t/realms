--[[
    Realm System
    Represents a single realm/world area
]]

local Realm = {}
Realm.__index = Realm

function Realm.new(name, width, height)
    local self = setmetatable({}, Realm)

    self.name = name or "Unknown Realm"
    self.width = width or 800
    self.height = height or 600

    -- Tiles (simple 2D array for now)
    self.tiles = {}
    self.tileSize = 32
    self.tileset = nil

    -- World objects (trees, rocks, etc.)
    self.objects = {}

    -- Collision world (bump.lua)
    self.collisionWorld = nil

    -- Bounds
    self.bounds = {
        x = 0,
        y = 0,
        width = self.width,
        height = self.height
    }

    return self
end

function Realm:load()
    -- Try to load tileset
    local src = require("src.init")
    self.tileset = src.core.AssetManager.loadImage("assets/images/tileset.png", "tileset")

    -- Initialize collision world if bump.lua is available
    local success, bump = pcall(require, "libs.bump")
    if success and bump then
        self.collisionWorld = bump.newWorld(self.tileSize)
        self:setupCollision()
    end

    -- Generate simple tile map if none exists
    if #self.tiles == 0 then
        self:generateDefaultTiles()
    end
end

function Realm:generateDefaultTiles()
    -- Generate a simple default tile map
    local tilesWide = math.ceil(self.width / self.tileSize)
    local tilesHigh = math.ceil(self.height / self.tileSize)

    for y = 1, tilesHigh do
        self.tiles[y] = {}
        for x = 1, tilesWide do
            -- Simple pattern: grass (1) with occasional stone (2)
            local tileType = 1
            if math.random() < 0.1 then
                tileType = 2
            end
            self.tiles[y][x] = tileType
        end
    end
end

function Realm:setupCollision()
    if not self.collisionWorld then return end

    -- Add boundary walls
    local tilesWide = math.ceil(self.width / self.tileSize)
    local tilesHigh = math.ceil(self.height / self.tileSize)

    -- Top and bottom walls
    for x = 1, tilesWide do
        self.collisionWorld:add({type = "wall"}, (x - 1) * self.tileSize, 0, self.tileSize, self.tileSize)
        self.collisionWorld:add({type = "wall"}, (x - 1) * self.tileSize, (tilesHigh - 1) * self.tileSize, self.tileSize, self.tileSize)
    end

    -- Left and right walls
    for y = 1, tilesHigh do
        self.collisionWorld:add({type = "wall"}, 0, (y - 1) * self.tileSize, self.tileSize, self.tileSize)
        self.collisionWorld:add({type = "wall"}, (tilesWide - 1) * self.tileSize, (y - 1) * self.tileSize, self.tileSize, self.tileSize)
    end
end

function Realm:setTile(x, y, tileType)
    if not self.tiles[y] then
        self.tiles[y] = {}
    end
    self.tiles[y][x] = tileType
end

function Realm:getTile(x, y)
    if not self.tiles[y] or not self.tiles[y][x] then
        return 0
    end
    return self.tiles[y][x]
end

function Realm:addObject(object)
    table.insert(self.objects, object)

    -- Add to collision world if applicable
    if self.collisionWorld and object.getBounds then
        local x, y, w, h = object:getBounds()
        self.collisionWorld:add(object, x, y, w, h)
    end
end

function Realm:removeObject(object)
    for i, obj in ipairs(self.objects) do
        if obj == object then
            table.remove(self.objects, i)
            break
        end
    end

    -- Remove from collision world
    if self.collisionWorld then
        self.collisionWorld:remove(object)
    end
end

function Realm:update(dt)
    -- Update world objects
    for _, object in ipairs(self.objects) do
        if object.update then
            object:update(dt)
        end
    end
end

function Realm:draw()
    -- Draw tiles
    local tilesWide = math.ceil(self.width / self.tileSize)
    local tilesHigh = math.ceil(self.height / self.tileSize)

    love.graphics.setColor(1, 1, 1)

    for y = 1, tilesHigh do
        for x = 1, tilesWide do
            local tileType = self:getTile(x, y)
            local tileX = (x - 1) * self.tileSize
            local tileY = (y - 1) * self.tileSize

            if self.tileset then
                -- Draw from tileset (simplified - would need proper tile mapping)
                love.graphics.draw(self.tileset, tileX, tileY)
            else
                -- Draw colored rectangles as placeholder
                if tileType == 1 then
                    love.graphics.setColor(0.4, 0.8, 0.4) -- Green for grass
                elseif tileType == 2 then
                    love.graphics.setColor(0.6, 0.6, 0.6) -- Gray for stone
                else
                    love.graphics.setColor(0.2, 0.2, 0.2) -- Dark for void
                end
                love.graphics.rectangle("fill", tileX, tileY, self.tileSize, self.tileSize)
                love.graphics.setColor(1, 1, 1)
            end
        end
    end

    -- Draw world objects
    for _, object in ipairs(self.objects) do
        if object.draw then
            object:draw()
        end
    end
end

function Realm:getCollisionWorld()
    return self.collisionWorld
end

function Realm:getBounds()
    return self.bounds.x, self.bounds.y, self.bounds.width, self.bounds.height
end

return Realm

