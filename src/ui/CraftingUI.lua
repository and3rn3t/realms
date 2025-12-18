--[[
    Crafting UI
    Displays crafting interface for interacting with crafting stations
]]

local CraftingUI = {}
CraftingUI.visible = false
CraftingUI.selectedRecipe = 1
CraftingUI.currentStation = nil

function CraftingUI.new()
    local self = {}
    self.visible = false
    self.selectedRecipe = 1
    self.currentStation = nil
    return self
end

function CraftingUI:open(station, craftingSystem)
    self.visible = true
    self.currentStation = station
    self.craftingSystem = craftingSystem
    self.selectedRecipe = 1
end

function CraftingUI:close()
    self.visible = false
    self.currentStation = nil
end

function CraftingUI:draw(inventory)
    if not self.visible or not self.currentStation or not inventory then return end

    local width = 700
    local height = 500
    local x = (love.graphics.getWidth() - width) / 2
    local y = (love.graphics.getHeight() - height) / 2

    -- Background
    love.graphics.setColor(0.1, 0.1, 0.1, 0.95)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("line", x, y, width, height)

    -- Title
    love.graphics.setColor(1, 1, 1)
    local stationName = self.currentStation.stationType:gsub("^%l", string.upper)
    love.graphics.print(stationName .. " - Crafting", x + 20, y + 20)

    -- Recipe list area
    local listX = x + 20
    local listY = y + 60
    local listWidth = 250
    local listHeight = height - 80

    love.graphics.setColor(0.15, 0.15, 0.15)
    love.graphics.rectangle("fill", listX, listY, listWidth, listHeight)
    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.rectangle("line", listX, listY, listWidth, listHeight)

    -- Get recipes from station
    local recipes = self.currentStation:getRecipes()
    local recipeList = {}
    for recipeId, recipeData in pairs(recipes) do
        table.insert(recipeList, {id = recipeId, data = recipeData})
    end

    -- Draw recipe list
    local recipeY = listY + 10
    for i, recipe in ipairs(recipeList) do
        local canCraft = self.craftingSystem.canCraft(recipe.id, inventory)

        if i == self.selectedRecipe then
            love.graphics.setColor(0.3, 0.5, 0.8)
            love.graphics.rectangle("fill", listX + 5, recipeY - 2, listWidth - 10, 30)
        elseif not canCraft then
            love.graphics.setColor(0.2, 0.2, 0.2)
        end

        love.graphics.setColor(canCraft and 1 or 0.5, canCraft and 1 or 0.5, canCraft and 1 or 0.5)
        love.graphics.print(recipe.data.name or recipe.id, listX + 10, recipeY)
        recipeY = recipeY + 35
    end

    -- Recipe details area
    local detailsX = listX + listWidth + 10
    local detailsY = listY
    local detailsWidth = width - (detailsX - x) - 20
    local detailsHeight = listHeight

    love.graphics.setColor(0.15, 0.15, 0.15)
    love.graphics.rectangle("fill", detailsX, detailsY, detailsWidth, detailsHeight)
    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.rectangle("line", detailsX, detailsY, detailsWidth, detailsHeight)

    -- Draw selected recipe details
    if #recipeList > 0 and self.selectedRecipe <= #recipeList then
        local recipe = recipeList[self.selectedRecipe]
        local recipeData = recipe.data
        local textY = detailsY + 20

        -- Recipe name
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.print(recipeData.name or recipe.id, detailsX + 10, textY)
        textY = textY + 30

        -- Ingredients
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Ingredients:", detailsX + 10, textY)
        textY = textY + 25

        if recipeData.ingredients then
            local Items = require("src.data.Items")
            for _, ingredient in ipairs(recipeData.ingredients) do
                local hasItem = inventory:hasItem(ingredient.id, ingredient.quantity or 1)
                local itemData = Items.getItem(ingredient.id)
                local itemName = itemData and itemData.name or ingredient.id
                local quantity = ingredient.quantity or 1
                local count = inventory:getItemCount(ingredient.id)

                if hasItem then
                    love.graphics.setColor(0.3, 1, 0.3)
                else
                    love.graphics.setColor(1, 0.3, 0.3)
                end

                local text = string.format("• %s x%d", itemName, quantity)
                if not hasItem then
                    text = text .. string.format(" (Have: %d)", count)
                end
                love.graphics.print(text, detailsX + 20, textY)
                textY = textY + 25
            end
        end

        -- Result
        textY = textY + 10
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.print("Result:", detailsX + 10, textY)
        textY = textY + 25

        if recipeData.result then
            local Items = require("src.data.Items")
            local itemData = Items.getItem(recipeData.result.id)
            local itemName = itemData and itemData.name or recipeData.result.id
            local quantity = recipeData.result.quantity or 1

            love.graphics.setColor(0.3, 1, 0.8)
            love.graphics.print(string.format("• %s x%d", itemName, quantity), detailsX + 20, textY)
        end

        -- Craft button hint
        local canCraft = self.craftingSystem.canCraft(recipe.id, inventory)
        textY = detailsY + detailsHeight - 40
        if canCraft then
            love.graphics.setColor(0.3, 1, 0.3)
            love.graphics.print("Press ENTER to craft", detailsX + 10, textY)
        else
            love.graphics.setColor(1, 0.3, 0.3)
            love.graphics.print("Missing ingredients", detailsX + 10, textY)
        end
    end

    -- Close hint
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.print("Press E or ESC to close", x + width - 200, y + height - 25)
end

function CraftingUI:keypressed(key, inventory)
    if not self.visible then return end

    if key == "e" or key == "escape" then
        self:close()
        return
    end

    -- Get recipes
    local recipes = self.currentStation:getRecipes()
    local recipeList = {}
    for recipeId, recipeData in pairs(recipes) do
        table.insert(recipeList, {id = recipeId, data = recipeData})
    end

    -- Arrow keys for recipe selection
    if key == "up" then
        self.selectedRecipe = math.max(1, self.selectedRecipe - 1)
    elseif key == "down" then
        self.selectedRecipe = math.min(#recipeList, self.selectedRecipe + 1)
    elseif key == "return" or key == "kpenter" then
        -- Craft selected recipe
        if #recipeList > 0 and self.selectedRecipe <= #recipeList then
            local recipe = recipeList[self.selectedRecipe]
            if self.craftingSystem.canCraft(recipe.id, inventory) then
                if self.craftingSystem.craft(recipe.id, inventory) then
                    print("Crafted: " .. (recipe.data.name or recipe.id))
                end
            end
        end
    end
end

return CraftingUI

