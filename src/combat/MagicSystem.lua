--[[
    Magic System
    Handles spells, spell casting, and spell schools
]]

local MagicSystem = {}
MagicSystem.spells = {}
MagicSystem.activeSpells = {}

-- Initialize magic system
function MagicSystem.init()
    MagicSystem.spells = {}
    MagicSystem.activeSpells = {}
end

-- Register a spell
function MagicSystem.registerSpell(spellId, spellData)
    MagicSystem.spells[spellId] = spellData
end

-- Cast a spell
function MagicSystem.castSpell(spellId, caster, target)
    if not MagicSystem.spells[spellId] then
        return false
    end

    local spell = MagicSystem.spells[spellId]

    -- Check mana (support both direct mana property and stats object)
    local currentMana = caster.mana or (caster.getMana and caster:getMana() or 0)
    if currentMana < spell.manaCost then
        return false
    end

    -- Check cooldown
    if spell.cooldown and spell.cooldown > 0 then
        return false
    end

    -- Consume mana
    if caster.setMana then
        caster:setMana(currentMana - spell.manaCost)
    elseif caster.mana then
        caster.mana = currentMana - spell.manaCost
    end

    -- Apply spell effect
    if spell.effect == "damage" and target then
        if target.takeDamage then
            target:takeDamage(spell.damage or 10)
        end
    elseif spell.effect == "heal" and target then
        if target.setHealth then
            local currentHealth = target.getHealth and target:getHealth() or target.health or 0
            local maxHealth = target.getHealth and (select(2, target:getHealth())) or target.maxHealth or 100
            target:setHealth(math.min(maxHealth, currentHealth + (spell.healAmount or 10)))
        elseif target.health then
            target.health = math.min(target.maxHealth or 100, target.health + (spell.healAmount or 10))
        end
    end

    -- Set cooldown
    if spell.cooldownTime then
        spell.cooldown = spell.cooldownTime
    end

    return true
end

-- Update magic system
function MagicSystem.update(dt)
    -- Update spell cooldowns
    for _, spell in pairs(MagicSystem.spells) do
        if spell.cooldown then
            spell.cooldown = math.max(0, spell.cooldown - dt)
        end
    end
end

return MagicSystem

