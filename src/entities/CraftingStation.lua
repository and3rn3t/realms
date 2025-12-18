--[[
    Crafting Station Entity
    Interactive crafting station in the world
]]

local Entity = require("src.entities.Entity")
local CraftingStation = {}
CraftingStation.__index = CraftingStation
setmetatable(CraftingStation, Entity)

function CraftingStation.new(x, y, stationType)
    local self = setmetatable(Entity.new(x, y), CraftingStation)

    self.stationType = stationType or "forge" -- "forge", "alchemy", "enchanting", "workbench"
    self.interactionRange = 50
    self.canInteract = true
    self.recipes = {} -- Recipes available at this station

    return self
end

function CraftingStation:update(dt)
    Entity.update(self, dt)
end

function CraftingStation:draw()
    if not self.visible then return end

    -- Draw station based on type
    if self.stationType == "forge" then
        love.graphics.setColor(0.5, 0.3, 0.2)
    elseif self.stationType == "alchemy" then
        love.graphics.setColor(0.2, 0.5, 0.8)
    elseif self.stationType == "enchanting" then
        love.graphics.setColor(0.8, 0.2, 0.8)
    else
        love.graphics.setColor(0.4, 0.4, 0.4)
    end

    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    -- Draw interaction indicator
    if self.canInteract then
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle("line", self.x + self.width / 2, self.y - 10, 5)
    end
end

function CraftingStation:canPlayerInteract(player)
    if not self.canInteract then return false end

    local dx = player.x - self.x
    local dy = player.y - self.y
    local dist = math.sqrt(dx * dx + dy * dy)

    return dist < self.interactionRange
end

function CraftingStation:setRecipes(recipes)
    self.recipes = recipes
end

function CraftingStation:getRecipes()
    return self.recipes
end

return CraftingStation

