--[[
    Recipe Data Definitions
    Defines all crafting recipes
]]

local Recipes = {}

Recipes.data = {
    -- Forge recipes
    craft_iron_sword = {
        name = "Iron Sword",
        station = "forge",
        ingredients = {
            {id = "iron_ore", quantity = 5},
            {id = "steel_ingot", quantity = 2},
        },
        result = {id = "sword_iron", quantity = 1},
    },
    craft_steel_sword = {
        name = "Steel Sword",
        station = "forge",
        ingredients = {
            {id = "steel_ingot", quantity = 5},
            {id = "magic_crystal", quantity = 1},
        },
        result = {id = "sword_steel", quantity = 1},
    },
    craft_chain_armor = {
        name = "Chain Mail",
        station = "forge",
        ingredients = {
            {id = "iron_ore", quantity = 10},
        },
        result = {id = "armor_chain", quantity = 1},
    },
    craft_plate_armor = {
        name = "Plate Armor",
        station = "forge",
        ingredients = {
            {id = "steel_ingot", quantity = 8},
        },
        result = {id = "armor_plate", quantity = 1},
    },

    -- Alchemy recipes
    craft_health_potion = {
        name = "Health Potion",
        station = "alchemy",
        ingredients = {
            {id = "iron_ore", quantity = 1}, -- Placeholder ingredient
        },
        result = {id = "potion_health", quantity = 2},
    },
    craft_mana_potion = {
        name = "Mana Potion",
        station = "alchemy",
        ingredients = {
            {id = "magic_crystal", quantity = 1},
        },
        result = {id = "potion_mana", quantity = 2},
    },
    craft_greater_health_potion = {
        name = "Greater Health Potion",
        station = "alchemy",
        ingredients = {
            {id = "potion_health", quantity = 3},
            {id = "magic_crystal", quantity = 1},
        },
        result = {id = "potion_health_greater", quantity = 1},
    },

    -- Enchanting recipes
    craft_magic_sword = {
        name = "Magic Sword",
        station = "enchanting",
        ingredients = {
            {id = "sword_steel", quantity = 1},
            {id = "magic_crystal", quantity = 5},
        },
        result = {id = "sword_magic", quantity = 1},
    },
    craft_arcane_staff = {
        name = "Arcane Staff",
        station = "enchanting",
        ingredients = {
            {id = "staff_basic", quantity = 1},
            {id = "magic_crystal", quantity = 3},
        },
        result = {id = "staff_arcane", quantity = 1},
    },
}

function Recipes.getRecipe(id)
    return Recipes.data[id]
end

function Recipes.getAllRecipes()
    return Recipes.data
end

function Recipes.getRecipesByStation(stationType)
    local stationRecipes = {}
    for recipeId, recipe in pairs(Recipes.data) do
        if recipe.station == stationType then
            stationRecipes[recipeId] = recipe
        end
    end
    return stationRecipes
end

return Recipes

