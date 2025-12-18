--[[
    Quest Data Definitions
    Defines all quests in the game
]]

local Quests = {}

Quests.data = {
    first_quest = {
        name = "First Quest",
        description = "Complete your first quest",
        objectives = {
            {id = "talk_npc", type = "talk", target = 1, description = "Talk to the NPC"},
        },
        rewards = {
            experience = 100,
            items = {
                {id = "sword_basic", quantity = 1},
            },
        },
    },
    slay_enemies = {
        name = "Slay the Enemies",
        description = "Defeat 5 enemies to prove your strength",
        objectives = {
            {id = "kill_enemies", type = "kill", target = 5, description = "Defeat 5 enemies"},
        },
        rewards = {
            experience = 250,
            items = {
                {id = "potion_health", quantity = 3},
                {id = "armor_leather", quantity = 1},
            },
        },
    },
    gather_materials = {
        name = "Gather Materials",
        description = "Collect 10 iron ore for the blacksmith",
        objectives = {
            {id = "collect_ore", type = "collect", itemId = "iron_ore", target = 10, description = "Collect 10 iron ore"},
        },
        rewards = {
            experience = 150,
            items = {
                {id = "sword_iron", quantity = 1},
            },
        },
    },
    explore_forest = {
        name = "Explore the Forest",
        description = "Discover the secrets of the forest realm",
        objectives = {
            {id = "visit_forest", type = "visit", target = 1, description = "Visit the forest realm"},
            {id = "find_landmark", type = "find", target = 1, description = "Find the ancient tree"},
        },
        rewards = {
            experience = 300,
            items = {
                {id = "magic_crystal", quantity = 2},
            },
        },
    },
    master_crafter = {
        name = "Master Crafter",
        description = "Craft 5 items to become a master",
        objectives = {
            {id = "craft_items", type = "craft", target = 5, description = "Craft 5 items"},
        },
        rewards = {
            experience = 400,
            items = {
                {id = "staff_arcane", quantity = 1},
            },
        },
    },
}

function Quests.getQuest(id)
    return Quests.data[id]
end

return Quests

