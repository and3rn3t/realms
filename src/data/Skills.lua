--[[
    Skill Tree Data
    Defines skill trees and abilities
]]

local Skills = {}

Skills.data = {
    combat_mastery = {
        name = "Combat Mastery",
        description = "Increases damage",
        maxLevel = 5,
        effects = {
            damage = 2, -- per level
        },
    },
    magic_affinity = {
        name = "Magic Affinity",
        description = "Increases mana",
        maxLevel = 5,
        effects = {
            maxMana = 10, -- per level
        },
    },
}

function Skills.getSkill(id)
    return Skills.data[id]
end

return Skills

