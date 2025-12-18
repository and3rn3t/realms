--[[
    Base Entity Class
    Base class for all game entities (Player, NPCs, Enemies)
]]

local Entity = {}
Entity.__index = Entity

function Entity.new(x, y)
    local self = setmetatable({}, Entity)

    self.x = x or 0
    self.y = y or 0
    self.vx = 0
    self.vy = 0
    self.width = 16
    self.height = 16
    self.speed = 100
    self.direction = 0 -- radians
    self.active = true
    self.visible = true

    return self
end

function Entity:update(dt)
    -- Update position based on velocity
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

function Entity:draw()
    -- Base draw (override in subclasses)
    if self.visible then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
end

function Entity:getCenter()
    return self.x + self.width / 2, self.y + self.height / 2
end

function Entity:setCenter(x, y)
    self.x = x - self.width / 2
    self.y = y - self.height / 2
end

function Entity:getBounds()
    return self.x, self.y, self.width, self.height
end

function Entity:setPosition(x, y)
    self.x = x
    self.y = y
end

function Entity:getPosition()
    return self.x, self.y
end

function Entity:setVelocity(vx, vy)
    self.vx = vx
    self.vy = vy
end

function Entity:getVelocity()
    return self.vx, self.vy
end

return Entity

