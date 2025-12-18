--[[
    Resolution System
    Resolution-independent rendering using push library
]]

local Resolution = {}
Resolution.push = nil
Resolution.usePush = false
Resolution.virtualWidth = 800
Resolution.virtualHeight = 600
Resolution.windowWidth = 800
Resolution.windowHeight = 600

-- Initialize resolution system
function Resolution.init(virtualWidth, virtualHeight)
    Resolution.virtualWidth = virtualWidth or 800
    Resolution.virtualHeight = virtualHeight or 600

    -- Try to use push library if available
    local success, push = pcall(require, "libs.push")
    if success and push then
        Resolution.usePush = true
        Resolution.push = push
        Resolution.push:setupScreen(
            Resolution.virtualWidth,
            Resolution.virtualHeight,
            {
                fullscreen = false,
                resizable = true,
                vsync = true,
                highdpi = true
            }
        )
        return
    end

    -- Fallback: no resolution scaling
    Resolution.usePush = false
    Resolution.windowWidth = love.graphics.getWidth()
    Resolution.windowHeight = love.graphics.getHeight()
end

-- Update resolution (call in love.resize)
function Resolution.resize(w, h)
    Resolution.windowWidth = w
    Resolution.windowHeight = h

    if Resolution.usePush and Resolution.push then
        Resolution.push:resize(w, h)
    end
end

-- Begin resolution drawing (call before drawing)
function Resolution.begin()
    if Resolution.usePush and Resolution.push then
        Resolution.push:start()
    end
end

-- End resolution drawing (call after drawing)
function Resolution.finish()
    if Resolution.usePush and Resolution.push then
        Resolution.push:finish()
    end
end

-- Get virtual dimensions
function Resolution.getVirtualDimensions()
    return Resolution.virtualWidth, Resolution.virtualHeight
end

-- Get window dimensions
function Resolution.getWindowDimensions()
    return Resolution.windowWidth, Resolution.windowHeight
end

-- Get scale factor
function Resolution.getScale()
    if Resolution.usePush and Resolution.push then
        return Resolution.push:getWidth() / Resolution.virtualWidth,
               Resolution.push:getHeight() / Resolution.virtualHeight
    else
        return Resolution.windowWidth / Resolution.virtualWidth,
               Resolution.windowHeight / Resolution.virtualHeight
    end
end

return Resolution

