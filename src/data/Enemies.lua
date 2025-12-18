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
    },
    strong = {
        name = "Strong Enemy",
        health = 100,
        damage = 20,
        speed = 60,
    },
}

function Enemies.getEnemyData(type)
    return Enemies.data[type]
end

return Enemies

