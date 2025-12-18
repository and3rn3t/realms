--[[
    NPC Entity
    Non-player character with dialogue and interaction
]]

local Entity = require("src.entities.Entity")
local NPC = {}
NPC.__index = NPC
setmetatable(NPC, Entity)

function NPC.new(x, y, npcData)
    local self = setmetatable(Entity.new(x, y), NPC)

    self.name = npcData.name or "NPC"
    self.dialogue = npcData.dialogue or {}
    self.interactionRange = 50
    self.canInteract = true

    return self
end

function NPC:update(dt)
    Entity.update(self, dt)
end

function NPC:draw()
    if not self.visible then return end

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

function NPC:canPlayerInteract(player)
    if not self.canInteract then return false end

    local dx = player.x - self.x
    local dy = player.y - self.y
    local dist = math.sqrt(dx * dx + dy * dy)

    return dist < self.interactionRange
end

return NPC

