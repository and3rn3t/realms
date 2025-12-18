--[[
    Combat System
    Handles combat logic, abilities, and status effects
]]

local CombatSystem = {}
CombatSystem.enemies = {}
CombatSystem.statusEffects = {}

-- Initialize combat system
function CombatSystem.init()
    CombatSystem.enemies = {}
    CombatSystem.statusEffects = {}
end

-- Add enemy to combat
function CombatSystem.addEnemy(enemy)
    table.insert(CombatSystem.enemies, enemy)
end

-- Remove enemy
function CombatSystem.removeEnemy(enemy)
    for i, e in ipairs(CombatSystem.enemies) do
        if e == enemy then
            table.remove(CombatSystem.enemies, i)
            return
        end
    end
end

-- Update combat
function CombatSystem.update(dt, player)
    -- Update enemies
    for i = #CombatSystem.enemies, 1, -1 do
        local enemy = CombatSystem.enemies[i]
        if enemy.active then
            enemy:update(dt, player)
        else
            table.remove(CombatSystem.enemies, i)
        end
    end

    -- Update status effects
    for i = #CombatSystem.statusEffects, 1, -1 do
        local effect = CombatSystem.statusEffects[i]
        effect.duration = effect.duration - dt

        if effect.duration <= 0 then
            table.remove(CombatSystem.statusEffects, i)
        else
            -- Apply effect
            if effect.type == "poison" and effect.target then
                effect.target:takeDamage(effect.damage * dt)
            elseif effect.type == "burn" and effect.target then
                effect.target:takeDamage(effect.damage * dt)
            end
        end
    end
end

-- Apply status effect
function CombatSystem.applyStatusEffect(target, effectType, duration, damage)
    table.insert(CombatSystem.statusEffects, {
        target = target,
        type = effectType,
        duration = duration,
        damage = damage or 0,
    })
end

-- Draw combat
function CombatSystem.draw()
    for _, enemy in ipairs(CombatSystem.enemies) do
        enemy:draw()
    end
end

-- Calculate damage
function CombatSystem.calculateDamage(attacker, defender)
    local damage = attacker.damage or 10

    -- Apply defense
    local defense = defender.defense or 0
    damage = math.max(1, damage - defense)

    -- Critical hit chance
    local critChance = attacker.critChance or 0.05
    if math.random() < critChance then
        damage = damage * (attacker.critDamage or 1.5)
    end

    return damage
end

return CombatSystem

