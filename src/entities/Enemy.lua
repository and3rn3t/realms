--[[
    Enemy Entity
    Enemy with AI, combat, and stats
]]

local Entity = require("src.entities.Entity")
local Enemy = {}
Enemy.__index = Enemy
setmetatable(Enemy, Entity)

function Enemy.new(x, y, enemyType)
    local self = setmetatable(Entity.new(x, y), Enemy)

    self.enemyType = enemyType or "basic"
    self.health = 50
    self.maxHealth = 50
    self.damage = 10
    self.defense = 0
    self.speed = 80
    self.aggroRange = 150
    self.attackRange = 40
    self.attackCooldown = 0
    self.attackDelay = 1.0

    -- AI state
    self.aiState = "idle" -- "idle", "patrol", "chase", "attack", "flee"
    self.target = nil
    self.patrolPoints = {}
    self.currentPatrolIndex = 1

    return self
end

function Enemy:update(dt, player)
    self.attackCooldown = math.max(0, self.attackCooldown - dt)

    -- Simple AI
    if player then
        local dx = player.x - self.x
        local dy = player.y - self.y
        local dist = math.sqrt(dx * dx + dy * dy)

        if dist < self.aggroRange then
            if dist < self.attackRange and self.attackCooldown <= 0 then
                self:attack(player)
            else
                -- Chase player
                local angle = math.atan2(dy, dx)
                self.vx = math.cos(angle) * self.speed
                self.vy = math.sin(angle) * self.speed
            end
        else
            -- Idle/patrol
            self.vx = 0
            self.vy = 0
        end
    end

    Entity.update(self, dt)
end

function Enemy:attack(target)
    if self.attackCooldown > 0 then
        return
    end

    self.attackCooldown = self.attackDelay

    -- Deal damage
    if target.takeDamage then
        target:takeDamage(self.damage)
    end
end

function Enemy:takeDamage(amount)
    self.health = self.health - amount

    if self.health <= 0 then
        self:die()
    end
end

function Enemy:die()
    self.active = false

    -- Update quest progress for enemy kills
    local QuestSystem = require("src.quests.QuestSystem")
    local activeQuests = QuestSystem.getActiveQuests()
    for _, questId in ipairs(activeQuests) do
        local quest = QuestSystem.getQuest(questId)
        if quest and quest.objectives then
            for _, objective in ipairs(quest.objectives) do
                if objective.type == "kill" then
                    QuestSystem.updateProgress(questId, objective.id, 1)
                end
            end
        end
    end

    -- Drop loot
    local Loot = require("src.inventory.Loot")
    Loot.createDrop("potion_health", self.x, self.y, 1)
end

function Enemy:draw()
    if not self.visible or not self.active then return end

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Health bar
    local barWidth = self.width
    local barHeight = 4
    local healthPercent = self.health / self.maxHealth

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y - 8, barWidth, barHeight)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y - 8, barWidth * healthPercent, barHeight)

    love.graphics.setColor(1, 1, 1)
end

return Enemy

