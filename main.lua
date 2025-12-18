--[[
    Realms - A LÖVE2D Game Project
    Entry point for the game
]]

-- Load configuration and libraries
local Game = {}

function love.load()
    -- Set default filter for pixel art (use 'linear' for smooth graphics)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Initialize game state
    Game.title = "Realms"
    Game.version = "0.1.0"

    print(Game.title .. " v" .. Game.version .. " loaded!")
end

function love.update(dt)
    -- Update game logic here
    -- dt = delta time (time since last frame)
end

function love.draw()
    -- Draw welcome message
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Welcome to Realms!", 10, 10)
    love.graphics.print("Press ESC to quit", 10, 30)

    -- Display FPS
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, love.graphics.getHeight() - 20)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.resize(w, h)
    -- Handle window resize
end
