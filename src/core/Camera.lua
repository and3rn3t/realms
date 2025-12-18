--[[
    Camera System
    Camera following player with smooth movement
    Can use hump.camera if available, otherwise simple implementation
]]

local Camera = {}
Camera.x = 0
Camera.y = 0
Camera.scale = 1
Camera.rotation = 0
Camera.target = nil
Camera.smooth = true
Camera.smoothSpeed = 0.1
Camera.bounds = nil -- {x, y, width, height}
Camera.useHump = false
Camera.humpCamera = nil

-- Initialize camera
function Camera.init()
    -- Try to use hump.camera if available
    local success, humpCamera = pcall(require, "libs.hump.camera")
    if success and humpCamera then
        Camera.useHump = true
        Camera.humpCamera = humpCamera(0, 0)
        Camera.x = 0
        Camera.y = 0
        return
    end

    -- Fallback implementation
    Camera.useHump = false
    Camera.x = 0
    Camera.y = 0
    Camera.scale = 1
    Camera.rotation = 0
end

-- Set camera target (entity to follow)
function Camera.setTarget(entity)
    Camera.target = entity
end

-- Set camera position
function Camera.setPosition(x, y)
    Camera.x = x
    Camera.y = y

    if Camera.useHump and Camera.humpCamera then
        Camera.humpCamera:lookAt(x, y)
    end
end

-- Get camera position
function Camera.getPosition()
    if Camera.useHump and Camera.humpCamera then
        return Camera.humpCamera:position()
    else
        return Camera.x, Camera.y
    end
end

-- Set camera scale
function Camera.setScale(scale)
    Camera.scale = scale

    if Camera.useHump and Camera.humpCamera then
        Camera.humpCamera:zoom(scale)
    end
end

-- Get camera scale
function Camera.getScale()
    if Camera.useHump and Camera.humpCamera then
        return Camera.humpCamera:zoom()
    else
        return Camera.scale
    end
end

-- Set camera rotation
function Camera.setRotation(rotation)
    Camera.rotation = rotation

    if Camera.useHump and Camera.humpCamera then
        Camera.humpCamera:rotate(rotation)
    end
end

-- Set camera bounds (limits camera movement)
function Camera.setBounds(x, y, width, height)
    Camera.bounds = {x = x, y = y, width = width, height = height}
end

-- Set smooth following
function Camera.setSmooth(smooth, speed)
    Camera.smooth = smooth
    if speed then
        Camera.smoothSpeed = speed
    end
end

-- Update camera (call in update loop)
function Camera.update(dt)
    if not Camera.target then return end

    local targetX, targetY = Camera.target.x, Camera.target.y

    -- Apply bounds if set
    if Camera.bounds then
        local screenWidth = love.graphics.getWidth() / Camera.scale
        local screenHeight = love.graphics.getHeight() / Camera.scale

        local minX = Camera.bounds.x + screenWidth / 2
        local maxX = Camera.bounds.x + Camera.bounds.width - screenWidth / 2
        local minY = Camera.bounds.y + screenHeight / 2
        local maxY = Camera.bounds.y + Camera.bounds.height - screenHeight / 2

        targetX = math.max(minX, math.min(maxX, targetX))
        targetY = math.max(minY, math.min(maxY, targetY))
    end

    -- Smooth or instant movement
    if Camera.smooth then
        Camera.x = Camera.x + (targetX - Camera.x) * Camera.smoothSpeed
        Camera.y = Camera.y + (targetY - Camera.y) * Camera.smoothSpeed
    else
        Camera.x = targetX
        Camera.y = targetY
    end

    if Camera.useHump and Camera.humpCamera then
        Camera.humpCamera:lookAt(Camera.x, Camera.y)
    end
end

-- Begin camera drawing (call before drawing world)
function Camera.begin()
    if Camera.useHump and Camera.humpCamera then
        Camera.humpCamera:attach()
    else
        love.graphics.push()
        love.graphics.translate(-Camera.x + love.graphics.getWidth() / 2, -Camera.y + love.graphics.getHeight() / 2)
        love.graphics.scale(Camera.scale, Camera.scale)
        love.graphics.rotate(Camera.rotation)
    end
end

-- End camera drawing (call after drawing world)
function Camera.finish()
    if Camera.useHump and Camera.humpCamera then
        Camera.humpCamera:detach()
    else
        love.graphics.pop()
    end
end

-- Convert world coordinates to screen coordinates
function Camera.worldToScreen(wx, wy)
    if Camera.useHump and Camera.humpCamera then
        return Camera.humpCamera:worldCoords(wx, wy)
    else
        local sw = love.graphics.getWidth()
        local sh = love.graphics.getHeight()
        local sx = (wx - Camera.x) * Camera.scale + sw / 2
        local sy = (wy - Camera.y) * Camera.scale + sh / 2
        return sx, sy
    end
end

-- Convert screen coordinates to world coordinates
function Camera.screenToWorld(sx, sy)
    if Camera.useHump and Camera.humpCamera then
        return Camera.humpCamera:worldCoords(sx, sy)
    else
        local sw = love.graphics.getWidth()
        local sh = love.graphics.getHeight()
        local wx = (sx - sw / 2) / Camera.scale + Camera.x
        local wy = (sy - sh / 2) / Camera.scale + Camera.y
        return wx, wy
    end
end

return Camera

