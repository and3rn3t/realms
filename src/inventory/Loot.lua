--[[
    Loot System
    Handles item drops, chests, and rarity
]]

local Loot = {}
Loot.drops = {}
Loot.chests = {}

-- Initialize loot system
function Loot.init()
    Loot.drops = {}
    Loot.chests = {}
end

-- Create a loot drop
function Loot.createDrop(itemId, x, y, quantity, lifetime)
    quantity = quantity or 1
    lifetime = lifetime or 30 -- seconds

    table.insert(Loot.drops, {
        itemId = itemId,
        x = x,
        y = y,
        quantity = quantity,
        lifetime = lifetime,
        age = 0,
        collected = false,
    })
end

-- Create a chest
function Loot.createChest(x, y, items, opened)
    items = items or {}
    opened = opened or false

    table.insert(Loot.chests, {
        x = x,
        y = y,
        items = items,
        opened = opened,
        width = 32,
        height = 32,
    })
end

-- Update loot drops
function Loot.update(dt)
    for i = #Loot.drops, 1, -1 do
        local drop = Loot.drops[i]
        drop.age = drop.age + dt

        if drop.age >= drop.lifetime then
            table.remove(Loot.drops, i)
        end
    end
end

-- Check if player can collect drop
function Loot.checkCollection(player, inventory)
    for i, drop in ipairs(Loot.drops) do
        if not drop.collected then
            local dx = player.x - drop.x
            local dy = player.y - drop.y
            local dist = math.sqrt(dx * dx + dy * dy)

            if dist < 30 then
                if inventory:addItem(drop.itemId, drop.quantity) then
                    drop.collected = true
                    table.remove(Loot.drops, i)
                    return true
                end
            end
        end
    end
    return false
end

-- Check if player can open chest
function Loot.checkChest(player, inventory)
    for _, chest in ipairs(Loot.chests) do
        if not chest.opened then
            local dx = player.x - chest.x
            local dy = player.y - chest.y
            local dist = math.sqrt(dx * dx + dy * dy)

            if dist < 50 then
                -- Add all items from chest to inventory
                for _, item in ipairs(chest.items) do
                    inventory:addItem(item.id, item.quantity or 1)
                end
                chest.opened = true
                return true
            end
        end
    end
    return false
end

-- Draw loot drops
function Loot.draw()
    local Items = require("src.data.Items")

    for _, drop in ipairs(Loot.drops) do
        if not drop.collected then
            local item = Items.getItem(drop.itemId)
            if item then
                local r, g, b = Items.getRarityColor(item.rarity)
                love.graphics.setColor(r, g, b)
                love.graphics.circle("fill", drop.x, drop.y, 8)
                love.graphics.setColor(1, 1, 1)
                love.graphics.circle("line", drop.x, drop.y, 8)
            end
        end
    end

    -- Draw chests
    for _, chest in ipairs(Loot.chests) do
        if chest.opened then
            love.graphics.setColor(0.5, 0.5, 0.5)
        else
            love.graphics.setColor(0.8, 0.6, 0.2)
        end
        love.graphics.rectangle("fill", chest.x, chest.y, chest.width, chest.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", chest.x, chest.y, chest.width, chest.height)
    end
end

-- Generate random loot based on rarity
function Loot.generateLoot(rarity, count)
    rarity = rarity or "common"
    count = count or 1

    local Items = require("src.data.Items")
    local possibleItems = {}

    for id, item in pairs(Items.getAllItems()) do
        if item.rarity == rarity then
            table.insert(possibleItems, id)
        end
    end

    local loot = {}
    for i = 1, count do
        if #possibleItems > 0 then
            local itemId = possibleItems[math.random(#possibleItems)]
            table.insert(loot, {
                id = itemId,
                quantity = 1,
            })
        end
    end

    return loot
end

return Loot

