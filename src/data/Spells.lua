--[[
    Spell Data Definitions
    Defines all spells in the game
]]

local Spells = {}

Spells.data = {
    -- Damage spells
    fireball = {
        name = "Fireball",
        description = "Launch a fireball at your target",
        school = "fire",
        manaCost = 15,
        cooldownTime = 2.0,
        effect = "damage",
        damage = 25,
        range = 200,
        castTime = 0.5,
    },
    ice_bolt = {
        name = "Ice Bolt",
        description = "Fires a bolt of ice that damages and slows enemies",
        school = "ice",
        manaCost = 12,
        cooldownTime = 1.5,
        effect = "damage",
        damage = 20,
        range = 200,
        castTime = 0.3,
    },
    lightning = {
        name = "Lightning",
        description = "Strikes target with lightning",
        school = "lightning",
        manaCost = 20,
        cooldownTime = 3.0,
        effect = "damage",
        damage = 35,
        range = 250,
        castTime = 0.8,
    },

    -- Healing spells
    heal = {
        name = "Heal",
        description = "Restores health",
        school = "holy",
        manaCost = 10,
        cooldownTime = 1.0,
        effect = "heal",
        healAmount = 30,
        range = 0, -- Self-cast
        castTime = 0.5,
    },
    greater_heal = {
        name = "Greater Heal",
        description = "Restores a large amount of health",
        school = "holy",
        manaCost = 25,
        cooldownTime = 3.0,
        effect = "heal",
        healAmount = 75,
        range = 0, -- Self-cast
        castTime = 1.0,
    },

    -- Buff spells
    shield = {
        name = "Shield",
        description = "Increases defense temporarily",
        school = "protection",
        manaCost = 15,
        cooldownTime = 5.0,
        effect = "buff",
        buffType = "defense",
        buffAmount = 10,
        buffDuration = 10.0,
        range = 0, -- Self-cast
        castTime = 0.5,
    },
    haste = {
        name = "Haste",
        description = "Increases movement speed temporarily",
        school = "enhancement",
        manaCost = 20,
        cooldownTime = 10.0,
        effect = "buff",
        buffType = "speed",
        buffAmount = 1.5,
        buffDuration = 15.0,
        range = 0, -- Self-cast
        castTime = 0.5,
    },
}

function Spells.getSpell(id)
    return Spells.data[id]
end

function Spells.getAllSpells()
    return Spells.data
end

function Spells.getSpellsBySchool(school)
    local schoolSpells = {}
    for spellId, spellData in pairs(Spells.data) do
        if spellData.school == school then
            schoolSpells[spellId] = spellData
        end
    end
    return schoolSpells
end

return Spells

