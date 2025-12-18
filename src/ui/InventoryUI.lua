--[[
    Inventory UI
    Displays and manages inventory interface
]]

local InventoryUI = {}
InventoryUI.visible = false
InventoryUI.selectedSlot = 1

function InventoryUI.new()
    local self = {}
    self.visible = false
    self.selectedSlot = 1
    self.selectedEquipmentSlot = nil -- "weapon", "armor", "accessory"
    self.showItemDetails = false
    return self
end

function InventoryUI:toggle()
    self.visible = not self.visible
end

function InventoryUI:draw(inventory, player)
    if not self.visible or not inventory then return end

    local width = 700
    local height = 500
    local x = (love.graphics.getWidth() - width) / 2
    local y = (love.graphics.getHeight() - height) / 2

    -- Background
    love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, width, height)

    -- Title
    love.graphics.print("Inventory", x + 10, y + 10)

    -- Quick item slots (F1-F4)
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print("Quick Items (F1-F4):", x + 10, y + 35)
    local quickSlotSize = 50
    local quickStartX = x + 10
    local quickStartY = y + 55

    for i = 1, 4 do
        local quickX = quickStartX + (i - 1) * (quickSlotSize + 5)
        local quickY = quickStartY

        -- Quick slot background
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle("fill", quickX, quickY, quickSlotSize, quickSlotSize)
        love.graphics.setColor(0.6, 0.6, 0.6)
        love.graphics.rectangle("line", quickX, quickY, quickSlotSize, quickSlotSize)

        -- Show quick item if set
        if player and player:getQuickItem(i) then
            local itemId = player:getQuickItem(i)
            local Items = require("src.data.Items")
            local itemData = Items.getItem(itemId)
            if itemData then
                love.graphics.setColor(1, 1, 1)
                love.graphics.print(itemData.name, quickX + 5, quickY + 15)
                -- Show cooldown
                if player.itemCooldowns[itemId] and player.itemCooldowns[itemId] > 0 then
                    love.graphics.setColor(1, 0, 0, 0.7)
                    love.graphics.rectangle("fill", quickX, quickY, quickSlotSize, quickSlotSize)
                    love.graphics.setColor(1, 1, 1)
                    local cdText = string.format("%.1f", player.itemCooldowns[itemId])
                    love.graphics.print(cdText, quickX + 15, quickY + 25)
                end
            end
        end

        -- F-key label
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.print("F" .. i, quickX + 5, quickY + 2)
    end

    -- Equipment panel (right side)
    local equipPanelX = x + 350
    local equipPanelY = y + 35
    local equipPanelWidth = 150
    local equipPanelHeight = 200

    love.graphics.setColor(0.15, 0.15, 0.15)
    love.graphics.rectangle("fill", equipPanelX, equipPanelY, equipPanelWidth, equipPanelHeight)
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("line", equipPanelX, equipPanelY, equipPanelWidth, equipPanelHeight)

    -- Equipment title
    love.graphics.setColor(1, 1, 0.5)
    love.graphics.print("Equipment", equipPanelX + 10, equipPanelY + 5)

    -- Equipment slots
    local Items = require("src.data.Items")
    local equipSlots = {
        {name = "Weapon", slot = "weapon", y = equipPanelY + 30},
        {name = "Armor", slot = "armor", y = equipPanelY + 80},
        {name = "Accessory", slot = "accessory", y = equipPanelY + 130},
    }

    for _, equipSlot in ipairs(equipSlots) do
        local slotX = equipPanelX + 10
        local slotY = equipSlot.y
        local slotWidth = equipPanelWidth - 20
        local slotHeight = 40

        -- Highlight if selected
        if self.selectedEquipmentSlot == equipSlot.slot then
            love.graphics.setColor(0.3, 0.5, 0.8)
        else
            love.graphics.setColor(0.2, 0.2, 0.2)
        end
        love.graphics.rectangle("fill", slotX, slotY, slotWidth, slotHeight)
        love.graphics.setColor(0.6, 0.6, 0.6)
        love.graphics.rectangle("line", slotX, slotY, slotWidth, slotHeight)

        -- Slot label
        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.print(equipSlot.name .. ":", slotX + 5, slotY + 5)

        -- Equipped item
        local equippedId = inventory.equipped[equipSlot.slot]
        if equippedId then
            local itemData = Items.getItem(equippedId)
            if itemData then
                love.graphics.setColor(0.3, 1, 0.3)
                local name = itemData.name or equippedId
                if #name > 15 then
                    name = string.sub(name, 1, 15) .. "..."
                end
                love.graphics.print(name, slotX + 5, slotY + 20)
            end
        else
            love.graphics.setColor(0.4, 0.4, 0.4)
            love.graphics.print("(empty)", slotX + 5, slotY + 20)
        end
    end

    -- Items (left side)
    local slotSize = 40
    local slotsPerRow = 6
    local startX = x + 10
    local startY = y + 120

    for i, slot in ipairs(inventory.items) do
        local col = (i - 1) % slotsPerRow
        local row = math.floor((i - 1) / slotsPerRow)
        local slotX = startX + col * (slotSize + 5)
        local slotY = startY + row * (slotSize + 5)

        -- Check if item is equipped
        local isEquipped = false
        for _, equipId in pairs(inventory.equipped) do
            if equipId == slot.id then
                isEquipped = true
                break
            end
        end

        -- Slot background
        if i == self.selectedSlot then
            love.graphics.setColor(0.5, 0.5, 0.8)
        elseif isEquipped then
            love.graphics.setColor(0.3, 0.6, 0.3)
        else
            love.graphics.setColor(0.3, 0.3, 0.3)
        end
        love.graphics.rectangle("fill", slotX, slotY, slotSize, slotSize)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", slotX, slotY, slotSize, slotSize)

        -- Item info
        local itemData = Items.getItem(slot.id)
        if itemData then
            -- Item name (abbreviated)
            love.graphics.setColor(1, 1, 1)
            local name = itemData.name or slot.id
            if #name > 6 then
                name = string.sub(name, 1, 6)
            end
            love.graphics.print(name, slotX + 2, slotY + 10)
        end

        -- Item quantity
        if slot.quantity > 1 then
            love.graphics.setColor(1, 1, 0)
            love.graphics.print(tostring(slot.quantity), slotX + 2, slotY + 2)
        end

        -- Equipped indicator
        if isEquipped then
            love.graphics.setColor(0, 1, 0)
            love.graphics.print("E", slotX + slotSize - 12, slotY + 2)
        end
    end

    -- Item details panel
    if self.selectedSlot >= 1 and self.selectedSlot <= #inventory.items then
        local slot = inventory.items[self.selectedSlot]
        local itemData = Items.getItem(slot.id)
        if itemData then
            local detailsX = x + 10
            local detailsY = y + 350
            local detailsWidth = width - 20
            local detailsHeight = 100

            love.graphics.setColor(0.15, 0.15, 0.15)
            love.graphics.rectangle("fill", detailsX, detailsY, detailsWidth, detailsHeight)
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.rectangle("line", detailsX, detailsY, detailsWidth, detailsHeight)

            local textY = detailsY + 10
            love.graphics.setColor(1, 1, 0.5)
            love.graphics.print(itemData.name or slot.id, detailsX + 10, textY)
            textY = textY + 20

            love.graphics.setColor(0.8, 0.8, 0.8)
            if itemData.type == "weapon" then
                love.graphics.print("Type: Weapon", detailsX + 10, textY)
                if itemData.damage then
                    love.graphics.print("Damage: +" .. itemData.damage, detailsX + 150, textY)
                end
            elseif itemData.type == "armor" then
                love.graphics.print("Type: Armor", detailsX + 10, textY)
                if itemData.defense then
                    love.graphics.print("Defense: +" .. itemData.defense, detailsX + 150, textY)
                end
            elseif itemData.type == "consumable" then
                love.graphics.print("Type: Consumable", detailsX + 10, textY)
                if itemData.effect then
                    local effectText = "Effect: " .. itemData.effect
                    if itemData.amount then
                        effectText = effectText .. " (+" .. itemData.amount .. ")"
                    end
                    love.graphics.print(effectText, detailsX + 150, textY)
                end
            end
            textY = textY + 20

            -- Equip hint
            if itemData.type == "weapon" or itemData.type == "armor" or itemData.type == "accessory" then
                love.graphics.setColor(0.3, 1, 0.3)
                love.graphics.print("Press E to equip", detailsX + 10, textY)
            end
        end
    end

    -- Instructions
    love.graphics.setColor(0.6, 0.6, 0.6)
    local instText = "Arrow keys: Select | ENTER: Use | 1-4: Quick | E: Equip | U: Unequip"
    love.graphics.print(instText, x + 10, y + height - 20)
