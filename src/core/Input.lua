--[[
    Input System
    Centralized input handling with keybind configuration
]]

local Input = {}
Input.keys = {}
Input.keysPressed = {}
Input.keysReleased = {}
Input.mouseButtons = {}
Input.mouseButtonsPressed = {}
Input.mouseButtonsReleased = {}
Input.mouseX = 0
Input.mouseY = 0

-- Default keybinds
Input.keybinds = {
    up = {"w", "up"},
    down = {"s", "down"},
    left = {"a", "left"},
    right = {"d", "right"},
    interact = {"e", "space"},
    attack = {"j", "z"},
    use = {"k", "x"},
    inventory = {"i", "tab"},
    menu = {"escape", "m"},
    run = {"lshift", "rshift"},
    f5 = {"f5"},
    f9 = {"f9"},
}

-- Initialize input system
function Input.init()
    Input.keys = {}
    Input.keysPressed = {}
    Input.keysReleased = {}
    Input.mouseButtons = {}
    Input.mouseButtonsPressed = {}
    Input.mouseButtonsReleased = {}
end

-- Update input state (call at start of update)
function Input.update()
    -- Clear one-frame states
    Input.keysPressed = {}
    Input.keysReleased = {}
    Input.mouseButtonsPressed = {}
    Input.mouseButtonsReleased = {}

    -- Update mouse position
    Input.mouseX, Input.mouseY = love.mouse.getPosition()
end

-- Check if a keybind is held
function Input.isDown(action)
    local binds = Input.keybinds[action]
    if not binds then return false end

    for _, key in ipairs(binds) do
        if Input.keys[key] then
            return true
        end
    end
    return false
end

-- Check if a keybind was pressed this frame
function Input.wasPressed(action)
    local binds = Input.keybinds[action]
    if not binds then return false end

    for _, key in ipairs(binds) do
        if Input.keysPressed[key] then
            return true
        end
    end
    return false
end

-- Check if a keybind was released this frame
function Input.wasReleased(action)
    local binds = Input.keybinds[action]
    if not binds then return false end

    for _, key in ipairs(binds) do
        if Input.keysReleased[key] then
            return true
        end
    end
    return false
end

-- Check if a specific key is held
function Input.isKeyDown(key)
    return Input.keys[key] == true
end

-- Check if a specific key was pressed
function Input.wasKeyPressed(key)
    return Input.keysPressed[key] == true
end

-- Check if a specific key was released
function Input.wasKeyReleased(key)
    return Input.keysReleased[key] == true
end

-- Check if mouse button is held
function Input.isMouseDown(button)
    return Input.mouseButtons[button] == true
end

-- Check if mouse button was pressed
function Input.wasMousePressed(button)
    return Input.mouseButtonsPressed[button] == true
end

-- Check if mouse button was released
function Input.wasMouseReleased(button)
    return Input.mouseButtonsReleased[button] == true
end

-- Get mouse position
function Input.getMousePosition()
    return Input.mouseX, Input.mouseY
end

-- Handle key pressed
function Input.keypressed(key, scancode, isrepeat)
    Input.keys[key] = true
    if not isrepeat then
        Input.keysPressed[key] = true
    end
end

-- Handle key released
function Input.keyreleased(key, scancode)
    Input.keys[key] = false
    Input.keysReleased[key] = true
end

-- Handle mouse pressed
function Input.mousepressed(x, y, button, istouch, presses)
    Input.mouseButtons[button] = true
    Input.mouseButtonsPressed[button] = true
    Input.mouseX = x
    Input.mouseY = y
end

-- Handle mouse released
function Input.mousereleased(x, y, button, istouch, presses)
    Input.mouseButtons[button] = false
    Input.mouseButtonsReleased[button] = true
    Input.mouseX = x
    Input.mouseY = y
end

-- Set keybind for an action
function Input.setKeybind(action, keys)
    Input.keybinds[action] = type(keys) == "table" and keys or {keys}
end

-- Get keybind for an action
function Input.getKeybind(action)
    return Input.keybinds[action]
end

return Input

