--[[
    Inventory System
    Handles items, equipment, and inventory management
]]

local Inventory = {}
Inventory.__index = Inventory

function Inventory.new(maxSize)
    local self = setmetatable({}, Inventory)

    self.items = {}
    self.maxSize = maxSize or 20
    self.equipped = {
        weapon = nil,
        armor = nil,
        accessory = nil,
    }

    return self
end

function Inventory:addItem(itemId, quantity)
    quantity = quantity or 1

    -- Check if item already exists and is stackable
    for _, slot in ipairs(self.items) do
        if slot.id == itemId and slot.quantity < (slot.maxStack or 1) then
            local canAdd = math.min(quantity, (slot.maxStack or 1) - slot.quantity)
            slot.quantity = slot.quantity + canAdd

            -- Update quest progress for item collection
            local QuestSystem = require("src.quests.QuestSystem")
            local activeQuests = QuestSystem.getActiveQuests()
            for _, questId in ipairs(activeQuests) do
                local quest = QuestSystem.getQuest(questId)
                if quest and quest.objectives then
                    for _, objective in ipairs(quest.objectives) do
                        if objective.type == "collect" and objective.itemId == itemId then
                            QuestSystem.updateProgress(questId, objective.id, canAdd)
                        end
                    end
                end
            end

            quantity = quantity - canAdd
            if quantity <= 0 then
                return true
            end
        end
    end

    -- Add new item slot
    if #self.items >= self.maxSize then
        return false -- Inventory full
    end

    local Items = require("src.data.Items")
    local itemData = Items.getItem(itemId)
    if not itemData then
        return false
    end

    table.insert(self.items, {
        id = itemId,
        quantity = quantity,
        maxStack = itemData.stackable and (itemData.maxStack or 99) or 1,
    })

    -- Update quest progress for item collection
    local QuestSystem = require("src.quests.QuestSystem")
    local activeQuests = QuestSystem.getActiveQuests()
    for _, questId in ipairs(activeQuests) do
        local quest = QuestSystem.getQuest(questId)
        if quest and quest.objectives then
            for _, objective in ipairs(quest.objectives) do
                if objective.type == "collect" and objective.itemId == itemId then
                    QuestSystem.updateProgress(questId, objective.id, quantity)
                end
            end
        end
    end

    return true
end

function Inventory:removeItem(itemId, quantity)
    quantity = quantity or 1

    for i, slot in ipairs(self.items) do
        if slot.id == itemId then
            if slot.quantity <= quantity then
                quantity = quantity - slot.quantity
                table.remove(self.items, i)
                if quantity <= 0 then
                    return true
                end
            else
                slot.quantity = slot.quantity - quantity
                return true
            end
        end
    end

    return false
end

function Inventory:hasItem(itemId, quantity)
    quantity = quantity or 1
    local count = 0

    for _, slot in ipairs(self.items) do
        if slot.id == itemId then
            count = count + slot.quantity
            if count >= quantity then
                return true
            end
        end
    end

    return false
end

function Inventory:getItemCount(itemId)
    local count = 0
    for _, slot in ipairs(self.items) do
        if slot.id == itemId then
            count = count + slot.quantity
        end
    end
    return count
end

function Inventory:equipItem(itemId, slot)
    slot = slot or "weapon"

    local Items = require("src.data.Items")
    local itemData = Items.getItem(itemId)
    if not itemData then
        return false
    end

    if itemData.type ~= slot and itemData.type ~= "accessory" then
        return false
    end

    -- Unequip current item
    if self.equipped[slot] then
        self:addItem(self.equipped[slot])
    end

    -- Equip new item
    if self:hasItem(itemId, 1) then
        self:removeItem(itemId, 1)
        self.equipped[slot] = itemId
        return true
    end

    return false
end

function Inventory:unequipItem(slot)
    if not self.equipped[slot] then
        return false
    end

    local itemId = self.equipped[slot]
    if self:addItem(itemId, 1) then
        self.equipped[slot] = nil
        return true
    end

    return false
end

function Inventory:useItem(itemId, target)
    target = target or nil

    local Items = require("src.data.Items")
    local itemData = Items.getItem(itemId)
    if not itemData or itemData.type ~= "consumable" then
        return false
    end

    if not self:hasItem(itemId, 1) then
        return false
    end

    -- Apply effect
    if itemData.effect == "heal" and target then
        local current = target:getHealth()
        target:setHealth(current + (itemData.amount or 0))
    elseif itemData.effect == "mana" and target then
        local current = target:getMana()
        target:setMana(current + (itemData.amount or 0))
    end

    -- Remove item
    self:removeItem(itemId, 1)
    return true
end

function Inventory:getEquippedStats()
    local stats = {
        damage = 0,
        defense = 0,
    }

    local Items = require("src.data.Items")

    if self.equipped.weapon then
        local item = Items.getItem(self.equipped.weapon)
        if item then
            stats.damage = stats.damage + (item.damage or 0)
        end
    end

    if self.equipped.armor then
        local item = Items.getItem(self.equipped.armor)
        if item then
            stats.defense = stats.defense + (item.defense or 0)
        end
    end

    return stats
end

return Inventory

