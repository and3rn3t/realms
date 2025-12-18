--[[
    Economy System
    Handles currency, shops, and trading
]]

local EconomySystem = {}
EconomySystem.currency = 0
EconomySystem.shops = {}

-- Initialize economy
function EconomySystem.init()
    EconomySystem.currency = 0
    EconomySystem.shops = {}
end

-- Add currency
function EconomySystem.addCurrency(amount)
    EconomySystem.currency = EconomySystem.currency + amount
end

-- Remove currency
function EconomySystem.removeCurrency(amount)
    if EconomySystem.currency >= amount then
        EconomySystem.currency = EconomySystem.currency - amount
        return true
    end
    return false
end

-- Get currency
function EconomySystem.getCurrency()
    return EconomySystem.currency
end

-- Buy item
function EconomySystem.buyItem(itemId, price, inventory)
    if not EconomySystem.removeCurrency(price) then
        return false
    end

    return inventory:addItem(itemId, 1)
end

-- Sell item
function EconomySystem.sellItem(itemId, price, inventory)
    if not inventory:hasItem(itemId, 1) then
        return false
    end

    inventory:removeItem(itemId, 1)
    EconomySystem.addCurrency(price)
    return true
end

return EconomySystem

