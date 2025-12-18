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

    -- Combat properties
    self.attackRange = 50
    self.attackCooldown = 0
    self.attackDelay = 0.5
    self.isAttacking = false
    self.attackDuration = 0.2
    self.attackTimer = 0

    -- Magic properties
    self.knownSpells = {} -- List of spell IDs the player knows
    self.selectedSpell = nil -- Currently selected spell
    self.castingSpell = nil -- Spell being cast
    self.castTimer = 0

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

    -- Update attack cooldown
    self.attackCooldown = math.max(0, self.attackCooldown - dt)

    -- Update attack animation
    if self.isAttacking then
        self.attackTimer = self.attackTimer - dt
        if self.attackTimer <= 0 then
            self.isAttacking = false
        end
    end

    -- Update spell casting
    if self.castingSpell then
        self.castTimer = self.castTimer - dt
        if self.castTimer <= 0 then
            self.castingSpell = nil
        end
    end

    -- Handle collision if bump.lua is available
    if self.collisionWorld then
        local actualX, actualY = self.collisionWorld:move(
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

    -- Draw attack indicator
    if self.isAttacking then
        local centerX = self.x + self.width / 2
        local centerY = self.y + self.height / 2
        local attackRadius = self.attackRange

        -- Draw attack arc based on facing direction
        love.graphics.setColor(1, 1, 0, 0.3)
        if self.facing == "up" then
            love.graphics.arc("fill", centerX, centerY, attackRadius, math.pi, 0)
        elseif self.facing == "down" then
            love.graphics.arc("fill", centerX, centerY, attackRadius, 0, math.pi)
        elseif self.facing == "left" then
            love.graphics.arc("fill", centerX, centerY, attackRadius, math.pi / 2, 3 * math.pi / 2)
        elseif self.facing == "right" then
            love.graphics.arc("fill", centerX, centerY, attackRadius, 3 * math.pi / 2, math.pi / 2)
        end
    end

    -- Draw spell casting indicator
    if self.castingSpell then
        local centerX = self.x + self.width / 2
        local centerY = self.y + self.height / 2
        local Spells = require("src.data.Spells")
        local spellData = Spells.getSpell(self.castingSpell)

        if spellData then
            local progress = 1 - (self.castTimer / (spellData.castTime or 0.5))
            love.graphics.setColor(0.5, 0.2, 1, 0.5)
            love.graphics.circle("line", centerX, centerY, 20 + progress * 10, 32)
            love.graphics.setColor(0.5, 0.2, 1, 0.3)
            love.graphics.circle("fill", centerX, centerY, 20 + progress * 10, 32)
        end
    end

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
            local spriteW = self.sprite:getWidth()
            local spriteH = self.sprite:getHeight()
            love.graphics.draw(
                self.sprite,
                self.x + self.width / 2,
                self.y + self.height / 2,
                0,
                scaleX,
                1,
                spriteW / 2,
                spriteH / 2
            )
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

-- Attack nearby enemies
function Player:attack(enemies)
    if self.attackCooldown > 0 or self.isAttacking then
        return false
    end

    if not enemies or #enemies == 0 then
        return false
    end

    -- Set attack cooldown and animation
    self.attackCooldown = self.attackDelay
    self.isAttacking = true
    self.attackTimer = self.attackDuration

    -- Calculate base damage from stats
    local baseDamage = self.stats:getDamage()

    -- Add weapon damage if equipped
    if self.inventory then
        local equippedStats = self.inventory:getEquippedStats()
        baseDamage = baseDamage + equippedStats.damage
    end

    -- Find enemies in attack range
    local hitEnemies = {}
    local playerCenterX = self.x + self.width / 2
    local playerCenterY = self.y + self.height / 2

    for _, enemy in ipairs(enemies) do
        if enemy.active then
            local enemyCenterX = enemy.x + enemy.width / 2
            local enemyCenterY = enemy.y + enemy.height / 2
            local dx = enemyCenterX - playerCenterX
            local dy = enemyCenterY - playerCenterY
            local dist = math.sqrt(dx * dx + dy * dy)

            -- Check if enemy is in range and in attack direction
            if dist <= self.attackRange then
                -- Check if enemy is in the direction player is facing
                local inDirection = false
                if self.facing == "up" and dy < 0 and math.abs(dx) < math.abs(dy) then
                    inDirection = true
                elseif self.facing == "down" and dy > 0 and math.abs(dx) < math.abs(dy) then
                    inDirection = true
                elseif self.facing == "left" and dx < 0 and math.abs(dy) < math.abs(dx) then
                    inDirection = true
                elseif self.facing == "right" and dx > 0 and math.abs(dy) < math.abs(dx) then
                    inDirection = true
                end

                if inDirection then
                    table.insert(hitEnemies, enemy)
                end
            end
        end
    end

    -- Deal damage to hit enemies
    local CombatSystem = require("src.combat.CombatSystem")
    for _, enemy in ipairs(hitEnemies) do
        -- Calculate damage with combat system
        local attacker = {
            damage = baseDamage,
            critChance = self.stats:getCriticalChance() / 100,
            critDamage = self.stats:getCriticalDamage(),
        }
        local defender = {
            defense = enemy.defense or 0,
        }
        local damage = CombatSystem.calculateDamage(attacker, defender)
        enemy:takeDamage(damage)
    end

    return #hitEnemies > 0
end

-- Get attack damage (for UI display)
function Player:getAttackDamage()
    local baseDamage = self.stats:getDamage()
    if self.inventory then
        local equippedStats = self.inventory:getEquippedStats()
        baseDamage = baseDamage + equippedStats.damage
    end
    return baseDamage
end

-- Learn a spell
function Player:learnSpell(spellId)
    if not self.knownSpells[spellId] then
        self.knownSpells[spellId] = true
        return true
    end
    return false
end

-- Cast a spell
function Player:castSpell(spellId, enemies)
    if not self.knownSpells[spellId] then
        return false
    end

    local Spells = require("src.data.Spells")
    local spellData = Spells.getSpell(spellId)

    if not spellData then
        return false
    end

    -- Check if already casting
    if self.castingSpell then
        return false
    end

    -- Start cast timer
    self.castingSpell = spellId
    self.castTimer = spellData.castTime or 0.5

    -- For instant cast spells, cast immediately
    if spellData.castTime <= 0 then
        return self:executeSpell(spellId, enemies)
    end

    return true
end

-- Execute spell after cast time
function Player:executeSpell(spellId, enemies)
    local MagicSystem = require("src.combat.MagicSystem")
    local Spells = require("src.data.Spells")
    local spellData = Spells.getSpell(spellId)

    if not spellData then
        return false
    end

    -- Find target
    local target = nil
    if spellData.effect == "heal" or spellData.effect == "buff" then
        -- Self-cast
        target = self
    elseif spellData.effect == "damage" then
        -- Find nearest enemy
        local playerCenterX = self.x + self.width / 2
        local playerCenterY = self.y + self.height / 2
        local nearestDist = spellData.range or 200
        local nearestEnemy = nil

        for _, enemy in ipairs(enemies or {}) do
            if enemy.active then
                local enemyCenterX = enemy.x + enemy.width / 2
                local enemyCenterY = enemy.y + enemy.height / 2
                local dx = enemyCenterX - playerCenterX
                local dy = enemyCenterY - playerCenterY
                local dist = math.sqrt(dx * dx + dy * dy)

                if dist <= nearestDist then
                    nearestDist = dist
                    nearestEnemy = enemy
                end
            end
        end
        target = nearestEnemy
    end

    if not target then
        return false
    end

    -- Cast spell through magic system
    local success = MagicSystem.castSpell(spellId, self.stats, target)

    if success and spellData.effect == "damage" and target.takeDamage then
        -- Add magic damage bonus
        local magicDamage = self.stats:getMagicDamage()
        target:takeDamage(magicDamage)
    end

    return success
end

-- Get known spells
function Player:getKnownSpells()
    local Spells = require("src.data.Spells")
    local known = {}
    for spellId, _ in pairs(self.knownSpells) do
        table.insert(known, {id = spellId, data = Spells.getSpell(spellId)})
    end
    return known
end

return Player