end

function InventoryUI:keypressed(key, inventory, player)
    if not self.visible or not inventory then return end

    if key == "i" or key == "escape" or key == "tab" then
        self.visible = false
        return
    end

    -- Arrow keys for selection
    if key == "up" then
        self.selectedSlot = math.max(1, self.selectedSlot - 8)
    elseif key == "down" then
        self.selectedSlot = math.min(#inventory.items, self.selectedSlot + 8)
    elseif key == "left" then
        self.selectedSlot = math.max(1, self.selectedSlot - 1)
    elseif key == "right" then
        self.selectedSlot = math.min(#inventory.items, self.selectedSlot + 1)
    elseif key == "return" or key == "kpenter" then
        -- Use item
        if self.selectedSlot >= 1 and self.selectedSlot <= #inventory.items then
            local slot = inventory.items[self.selectedSlot]
            local Items = require("src.data.Items")
            local itemData = Items.getItem(slot.id)
            if itemData and itemData.type == "consumable" then
                if player then
                    player:useItem(slot.id)
                end
            end
        end
    elseif key == "e" then
        -- Equip item
        if self.selectedSlot >= 1 and self.selectedSlot <= #inventory.items then
            local slot = inventory.items[self.selectedSlot]
            local Items = require("src.data.Items")
            local itemData = Items.getItem(slot.id)
            if itemData then
                local equipSlot = itemData.type
                if equipSlot == "weapon" or equipSlot == "armor" or equipSlot == "accessory" then
                    inventory:equipItem(slot.id, equipSlot)
                end
            end
        end
    elseif key == "u" then
        -- Unequip from selected equipment slot
        if self.selectedEquipmentSlot then
            inventory:unequipItem(self.selectedEquipmentSlot)
        end
    elseif key == "1" or key == "2" or key == "3" or key == "4" then
        -- Set quick item slot
        if self.selectedSlot >= 1 and self.selectedSlot <= #inventory.items then
            local slot = inventory.items[self.selectedSlot]
            local quickSlot = tonumber(key)
            if player then
                player:setQuickItem(quickSlot, slot.id)
            end
        end
    end

    -- Equipment slot selection (W/A/S/D or separate keys)
    if key == "w" then
        self.selectedEquipmentSlot = "weapon"
    elseif key == "a" then
        self.selectedEquipmentSlot = "armor"
    elseif key == "s" then
        self.selectedEquipmentSlot = "accessory"
    end
end

return InventoryUI

