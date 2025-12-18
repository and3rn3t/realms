--[[
    Crafting System
    Handles recipes, crafting stations, and material gathering
]]

local CraftingSystem = {}
CraftingSystem.recipes = {}
CraftingSystem.stations = {}

-- Initialize crafting system
function CraftingSystem.init()
    CraftingSystem.recipes = {}
    CraftingSystem.stations = {}
end

-- Register a recipe
function CraftingSystem.registerRecipe(recipeId, recipeData)
    CraftingSystem.recipes[recipeId] = recipeData
end

-- Can craft recipe
function CraftingSystem.canCraft(recipeId, inventory)
    if not CraftingSystem.recipes[recipeId] then
        return false
    end

    local recipe = CraftingSystem.recipes[recipeId]

    -- Check ingredients
    if recipe.ingredients then
        for _, ingredient in ipairs(recipe.ingredients) do
            if not inventory:hasItem(ingredient.id, ingredient.quantity or 1) then
                return false
            end
        end
    end

    return true
end

-- Craft item
function CraftingSystem.craft(recipeId, inventory)
    if not CraftingSystem.canCraft(recipeId, inventory) then
        return false
    end

    local recipe = CraftingSystem.recipes[recipeId]

    -- Remove ingredients
    if recipe.ingredients then
        for _, ingredient in ipairs(recipe.ingredients) do
            inventory:removeItem(ingredient.id, ingredient.quantity or 1)
        end
    end

    -- Add result
    if recipe.result then
        inventory:addItem(recipe.result.id, recipe.result.quantity or 1)
    end

    return true
end

return CraftingSystem

