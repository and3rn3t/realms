--[[
    Realms - A LÖVE2D Game Project
    Entry point for the game
]]

-- Load source modules
local src = require("src.init")

-- Game state
local Game = {}
Game.title = "Realms"
Game.version = "0.1.0"

-- Initialize game
function love.load()
    -- Set default filter for pixel art
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Initialize core systems
    src.core.Resolution.init(800, 600)
    src.core.StateManager.init()
    src.core.Input.init()
    src.core.AssetManager.init()
    src.core.Camera.init()

    -- Initialize world system
    src.world = {}
    src.world.World = require("src.world.World")
    src.world.World.init()

    -- Load realm data
    src.data = {}
    src.data.Realms = require("src.data.Realms")
    for name, data in pairs(src.data.Realms.getAllRealms()) do
        src.world.World.registerRealm(name, data)
    end

    -- Create menu state
    local MenuState = {
        name = "menu",
        enter = function(self)
            print("Entered menu state")
        end,
        update = function(self, dt)
            -- Menu update logic
        end,
        draw = function(self)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print("Welcome to Realms!", 10, 10)
            love.graphics.print("Press ENTER to start", 10, 30)
            love.graphics.print("Press ESC to quit", 10, 50)
        end,
        keypressed = function(self, key)
            if key == "return" or key == "kpenter" then
                src.core.StateManager.switch("game")
            elseif key == "escape" then
                love.event.quit()
            end
        end
    }

    -- Create game state
    local GameState = {
        name = "game",
        player = nil,
        enter = function(self)
            print("Entered game state")

            -- Create player
            local Player = require("src.entities.Player")
            self.player = Player.new(400, 300)
            self.player:load()

            -- Load starting realm
            local realm = src.world.World.loadRealm("starting_realm")
            if realm then
                -- Set up player collision
                if realm:getCollisionWorld() then
                    self.player:setCollisionWorld(realm:getCollisionWorld())
                end

                -- Set camera target and bounds
                src.core.Camera.setTarget(self.player)
                local bx, by, bw, bh = realm:getBounds()
                src.core.Camera.setBounds(bx, by, bw, bh)
            end
        end,
        update = function(self, dt)
            src.core.Input.update()

            -- Update world
            src.world.World.update(dt)

            -- Update player
            if self.player then
                self.player:update(dt, src.core.Input)
            end

            -- Update camera
            src.core.Camera.update(dt)
        end,
        draw = function(self)
            src.core.Resolution.begin()

            src.core.Camera.begin()

            -- Draw world
            src.world.World.draw()

            -- Draw player
            if self.player then
                self.player:draw()
            end

            src.core.Camera.finish()

            -- UI drawing
            love.graphics.setColor(1, 1, 1)
            local font = src.core.AssetManager.getDefaultFont(14)
            love.graphics.setFont(font)
            love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)

            if self.player then
                local health, maxHealth = self.player:getHealth()
                love.graphics.print("Health: " .. math.floor(health) .. "/" .. maxHealth, 10, 30)
            end

            src.core.Resolution.finish()
        end,
        keypressed = function(self, key)
            if key == "escape" then
                src.core.StateManager.switch("menu")
            end
        end
    }

    -- Register states
    src.core.StateManager.register("menu", MenuState)
    src.core.StateManager.register("game", GameState)

    -- Start with menu state
    src.core.StateManager.switch("menu")

    print(Game.title .. " v" .. Game.version .. " loaded!")
end

function love.update(dt)
    src.core.StateManager.update(dt)
end

function love.draw()
    src.core.StateManager.draw()
end

function love.keypressed(key, scancode, isrepeat)
    src.core.Input.keypressed(key, scancode, isrepeat)
    src.core.StateManager.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    src.core.Input.keyreleased(key, scancode)
    src.core.StateManager.keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
    src.core.Input.mousepressed(x, y, button, istouch, presses)
    src.core.StateManager.mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    src.core.Input.mousereleased(x, y, button, istouch, presses)
    src.core.StateManager.mousereleased(x, y, button, istouch, presses)
end

function love.resize(w, h)
    src.core.Resolution.resize(w, h)
end
