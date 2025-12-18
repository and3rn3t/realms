--[[
    Example Mod
    Template for creating mods
]]

return {
    name = "Example Mod",
    version = "1.0.0",
    author = "Mod Author",
    description = "An example mod showing how to add content",

    -- Add new items
    items = {
        example_sword = {
            name = "Example Sword",
            type = "weapon",
            rarity = "rare",
            damage = 30,
            value = 300,
        },
    },

    -- Add new quests
    quests = {
        example_quest = {
            name = "Example Quest",
            description = "An example quest from a mod",
            objectives = {
                {id = "example_objective", type = "kill", target = 3, description = "Kill 3 enemies"},
            },
            rewards = {
                experience = 200,
                items = {
                    {id = "example_sword", quantity = 1},
                },
            },
        },
    },

    -- Add new enemies
    enemies = {
        example_enemy = {
            name = "Example Enemy",
            health = 75,
            damage = 15,
            speed = 90,
            experience = 40,
        },
    },

    -- Add new realms
    realms = {
        example_realm = {
            name = "Example Realm",
            width = 1000,
            height = 1000,
            theme = "example",
            music = "example",
        },
    },
}

