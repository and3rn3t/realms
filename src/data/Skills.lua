--[[
    Skill Tree Data
    Defines skill trees and abilities
]]

local Skills = {}

Skills.data = {
    combat_mastery = {
        name = "Combat Mastery",
        description = "Increases physical damage dealt",
        maxLevel = 5,
        effects = {
            damage = 2, -- per level
        },
    },
    magic_affinity = {
        name = "Magic Affinity",
        description = "Increases maximum mana",
        maxLevel = 5,
        effects = {
            maxMana = 10, -- per level
        },
    },
    health_boost = {
        name = "Health Boost",
        description = "Increases maximum health",
        maxLevel = 5,
        effects = {
            maxHealth = 20, -- per level
        },
    },
    critical_strike = {
        name = "Critical Strike",
        description = "Increases critical hit chance and damage",
        maxLevel = 5,
        prerequisites = {"combat_mastery"},
        effects = {
            critChance = 2, -- per level
            critDamage = 0.1, -- per level
        },
    },
    spell_power = {
        name = "Spell Power",
        description = "Increases magic damage",
        maxLevel = 5,
        prerequisites = {"magic_affinity"},
        effects = {
            magicDamage = 3, -- per level
        },
    },
    defensive_stance = {
        name = "Defensive Stance",
        description = "Increases defense",
        maxLevel = 5,
        prerequisites = {"health_boost"},
        effects = {
            defense = 2, -- per level
        },
    },
}

function Skills.getSkill(id)
    return Skills.data[id]
end

function Skills.getAllSkills()
    return Skills.data
end

return Skills

