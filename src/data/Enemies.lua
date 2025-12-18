--[[
    Enemy Data Definitions
    Defines all enemy types
]]

local Enemies = {}

Enemies.data = {
    basic = {
        name = "Basic Enemy",
        health = 50,
        damage = 10,
        speed = 80,
        experience = 25,
        loot = {
            {id = "potion_health", chance = 0.3},
            {id = "iron_ore", chance = 0.5},
        },
    },
    strong = {
        name = "Strong Enemy",
        health = 100,
        damage = 20,
        speed = 60,
        experience = 50,
        loot = {
            {id = "potion_health_greater", chance = 0.4},
            {id = "steel_ingot", chance = 0.3},
        },
    },
    fast = {
        name = "Fast Enemy",
        health = 40,
        damage = 15,
        speed = 120,
        experience = 30,
        loot = {
            {id = "potion_mana", chance = 0.5},
        },
    },
    tank = {
        name = "Tank Enemy",
        health = 200,
        damage = 15,
        speed = 40,
        experience = 75,
        loot = {
            {id = "armor_chain", chance = 0.2},
            {id = "potion_health_greater", chance = 0.6},
        },
    },
    mage = {
        name = "Enemy Mage",
        health = 60,
        damage = 5,
        magicDamage = 30,
        speed = 70,
        experience = 60,
        loot = {
            {id = "potion_mana_greater", chance = 0.4},
            {id = "magic_crystal", chance = 0.3},
        },
    },
    boss = {
        name = "Boss Enemy",
        health = 500,
        damage = 40,
        speed = 50,
        experience = 500,
        loot = {
            {id = "sword_magic", chance = 0.8},
            {id = "armor_magic", chance = 0.7},
            {id = "potion_elixir", chance = 1.0},
        },
    },
}

function Enemies.getEnemyData(type)
    return Enemies.data[type]
end

return Enemies

