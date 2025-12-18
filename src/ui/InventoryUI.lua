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
    return self
end

function InventoryUI:toggle()
    self.visible = not self.visible
end

function InventoryUI:draw(inventory)
    if not self.visible or not inventory then return end
    
    local width = 400
    local height = 300
    local x = (love.graphics.getWidth() - width) / 2
    local y = (love.graphics.getHeight() - height) / 2
    
    -- Background
    love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, width, height)
    
    -- Title
    love.graphics.print("Inventory", x + 10, y + 10)
    
    -- Items
    local slotSize = 40
    local slotsPerRow = 8
    local startX = x + 10
    local startY = y + 40
    
    for i, slot in ipairs(inventory.items) do
        local col = (i - 1) % slotsPerRow
        local row = math.floor((i - 1) / slotsPerRow)
        local slotX = startX + col * (slotSize + 5)
        local slotY = startY + row * (slotSize + 5)
        
        -- Slot background
        if i == self.selectedSlot then
            love.graphics.setColor(0.5, 0.5, 0.8)
        else
            love.graphics.setColor(0.3, 0.3, 0.3)
        end
        love.graphics.rectangle("fill", slotX, slotY, slotSize, slotSize)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", slotX, slotY, slotSize, slotSize)
        
        -- Item quantity
        if slot.quantity > 1 then
            love.graphics.print(tostring(slot.quantity), slotX + 2, slotY + 2)
        end
    end
end

return InventoryUI

