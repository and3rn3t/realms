--[[
    Realm Data Definitions
    Defines all realms in the game
]]

local Realms = {}

Realms.data = {
    starting_realm = {
        name = "Starting Realm",
        width = 1600,
        height = 1200,
        theme = "grassland",
        music = "peaceful",
    },
    forest_realm = {
        name = "Forest Realm",
        width = 2000,
        height = 1800,
        theme = "forest",
        music = "nature",
    },
    desert_realm = {
        name = "Desert Realm",
        width = 1800,
        height = 1600,
        theme = "desert",
        music = "wind",
    },
    mountain_realm = {
        name = "Mountain Realm",
        width = 2200,
        height = 2000,
        theme = "mountain",
        music = "echo",
    },
    dungeon_realm = {
        name = "Ancient Dungeon",
        width = 1500,
        height = 1500,
        theme = "dungeon",
        music = "dark",
    },
    crystal_realm = {
        name = "Crystal Realm",
        width = 1800,
        height = 1800,
        theme = "crystal",
        music = "mystical",
    },
    void_realm = {
        name = "Void Realm",
        width = 2000,
        height = 2000,
        theme = "void",
        music = "ominous",
    },
}

function Realms.getRealmData(name)
    return Realms.data[name]
end

function Realms.getAllRealms()
    return Realms.data
end

return Realms

