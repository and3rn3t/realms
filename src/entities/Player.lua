--[[
    Player Entity
    Player character with movement, animations, and collision
]]

local Entity = require("src.entities.Entity")
local Player = {}
Player.__index = Player
setmetatable(Player, Entity)

function Player.new(x, y)
    local self = setmetatable(Entity.new(x, y), Player)

    -- Player-specific properties
    self.speed = 150
    self.runSpeed = 250
    self.isRunning = false
    self.facing = "down" -- "up", "down", "left", "right"

    -- Animation (will use anim8 when available)
    self.animation = nil
    self.animations = {}
    self.currentAnimation = "idle_down"
    self.sprite = nil

    -- Collision (will use bump.lua when available)
    self.collisionWorld = nil
    self.collisionFilter = function(item, other)
        return "slide"
    end

    -- Stats system
    local Stats = require("src.entities.Stats")
    self.stats = Stats.new()
    self.inventory = nil -- Will be set up separately

    return self
end

function Player:load()
    -- Try to load player sprite
    local src = require("src.init")
    self.sprite = src.core.AssetManager.loadImage("assets/images/player.png", "player")

    -- If sprite not found, create placeholder
    if not self.sprite then
        print("Player sprite not found, using placeholder")
    end

    -- Initialize animations (will use anim8 when available)
    self:initAnimations()
end

function Player:initAnimations()
    -- Animation setup (placeholder - will use anim8)
    -- When anim8 is available:
    -- local grid = anim8.newGrid(32, 32, self.sprite:getWidth(), self.sprite:getHeight())
    -- self.animations.idle_down = anim8.newAnimation(grid('1-4', 1), 0.2)
    -- etc.

    -- For now, just track animation state
    self.animations = {
        idle_down = "idle_down",
        idle_up = "idle_up",
        idle_left = "idle_left",
        idle_right = "idle_right",
        walk_down = "walk_down",
        walk_up = "walk_up",
        walk_left = "walk_left",
        walk_right = "walk_right",
    }
end

function Player:update(dt, input)
    input = input or require("src.core.Input")

    -- Get input
    local moveX, moveY = 0, 0
    local isMoving = false

    if input.isDown("up") then
        moveY = moveY - 1
        self.facing = "up"
        isMoving = true
    end
    if input.isDown("down") then
        moveY = moveY + 1
        self.facing = "down"
        isMoving = true
    end
    if input.isDown("left") then
        moveX = moveX - 1
        self.facing = "left"
        isMoving = true
    end
    if input.isDown("right") then
        moveX = moveX + 1
        self.facing = "right"
        isMoving = true
    end

    -- Normalize diagonal movement
    if moveX ~= 0 and moveY ~= 0 then
        moveX = moveX * 0.707
        moveY = moveY * 0.707
    end

    -- Check if running
    self.isRunning = input.isDown("run")
    local currentSpeed = self.isRunning and self.runSpeed or self.speed

    -- Set velocity
    self.vx = moveX * currentSpeed
    self.vy = moveY * currentSpeed

    -- Update animation
    if isMoving then
        self.currentAnimation = "walk_" .. self.facing
    else
        self.currentAnimation = "idle_" .. self.facing
    end

    -- Update animations if using anim8
    if self.animation then
        self.animation:update(dt)
    end

    -- Handle collision if bump.lua is available
    if self.collisionWorld then
        local actualX, actualY, cols, len = self.collisionWorld:move(
            self,
            self.x + self.vx * dt,
            self.y + self.vy * dt,
            self.collisionFilter
        )
        self.x = actualX
        self.y = actualY
    else
        -- Fallback: simple position update
        Entity.update(self, dt)
    end
end

function Player:draw()
    if not self.visible then return end

    love.graphics.setColor(1, 1, 1)

    -- Draw sprite if available
    if self.sprite then
        local scaleX = 1
        if self.facing == "left" then
            scaleX = -1
        end

        -- If using anim8
        if self.animation then
            self.animation:draw(self.sprite, self.x, self.y, 0, scaleX, 1, self.width / 2, self.height / 2)
        else
            -- Simple sprite draw
            love.graphics.draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, 0, scaleX, 1, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
        end
    else
        -- Placeholder rectangle
        love.graphics.setColor(0, 0.8, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    end
end

function Player:setCollisionWorld(world)
    self.collisionWorld = world
end

function Player:getHealth()
    return self.stats.health, self.stats.maxHealth
end

function Player:setHealth(health)
    self.stats:setHealth(health)
end

function Player:getMana()
    return self.stats.mana, self.stats.maxMana
end

function Player:setMana(mana)
    self.stats:setMana(mana)
end

function Player:takeDamage(amount)
    self.stats:setHealth(self.stats.health - amount)
end

return Player

