--[[
    LÖVE2D Configuration File
    See: https://love2d.org/wiki/Config_Files
]]

function love.conf(t)
    -- Identity (save directory name)
    t.identity = "realms"

    -- Game window settings
    t.window.title = "Realms"
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = true
    t.window.minwidth = 400
    t.window.minheight = 300
    t.window.vsync = 1

    -- LÖVE version this game was made for
    t.version = "11.4"

    -- Console output (useful for debugging on Windows)
    t.console = false

    -- Modules to enable/disable
    t.modules.audio = true
    t.modules.data = true
    t.modules.event = true
    t.modules.font = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = true
    t.modules.sound = true
    t.modules.system = true
    t.modules.thread = true
    t.modules.timer = true
    t.modules.touch = true
    t.modules.video = true
    t.modules.window = true
end
