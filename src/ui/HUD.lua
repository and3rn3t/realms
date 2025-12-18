--[[
    HUD (Heads-Up Display)
    In-game UI showing health, mana, etc.
]]

local HUD = {}
HUD.visible = true

function HUD.new()
    local self = {}
    self.visible = true
    return self
end

function HUD:draw(player)
    if not self.visible or not player then return end

    local health, maxHealth = player:getHealth()
    local mana, maxMana = player:getMana()

    -- Health bar
    local barWidth = 200
    local barHeight = 20
    local x = 10
    local y = love.graphics.getHeight() - 60

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", x, y, barWidth, barHeight)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", x, y, barWidth * (health / maxHealth), barHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, barWidth, barHeight)

    -- Mana bar
    y = y + 25
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", x, y, barWidth, barHeight)
    love.graphics.setColor(0, 0.5, 1)
    love.graphics.rectangle("fill", x, y, barWidth * (mana / maxMana), barHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, barWidth, barHeight)
end

return HUD

