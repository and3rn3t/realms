--[[
    UI Manager
    Manages all UI elements
]]

local UIManager = {}
UIManager.elements = {}
UIManager.active = true

-- Initialize UI manager
function UIManager.init()
    UIManager.elements = {}
    UIManager.active = true
end

-- Add UI element
function UIManager.addElement(name, element)
    UIManager.elements[name] = element
end

-- Remove UI element
function UIManager.removeElement(name)
    UIManager.elements[name] = nil
end

-- Update UI
function UIManager.update(dt)
    if not UIManager.active then return end

    for _, element in pairs(UIManager.elements) do
        if element.update then
            element:update(dt)
        end
    end
end

-- Draw UI
function UIManager.draw()
    if not UIManager.active then return end

    for _, element in pairs(UIManager.elements) do
        if element.draw then
            element:draw()
        end
    end
end

return UIManager

