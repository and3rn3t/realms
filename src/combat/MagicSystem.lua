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
    
    -- Check mana
    if caster.mana < spell.manaCost then
        return false
    end
    
    -- Check cooldown
    if spell.cooldown and spell.cooldown > 0 then
        return false
    end
    
    -- Consume mana
    caster:setMana(caster.mana - spell.manaCost)
    
    -- Apply spell effect
    if spell.effect == "damage" and target then
        target:takeDamage(spell.damage or 10)
    elseif spell.effect == "heal" and target then
        target:setHealth(target.health + (spell.healAmount or 10))
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

