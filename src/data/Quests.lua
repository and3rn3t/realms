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
}

function Quests.getQuest(id)
    return Quests.data[id]
end

return Quests

