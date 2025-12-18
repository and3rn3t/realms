--[[
    State Manager
    Manages game states (menu, game, pause, etc.)
    Uses hump.gamestate when available, falls back to simple state machine
]]

local StateManager = {}
StateManager.currentState = nil
StateManager.states = {}

-- Initialize state manager
function StateManager.init()
    -- Try to use hump.gamestate if available
    local success, gamestate = pcall(require, "libs.hump.gamestate")
    if success and gamestate then
        StateManager.useHump = true
        StateManager.gamestate = gamestate
        return
    end

    -- Fallback to simple state machine
    StateManager.useHump = false
    StateManager.currentState = nil
end

-- Register a state
function StateManager.register(name, state)
    StateManager.states[name] = state

    if StateManager.useHump and StateManager.gamestate then
        StateManager.gamestate.registerEvents()
    end
end

-- Switch to a state
function StateManager.switch(name, ...)
    if StateManager.useHump and StateManager.gamestate then
        StateManager.gamestate.switch(StateManager.states[name], ...)
    else
        -- Fallback implementation
        if StateManager.currentState and StateManager.currentState.exit then
            StateManager.currentState.exit()
        end

        StateManager.currentState = StateManager.states[name]

        if StateManager.currentState and StateManager.currentState.enter then
            StateManager.currentState.enter(...)
        end
    end
end

-- Push a state (for pause menus, etc.)
function StateManager.push(name, ...)
    if StateManager.useHump and StateManager.gamestate then
        StateManager.gamestate.push(StateManager.states[name], ...)
    else
        -- Fallback: simple push (store previous state)
        StateManager.previousState = StateManager.currentState
        StateManager.switch(name, ...)
    end
end

-- Pop a state
function StateManager.pop()
    if StateManager.useHump and StateManager.gamestate then
        StateManager.gamestate.pop()
    else
        -- Fallback: restore previous state
        if StateManager.previousState then
            StateManager.switch(StateManager.previousState.name or "game")
        end
    end
end

-- Get current state
function StateManager.getCurrent()
    if StateManager.useHump and StateManager.gamestate then
        return StateManager.gamestate.current()
    else
        return StateManager.currentState
    end
end

-- Update current state
function StateManager.update(dt)
    local state = StateManager.getCurrent()
    if state and state.update then
        state.update(dt)
    end
end

-- Draw current state
function StateManager.draw()
    local state = StateManager.getCurrent()
    if state and state.draw then
        state.draw()
    end
end

-- Handle key pressed
function StateManager.keypressed(key, scancode, isrepeat)
    local state = StateManager.getCurrent()
    if state and state.keypressed then
        state.keypressed(key, scancode, isrepeat)
    end
end

-- Handle key released
function StateManager.keyreleased(key, scancode)
    local state = StateManager.getCurrent()
    if state and state.keyreleased then
        state.keyreleased(key, scancode)
    end
end

-- Handle mouse pressed
function StateManager.mousepressed(x, y, button, istouch, presses)
    local state = StateManager.getCurrent()
    if state and state.mousepressed then
        state.mousepressed(x, y, button, istouch, presses)
    end
end

-- Handle mouse released
function StateManager.mousereleased(x, y, button, istouch, presses)
    local state = StateManager.getCurrent()
    if state and state.mousereleased then
        state.mousereleased(x, y, button, istouch, presses)
    end
end

return StateManager

